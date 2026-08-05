import 'package:flutter/widgets.dart';

import 'chart_models.dart';
import 'radial_distribution_chart.dart';

/// Gráfico de **pizza** — distribuição de [segments] em fatias.
///
/// Cores da paleta categórica do tema (`chartCategorical`) quando não dadas.
/// Hover/tap mostra um tooltip e emite [onSelectionChanged].
///
/// ```dart
/// AppPieChart(segments: <AppPieChartSegment>[
///   AppPieChartSegment(label: 'A', value: 30),
///   AppPieChartSegment(label: 'B', value: 70),
/// ])
/// ```
final class AppPieChart extends StatelessWidget {
  /// Cria um [AppPieChart].
  const AppPieChart({
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
    onSelectionChanged: onSelectionChanged,
    segments: segments,
    valueFormatter: valueFormatter,
  );
}
