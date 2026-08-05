import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppScaffold]. Registrado em `flocksCatalog`.
const AppComponentMeta appScaffoldMeta = AppComponentMeta(
  id: 'app_scaffold',
  name: 'AppScaffold',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  since: 'flocks@0.6.0',
  summary: LocalizedText(
    en: 'Page layout: header · content · footer over the surface.',
    pt: 'Layout de página: header · conteúdo · footer sobre a surface.',
  ),
  description: LocalizedText(
    en: 'A layout organism (structural): it places an optional header at the top, the content in the middle (expanded) and an optional footer at the bottom, over the theme\'s `surface` color, with an optional SafeArea. It takes no part in the style/radius axes (it is structure, not surface).',
    pt:
        'Organismo de layout (estrutural): posiciona um cabeçalho opcional no '
        'topo, o conteúdo no meio (expandido) e um rodapé opcional na base, sobre '
        'a cor `surface` do tema, com SafeArea opcional. Não participa dos eixos '
        'de estilo/raio (é estrutura, não superfície).',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'The base of a page or screen with a fixed header and/or footer.',
      'The body of an AppBottomSheet (scrollable content + an action footer).',
    ],
    pt: <String>[
      'Base de uma página/tela com header e/ou footer fixos.',
      'Corpo de um AppBottomSheet (conteúdo rolável + rodapé de ações).',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A surface with a fill, a border or a shadow (a floating card) → AppCard/AppDialog.',
    ],
    pt: <String>[
      'Superfície com fill/borda/sombra (card flutuante) → AppCard/AppDialog.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'child', type: 'Widget', isRequired: true),
    PropMeta(name: 'fadeFooter', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'fadeHeader', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'floatingAction', type: 'Widget?'),
    PropMeta(
      name: 'floatingActionAlignment',
      type: 'AlignmentGeometry',
      defaultValue: 'AlignmentDirectional.bottomEnd',
    ),
    PropMeta(name: 'footer', type: 'Widget?'),
    PropMeta(name: 'header', type: 'Widget?'),
    PropMeta(name: 'safeAreaOnBottom', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'safeAreaOnTop', type: 'bool', defaultValue: 'false'),
  ],
  states: <String>['default'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Page with a header and a footer',
        pt: 'Página com header e footer',
      ),
      code:
          'AppScaffold(header: const AppSimpleHeader('
          "child: AppText('Veículos')), footer: buttonsFooter, child: content)",
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use AppSimpleHeader/AppPrimaryHeader in the header.'],
    pt: <String>['Use AppSimpleHeader/AppPrimaryHeader no header.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not nest AppScaffolds just to stack sections.'],
    pt: <String>['Não aninhe AppScaffolds só para empilhar seções.'],
  ),
  a11y: LocalizedText(
    en: 'Structural: it injects no semantics of its own; the regions (header/footer/content) bring theirs. A `surface` background with `onSurface` text passes AA.',
    pt:
        'Estrutural: não injeta semântica própria; as regiões (header/footer/'
        'conteúdo) trazem a sua. Fundo `surface`/texto `onSurface` passam AA.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>[
    'app_bottom_sheet',
    'app_simple_header',
    'app_buttons_footer',
    'app_floating_button',
  ],
);

/// Descritor MCP do [AppAuthSplitLayout]. Registrado em `flocksCatalog`.
const AppComponentMeta appAuthSplitLayoutMeta = AppComponentMeta(
  id: 'app_auth_split_layout',
  name: 'AppAuthSplitLayout',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  since: 'flocks@0.6.0',
  summary: LocalizedText(
    en: 'Split layout for the authentication pages (login/OTP).',
    pt: 'Layout dividido das páginas de autenticação (login/OTP).',
  ),
  description: LocalizedText(
    en: 'On desktop: a brand panel (clickable logo, title/subtitle + the form) on the left and a background image on the right. On mobile: a centered card over the background image. It breaks at AppDevice\'s breakpoints. Colors from the theme; the mobile card\'s corners from the radius axis; the logo has a touch micro-interaction (it opens the brand\'s site).',
    pt:
        'No desktop: painel de marca (logo clicável, título/subtítulo + o '
        'formulário) à esquerda e imagem de fundo à direita. No mobile: card '
        'centralizado sobre a imagem de fundo. Quebra pelos breakpoints de '
        'AppDevice. Cores do tema; cantos do card mobile pelo eixo de raio; logo '
        'com micro-interação de toque (abre o site da marca).',
  ),
  whenToUse: LocalizedList(
    en: <String>['Authentication screens (login, OTP, recovery) in the apps.'],
    pt: <String>['Telas de autenticação (login, OTP, recuperação) nos apps.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['An ordinary inner page → AppScaffold.'],
    pt: <String>['Página interna comum → AppScaffold.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'brandTitle', type: 'String', isRequired: true),
    PropMeta(name: 'brandSubtitle', type: 'String', isRequired: true),
    PropMeta(name: 'child', type: 'Widget', isRequired: true),
    PropMeta(name: 'backgroundImageUrl', type: 'String?'),
    PropMeta(name: 'logoUrl', type: 'String?'),
    PropMeta(name: 'websiteUrl', type: 'String?'),
  ],
  variants: <String>['desktop', 'mobile'],
  states: <String>['default'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Login screen', pt: 'Tela de login'),
      code:
          "AppAuthSplitLayout(brandTitle: 'Bem-vindo', "
          "brandSubtitle: 'Acesse sua conta', logoUrl: logo, child: loginForm)",
    ),
  ],
  dos: LocalizedList(
    en: <String>['Pass the auth form in child.'],
    pt: <String>['Passe o formulário de auth em child.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it on inner screens (that is AppScaffold).'],
    pt: <String>['Não use em telas internas (isso é AppScaffold).'],
  ),
  a11y: LocalizedText(
    en: 'The background image is decorative (excluded from the semantics); the logo is clickable and labelled. Title and subtitle derive a legible stop over the panel (`surfaceContainer`) through `readableStopOn`, passing AA in both themes.',
    pt:
        'Imagem de fundo é decorativa (excluída da semântica); logo é clicável '
        'com rótulo. Título e subtítulo derivam o stop legível sobre o painel '
        '(`surfaceContainer`) por `readableStopOn`, passando AA nos dois temas.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_scaffold'],
);
