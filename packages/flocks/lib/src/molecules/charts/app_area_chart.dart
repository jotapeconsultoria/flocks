import 'package:flutter/widgets.dart';

import 'cartesian_series_chart.dart';
import 'chart_models.dart';

/// Gráfico de **área**: uma linha por série com o espaço abaixo preenchido.
///
/// Mesma geometria do [AppLineChart] — muda o preenchimento, controlado por
/// `areaOpacity`. Use quando o VOLUME acumulado importa tanto quanto a
/// tendência; para comparar séries que se cruzam muito, a linha lê melhor.
///
/// ```dart
/// AppAreaChart(series: <AppCartesianChartSeries>[
///   AppCartesianChartSeries(id: 'consumo', label: 'Consumo', points: points),
/// ])
/// ```
final class AppAreaChart extends StatelessWidget {
  const AppAreaChart({
    required this.series,
    this.areaOpacity = 0.18,
    this.maxY,
    this.minY = 0,
    this.onSelectionChanged,
    this.showGrid = true,
    this.valueFormatter,
    super.key,
  });

  final double areaOpacity;
  final double? maxY;
  final double minY;
  final void Function(AppCartesianChartSelection selection)? onSelectionChanged;
  final List<AppCartesianChartSeries> series;
  final bool showGrid;
  final AppChartValueFormatter? valueFormatter;

  @override
  Widget build(BuildContext context) {
    return CartesianSeriesChart(
      areaOpacity: areaOpacity,
      maxY: maxY,
      minY: minY,
      onSelectionChanged: onSelectionChanged,
      series: series,
      showArea: true,
      showGrid: showGrid,
      valueFormatter: valueFormatter,
    );
  }
}
