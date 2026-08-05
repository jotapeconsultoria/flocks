import 'package:flutter/widgets.dart';

import 'cartesian_series_chart.dart';
import 'chart_models.dart';

/// Gráfico de **linha**: uma polilinha por série sobre eixos cartesianos.
///
/// A escolha padrão para tendência ao longo do tempo. Hover/tap emite
/// `onSelectionChanged` e mostra o tooltip do ponto.
///
/// ```dart
/// AppLineChart(series: <AppCartesianChartSeries>[
///   AppCartesianChartSeries(id: 'consumo', label: 'Consumo', points: points),
/// ])
/// ```
final class AppLineChart extends StatelessWidget {
  const AppLineChart({
    required this.series,
    this.maxY,
    this.minY = 0,
    this.onSelectionChanged,
    this.showGrid = true,
    this.valueFormatter,
    super.key,
  });

  final double? maxY;
  final double minY;
  final void Function(AppCartesianChartSelection selection)? onSelectionChanged;
  final List<AppCartesianChartSeries> series;
  final bool showGrid;
  final AppChartValueFormatter? valueFormatter;

  @override
  Widget build(BuildContext context) {
    return CartesianSeriesChart(
      maxY: maxY,
      minY: minY,
      onSelectionChanged: onSelectionChanged,
      series: series,
      showGrid: showGrid,
      valueFormatter: valueFormatter,
    );
  }
}
