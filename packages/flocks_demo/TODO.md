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

# O `preventDefault()` do SDK que engole o `mousedown` sob todo texto selecionável

**Um `SelectableRegion` na web não é só semântica: é um elemento do DOM por cima
do que ele cobre.** `SelectableRegion` monta um `PlatformSelectableRegionContextMenu`,
que é um `Positioned.fill` com `HtmlElementView` — um platform view real. O
listener dele, em
`packages/flutter/lib/src/widgets/_platform_selectable_region_context_menu_web.dart`
(SDK 3.44.0), chama `preventDefault()` **antes** de testar qual botão foi
pressionado:

```dart
mouseEvent.preventDefault();              // incondicional
if (mouseEvent.button != _kRightClickButton) { return; }
```

`preventDefault()` no `mousedown` cancela a transferência de foco padrão do
navegador. É a mesma perda de foco que
`packages/flocks/lib/src/foundation/pointer/pointer_interceptor_web.dart:72-78`
já documenta, só que aqui vinda do próprio framework.

Medido em https://flocks.live/demo/?screen=crud em 2026-08-11, com
`document.elementsFromPoint` antes de qualquer clique:

| Ponto sondado | Elemento no topo |
| --- | --- |
| campo de busca do CRUD (tem `hintText`) | `div.web-selectable-region-context-menu` |
| botão "New account" | `flutter-view` |
| linha da lista | `flutter-view` |

E no `AppBarChart` do widgetbook, 48 pontos da área do gráfico tinham um desses
divs no topo; o `pointerdown` sobre uma barra coberta por rótulo de eixo era
entregue ao div, não ao gráfico.

**O que já foi corrigido.** Do lado do Flocks, todo texto decorativo sob
`IgnorePointer` passou a viver num `SelectionContainer.disabled`, e
`packages/flocks/test/architecture/decorative_selection_test.dart` mantém a regra.
`IgnorePointer` sozinho não bastava: ele tira o texto do hit-test do Flutter e
deixa o elemento do DOM de pé para o navegador.

**Por que ainda não foi corrigido lá em cima:** o `preventDefault()`
incondicional é defensavelmente um bug do SDK, mas **não há repro mínimo fora
deste repo**. Sem um projeto `flutter create` novo isolando um `SelectableRegion`
sobre um `TextField`, não dá para abrir issue no flutter/flutter sem afirmar mais
do que foi verificado. A dívida é construir esse repro.

**A questão maior, ainda em aberto:** `AppText` embrulha **cada** texto num
`AppSelectionRegion` (`packages/flocks/lib/src/atoms/texts/app_text.dart:58`), e
com `Overlay` ancestral isso vira um `SelectableRegion` por texto — 21 platform
views DOM só na tela do CRUD, medidos. `SelectableRegion` foi desenhado para
envolver uma REGIÃO uma vez, não cada folha. Trocar isso muda se o texto do
design system é selecionável por padrão: é decisão de API do mantenedor, e mexe
nos 131 componentes.

**Como medir, para a próxima pessoa não errar como a anterior.** Não confie no
`flutter run -d web-server` nem em servir o `build/web` em `127.0.0.1` para
julgar entrada de texto: nas duas formas o campo do formulário — que funciona em
produção — também recusou texto, com a árvore intacta. Sempre valide o harness
com um controle conhecido-bom ANTES de concluir qualquer coisa; se o controle
falha, a medição não vale. `flutter test --platform chrome` também não pega esta
classe: em `packages/flocks` a suíte nem carrega (`Unsupported operation:
_Namespace`, de `dart:io` em `test/flutter_test_config.dart`), e onde carrega o
`tester.enterText` injeta pelo `TestTextInput` do harness, sem passar pelo
caminho DOM do engine, e o view factory do platform view não é registrado sob
`flutter_test`.
