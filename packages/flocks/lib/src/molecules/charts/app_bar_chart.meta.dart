import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppBarChart]. Registrado em `flocksCatalog`.
const AppComponentMeta appBarChartMeta = AppComponentMeta(
  id: 'app_bar_chart',
  name: 'AppBarChart',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Bar chart, grouped or stacked.',
    pt: 'Gráfico de barras, agrupado ou empilhado.',
  ),
  description: LocalizedText(
    en: 'Vertical or horizontal, grouped or stacked. It is the comparison chart: values over a common baseline. Stacked, the joint stays square and only the outer end rounds — the corner comes from the brand\'s shape axis.',
    pt: 'Vertical ou horizontal, agrupado ou empilhado. É o gráfico de comparação: valores sobre uma linha de base comum. Empilhado, a junta fica reta e só a ponta de fora arredonda — o canto sai do eixo de forma da marca.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Comparing categories precisely.'],
    pt: <String>['Comparar categorias com precisão.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A trend over time → AppLineChart.',
      'The composition of a whole → AppPieChart.',
    ],
    pt: <String>[
      'Tendência no tempo → AppLineChart.',
      'Composição de um todo → AppPieChart.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'labels', type: 'List<String>', isRequired: true),
    PropMeta(name: 'series', type: 'List<AppBarChartSeries>', isRequired: true),
    PropMeta(name: 'layout', type: 'AppBarChartLayout'),
    PropMeta(name: 'orientation', type: 'AppBarChartOrientation'),
    PropMeta(name: 'barThickness', type: 'double?'),
    PropMeta(name: 'categorySpacing', type: 'double?'),
    PropMeta(name: 'maxValue', type: 'double?'),
    PropMeta(name: 'showGrid', type: 'bool'),
    PropMeta(name: 'enableInternalScroll', type: 'bool'),
    PropMeta(
      name: 'onSelectionChanged',
      type: 'void Function(AppBarChartSelection)?',
    ),
    PropMeta(name: 'valueFormatter', type: 'AppChartValueFormatter?'),
  ],
  states: <String>['default', 'selected'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Grouped bars', pt: 'Barras agrupadas'),
      code: 'AppBarChart(labels: labels, series: series)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Start the axis at zero — a truncated bar lies about the comparison.',
    ],
    pt: <String>['Comece o eixo no zero — barra truncada mente na comparação.'],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not use stacked bars to compare the segments in the middle.',
    ],
    pt: <String>['Não use empilhado para comparar segmentos do meio.'],
  ),
  a11y: LocalizedText(
    en: 'The semantic label aggregates each series; the legend is keyboard-navigable.',
    pt: 'Rótulo semântico agrega cada série; a legenda é navegável por teclado.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_line_chart', 'app_bubble_chart'],
);
