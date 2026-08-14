# Changelog

Every relevant change to this package. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the numbering
follows [SemVer](https://semver.org/).

> **On the numbering.** Nothing below `[0.1.0]` was ever published. Those
> versions are *internal* migration milestones from the monorepo — they ran
> from `0.1.0` to `1.5.0` while the pubspec still said `1.0.0`, so they never
> agreed with it in the first place. The component catalog used to carry the
> same milestones in a `since:` field; it was dropped for that reason.
>
> The **public** line starts at `0.1.0`, on purpose. `1.0.0` on pub.dev is a
> promise about the future, and this package has not yet met an external
> consumer. In `0.x`, SemVer makes the minor the breaking slot, so `^0.1.0`
> pins adopters to `>=0.1.0 <0.2.0` and the churn cannot reach them by
> surprise. It graduates to `1.0.0` once the API holds still through a few
> outside adopters.

## [Unreleased]

### Added

- **`AppBadge(icon:)` — o glifo à esquerda do rótulo, casado à caixa de linha.**
  Slug de `AppIconToken` pintado com o MESMO papel de cor do texto. O tamanho do
  ícone é a caixa de linha **medida** do label: o `TextPainter` já aplica o
  `textScaler`, e altura de ícone igual à da linha garante por construção que a
  pílula com ícone tem a mesma altura da sem — o raio proporcional não se mexe, e
  o teste pina isso comparando o `BorderRadius` com e sem ícone. A largura medida
  soma ícone + gap, senão o resolvedor de raio veria uma pílula mais estreita que
  a real. O glifo fica fora do `SelectionContainer` e é decorativo: o badge segue
  um nó rotulado único, com o label ORIGINAL. Contador e conteúdo à direita
  seguem deliberadamente fora.

- **`AppAvatar(fallbackIcon:)` — o glifo do estado sem imagem e sem texto.** Nos
  dois construtores: o slug que substitui o `user` chumbado quando não há imagem
  nem texto — o círculo de anexo, a miniatura de entidade. `null` é o glifo de
  sempre, o texto de fallback continua vencendo o ícone, e a cor do glifo segue o
  neutro chumbado (abrir a cor é outro item). Cada caminho preserva o próprio
  regime de escala; os testes de geometria existentes passaram sem edição e os 6
  goldens do avatar ficaram byte-idênticos.

- **`AppActionItem(direction:)` — a célula da grade de anexos.** `Axis.vertical`
  empilha ícone sobre rótulo centrado, com o MESMO padding, o mesmo raio e as
  mesmas cores; `horizontal` (default) segue a linha de sempre, com teste de
  identidade pinando `getSize` e a ordem ícone-à-esquerda. Abrir a cor por papel
  continua sendo outro item.

- **`AppColorPickerPanel(showSpectrum:)` — o modo só-presets.** `false` esconde o
  espectro de edição livre INTEIRO — área de saturação/brilho, barra de matiz e o
  preview com hex, que pertence à edição livre — deixando só a paleta fixa. Um
  assert fecha o painel vazio, e o respiro entre seções sai junto com o espectro:
  só-presets abre direto no rótulo, sem vão órfão. O painel não tinha teste
  dedicado (a cobertura vinha indireta pelos picker inputs); agora tem.

- **`AppSegment(tooltip:)` — a forma longa do rótulo abreviado.** A classe é
  DADO, então não dava para embrulhar um segmento em `AppTooltip` por fora: o
  parâmetro viaja com o segmento e a célula é envolvida DENTRO do
  `AppSemantics.toggle` (o precedente é o rail colapsado). O nome do controle
  continua o do toggle; a dica é visual. Sem `tooltip`, a árvore é a de sempre e
  os 9 goldens do segmented ficaram byte-idênticos.

- **`AppListTileGroup(title:)` — o rótulo de seção acima do card.** Mesmo traje do
  título de seção do `AppMenu` (a classe de lá é privada; o desenho foi duplicado
  com a referência anotada). Fica FORA do container de propósito: o card é o
  conteúdo, o rótulo separa grupos numa lista seccionada. `null` é a árvore de
  sempre, provada por teste dedicado — o grupo não tinha nenhum.

- **`AppTileInfo` deita na linha de ficha e ganha ícone.** `AppTileInfoLayout
  {vertical, horizontal}`, default `vertical` — e sem `icon` o vertical é nó a nó
  a `Column` de sempre. O horizontal é a linha de ficha que oito pontos do
  consumidor montavam com larguras mágicas: rótulo à esquerda com o ícone
  opcional na mesma cor muted, valor no `Expanded` à direita.

- **`AppSimpleDataTable(columnFlex:)` — a coluna larga sem sair do flex.** Fator
  por coluna (`[2.2, 1, 1]`); `null` é a repartição uniforme de sempre. O
  mecanismo continua o dos dois caminhos de hoje: com largura finita vira
  `FlexColumnWidth`, sem largura vira `IntrinsicColumnWidth(flex:)`, que reparte
  só a sobra. O nome diverge do `columnWidths` do `AppDataTable` de propósito —
  lá é pixel, aqui é proporção: duas semânticas, dois nomes.

- **`showAppSnackbar` ganha o toast de uma frase, o papel de aviso e o canto.**
  `title` vira opcional com `type` defaultando para `info` — sem título a linha
  some, o ícone centraliza com a mensagem e ela assume `onSurface`, por ser o
  único conteúdo do card. `AppSnackbarType` ganha `warning`, com o mesmo âmbar e
  o mesmo ícone do `AppAlert` — era o único papel semântico que o alerta tinha e
  a snackbar não. E `position` deixa de ser chumbado (default `bottomRight`; no
  celular o esperado é `bottomCenter`). **Atenção na migração:** erro precisa
  passar `type` explícito — com o default `info`, remover o tipo troca vermelho
  por azul em silêncio.

- **`AppMenuItem(subtitle:)` — a prévia de duas linhas.** Até 2 linhas com
  ellipsis, no mesmo par do chrome de seção do menu, esmaecidas junto com o label
  quando desabilitado. O rótulo semântico soma as duas linhas, então o leitor
  ouve a prévia sem navegar para dentro do item. Sem `subtitle` a linha é nó a nó
  a de sempre e os 12 goldens do menu ficaram byte-idênticos.

- **`AppAlert` ganha ação, dispensar e conteúdo livre DENTRO do card.** `action`
  é Widget, e não par rótulo/callback, porque os casos reais precisam de loading,
  dropdown ou duas ações; `actionPlacement` escolhe rodapé ou trailing.
  `onDismiss` é callback puro num × de alvo próprio — dispensar e agir são gestos
  diferentes, como no `AppFilterChip`. `child` entra entre descrição e rodapé,
  herdando o fundo tingido. `liveRegion` existe porque região viva com controle
  dentro re-anuncia o card a cada loading: alerta que é mobília da tela agora
  desliga o anúncio sem calar o texto. E `maxLines` (default 3, `null` remove o
  teto) tira o limite chumbado da descrição.

  Junto veio uma correção nos helpers do eixo `AppStyle`: eles liam TODOS os
  `DecoratedBox` descendentes, e o anel de foco transparente do × viraria falso
  positivo de borda. Agora leem a caixa PRÓPRIA do card, que é o que o eixo mede.

- **`AppNavigationRailItem(activeIcon:)` — o par vazado/cheio do rail.** O slug
  alternativo renderizado só enquanto o item está selecionado. Há UM ponto de
  render de ícone no rail, então colapsado e expandido herdam de graça; no
  item-pai o sinal é o mesmo que já pinta ícone e título de accent — no rail
  colapsado com filho selecionado, o ícone do pai é a única pista visível.
  `null` deixa `icon` servindo aos dois estados, com árvore idêntica por colapso
  da expressão.

- **`AppNavigationRail` aceita a marca como Widget.** `logo`/`logoCompact` +
  `logoSemanticLabel` — obrigatório por assert, porque slot de widget só entra
  nomeado —, mutuamente exclusivos com os slugs e URLs legados, também por
  assert. O fallback é simétrico nos dois sentidos: a assimetria do canal antigo
  era acidente de tipo (slug × URL), e dois widgets são intercambiáveis. A
  semântica segue o idioma do `AppImage`: UM nó de imagem nomeado com a subárvore
  excluída, senão o rótulo mescla com o texto interno e o leitor anuncia a marca
  duas vezes. De carona, a meta declarava `logoCollapsed` como obrigatório e o
  widget o tem opcional desde sempre — a mentira foi corrigida ao lado dos props
  novos.

- **`AppPrimaryHeader(bottom:, bottomHeight:)` — a faixa de filtros dentro da
  barra.** A linha extra que vivia no `AppBar.bottom` do Material, herdando fill,
  borda e glass da superfície. A altura é **declarada**, não medida: o
  `AppScaffold` reserva a extensão da barra ANTES do layout, então a resolução
  soma exatamente `bottomHeight`, e os dois parâmetros andam juntos por assert
  (com `bottomHeight >= 0` à parte — o biconditional sozinho deixaria -5 passar).
  No ramo `null` o corpo É o mesmo objeto de antes: árvore idêntica por
  construção.

- **`AppAuthSplitLayout` aceita marca como Widget e afrouxa os textos.**
  `brandTitle`/`brandSubtitle` viram opcionais e entra `logo` +
  `logoSemanticLabel`, com TRÊS asserts que fecham os franken-estados: um logo só
  (Widget OU slug), widget exige rótulo, e identidade sempre presente
  (`brandTitle` OU `logoSemanticLabel`) — porque subtítulo sozinho não nomeia
  marca. Era o buraco de a11y do item: sem os asserts, tirar o `required`
  deixaria o painel mudo.

- **`AppInput(textAlign:)`** — o campo de código centralizado, sem furar o eixo
  de tipografia. Entra só o alinhamento; o `TextStyle` livre continua **fora** de
  propósito, porque um estilo cru no call site tira o texto do eixo que faz um
  valor no tema restilar o pacote inteiro.

- **`AppImage.memory` — a terceira variante do átomo de imagem, para o payload
  que não tem URL.** O QR do PIX que chega em base64, o preview de anexo, o
  gráfico renderizado pelo backend. Mesmo contrato da variante de rede
  (placeholder, cross-fade, fallback em erro), com `gaplessPlayback` para
  trocar de conteúdo sem piscada; bytes vazios ou corrompidos nunca viram frame
  quebrado. Junto vem `AppImage.decodeBase64`, tolerante ao que o backend
  costuma mandar (whitespace, prefixo `data:`, padding ausente) e devolvendo
  `null` em vez de lançar. `src` afrouxa para `String?` — nulo **apenas** na
  variante nova; `.network`/`.asset` seguem exigindo `String` no call site.
  `memory` entra em `kComponentVariants` e a matriz golden congela o caminho
  novo; os 4 PNGs de fallback existentes ficam byte-idênticos, que é a prova de
  que a árvore sem o parâmetro novo é a de hoje.

- **`AppChoiceChip` + `AppChoiceChipBar` — o chip selecionável que faltava e a
  barra de filtros que o AppSegmentedButton não atende.** O terceiro chip do
  pacote é o único com estado de ESCOLHA: UM alvo sob semântica de toggle
  (checked/inMutuallyExclusiveGroup), contador em pílula própria (colar o
  número no rótulo mata o alinhamento), selecionado no MESMO
  `appFilledButtonColors` do AppSegmentedButton — os dois respondem "um de N"
  e o teste compara contra o resolvedor para nunca divergirem. A barra rola
  onde o segmented estoura (células de largura própria + véu de borda), com
  ←/→ andando pelos chips e o focado rolado até aparecer; o `.multi` devolve
  SEMPRE um `Set` novo. Altura mínima **44**, o piso de alvo de toque do iOS —
  e não os 40 do `AppButton(size: s)`: um componente que nasce agora não nasce
  devendo acessibilidade, e a diferença de 4px contra um botão `s` ao lado foi
  o preço aceito. Os 48×48 do Android seguem em `kA11yDebt`, porque fechá-los
  custaria a densidade da barra inteira; a metade cumprida é medida por gate,
  para o número não escorregar de volta. O catálogo vai a **135** (24·75·36).

- **`AppSlider` — o primeiro slider público do pacote.** Controlado (value +
  onChanged, estado no chamador, molde do AppRating); `step` quantiza em
  UNIDADES DO DOMÍNIO (1.0 = inteiros) em vez do `divisions` do Material;
  `formatValue` é fonte única para o rótulo inline (`showValue`) e para o
  leitor de tela — um formatador separado criaria a divergência que a Regra 8
  impede. Nasce com 48px de alvo (sem entrada em kA11yDebt), nó `slider` com
  onIncrease/onDecrease, setas espelhadas em RTL, Home/End, anel de foco sem
  duração e `onChangeEnd` para persistência. O catálogo vai a **133**
  (24·73·36). O hue slider privado do color picker segue como está — a
  recomposição exigiria trilho-gradiente público por um consumidor interno;
  fica registrada para rodada própria.

- **`AppQuotedMessage` — o bloco de citação que faltava no chat** (autor +
  prévia + miniatura opcional, atrás de uma barra de acento). Vai de `header`
  numa `AppChatBubble` (a resposta) ou solto no composer (a prévia de
  "respondendo a…", com `onRemove` de cancelar — alvo PRÓPRIO, idioma do
  AppFilterChip). A cor vem do `AppChatBubbleColor` da conversa: `accentOn` na
  barra e no autor, `resolve` a **10%** no fundo — um degrau abaixo dos 14% da
  bolha, para ler como camada aninhada. O catálogo vai a **132** componentes
  (24·72·36).

- **`AppPulse` — o pulso em laço do eixo de motion** (respiração de opacidade
  e, opcionalmente, escala) para indicadores ao vivo: a bolinha de gravação, o
  dot de transmissão. Amplitude em vez de flag: `minOpacity`/`minScale` dizem
  o quanto, e `1.0` desliga o eixo. Sob reduce-motion o laço **para e congela
  no estado cheio** — deliberadamente diferente do resto do eixo, que colapsa
  para o alvo: laço não tem alvo, e um indicador ao vivo congelado apagado
  leria como "desligado". Decorativo por contrato: quem indica "gravando"
  rotula no ponto de uso.

- **`showAppConfirm` — a confirmação sim/não como função, sobre o
  `showAppDialog`.** Devolve `Future<bool>` que **nunca é nulo**: confirmar
  resolve `true`; cancelar, barrier, "X" e Esc resolvem `false`. A normalização
  é a razão de a função existir — sem ela cada chamador remonta corpo + rodapé
  e escreve `== true` no final. `destructive:` liga o papel `danger` no botão
  de confirmar E no acento da ilustração (o contrato do `accentRole`);
  `confirmColor:` sobrescreve o papel sem desligar a semântica. Uma guarda
  `appRouteIsTopmost` faz de dois toques rápidos um pop só. É função, não
  widget: não tem entrada própria no catálogo (precedente dos helpers `show*`)
  e vive documentada na ficha do `AppDialog`.

### Changed

- **`AppDialogContent.illustration` ficou opcional (`String?`).** `null` tira o
  bloco da arte inteiro do layout — os dois respiros de 64 e a ilustração — e o
  corpo fecha com um respiro de 32: é o corpo do diálogo de confirmação puro,
  que é maioria. Source-compatible para quem constrói (todo chamador passa
  named param); quem **lê** o campo como `String` não-nulável precisa de `?`
  agora — daí a linha aqui.

## [0.1.2] - 2026-08-12

A marca aprende a se escrever. É a única feature de pacote que o ROADMAP prevê,
e ela existe para a demo do site: sem isto o visitante vê a marca dele nos 131
componentes e vai embora; com isto ele leva o arquivo que reproduz o que viu.

E a demo já pagou o primeiro dividendo: montar duas telas inteiras sobre o eixo
de forma revelou que uma superfície grande em `circular` cortava o próprio
conteúdo — um defeito que nenhum use case isolado tinha exercitado.

### Added

- **`toDartSnippet` escreve uma `AppBrandConfig` como código Dart colável.** É
  uma extension, não um método: a classe documenta no próprio dartdoc o que ela
  deliberadamente não guarda, e gerar código não é responsabilidade de uma
  configuração. Também não é um `Codec` — o nome vem de `dart:convert` e promete
  um `decode` simétrico que não existe aqui, porque o decode desta serialização
  é o compilador Dart.

  A saída traz **só o que difere do padrão**: eixo em `standard` não aparece,
  papel de cor ausente também não. Cada swatch sai pela função que o reconstrói
  (`swatchFromSeed`, `neutralSwatchFromSeed`, `flippedSwatch`) sempre que a
  semente o reconstrói **de fato** — o gerador confere antes de escolher a forma
  curta, e um swatch escrito à mão, que não tem semente que o descreva, cai no
  literal de 11 stops. Serialização que não faz ida e volta é serialização
  errada, e a alternativa (assumir a semente) devolveria uma paleta diferente da
  que entrou.

  O gate mora em `test/architecture/brand_snippet_freshness_test.dart` e o
  artefato em `test/support/exported_brand_snippet.dart` — um `.dart` de
  verdade, e não um `.txt`, para que o `dart analyze` da raiz prove de graça
  aquilo que um teste de string não alcança: que o snippet **compila**.

- **`flippedSwatch` espelha um swatch**, que é como a rampa neutra escura de uma
  marca se obtém da clara. A função já existia, privada, dentro da `flocksBrand`;
  virou pública porque um snippet que a usasse sem poder nomeá-la teria de
  despejar os 11 stops justamente no papel onde a saída precisa continuar
  legível. `kSwatchStops` veio junto, pelo mesmo motivo de quem percorre um
  swatch: um `ColorSwatch` não expõe as próprias chaves.

- **A IBM Plex Mono, empacotada** — `AppFontFamilies.ibmPlexMono`, pesos 400 e
  600, com o `OFL.txt` ao lado dos `.ttf` como as outras duas famílias. São os
  dois pesos que o pacote realmente pede: 400 em todo bloco e código inline, 600
  nos placeholders de `AppApiPath`. Sem itálico, porque o `case 'code'` do inline
  builder não herda o estilo do pai e mono itálica nunca é pedida.

  `AppContentStyle.code` deixa de tentar a mono do SO, e isso conserta duas
  coisas de uma vez. As baselines de código passam a mostrar código: no sandbox
  de teste nenhuma mono de sistema existe, então o `flutter_test_config.dart`
  registrava a Poppins sob o nome `SF Mono` — determinístico, sim, mas era uma
  proporcional fingindo ser mono, e é isso que os 4 goldens de `AppMarkdown`
  tinham de errado. O que ainda varia entre máquinas é o rasterizador de texto, e
  isso nunca foi sobre a família. E, no CanvasKit, uma
  pilha de famílias **não** registradas faz cada codepoint sem cobertura entrar
  na fila de fallback do engine: um acento de comentário em português bastava
  para baixar 69.116 B de Noto Sans Symbols de `fonts.gstatic.com` (medido em
  produção na PR #20, e medido de novo aqui nos dois builds servidos lado a lado
  — 20 requisições e 2 de terceiro antes, 21 e 1 depois). A Roboto de 63.464 B
  continua: a condição que a dispara é o nome da família no `FontManifest.json`,
  e nada disto muda isso.

  Custa **280.252 B** nos assets — 135.580 do Regular, 140.216 do SemiBold, 4.456
  do `OFL.txt` — e custa **integralmente**: fonte de texto declarada em `fonts:`
  **não** é podada pelo `--tree-shake-icons`, que só alcança fonte de ícone por
  `IconData` constante, e os dois `.ttf` saem do build web com os mesmos bytes
  com e sem a flag. No tarball comprimido isso vira algo perto de **+8%**, e não
  um número exato: o `dart pub publish --dry-run` só reporta "1 MB", e reproduzir
  o arquivo por fora dá de 1,52 a 1,63 MB para a MESMA lista de caminhos,
  conforme o empacotador e o nível de gzip. O que é exato é o que está acima. A
  Inconsolata faria o mesmo trabalho por 63.332 B menos; ficou de fora por
  cobertura, e o pubspec registra a comparação inteira.

  Junto entra `test/architecture/font_axis_test.dart`, que cobra o que até aqui
  era só comentário: todo `asset:` declarado existe em disco, o carregador dos
  testes espelha a seção `fonts:` do pubspec, e o texto da licença viaja no
  diretório da família que ele cobre.

  **Depreciadas por isto:** `kAppContentMonoFamily` e `kAppContentMonoFallback`.
  Eram a pilha de monos do sistema e não têm mais função, mas eram API pública na
  0.1.1 — e em `0.x` o slot de mudança breaking é o minor, então ficam marcadas
  com `@Deprecated` e saem na 0.2.0.

### Fixed

- **Uma superfície grande em `circular` parou de cortar o próprio conteúdo.**
  `AppCard` e o cartão de conteúdo do `AppShell` resolviam a forma pela escada
  GERAL, em que `circular` significa "metade do lado menor". Num chip isso é a
  pílula que se espera; num cartão de gráfico de 400 px é uma elipse de 180 px de
  raio cujo canto passa por cima do header — o título "Recurring revenue"
  aparecia como "urring revenue". Os dois passaram a usar `contentSurfaceRadius`,
  uma escada nova que fica ENTRE `resolve` e `surfaceCornerRadius`: idêntica à
  geral em `reto`/`redondo`/`padrao` (um cartão pequeno não deve herdar o canto
  de um bottom sheet) e com teto em `circular`.

  O gate é `test/architecture/surface_clip_test.dart`, e ele é geométrico em vez
  de tipográfico: pinta a área de conteúdo e exige que os quatro cantos dela
  continuem pintados. Não depende de fonte, tema nem baseline — só do clip.

  Descoberto pela demo da Fase D, que é a primeira coisa a exercitar o eixo de
  forma inteiro com conteúdo real em cima.

- **Texto decorativo parou de interceptar seleção sobre área interativa na web.**
  `AppText` embrulha todo texto num `AppSelectionRegion`, e com um `Overlay`
  ancestral isso vira um `SelectableRegion`. Na web um `SelectableRegion` monta um
  `PlatformSelectableRegionContextMenu` — um `Positioned.fill` com
  `HtmlElementView`, ou seja um elemento real do DOM cobrindo a região. Um
  elemento do DOM não participa do hit-test do Flutter, então o `IgnorePointer`
  que marcava o texto como decorativo desaparecia para o framework e continuava de
  pé para o navegador: a dica do campo, os rótulos de eixo dos gráficos e o número
  do passo do stepper ofereciam seleção e menu de contexto exatamente sobre o que
  devia ser só alvo de interação. Medido: 21 desses divs numa tela da demo, e 48
  pontos da área de um `AppBarChart` com um deles no topo.

  Os 17 sítios de texto decorativo passaram a viver num
  `SelectionContainer.disabled`, que zera o registrar e cai no guard que
  `AppSelectionRegion` já tinha — sem API pública nova, e pela receita que o
  pacote já usava em 33 arquivos (o `AppAvatar` a documenta citando o
  `ButtonCore`). Atinge `AppInput`, `AppColorPickerInput`, `AppStepper` e os
  cinco gráficos, que eram justamente os que tinham ficado de fora.

  O gate é `test/architecture/decorative_selection_test.dart`, e é de FONTE por
  necessidade: na VM o platform view nem chega a ser construído — o
  `SelectableRegion` só o embrulha sob `kIsWeb && BrowserContextMenu.enabled` e
  fora de Android/iOS, e o ramo `_io` do arquivo existe apenas para o import
  condicional compilar (descarta o `child` e lança `UnimplementedError` no
  `build`). Nenhum teste de widget alcança a classe. O gate resolve tipos que
  carregam texto transitivamente e filhos passados por variável, porque as duas
  formas escaparam da primeira versão da regra.

- **O `Overlay` que o pacote exige passou a estar no caminho de entrada.** Os
  componentes que flutuam inserem no `Overlay` ancestral mais próximo — os quatro
  dropdowns, o `AppTooltip`, o `showAppOverlay` (e o `showAppSnackbar` que sai
  dele) e o controlador ancorado que serve `AppPopover`, `AppMenu`,
  `AppOmniSearch` e o `AppPickerAnchor` dos campos de data, hora e cor. O pacote
  não monta `Overlay` em lugar nenhum, de propósito: quem hospeda decide onde a
  camada flutuante vive. O mecanismo já aparecia no dartdoc de alguns deles
  ("renderiza via `Overlay`"), mas dizer por onde o painel sai não é dizer que o
  host tem de fornecer o ancestral, nem o que acontece quando falta — e o README,
  que é a página do pub.dev, não citava a palavra uma vez. O
  `example/lib/main.dart` ia além: montava um root SEM `Overlay`, então quem
  copiasse o exemplo e pusesse um dropdown recebia o crash. Os dois passaram a
  montar e a nomear quem exige, junto com as duas páginas da landing, que traziam
  o mesmo `runApp`.

  **Nenhum comportamento mudou POR CAUSA deste item** — nada em `lib/` foi tocado
  por ele, e atualizar não conserta o crash de quem já o tem: o que faltava era a
  frase, não o código. Sem ancestral, abrir qualquer um deles lança em debug pelo
  assert do próprio framework, que manda incluir `MaterialApp`, `CupertinoApp` ou
  `Navigator` — os três widgets que este pacote existe para não ter. A
  `ErrorDescription` dele fica genérica ("Some widgets require an Overlay widget
  ancestor") porque nenhum dos sítios passa `debugRequiredFor`; o `ErrorSummary`
  acima dela nunca nomeia nada, e o componente que falhou aparece só na última
  linha, a do contexto. Em release o assert sai, o `Overlay.of` termina no `!` dele
  e resta `Null check operator used on a null value`.

  A exigência alcança mais que os sítios diretos, e o README passou a dizer as três
  categorias: quem insere sozinho, quem herda de um filho (`AppInput(info:)`,
  `AppPagination(perPage:)`, `AppSplitButton`) e **todo campo de texto**, por regra
  do framework — ao GANHAR FOCO, um `AppInput` monta um `TextSelectionOverlay`, e é
  o construtor do `SelectionOverlay` embaixo dele que exige o ancestral, com
  `assert(debugCheckHasOverlay(context))` na lista de inicialização
  (`widgets/text_selection.dart`). O toque é só uma das formas: `Tab` e um
  `requestFocus()` no `focusNode` que o campo aceita por parâmetro lançam igual.
  Desenhar um campo não lança porque até o foco o overlay de seleção não existe.

  O gate novo é de PRESENÇA, e cobre as quatro cópias da mesma raiz: o primeiro
  bloco de código do README e o `example/lib/main.dart` no
  `readme_example_test.dart`, que já lia o README, e o `<pre><code>` das duas
  páginas do site no `install_docs_test.dart`, ao lado da copy de instalação que
  ele já fiscalizava. O critério está em `test/architecture/entry_root_tokens.dart`.
  Fecha uma armadilha silenciosa: sem ele o `Overlay` sai de uma das quatro numa
  refatoração e nada fica vermelho — nem o `dart analyze`, porque a árvore sem ele
  compila. Nas páginas a comparação é sobre o texto extraído do DOM, porque no HTML
  cru o token vem partido pelos `<span>` de coloração. A árvore da demo continua
  coberta pelo `overlay_dependent_test.dart` dela.

## [0.1.1] - 2026-08-10

Três defeitos que só a análise do pub.dev revelou, no dia seguinte à
publicação. Nenhum deles se conserta na `0.1.0`: lá o tarball é imutável.

### Fixed

- **A licença volta a ser reconhecida.** O `LICENSE` trazia o MIT verbatim
  seguido de um bloco de notas sobre assets de terceiros, e o
  `license_detector` casa o arquivo INTEIRO contra o corpus SPDX — o texto
  apensado derrubava a confiança abaixo do limiar e o pub.dev reportava "No
  license was recognized", 0 de 10 pontos. O arquivo passa a ser exatamente o
  texto SPDX. As notas de terceiros continuam no README, e as obrigações
  legais sempre estiveram cumpridas pelos textos que viajam ao lado de cada
  asset (`OFL.txt`, `assets/icons/LICENSE`).
- **O pacote compila em WebAssembly.** `app_network_icon_provider.dart`
  escolhia o ramo do loader de ícones com `if (dart.library.html)`, e
  `dart:html` não existe no dart2wasm: todo build `--wasm` caía no ramo
  default e arrastava `dart:io` (via `flutter_cache_manager`) para um alvo que
  não o tem. A condição virou `if (dart.library.io)`, que é verdadeira na VM e
  falsa nos dois backends web. Não era só nota: um app em wasm quebrava.
- **Suporte de plataforma volta a 6 de 6.** Ver abaixo.

### Changed

- **A interceptação de ponteiro passou a morar no pacote**, em
  `src/foundation/pointer/`, e a dependência `pointer_interceptor` saiu. Ela
  era um plugin federado que endossa só `web` e `ios`, e o pana intersecta as
  plataformas de todo o fecho de dependências: aquela única linha rebaixava o
  `flocks` — e por herança o `flocks_phosphor` e o `flocks_material` — a
  "Supports 2 of 6 platforms (iOS, Web)" na página do pub.dev, num design
  system que roda em toda parte. Import condicional não resolveria: o pana lê
  o pubspec, não o grafo de imports.

  No web o comportamento é o mesmo, pelo mesmo mecanismo (um `<div>` vazio
  montado atrás do conteúdo, agora sobre `dart:js_interop` + `package:web`, e
  portanto wasm-compatível). **O que se perdeu foi a interceptação no iOS**:
  ela dependia de um `UIView` nativo, e código nativo é justamente o que um
  pacote Dart puro não pode carregar sem virar plugin — que é o problema que
  se estava resolvendo. Um app iOS que precise disso pode declarar
  `pointer_interceptor` por conta própria e embrulhar o `AppOverlayCard`.

  A API pública de `AppOverlayCard` não mudou: mesmos parâmetros, mesmo nome,
  mesmos pixels (os 4 goldens não se mexeram).

### Added

- **`example/`** — a tese do pacote numa tela só: uma semente de cor e os eixos
  globais alternáveis ao vivo, com o card e os botões restilizando juntos. O
  pacote não tinha exemplo, o que custava 10 pontos na análise do pub.dev
  (`0/10 Package has an example`) e, pior, obrigava quem chegava a montar o
  primeiro `runApp` por tentativa.

### Removed

- `lib/src/atoms/illustrations/app_illustration_{io,web}.dart` — código morto
  desde que os providers de ilustração foram para `foundation/illustrations/`:
  nada os importava e o barril não os exportava. O `_io` carregava o segundo
  `dart:io` do pacote.

## [0.1.0] - 2026-08-10

### Added

- `AppBrandTypography` — a brand now picks its display and body families. It
  closes the last white-label gap: color, radius, motion, style, glass and icon
  already belonged to the brand; typography was pinned in the package.
- `AppIconToken` — the contract of 55 icons the components use, and that every
  provider has to know how to serve. It is an `extension type` over `String`, so
  it is accepted anywhere a `String` already is.
- `AppIconProvider` as a theme axis, with two implementations:
  `AppAssetIconProvider` (the default, bundled SVGs, no network) and
  `AppNetworkIconProvider` (a CDN, with the base URL injected).
- `AppIllustrationToken`, `AppIllustrationProvider` and the
  `AppIllustrationTheme` axis — the last corner where the package took a
  third-party licensed asset. The bundled `empty` comes from
  [Open Peeps](https://www.openpeeps.com) under **CC0**, which (unlike
  unDraw/ManyPixels/Storyset) does not forbid redistributing it in a package.
- `AppThemeScope(iconProvider:, illustrationProvider:)` — the seam through which
  the APP picks the icon set. The brand cannot declare it: a large set lives in a
  sibling package, and the core does not depend on those.
- Sibling packages `flocks_phosphor` (1,512 icons × 6 weights, with
  `PhosphorWeight` as an axis) and `flocks_material` (the reference
  implementation, which proves the zero-Material thesis from outside).
- The `flocks` brand — the whole palette derived from a seed through
  `swatchFromSeed`, with Space Grotesk on display. It is the living proof of the
  white-label. (It used to be the only brand that worked with no network at all;
  since `cdnBaseUrl` left `AppBrandConfig`, every brand does.)
- `neutralSwatchFromSeed` — the neutral ramp needs a tone ladder of its own: the
  theme uses stop 300 as `surface` and 600 as `outline`, and on the chromatic
  ladder those two sit 30 tones apart (a ratio of 2.79, below the 3.0 floor).
  Without it, **every** seed-generated brand would fail the contrast gate, in the
  same place.
- `AppTextTheme.copyWith` and `AppBrandConfig.copyWith`, which did not exist.
- `LICENSE` (MIT), this `CHANGELOG` and a real `README`.
- `tool/golden_triage.py` — it builds contact sheets per family for reviewing
  golden failures.
- The catalog freshness gate (`test/architecture/catalog_freshness_test.dart`).
  `doc/mcp/catalog.json` drifted twice in three days because regenerating it was
  a manual step, and the site reads that file to publish the component count —
  each drift became a false number in the wild. The test runs in every PR's
  `flutter test` and also requires that the hand-written numbers in the README
  match the code.

### Changed

- **The catalog's prose is bilingual.** `summary`, `description`, `whenToUse`,
  `whenNotToUse`, `props[].description`, `examples[].title/description`, `do`,
  `dont` and `a11y` now carry `LocalizedText`/`LocalizedList` (`en` + `pt`), and
  `doc/mcp/catalog.json` emits `{"en": …, "pt": …}` for each of them. Both
  languages are required by the constructor, so no component can ship
  half-translated; `test/architecture/catalog_language_test.dart` also fails when
  an `en` field is left carrying Portuguese. **Breaking** for anyone reading
  `AppComponentMeta` or the JSON.
- **`states` and `variants` are a closed English vocabulary.** They name API
  surface (an enum's value, an interaction state), so they are not localized;
  they are checked against the allow-list in
  `test/architecture/catalog_vocabulary.dart`.
- **The `.doc.md` files and this README are in English.** The package is
  international from publication onward. The Portuguese lives on in the catalog's
  `pt` side, which is what the site publishes on its PT routes.
- **`Poppins-SemiBold` enters, and the `title*` styles now render at the weight
  they ask for.** They had declared `w600` all along and fell back to 500 because
  there was no 600 file on disk — the design system's "semibold" never existed.
  161 goldens rebaselined.
- **The whole type scale is Poppins.** The `display*` and `label*` styles were
  Neutrek. The `label*` ones move up to weight 500: Neutrek's regular read much
  heavier than Poppins', and keeping them at 400 erased the separation between
  label and body.
- **`AppIcons` stores slugs, not URLs.** Translating a name into an address is
  the brand's provider's job. The `jotape` and `zxtrack` brands point at the CDN;
  the package's default resolves from the bundled assets.
- **The illustration's default accent became neutral** (it was `secondary`). An
  illustration's fill is the AREA — skin, clothing, surface — not a detail:
  painting it with the brand color left the whole figure monochrome in that
  color. It changes how the illustrations look in all 4 apps.
- `AppIllustrations` stores slugs, not URLs, and `AppIllustration` lost its own
  loading — the provider is what loads.
- `AppIcon` became a `StatelessWidget`. The loading moved inside the provider,
  which also resolved a trap: the download was born in `initState`, where reading
  the theme is unsafe — and the provider comes from the theme.
- `swatchFromSeed` now generates 11 stops (50–950), like the hand-written brands.
- `AppBrand` builds the registry as `final`, not `const`, because the `flocks`
  brand derives its palette at runtime.
- **`AppAuthSplitLayout` takes `websiteUrl` as a parameter.** It used to read
  `AppBrand.current.websiteUrl` — the one place in `lib/src` that reached for the
  global brand singleton, for a string that already had sibling parameters
  (`brandTitle`, `brandSubtitle`, `logoUrl`) right next to it. A component that
  reads a static registry cannot be tested without it, cannot render two brands
  on one screen, and forces the package to have an opinion about where the data
  lives. `null` keeps the logo and drops only the link. **Breaking** only in the
  sense that the link now needs to be asked for.

### Removed

- **`AppBrandConfig` is theme configuration, and nothing else.** Gone:
  `appName`, `brandSubtitle`, `websiteUrl`, `cdnBaseUrl` (with its seven derived
  asset getters and `precacheUrls`), `videoBasePath`, `playStoreUrl` and
  `poweredByLabel`. What stays is `clientSlug`, the palette, the six theme axes
  and `typography`.

  None of the removed fields were read by `lib/src` — the package carried them
  only so the app could read them back. The cost was never their weight: the
  derived getters (`splashLogoUrl`, `otpLogoUrl`, `railExpandedUrl` and company)
  **asserted an app architecture** — that there is a splash screen, an OTP flow,
  a profile page, a nav rail, an auth background, and a Play Store listing. A
  design system that asserts that has an opinion about someone else's product,
  which is the same coupling this package refuses when it declines to reuse
  `Card` and `Scaffold`.

  `clientSlug` stayed: with the asset path gone it is pure identity — the
  registry key, and the label that names the goldens and scopes the contrast
  reports. **Breaking** for anyone constructing an `AppBrandConfig`; the fix is
  to delete the arguments and keep that identity wherever your app already keeps
  its own.


- **The Neutrek font.** It is licensed "Personal Use Only"; in an MIT repository,
  using it would amount to redistribution. It was what blocked publishing the
  package.

### Fixed

- The OFL fonts were being redistributed **without the license text**, which the
  SIL Open Font License requires. There is now an `OFL.txt` beside each family.
- `AppIcons.mail`, `.plus` and `.refresh` were cited in dartdoc but did not
  exist. They exist now, as part of the contract.

### Security

- The package's default path no longer depends on a private CDN or on a licensed
  icon set (Streamline Ultimate). The default is offline and MIT.
- **A brand can no longer point anywhere.** `cdnBaseUrl` was first made optional,
  so that an adopter with nowhere to host was not pushed into copying
  `flocksBrand`'s value — which pointed at the site's own CDN, putting our infra
  and our logo inside their product. Removing the field settles it by absence:
  there is no URL to copy and no network for the package to reach.

## [1.0.0]

The first consolidated version of the design system inside the monorepo: tokens,
theme, per-brand white-label, the global axes (`AppStyle`, `AppRadiusMode`,
glass, motion, transparency) and 131 components across atoms/molecules/organisms,
each with a `.doc.md`, a preview, a Widgetbook case and a test.
