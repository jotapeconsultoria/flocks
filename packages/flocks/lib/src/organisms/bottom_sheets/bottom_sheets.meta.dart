import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppBottomSheet]. Registrado em `flocksCatalog`.
const AppComponentMeta appBottomSheetMeta = AppComponentMeta(
  id: 'app_bottom_sheet',
  name: 'AppBottomSheet',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  since: 'flocks@0.6.0',
  summary: LocalizedText(
    en: 'Floating panel anchored to the bottom (bottom sheet), optionally draggable.',
    pt: 'Painel flutuante ancorado na base (bottom sheet), opcionalmente arrastável.',
  ),
  description: LocalizedText(
    en: 'A detached card that rises from the bottom (margins on L/R/bottom, rounded corners) until the content fits (a `maxHeightFraction` ceiling, with internal scrolling above that). Show it as a modal through `showAppBottomSheet` (barrier + slide-up); with `draggable: true` it gains two states (rest ⇄ edge-to-edge page) with a fluid morph, an optional handle and swipe-to-dismiss. A top bar with an optional title and a close button (a circular chip, side chosen by `closeSide`). The container follows the AppStyle axis (its own `elevated` default, not the global one); the corners follow the radius axis. Colors 100% from the theme. `useRootNavigator` resolves the root navigator.',
    pt:
        'Um card destacado que sobe pela base (margem em L/R/base, cantos '
        'arredondados) até o conteúdo caber (teto `maxHeightFraction`, com scroll '
        'interno acima disso). Exiba como modal via `showAppBottomSheet` (barrier + '
        'slide-up); com `draggable: true` ganha dois estados (repouso ⇄ page '
        'edge-to-edge) com morph fluido, handle opcional e swipe-to-dismiss. '
        'Barra de topo com título opcional e botão de fechar (chip circular, lado '
        'via `closeSide`). Container segue o eixo AppStyle (default próprio '
        '`elevated`, não segue o global); os cantos seguem o eixo de raio. Cores '
        '100% do tema. `useRootNavigator` resolve o navigator raiz.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A form or detail that rises from the bottom on mobile (filters, actions).',
      'A long list or form that benefits from being dragged up into a page.',
    ],
    pt: <String>[
      'Formulário/detalhe que sobe de baixo no mobile (filtros, ações).',
      'Lista/formulário longo que se beneficia de arrastar até virar page.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A blocking central confirmation on desktop → AppDialog.',
      'A short menu anchored to a trigger → AppMenu.',
      'A full iOS-style page (with a peek at the top) → AppBottomSheetPage.',
    ],
    pt: <String>[
      'Confirmação central bloqueante no desktop → AppDialog.',
      'Menu curto ancorado a um gatilho → AppMenu.',
      'Página cheia estilo iOS (peek no topo) → AppBottomSheetPage.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'child', type: 'Widget', isRequired: true),
    PropMeta(name: 'footer', type: 'Widget?'),
    PropMeta(name: 'title', type: 'Widget?'),
    PropMeta(name: 'draggable', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'alwaysClose', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'showHandle', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'showCloseButton', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'onCloseButton', type: 'VoidCallback?'),
    PropMeta(name: 'onClose', type: 'VoidCallback?'),
    PropMeta(
      name: 'closeSide',
      type: 'AppSheetCloseSide',
      defaultValue: 'AppSheetCloseSide.end',
      enumValues: <String>['start', 'end'],
    ),
    PropMeta(name: 'maxHeightFraction', type: 'double', defaultValue: '0.65'),
    PropMeta(
      name: 'style',
      type: 'AppStyle?',
      defaultValue: 'AppStyle.elevated',
      enumValues: <String>['filled', 'outlined', 'elevated'],
    ),
    PropMeta(
      name: 'radiusMode',
      type: 'AppRadiusMode?',
      enumValues: <String>['reto', 'redondo', 'circular', 'padrao'],
    ),
  ],
  variants: <String>['filled', 'outlined', 'elevated'],
  states: <String>['rest', 'page'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Draggable filters on mobile',
        pt: 'Filtros arrastáveis no mobile',
      ),
      code:
          'showAppBottomSheet<void>(context: context, draggable: true, '
          'showHandle: true, title: Text("Filtros"), footer: buttonsFooter, '
          'useRootNavigator: true, child: filtersForm)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Use a fixed AppButtonsFooter for the actions.',
      'Pass useRootNavigator: true to cover the bottom navigation.',
      'Use draggable + showHandle for long content (rest ⇄ page).',
    ],
    pt: <String>[
      'Use um AppButtonsFooter fixo para as ações.',
      'Passe useRootNavigator: true para cobrir a bottom navigation.',
      'Use draggable + showHandle para conteúdo longo (repouso ⇄ page).',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not use it on desktop for confirmation (that is AppDialog).',
    ],
    pt: <String>['Não use no desktop para confirmação (isso é AppDialog).'],
  ),
  a11y: LocalizedText(
    en: 'Shown through the Navigator (a PopupRoute): focus and its return are managed by the route; the barrier and the close button are labelled "Close". The theme\'s colors pass AA.',
    pt:
        'Exibido via Navigator (PopupRoute): foco e devolução geridos pela rota; '
        'barrier e botão de fechar com rótulo "Fechar". Cores do tema passam AA.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>[
    'app_bottom_sheet_page',
    'app_bottom_sheet_content',
    'app_dialog',
    'app_scaffold',
  ],
);

