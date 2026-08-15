# Pendências da demo

## A fonte que o runtime do Flutter busca no Google

Eram **duas** requisições a `fonts.gstatic.com` por carregamento frio, e nenhuma
delas era escolha da demo. Medidas em `https://flocks.live/demo/` em 2026-08-11,
nas duas telas:

| Fonte | Bytes | Quando | Estado |
| --- | --- | --- | --- |
| `roboto/v32/KFOmCnqEu92Fr1Me4GZLCzYlKw.woff2` | 63.464 | na carga de fontes, junto dos TTF locais, **antes do primeiro frame** | de pé, e o caminho de conserto está decidido mais abaixo |
| `notosanssymbols/v43/rP2up3q65FkA….woff2` | 69.116 | no **primeiro layout**, sem ninguém digitar nada | **consertada na raiz** |

A medição acima é de produção e continua descrevendo o build que está no ar: o
conserto da segunda linha só chega a `flocks.live` no próximo deploy.

**A Roboto sai mesmo sem a demo usá-la, e não é lazy.** O CanvasKit precisa de
uma fonte de fallback registrada para não estourar ao dispor texto com família
desconhecida, e escolheu a Roboto para casar com o Android. Em
`canvaskit/fonts.dart` do engine (SDK 3.44.0), `loadAssetFonts` percorre o
`FontManifest.json` e, se nenhuma família ali se chamar literalmente `Roboto`,
acrescenta `_downloadFont('Roboto', _robotoUrl, 'Roboto')` à lista que é
**aguardada** antes de seguir. A comparação é igualdade de string —
`if (family.name == 'Roboto')` —, e o manifesto que este build gera declara
`packages/flocks/Poppins`, `packages/flocks/SpaceGrotesk` e
`packages/flocks/IBMPlexMono`: a condição é sempre verdadeira. `_robotoUrl` é
`'${configuration.fontFallbackBaseUrl}roboto/v32/…woff2'`, e
`fontFallbackBaseUrl` cai no default `https://fonts.gstatic.com/s/` porque
ninguém o configura — `web/index.html` não tem bloco de config do loader.

**A Noto Sans Symbols era lazy, e o gatilho era nosso.** A fila de fallback do
engine baixa uma Noto por codepoint sem cobertura, e
`getMissingCodePoints(codePoints, fontFamilies)` confere a cobertura **só contra
as famílias daquele span**, não contra tudo o que está registrado. O bloco de
código do painel ("Take it with you") pedia a pilha mono de
`app_content_style.dart` do `flocks` — `SF Mono`, `Menlo`, `Consolas`,
`Roboto Mono`, … —, e nenhuma delas estava registrada no CanvasKit. Aí cada
acento do comentário em português do snippet ("já", "padrão", "só") virava
codepoint órfão. Hoje `AppContentStyle.code` não pede pilha nenhuma: é uma
família só, empacotada, e sem `fontFamilyFallback`.
Como acento latino é coberto por dezenas de Noto, dá empate, e o desempate do
engine prefere explicitamente a Noto Sans Symbols: **67,5 KB de uma fonte de
símbolos para desenhar "ã"**. O painel é chrome compartilhado, então as duas
telas pagavam.

**Como morreu:** o `flocks` passou a empacotar a IBM Plex Mono em
`assets/fonts/`, e `AppContentStyle.code` pede `packages/flocks/IBMPlexMono` sem
`fontFamilyFallback`. A família está registrada no CanvasKit, os acentos têm
cobertura, e a fila de fallback nunca abre. Medido nos dois builds servidos lado
a lado em `127.0.0.1`, com `performance.getEntriesByType('resource')` e
esperando o número de recursos estabilizar (a aba throttla o render, e medir
cedo demais confunde "ainda não pediu" com "não pede"):

| Build | Recursos | De terceiro |
| --- | --- | --- |
| `origin/main` (856baee) | 20 | Roboto 63.464 B + **Noto Sans Symbols 69.116 B** |
| com a mono empacotada | 21 | Roboto 63.464 B |

O recurso a mais é aritmética: entram os dois TTF da mono, sai a Noto. A
contrapartida, dita por inteiro: a demo passa a baixar **275.796 B** de mono da
**própria origem**, com o mesmo `max-age` de um ano dos outros TTF. Troca-se um
terceiro por bytes nossos, não se economiza banda.

