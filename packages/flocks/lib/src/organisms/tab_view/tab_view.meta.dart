import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppTabView]. Registrado em `flocksCatalog`.
const AppComponentMeta appTabViewMeta = AppComponentMeta(
  id: 'app_tab_view',
  name: 'AppTabView',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  since: 'flocks@0.6.0',
  summary: LocalizedText(
    en: 'Horizontal tabs with a sliding indicator and lazy loading.',
    pt: 'Abas horizontais com indicador deslizante e carga preguiçosa.',
  ),
  description: LocalizedText(
    en: 'A tab bar (AppTabViewItem: label + builder) with an indicator that slides to the active tab and content loaded on demand (lazyLoadOnFirstOpen). Colors 100% from the theme; the indicator animates on motion tokens, honoring reduce-motion.',
    pt:
        'Barra de abas (AppTabViewItem: label + builder) com um indicador que '
        'desliza para a aba ativa e conteúdo carregado sob demanda '
        '(lazyLoadOnFirstOpen). Cores 100% do tema; o indicador anima via tokens '
        'de motion, respeitando reduce-motion.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Switching between parallel sections of one context.'],
    pt: <String>['Alternar entre seções paralelas de um mesmo contexto.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A flow with an order or progress → AppFormWizard.',
      'The app\'s primary navigation → AppNavigationRail.',
    ],
    pt: <String>[
      'Fluxo com ordem/progresso → AppFormWizard.',
      'Navegação primária do app → AppNavigationRail.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'items', type: 'List<AppTabViewItem>', isRequired: true),
    PropMeta(name: 'initialIndex', type: 'int', defaultValue: '0'),
    PropMeta(name: 'lazyLoadOnFirstOpen', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'onTabChanged', type: 'ValueChanged<int>?'),
    PropMeta(
      name: 'contentPadding',
      type: 'EdgeInsetsGeometry',
      defaultValue: 'EdgeInsets.symmetric(horizontal: AppSpacings.s8)',
    ),
  ],
  states: <String>['tab-active', 'tab-inactive'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Two tabs', pt: 'Duas abas'),
      code:
          'AppTabView(items: [AppTabViewItem(label: "Resumo", builder: ...), '
          'AppTabViewItem(label: "Detalhes", builder: ...)])',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Short labels; the active tab is marked by the indicator.'],
    pt: <String>['Rótulos curtos; a aba ativa é destacada pelo indicador.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for a sequential flow (AppFormWizard).'],
    pt: <String>['Não use para fluxo sequencial (AppFormWizard).'],
  ),
  a11y: LocalizedText(
    en: 'The active tab is highlighted by color (from the theme, AA). The content enters the reading focus order.',
    pt:
        'A aba ativa é destacada por cor (do tema, AA). O conteúdo entra na ordem '
        'de foco de leitura.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_form_wizard', 'app_navigation_rail'],
);
