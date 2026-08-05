import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppGaugeChart]. Registrado em `flocksCatalog`.
const AppComponentMeta appGaugeChartMeta = AppComponentMeta(
  id: 'app_gauge_chart',
  name: 'AppGaugeChart',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.6.0',
  summary: LocalizedText(
    en: 'Gauge: a segmented arc with a central label.',
    pt: 'Medidor: arco segmentado com rótulo central.',
  ),
  description: LocalizedText(
    en: 'For one indicator against a scale — occupancy, health, percentage of a target. variant chooses between a half arc and a full arc.',
    pt: 'Para um indicador contra uma escala — ocupação, saúde, percentual de meta. variant escolhe entre meio-arco e arco completo.',
  ),
  whenToUse: LocalizedList(
    en: <String>['One indicator against a scale.'],
    pt: <String>['Um indicador contra uma escala.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['Several indicators side by side → AppBarChart.'],
    pt: <String>['Vários indicadores lado a lado → AppBarChart.'],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'segments',
      type: 'List<AppGaugeChartSegment>',
      isRequired: true,
    ),
    PropMeta(name: 'variant', type: 'AppGaugeChartVariant'),
    PropMeta(name: 'centerLabel', type: 'String?'),
    PropMeta(name: 'centerValueLabel', type: 'String?'),
    PropMeta(
      name: 'onSelectionChanged',
      type: 'void Function(AppGaugeChartSelection)?',
    ),
    PropMeta(name: 'valueFormatter', type: 'AppChartValueFormatter?'),
  ],
  states: <String>['default', 'selected'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Occupancy gauge', pt: 'Medidor de ocupação'),
      code: 'AppGaugeChart(centerLabel: "Ocupação", segments: segments)',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use the central label for the number that matters.'],
    pt: <String>['Use o rótulo central para o número que importa.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not stack gauges to compare them.'],
    pt: <String>['Não empilhe medidores para comparar.'],
  ),
  a11y: LocalizedText(
    en: 'The central label is read together with the value; segments carry their own labels.',
    pt: 'O rótulo central é lido junto do valor; segmentos têm rótulo próprio.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_bar_chart', 'app_donut_chart'],
);
