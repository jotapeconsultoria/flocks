import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppShell]. Registrado em `flocksCatalog`.
const AppComponentMeta appShellMeta = AppComponentMeta(
  id: 'app_shell',
  name: 'AppShell',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Desktop workspace skeleton: rail, header, content in a card and a full-height side panel.',
    pt:
        'Esqueleto do workspace desktop: rail, header, conteúdo em cartão e '
        'painel lateral de altura total.',
  ),
  description: LocalizedText(
    en: 'It places the shell\'s four areas. The [aside] takes the full height; the [header] runs from the left edge UP TO the aside (it is not full-width); the [rail] sits below the header; the [content] becomes a floating card with rounded corners on all four sides and a margin that lifts it off the bottom. The continuity between rail, header and aside comes from sharing one surface, with no dividers — the contrast is the card. It works the same in light and dark: the shell does not pin a mode. The rail\'s and the aside\'s widths belong to whoever passes them, which allows a draggable panel without the design system knowing anything about persistence.',
    pt:
        'Posiciona as quatro áreas do shell. O [aside] ocupa a altura total; o '
        '[header] vai da borda esquerda ATÉ o aside (não é full-width); o [rail] '
        'fica abaixo do header; o [content] vira um cartão flutuante com cantos '
        'arredondados nos quatro lados e margem que o afasta da base. A '
        'continuidade entre rail, header e aside vem de compartilharem a mesma '
        'superfície, sem divisórias — o contraste é o cartão. Funciona igual nos '
        'temas claro e escuro: o shell não fixa um modo. Larguras de rail e aside '
        'são de quem os passa, o que permite um painel arrastável sem o DS '
        'saber de persistência.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A work app with side navigation and an always-present panel.',
      'When the content should read as a card over the background.',
    ],
    pt: <String>[
      'App de trabalho com navegação lateral e um painel sempre presente.',
      'Quando o conteúdo deve ler como um cartão sobre o fundo.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A single screen with no persistent navigation → AppScaffold.',
      'An authentication layout → AppAuthSplitLayout.',
    ],
    pt: <String>[
      'Tela única sem navegação persistente → AppScaffold.',
      'Layout de autenticação → AppAuthSplitLayout.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'content', type: 'Widget', isRequired: true),
    PropMeta(name: 'rail', type: 'Widget?'),
    PropMeta(name: 'header', type: 'Widget?'),
    PropMeta(name: 'aside', type: 'Widget?'),
    PropMeta(
      name: 'fullscreen',
      type: 'bool',
      defaultValue: 'false',
      description: LocalizedText(
        en: 'Hides rail/header/aside. The content does not move in the tree, so the screens\' state survives.',
        pt:
            'Esconde rail/header/aside. O content não muda de lugar na árvore, '
            'então o estado das telas sobrevive.',
      ),
    ),
    PropMeta(
      name: 'contentMargin',
      type: 'EdgeInsets',
      defaultValue: 'kAppShellContentMargin',
    ),
    PropMeta(name: 'contentRadius', type: 'BorderRadius?'),
    PropMeta(name: 'decoration', type: 'BoxDecoration?'),
  ],
  states: <String>['normal', 'fullscreen'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Full shell', pt: 'Shell completo'),
      code:
          'AppShell(rail: AppNavigationRail(...), header: header, '
          'aside: AppAssistantPanel(...), content: workspace)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Let the rail and the aside define their own width.',
      'Use fullscreen for maps, without remounting the content.',
    ],
    pt: <String>[
      'Deixe rail e aside definirem a própria largura.',
      'Use fullscreen para mapas, sem remontar o conteúdo.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not paint the header from outside: it already inherits the frame\'s surface.',
      'Do not force a dark theme on the shell — the contrast is surface vs surfaceContainer, and it works in both modes.',
    ],
    pt: <String>[
      'Não pinte o header por fora: ele já herda a superfície da moldura.',
      'Não force um tema escuro no shell — o contraste é surface x '
          'surfaceContainer, e funciona nos dois modos.',
    ],
  ),
  a11y: LocalizedText(
    en: 'Layout only: it introduces no semantics nodes of its own and captures no focus. Traversal order is header → rail → content → aside.',
    pt:
        'Só layout: não introduz nós de semântica próprios nem captura foco. A '
        'ordem de travessia segue header → rail → conteúdo → aside.',
  ),
  crossPlatform: false,
  themeAware: true,
  reducesMotion: true,
  related: <String>[
    'app_scaffold',
    'app_navigation_rail',
    'app_assistant_panel',
    'app_workspace_tabs',
  ],
);
