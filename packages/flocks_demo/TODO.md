# Pendências da demo

## As duas fontes que o runtime do Flutter busca no Google

São **duas** requisições a `fonts.gstatic.com` por carregamento frio, e nenhuma
delas é escolha da demo. Medidas em `https://flocks.live/demo/` em 2026-08-11,
nas duas telas:

| Fonte | Bytes | Quando |
| --- | --- | --- |
| `roboto/v32/KFOmCnqEu92Fr1Me4GZLCzYlKw.woff2` | 63.464 | na carga de fontes, junto dos 5 TTF locais, **antes do primeiro frame** |
| `notosanssymbols/v43/rP2up3q65FkA….woff2` | 69.116 | no **primeiro layout**, sem ninguém digitar nada |

**A Roboto sai mesmo sem a demo usá-la, e não é lazy.** O CanvasKit precisa de
uma fonte de fallback registrada para não estourar ao dispor texto com família
desconhecida, e escolheu a Roboto para casar com o Android. Em
`canvaskit/fonts.dart` do engine (SDK 3.44.0), `loadAssetFonts` percorre o
`FontManifest.json` e, se nenhuma família ali se chamar literalmente `Roboto`,
acrescenta `_downloadFont('Roboto', _robotoUrl, 'Roboto')` à lista que é
**aguardada** antes de seguir. Nosso manifesto declara `packages/flocks/Poppins`
e `packages/flocks/SpaceGrotesk`: a condição é sempre verdadeira. `_robotoUrl` é
`'${configuration.fontFallbackBaseUrl}roboto/v32/…woff2'`, e
`fontFallbackBaseUrl` cai no default `https://fonts.gstatic.com/s/` porque
ninguém o configura — `web/index.html` não tem bloco de config do loader.

**A Noto Sans Symbols é lazy, e o gatilho é nosso.** A fila de fallback do
engine baixa uma Noto por codepoint sem cobertura, e
`getMissingCodePoints(codePoints, fontFamilies)` confere a cobertura **só contra
as famílias daquele span**, não contra tudo o que está registrado. O bloco de
código do painel ("Take it with you") pede a pilha mono de
`app_content_style.dart` do `flocks` — `SF Mono`, `Menlo`, `Consolas`,
`Roboto Mono`, … —, e nenhuma delas está registrada no CanvasKit. Aí cada acento
do comentário em português do snippet ("já", "padrão", "só") vira codepoint
órfão.
Como acento latino é coberto por dezenas de Noto, dá empate, e o desempate do
engine prefere explicitamente a Noto Sans Symbols: **67,5 KB de uma fonte de
símbolos para desenhar "ã"**. O painel é chrome compartilhado, então as duas
telas pagam.

Nada disso é alcançável pelos gates: acontece no bootstrap JavaScript e na fila
do engine, antes e fora de qualquer Dart nosso. A irmã das duas — o CanvasKit
vindo do `www.gstatic.com` — já foi corrigida com `--no-web-resources-cdn` no
CI, com gate estático em `test/architecture_test.dart`, e a medição confirma que
essa continua corrigida: zero requisições a `www.gstatic.com`.

**Por que ainda não foi corrigido:** o caminho é `fontFallbackBaseUrl` na
configuração do loader, apontando para uma cópia das fontes de fallback servida
por nós. Isso significa vendorar a Roboto (Apache 2.0, redistribuível) e
reproduzir a estrutura de diretórios que o engine espera — sem contrato
documentado e sujeito a mudar entre versões do Flutter. E agora não é só a
Roboto: apontar a base para nós obriga a decidir o que fazer com a fila de Noto
inteira, que é grande e é escolhida em tempo de execução. A segunda requisição
tem um conserto mais barato e independente: empacotar uma mono nos assets do
`flocks` — o `TODO(flocks)` de `app_content_style.dart` já aponta para lá por
outro motivo (goldens de código determinísticos) — mata o gatilho na raiz.

**O que isso não é:** não é o logo saindo da aba. São downloads de fonte, não
uploads, e o gate de rede continua provando que nenhum byte do logo vai a lugar
nenhum.

**Onde a frase falsa está escrita.** "Esta página não contacta host nenhum" não
está na tela nem no README — mas está em dois lugares, e é falsa nos dois:
`ci.yml`, no comentário do passo de build da demo (corrigido no PR que trouxe
esta medição), e o `reason` do gate do CDN em `test/architecture_test.dart`, que
segue dizendo que sem a flag "deixa de ser verdade que ela não contacta host
nenhum" — sem a flag ou com ela, a demo contacta.

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
