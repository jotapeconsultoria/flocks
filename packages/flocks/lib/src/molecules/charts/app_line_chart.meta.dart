import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppLineChart]. Registrado em `flocksCatalog`.
const AppComponentMeta appLineChartMeta = AppComponentMeta(
  id: 'app_line_chart',
  name: 'AppLineChart',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.6.0',
  summary: LocalizedText(
    en: 'Line chart for a trend over time.',
    pt: 'Gráfico de linha para tendência ao longo do tempo.',
  ),
  description: LocalizedText(
    en: 'One polyline per series over cartesian axes. Hover/tap emits onSelectionChanged and shows the point\'s tooltip. Colors from the theme\'s categorical palette when not given.',
    pt: 'Uma polilinha por série sobre eixos cartesianos. Hover/tap emite onSelectionChanged e mostra o tooltip do ponto. Cores da paleta categórica do tema quando não dadas.',
  ),
  whenToUse: LocalizedList(
    en: <String>['How a metric evolves over time.'],
    pt: <String>['Evolução de uma métrica no tempo.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['Comparing categories → AppBarChart.'],
    pt: <String>['Comparar categorias → AppBarChart.'],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'series',
      type: 'List<AppCartesianChartSeries>',
      isRequired: true,
    ),
    PropMeta(name: 'minY', type: 'double'),
    PropMeta(name: 'maxY', type: 'double?'),
    PropMeta(name: 'showGrid', type: 'bool'),
    PropMeta(
      name: 'onSelectionChanged',
      type: 'void Function(AppCartesianChartSelection)?',
    ),
    PropMeta(name: 'valueFormatter', type: 'AppChartValueFormatter?'),
  ],
  states: <String>['default', 'selected'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Line', pt: 'Linha'),
      code: 'AppLineChart(series: series)',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Few series; label each one in the legend.'],
    pt: <String>['Poucas séries; rotule cada uma na legenda.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it to compare close values across categories.'],
    pt: <String>['Não use para comparar valores próximos entre categorias.'],
  ),
  a11y: LocalizedText(
    en: 'The semantic label aggregates the series; color is never the only cue.',
    pt: 'Rótulo semântico agrega a série; a cor nunca é a única pista.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_area_chart', 'app_bar_chart'],
);