/// Descritor MCP do [AppBottomSheetPage]. Registrado em `flocksCatalog`.
const AppComponentMeta appBottomSheetPageMeta = AppComponentMeta(
  id: 'app_bottom_sheet_page',
  name: 'AppBottomSheetPage',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  since: 'flocks@0.7.0',
  summary: LocalizedText(
    en: 'iOS-style modal page that rises to the top (peek), edge-to-edge.',
    pt: 'Página modal estilo iOS que sobe até o topo (peek), edge-to-edge.',
  ),
  description: LocalizedText(
    en: 'A page that rises to just below the top safe area, leaving a gap (peek) that shows the screen underneath behind the top corners. It is edge-to-edge on L/R/bottom; it closes from the close button, from the barrier or with a downward swipe. Show it through `showAppBottomSheetPage`. A top bar with an optional title and a close button (side chosen by `closeSide`). The container follows the AppStyle axis (its own `elevated` default); the top corners follow the radius axis. Colors 100% from the theme.',
    pt:
        'Página que sobe até logo abaixo do safe-area do topo, deixando um respiro '
        '(peek) que mostra a tela de baixo por trás dos cantos de cima. É '
        'edge-to-edge em L/R/base; fecha pelo botão de fechar, pelo barrier ou por '
        'swipe para baixo. Exiba via `showAppBottomSheetPage`. Barra de topo com '
        'título opcional e botão de fechar (lado via `closeSide`). Container segue '
        'o eixo AppStyle (default próprio `elevated`); cantos de cima pelo eixo de '
        'raio. Cores 100% do tema.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A contextual full screen on mobile (settings, a detail, a long form).',
      'A flow that needs almost the whole screen while keeping the context underneath (the peek).',
    ],
    pt: <String>[
      'Tela cheia contextual no mobile (configurações, detalhe, formulário longo).',
      'Fluxo que precisa quase toda a tela mantendo o contexto de baixo (peek).',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A short or medium panel that rises to fit its content → AppBottomSheet.',
      'A central confirmation on desktop → AppDialog.',
    ],
    pt: <String>[
      'Painel curto/médio que sobe até o conteúdo → AppBottomSheet.',
      'Confirmação central no desktop → AppDialog.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'child', type: 'Widget', isRequired: true),
    PropMeta(name: 'title', type: 'Widget?'),
    PropMeta(name: 'footer', type: 'Widget?'),
    PropMeta(name: 'showCloseButton', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'onCloseButton', type: 'VoidCallback?'),
    PropMeta(
      name: 'closeSide',
      type: 'AppSheetCloseSide',
      defaultValue: 'AppSheetCloseSide.end',
      enumValues: <String>['start', 'end'],
    ),
    PropMeta(
      name: 'style',
      type: 'AppStyle?',
      defaultValue: 'AppStyle.elevated',
      enumValues: <String>['filled', 'outlined', 'elevated'],
    ),
    PropMeta(
      name: 'radiusMode',
      type: 'AppRadiusMode?',
      enumValues: <String>['reto', 'redondo', 'circular', 'padrao'],
    ),
  ],
  variants: <String>['filled', 'outlined', 'elevated'],
  states: <String>['default'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Full-screen settings',
        pt: 'Configurações em tela cheia',
      ),
      code:
          'showAppBottomSheetPage<void>(context: context, title: Text("Ajustes"), '
          'useRootNavigator: true, child: settingsBody)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Use it for content that needs almost the whole screen.',
      'Pass useRootNavigator: true to cover the bottom navigation.',
    ],
    pt: <String>[
      'Use para conteúdo que precisa de quase toda a tela.',
      'Passe useRootNavigator: true para cobrir a bottom navigation.',
    ],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for short panels (that is AppBottomSheet).'],
    pt: <String>['Não use para painéis curtos (isso é AppBottomSheet).'],
  ),
  a11y: LocalizedText(
    en: 'Shown through the Navigator (a PopupRoute): focus and its return are managed by the route; the barrier and the close button are labelled "Close". The theme\'s colors pass AA.',
    pt:
        'Exibido via Navigator (PopupRoute): foco e devolução geridos pela rota; '
        'barrier e botão de fechar com rótulo "Fechar". Cores do tema passam AA.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_bottom_sheet', 'app_dialog', 'app_scaffold'],
);

