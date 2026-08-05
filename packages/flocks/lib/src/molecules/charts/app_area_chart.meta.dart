import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppAreaChart]. Registrado em `flocksCatalog`.
const AppComponentMeta appAreaChartMeta = AppComponentMeta(
  id: 'app_area_chart',
  name: 'AppAreaChart',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.6.0',
  summary: LocalizedText(
    en: 'Area chart: a line with the space beneath it filled.',
    pt: 'Gráfico de área: linha com o espaço abaixo preenchido.',
  ),
  description: LocalizedText(
    en: 'Same geometry as the line, with the fill controlled by areaOpacity. Use it when accumulated volume matters as much as the trend.',
    pt: 'Mesma geometria da linha, com preenchimento controlado por areaOpacity. Use quando o volume acumulado importa tanto quanto a tendência.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Accumulated volume over time.'],
    pt: <String>['Volume acumulado ao longo do tempo.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['Series that cross each other often → AppLineChart.'],
    pt: <String>['Séries que se cruzam muito → AppLineChart.'],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'series',
      type: 'List<AppCartesianChartSeries>',
      isRequired: true,
    ),
    PropMeta(name: 'areaOpacity', type: 'double'),
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
      title: LocalizedText(en: 'Area', pt: 'Área'),
      code: 'AppAreaChart(series: series)',
    ),
  ],
  dos: LocalizedList(
    en: <String>['One or two series; beyond that the fills overlap.'],
    pt: <String>[
      'Uma ou duas séries; mais que isso o preenchimento se sobrepõe.',
    ],
  ),
  donts: LocalizedList(
    en: <String>['Do not stack many translucent areas.'],
    pt: <String>['Não empilhe muitas áreas translúcidas.'],
  ),
  a11y: LocalizedText(
    en: 'The semantic label aggregates the series; color is never the only cue.',
    pt: 'Rótulo semântico agrega a série; a cor nunca é a única pista.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_line_chart'],
);
