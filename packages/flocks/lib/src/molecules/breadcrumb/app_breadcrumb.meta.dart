import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppBreadcrumb]. Registrado em `flocksCatalog`.
const AppComponentMeta appBreadcrumbMeta = AppComponentMeta(
  id: 'app_breadcrumb',
  name: 'AppBreadcrumb',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.5.0',
  summary: LocalizedText(
    en: 'Navigation trail with clickable items and separators.',
    pt: 'Trilha de navegação com itens clicáveis e separadores.',
  ),
  description: LocalizedText(
    en: 'Clickable items on FlocksInteraction (hover/press/focus/keyboard) with a highlight and a focus ring; link text in a legible stop (≥ AA) of the accent color, current item in onSurface. Colors from the theme; radius and animation global.',
    pt:
        'Itens clicáveis sobre FlocksInteraction (hover/press/foco/teclado) com '
        'realce e anel de foco; texto do link num stop legível (≥ AA) da cor de '
        'acento, item atual em onSurface. Cores do tema; raio/animação globais.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Showing and navigating the current page hierarchy.'],
    pt: <String>['Mostrar e navegar a hierarquia de páginas atual.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Primary navigation between sections → a menu or nav rail (organism).',
    ],
    pt: <String>['Navegação primária entre seções → menu/nav rail (organism).'],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'items',
      type: 'List<AppBreadcrumbItem>',
      isRequired: true,
      description: LocalizedText(
        en: 'Items from the shallowest to the current one; a null onTap marks the current item.',
        pt: 'Itens do mais raso ao atual; onTap null = item atual.',
      ),
    ),
  ],
  states: <String>['clickable', 'current', 'hovered', 'focused', 'pressed'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Plain trail', pt: 'Trilha simples'),
      code:
          "AppBreadcrumb(items: [AppBreadcrumbItem(label: 'Início', "
          "onTap: goHome), AppBreadcrumbItem(label: 'Veículos')])",
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Leave the last (current) item without an onTap — it becomes the onSurface highlight.',
    ],
    pt: <String>[
      'Deixe o último item (atual) sem onTap — vira o destaque onSurface.',
    ],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it as primary navigation.'],
    pt: <String>['Não use como navegação primária.'],
  ),
  a11y: LocalizedText(
    en: 'Clickable items with a button role (AppSemantics.button) + Enter/Space; the link in a legible accent ≥ AA against the surface; current item in onSurface.',
    pt:
        'Itens clicáveis com role de botão (AppSemantics.button) + Enter/Space; '
        'link em acento legível ≥ AA sobre a superfície; item atual em onSurface.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_action_item'],
);