Nada disso é alcançável pelos gates: acontece no bootstrap JavaScript e na fila
do engine, antes e fora de qualquer Dart nosso. A terceira irmã — o CanvasKit
vindo do `www.gstatic.com` — já foi corrigida com `--no-web-resources-cdn` no
CI, com gate estático em `test/architecture_test.dart`, e a medição confirma que
essa continua corrigida: zero requisições a `www.gstatic.com`.

**Confirmado no código atual, antes de decidir qualquer coisa.** Para escolher o
que fazer com a linha que sobrou era preciso saber se ela ainda é a única — a
tabela lá em cima é de produção, e o código já andou desde ela. Então o
`build/web` foi refeito com as flags do CI (`--release
--no-web-resources-cdn`), servido em `127.0.0.1` e medido com
`performance.getEntriesByType('resource')` — com a tela **pintada**, porque o
navegador estrangula o render de aba de fundo e o número fecha baixo se ninguém
olhar: com o painel oculto, aos 130 s o dashboard ainda não tinha pedido um único
ícone.

| Tela | Recursos | Da nossa origem | De terceiro |
| --- | --- | --- | --- |
| `?screen=dashboard` | 21 | 20 | Roboto 63.464 B |
| `?screen=crud` | 22 | 21 | Roboto 63.464 B |

Zero Noto e zero `www.gstatic.com` nas duas. A Roboto apareceu do cache do
navegador (`deliveryType: "cache"`, `transferSize: 0`); refetchada com
`cache: 'reload'` são **63.764 B na rede** para 63.464 B de corpo, por HTTP/3,
com `cache-control: public, max-age=31536000`. **Sobrou uma, e é a Roboto.**

**Decisão: não seguir pelo `fontFallbackBaseUrl`.** O caminho existe — apontar a
base para uma cópia servida por nós e vendorar a Roboto (Apache 2.0,
redistribuível) —, foi medido, e sai mais caro do que o defeito. Três razões, em
ordem de peso:

1. **O knob é um só, e a fila de Noto usa o mesmo.** Em `font_fallbacks.dart` do
   engine, `startDownloads()` monta a URL de **cada** fonte de fallback com o
   mesmo prefixo: `final url = '${configuration.fontFallbackBaseUrl}${font.url}'`.
   A tabela que alimenta essa fila — `font_fallback_data.dart`, gerada por
   `dev/roll_fallback_fonts.dart` — tem **724** entradas `NotoFont(` na 3.44.0, e
   nenhuma delas é a Roboto. Apontar a base para nós para matar uma requisição de
   63 KB manda as 724 para uma origem onde elas não existem. O engine não estoura
   com isso: em 404 `_downloadFont` faz
   `printWarning('Font family $fontFamily not found (404) at $url')` e devolve
   `FontDownloadResult.fromError`. O preço não é um erro, é o glifo não desenhado
   — e paga todo codepoint fora do que Poppins, Space Grotesk e IBM Plex Mono
   cobrem, numa demo cujo CRUD tem campo de busca e formulário que o visitante
   preenche.
2. **Não economiza byte nenhum.** Os 63.464 B continuam saindo; mudam de host. O
   ganho seria de terceiro, não de banda — real, e menor que o custo de (1).
3. **A falha futura é silenciosa, e nenhum gate a alcança.** O caminho sob a base
   não é contrato, e o próprio engine avisa: o comentário logo acima de
   `_robotoUrl` diz que a API do Google Fonts adverte que aquela URL não é
   estável. Medido no repo do Flutter com `git log -G"roboto/v"` — o `-S` não
   serve aqui, ele conta ocorrências e essa mudança não mudou a contagem —, o
   literal mudou **uma vez em seis anos e meio**: nasceu
   `roboto/v20/…5WZL….ttf` em 2019-11-27 e virou `roboto/v32/…4GZL….woff2` em
   2024-11-05, no "[web] Switch all fonts to WOFF2 (non-split)". Frequência
   baixa, mas quando acontecer a cópia vendorada dá 404, o engine só imprime
   aviso, e isto roda no bootstrap — fora do alcance de qualquer teste em VM. É o
   mesmo ponto cego que deixou o CanvasKit vir do CDN sem ninguém notar.