/// Descritor MCP do [AppBottomSheetContent]. Registrado em `flocksCatalog`.
const AppComponentMeta appBottomSheetContentMeta = AppComponentMeta(
  id: 'app_bottom_sheet_content',
  name: 'AppBottomSheetContent',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  since: 'flocks@0.6.0',
  summary: LocalizedText(
    en: 'Standard bottom sheet body: title, message and illustration.',
    pt: 'Corpo padrão de um bottom sheet: título, mensagem e ilustração.',
  ),
  description: LocalizedText(
    en: 'The most common body of an AppBottomSheet (a notice or a detail), scrollable: title, message and illustration. Colors from the theme; the illustration\'s accent uses `secondary` when none is given.',
    pt:
        'O corpo mais comum de um AppBottomSheet (aviso/detalhe), rolável: título, '
        'mensagem e ilustração. Cores do tema; o destaque da ilustração usa '
        '`secondary` quando não informado.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Filling an AppBottomSheet with the standard notice/detail layout.',
    ],
    pt: <String>[
      'Preencher um AppBottomSheet com o layout padrão de aviso/detalhe.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['Custom content (a form, a list) → pass your own child.'],
    pt: <String>[
      'Conteúdo customizado (formulário/lista) → passe seu próprio child.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'title', type: 'String', isRequired: true),
    PropMeta(name: 'message', type: 'String', isRequired: true),
    PropMeta(name: 'illustration', type: 'String', isRequired: true),
    PropMeta(
      name: 'accentRole',
      type: 'ColorSwatch<int>?',
      description: LocalizedText(
        en: 'The piece\'s color role — pass the SAME one as the action button (e.g. theme.colorTheme.danger). The illustration is tinted with that role\'s accent, the very value the button paints. Defaults to secondary.',
        pt:
            'Papel de cor da peça — passe o MESMO do botão de ação '
            '(ex.: theme.colorTheme.danger). A ilustração é tingida com o acento '
            'desse papel, o mesmo valor que o botão pinta. Default = secondary.',
      ),
    ),
  ],
  states: <String>['default'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Notice', pt: 'Aviso'),
      code:
          "AppBottomSheetContent(title: 'Atenção', message: '...', "
          "illustration: 'assets/warning.svg')",
    ),
  ],
  dos: LocalizedList(
    en: <String>['A short title and a to-the-point message.'],
    pt: <String>['Título curto e mensagem objetiva.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not stack multiple illustrations.'],
    pt: <String>['Não empilhe múltiplas ilustrações.'],
  ),
  a11y: LocalizedText(
    en: 'Title and message forward semanticLabel; title in onSurface and message in neutral s700 pass AA against the surface.',
    pt:
        'Título e mensagem repassam semanticLabel; título onSurface e mensagem '
        'neutro s700 passam AA sobre a superfície.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_bottom_sheet'],
);
