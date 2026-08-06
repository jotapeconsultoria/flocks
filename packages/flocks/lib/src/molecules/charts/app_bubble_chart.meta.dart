import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppBubbleChart]. Registrado em `flocksCatalog`.
const AppComponentMeta appBubbleChartMeta = AppComponentMeta(
  id: 'app_bubble_chart',
  name: 'AppBubbleChart',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Bubble chart: the circle\'s area is the value.',
    pt: 'Gráfico de bolhas: a área do círculo é o valor.',
  ),
  description: LocalizedText(
    en: 'Each node is a circle whose area represents the value. It serves orders of magnitude across a few categories, not precise comparison.',
    pt: 'Cada nó é um círculo cuja área representa o valor. Serve para ordem de grandeza entre poucas categorias, não para comparação precisa.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Showing relative magnitude across a few categories.'],
    pt: <String>['Mostrar magnitude relativa entre poucas categorias.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['Comparing close values → AppBarChart.'],
    pt: <String>['Comparar valores próximos → AppBarChart.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'nodes', type: 'List<AppBubbleChartNode>', isRequired: true),
    PropMeta(
      name: 'onSelectionChanged',
      type: 'void Function(AppBubbleChartSelection)?',
    ),
    PropMeta(name: 'valueFormatter', type: 'AppChartValueFormatter?'),
  ],
  states: <String>['default', 'selected'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Bubbles', pt: 'Bolhas'),
      code: 'AppBubbleChart(nodes: nodes)',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Few nodes, each with a visible label.'],
    pt: <String>['Poucos nós, com rótulo visível.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not ask the reader to compare areas of similar size.'],
    pt: <String>['Não peça ao leitor para comparar áreas parecidas.'],
  ),
  a11y: LocalizedText(
    en: 'Every bubble carries its own semantic label (label + value).',
    pt: 'Cada bolha tem rótulo semântico próprio (label + valor).',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_bar_chart'],
);