**Duas frases desta seção estavam imprecisas e saem.** A primeira dizia que a
estrutura esperada é "sem contrato documentado": o **knob é** contrato público —
`fontFallbackBaseUrl?: string` está declarado em
`lib/web_ui/flutter_js/src/types.d.ts` do engine, e o PR que o criou se chama
"[web] Add ability to customize font fallback download URL" (2024-03-22). O que
não tem contrato é o **layout de diretórios sob a base**. A distinção decide de
onde vem o risco. A segunda dizia que apontar a base "obriga a decidir o que
fazer com a fila de Noto inteira", como se fosse pendência: não é pendência, é a
razão de o caminho ser ruim.

**O que fazer no lugar, e por que não coube nesta raia.** `loadAssetFonts` pula o
download quando o manifesto **já** tem uma família chamada `Roboto`. O conserto,
então, não é redirecionar a base: é fazer o manifesto ter essa família. A versão
anterior desta seção chegou a um passo disso — observou que `IBMPlexMono` não se
chama `Roboto` — e não deu o passo seguinte.

A precisão que faltava: **fonte declarada por um pacote de dependência entra no
manifesto prefixada**. O `flutter_tools` faz
`Font('packages/$packageName/${font.familyName}', packageFontAssets)`
(`lib/src/asset.dart`), e é por isso que o manifesto da demo lista
`packages/flocks/Poppins` e não `Poppins`. Logo, embarcar uma Roboto no `flocks`
**não resolveria**: viraria `packages/flocks/Roboto`, e a comparação é igualdade
literal. A família só pode se chamar `Roboto` se for declarada no `pubspec.yaml`
do **próprio app** — `packages/flocks_demo/pubspec.yaml`, que hoje não tem sequer
seção `flutter:` de topo. Fora do escopo da raia que mediu isto, e é o item que
substitui este.

Duas variantes, e o que falta medir em cada uma:

- **vendorar uma Roboto de verdade.** Honesta: a família chamada Roboto é a
  Roboto. Custo: um TTF que a demo nunca usa passa a sair da nossa origem em toda
  carga fria, e fonte de texto não sofre tree-shaking — isso já foi medido quando
  a mono entrou. O número de bytes é **a medir**;
- **apelidar sob `family: Roboto` um TTF que já viaja no bundle.** Zero bytes a
  mais. Em troca o manifesto passa a declarar uma família `Roboto` que não é
  Roboto — num repo que trata prosa falsa como defeito, isso é decisão de
  honestidade, não de bytes. Falta medir também se uma seção `fonts:` do app
  aceita `asset:` de outro pacote.

Nas duas, `fontFallbackBaseUrl` fica intocado e a fila de Noto continua de pé:
some a requisição **incondicional**, que é a cara, e permanece a **sob demanda**,
que só sai quando um glifo precisa. Quem executar precisará atualizar junto o
`reason` do gate do CDN em `test/architecture_test.dart`, que hoje nomeia a
Roboto como o que a flag não alcança.

**Ressalvas desta medição, ditas por inteiro.** O Flutter instalado é **3.44.9**
e o CI pina **3.44.0**: os números de rede acima saíram de um build 3.44.9. O que
sustenta lê-los como válidos para a 3.44.0 não é suposição — `_robotoUrl`, a
condição de `loadAssetFonts`, o default de `fontFallbackBaseUrl`, a linha de
`startDownloads` e a contagem de 724 foram lidos na **tag `3.44.0`**
(`git show 3.44.0:<caminho>`), não na 3.44.9. E uma coisa **não** foi medida: que
digitar hoje um glifo sem cobertura puxe de fato uma Noto. A tentativa esbarrou
no que a seção da busca do CRUD já documenta — em build servido em `127.0.0.1` o
clique não chega ao Dart, e `input.flt-text-editing` nem chega a ser criado. A
fila de Noto está descrita pelo fonte do engine, não por uma requisição
observada.

**O que isso não é:** não é o logo saindo da aba. São downloads de fonte, não
uploads, e o gate de rede continua provando que nenhum byte do logo vai a lugar
nenhum.

**Onde a frase falsa estava escrita.** "Esta página não contacta host nenhum" não
está na tela nem no README — mas estava em dois lugares, e era falsa nos dois:
`ci.yml`, no comentário do passo de build da demo (corrigido no PR que trouxe
esta medição), e o `reason` do gate do CDN em `test/architecture_test.dart`, que
dizia que sem a flag "deixa de ser verdade que ela não contacta host nenhum" —
sem a flag ou com ela, a demo contacta. **Os dois estão corrigidos**; o `reason`
agora nomeia a Roboto, que é o que a flag não alcança. Continua valendo a regra
que gerou a dívida: a frase não pode voltar enquanto a Roboto sair.

