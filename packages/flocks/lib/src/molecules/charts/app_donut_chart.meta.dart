import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppDonutChart]. Registrado em `flocksCatalog`.
const AppComponentMeta appDonutChartMeta = AppComponentMeta(
  id: 'app_donut_chart',
  name: 'AppDonutChart',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Donut chart (a pie with a hole in the middle).',
    pt: 'Gráfico de rosca (pizza com furo central).',
  ),
  description: LocalizedText(
    en: 'Like the pie, with a central hole (innerRadiusFactor 0.58). Colors from the theme\'s categorical palette when not given; hover/tap shows a tooltip.',
    pt:
        'Como o pizza, com furo central (innerRadiusFactor 0.58). Cores da paleta '
        'categórica do tema quando não dadas; hover/tap mostra tooltip.',
  ),
  whenToUse: LocalizedList(
    en: <String>['The composition of a whole, leaving the center free.'],
    pt: <String>['Composição de um todo, deixando o centro livre.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['Comparing categories precisely → AppBarChart.'],
    pt: <String>['Comparar categorias com precisão → AppBarChart.'],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'segments',
      type: 'List<AppPieChartSegment>',
      isRequired: true,
    ),
    PropMeta(
      name: 'onSelectionChanged',
      type: 'void Function(AppPieChartSelection)?',
    ),
    PropMeta(name: 'valueFormatter', type: 'AppChartValueFormatter?'),
  ],
  states: <String>['default', 'selected'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Donut', pt: 'Rosca'),
      code:
          'AppDonutChart(segments: [AppPieChartSegment(label: "A", value: 30), '
          'AppPieChartSegment(label: "B", value: 70)])',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use few slices; put a total in the center.'],
    pt: <String>['Use poucas fatias; aproveite o centro para um total.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it with many categories.'],
    pt: <String>['Não use com muitas categorias.'],
  ),
  a11y: LocalizedText(
    en: 'The semantic label aggregates the values; data-viz palette.',
    pt: 'Rótulo semântico agrega os valores; paleta data-viz.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_pie_chart'],
);
