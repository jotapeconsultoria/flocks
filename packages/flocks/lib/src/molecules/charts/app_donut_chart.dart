import 'package:flutter/widgets.dart';

import 'chart_models.dart';
import 'radial_distribution_chart.dart';

/// Gráfico de **rosca** (donut) — como o pizza, mas com furo central.
///
/// Cores da paleta categórica do tema (`chartCategorical`) quando não dadas.
///
/// ```dart
/// AppDonutChart(segments: <AppPieChartSegment>[
///   AppPieChartSegment(label: 'A', value: 30),
///   AppPieChartSegment(label: 'B', value: 70),
/// ])
/// ```
final class AppDonutChart extends StatelessWidget {
  /// Cria um [AppDonutChart].
  const AppDonutChart({
    required this.segments,
    this.onSelectionChanged,
    this.valueFormatter,
    super.key,
  });

  /// Callback ao selecionar (hover/tap) uma fatia.
  final void Function(AppPieChartSelection selection)? onSelectionChanged;

  /// Segmentos (rótulo + valor + cor opcional).
  final List<AppPieChartSegment> segments;

  /// Formata o valor no tooltip.
  final AppChartValueFormatter? valueFormatter;

  @override
  Widget build(BuildContext context) => RadialDistributionChart(
    innerRadiusFactor: 0.58,
    onSelectionChanged: onSelectionChanged,
    segments: segments,
    valueFormatter: valueFormatter,
  );
}