**Como medir, para a próxima pessoa não errar como a anterior.** A auditoria de
2026-08-11 concluiu "39 requisições, todas em `flocks.live`, nenhuma para
`fonts.gstatic.com`" — e estava errada por método: a aba de rede usada lista só
requisições da origem da página, e as de terceiros não aparecem nela. O que vê
tudo é `performance.getEntriesByType('resource')` no console da própria página.
Os dois arquivos do gstatic vêm com `cache-control: public, max-age=31536000`,
então o byte sai na primeira visita e o cache responde nas seguintes; a primeira
visita de cada visitante é justamente a que a tese da demo descreve.

---

# Analytics — documentado, não implementado

O projeto PostHog ainda não existe, então **nada aqui está no código**. Este
arquivo fixa os nomes agora para que a instrumentação, quando chegar, não invente
um vocabulário novo — e para que a regra de privacidade abaixo entre junto com o
primeiro evento, e não depois do primeiro vazamento.

| Evento | Quando | Propriedades |
| --- | --- | --- |
| `demo opened` | a demo monta | os seis parâmetros do contrato de URL, como vieram |
| `demo brand changed` | a semente de cor muda | `seed` (hex) |
| `demo logo uploaded` | um logo é aceito | **só o fato.** Ver abaixo |
| `demo axis changed` | estilo, forma ou tipografia mudam | `axis`, `value` |
| `demo screen changed` | troca de tela | `screen` |
| `demo config exported` | o snippet Dart é copiado | os seis parâmetros |
| `demo link shared` | o link compartilhável é copiado | os seis parâmetros |

## A regra que não se negocia

`demo logo uploaded` registra **o fato, e nada mais**. Nunca a imagem, nunca os
bytes, nunca o nome do arquivo, nunca o tamanho, nunca o tipo MIME.

Isso não é excesso de zelo — é a mesma fronteira que
`test/no_network_test.dart` protege. A demo diz ao visitante, na tela, que o
logo dele não sai da aba. Um evento de analytics carregando `filename:
"logo-final-v3-aprovado.png"` desmente essa frase e sai por um caminho que o
gate de rede não vê, porque o cliente de analytics seria uma dependência
legítima com permissão para falar com o mundo.

Repare que o código já ajuda: o nome do arquivo **nunca chega ao estado da
demo** (`browser_web.dart` lê os bytes e descarta o resto, e o formato sai da
assinatura binária, não da extensão). Quem for instrumentar não vai encontrar o
nome do arquivo para registrar por engano — vai ter de ir buscá-lo de propósito.

## Ao implementar

Estender `test/architecture_test.dart` com a lista de dependências permitidas: um
cliente de analytics é, por definição, um caminho de rede, então o teste que hoje
exige ZERO requisições precisará distinguir o destino de telemetria de todo o
resto — e essa distinção é exatamente onde a fronteira do logo se perderia se
ninguém estivesse olhando.

---

# A busca do CRUD que não filtra na web — causa desconhecida

**O sintoma é real, reproduzível e continua sem causa conhecida.** Em
https://flocks.live/demo/?screen=crud, um clique no campo de busca e algumas
teclas: `document.querySelector('input.flt-text-editing').value` devolve o texto
digitado, o canvas segue no placeholder, a lista não filtra, o console fica
limpo. Reproduz em carga fria, no primeiro clique.

O caminho de texto funciona fora da web: `packages/flocks_demo/test/layout_test.dart`
exercita `tester.enterText` nos campos do CRUD e passa na VM. A ligação está
correta — `crud_screen.dart:257` passa `onChanged: onSearch`, e `:75` faz
`setState(() => _query = q)`.

## A hipótese que foi refutada, para ninguém gastar o tempo de novo

Suspeitou-se do platform view do DOM que o `SelectableRegion` monta na web (ver a
entrada seguinte). A teoria era: o div fica por cima do campo, o `preventDefault()`
do listener dele cancela a transferência de foco, e as teclas mutam o
`input.flt-text-editing` sem chegar ao Dart. **Três medições independentes
derrubam o elo** (Chrome, 1280x720, 2026-08-12):

