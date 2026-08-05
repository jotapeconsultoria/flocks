import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppPieChart]. Registrado em `flocksCatalog`.
const AppComponentMeta appPieChartMeta = AppComponentMeta(
  id: 'app_pie_chart',
  name: 'AppPieChart',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.5.0',
  summary: LocalizedText(
    en: 'Pie chart (distribution in slices).',
    pt: 'Gráfico de pizza (distribuição em fatias).',
  ),
  description: LocalizedText(
    en: 'Slices proportional to the values; colors from the theme\'s categorical palette (chartCategorical) when not given. Hover/tap shows a tooltip and emits a selection. Tooltip with surfaceContainer + outline.',
    pt:
        'Fatias proporcionais aos valores; cores da paleta categórica do tema '
        '(chartCategorical) quando não dadas. Hover/tap mostra tooltip e emite '
        'seleção. Tooltip com surfaceContainer + outline.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Showing the composition of a whole (proportions).'],
    pt: <String>['Mostrar a composição de um todo (proporções).'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Comparing categories precisely → AppBarChart.',
      'With a hole in the center → AppDonutChart.',
    ],
    pt: <String>[
      'Comparar categorias com precisão → AppBarChart.',
      'Com furo central → AppDonutChart.',
    ],
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
      title: LocalizedText(en: 'Pie', pt: 'Pizza'),
      code:
          'AppPieChart(segments: [AppPieChartSegment(label: "A", value: 30), '
          'AppPieChartSegment(label: "B", value: 70)])',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use few slices (≤ ~6) to keep it readable.'],
    pt: <String>['Use poucas fatias (≤ ~6) para leitura clara.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it with many categories.'],
    pt: <String>['Não use com muitas categorias.'],
  ),
  a11y: LocalizedText(
    en: 'The semantic label aggregates the values; colors from the data-viz palette (the categorical one is decorative — the distinction comes from the legend/label).',
    pt:
        'Rótulo semântico agrega os valores; cores da paleta data-viz (categórica '
        'é decorativa — distinção por legenda/rótulo).',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_donut_chart', 'app_bar_chart'],
);