| Medição | Resultado | O que derruba |
| --- | --- | --- |
| ponteiro PARADO sobre o div | `document.body.style.cursor === "text"` | o Flutter hit-testou por baixo e aplicou `SystemMouseCursors.text` — o ponteiro nunca foi perdido |
| `input.flt-text-editing` antes/depois do clique | 0 → 1 | o elemento só nasce porque o framework pediu `TextInput.setClient`/`show`; logo o clique CHEGOU ao Dart |
| clique em page (380,176) — dentro do campo, FORA do rect do div (que acaba em x=340), com `elementsFromPoint` === `["flutter-view","body"]` | sintoma IDÊNTICO em 2 de 2 cargas frias: `value === "nor"`, canvas no placeholder, 4 contas na lista | sem listener e sem `preventDefault` ali; se o div fosse a causa, esse clique teria funcionado |

Complemento: `grep -n "platformView\|flt-platform" <engine>/lib/web_ui/lib/src/engine/pointer_binding.dart`
não devolve nada — não há exclusão de platform view no `PointerBinding`. O
`pointerdown` borbulha do div até o root e é hit-testado normalmente.

O `preventDefault()` incondicional existe (`_platform_selectable_region_context_menu_web.dart:132`,
antes do teste de botão em `:133`) e os 21 divs existem. Eles só não são a causa
deste sintoma.

## Por onde continuar

O que o sintoma exige de qualquer teoria nova: o clique chega ao Dart (o
`setClient` prova), o valor chega ao elemento do DOM, e o
`EditableTextState._formatAndSetValue` não corre — ou corre e o `onChanged` não
sai. O próximo passo é instrumentar o caminho `TextInputClient.updateEditingValue`
num build de profile com `--dart-define` de log, e comparar com o campo do
formulário, que funciona na MESMA página.

## Como medir sem se enganar

**Valide o harness com um controle conhecido-bom ANTES de concluir qualquer
coisa.** O campo do formulário do CRUD funciona em produção e é o controle: se ele
falhar na sua medição, a medição não vale. Aprendido do jeito caro — nem
`flutter run -d web-server` nem servir o `build/web --release` em `127.0.0.1`
reproduzem entrada de texto de forma confiável: nos dois, o campo do formulário
recusou texto com a árvore intacta, inclusive no build SEM mudança nenhuma.

`flutter test --platform chrome` também não alcança: em `packages/flocks` a suíte
nem carrega (`Unsupported operation: _Namespace`, de `dart:io` em
`test/flutter_test_config.dart`), e onde carrega o `tester.enterText` injeta pelo
`TestTextInput` do harness, sem passar pelo caminho DOM do engine.

---

# Um `SelectableRegion` por `AppText` é um elemento do DOM por componente

**Na web, `SelectableRegion` não é só semântica: é um `div`.** Ele monta um
`PlatformSelectableRegionContextMenu` — um `Positioned.fill` com
`HtmlElementView` — e um elemento do DOM não participa do hit-test do Flutter.
`AppText` embrulha **cada** texto num `AppSelectionRegion`
(`packages/flocks/lib/src/atoms/texts/app_text.dart:58`), que cria a região sempre
que existe `Overlay` ancestral.

Medido em 2026-08-11: **21 desses divs numa tela** da demo, e 48 pontos da área de
um `AppBarChart` com um deles no topo.

**O que já foi corrigido:** os 17 sítios de texto decorativo sob `IgnorePointer`
passaram a viver num `SelectionContainer.disabled`, e
`packages/flocks/test/architecture/decorative_selection_test.dart` mantém a regra.
O `IgnorePointer` sozinho não bastava: ele tira o texto do hit-test do Flutter e
deixa o elemento do DOM de pé para o navegador, oferecendo seleção e menu de
contexto sobre o alvo.

**O que ainda não foi:** `SelectableRegion` foi desenhado para envolver uma
REGIÃO uma vez, não cada folha de texto. Enquanto `AppText` criar uma região por
texto, todo `AppText` que caia sobre algo interativo repete a classe. Mudar isso
altera se o texto do design system é selecionável por padrão — é decisão de API do
mantenedor, e toca os 131 componentes. Rastreado na issue #28.

**Também não:** o `preventDefault()` incondicional do SDK é defensavelmente um
bug, mas **não há repro mínimo fora deste repo**, e sem um `flutter create` novo
isolando um `SelectableRegion` sobre um `TextField` não dá para abrir issue no
flutter/flutter sem afirmar mais do que se verificou. Note que ele NÃO é a causa
da busca do CRUD (ver a entrada acima).
