import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'chart_models.dart';

/// Helpers de geometria/cor compartilhados pelos charts. Não é API pública.
final class ChartFoundation {
  /// Constrói o path de uma linha (reta ou suave) a partir dos [points].
  static Path buildLinePath(
    AppLineChartCurveStyle curveStyle,
    List<Offset> points,
  ) {
    final Path path = Path();
    if (points.isEmpty) return path;
    path.moveTo(points.first.dx, points.first.dy);
    if (curveStyle == AppLineChartCurveStyle.straight || points.length < 3) {
      for (final Offset point in points.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      return path;
    }
    for (int index = 0; index < points.length - 1; index++) {
      final Offset current = points[index];
      final Offset next = points[index + 1];
      final double controlX = (current.dx + next.dx) / 2;
      path.quadraticBezierTo(controlX, current.dy, next.dx, next.dy);
    }
    return path;
  }

  /// Converte um path contínuo em tracejado.
  static Path buildDashedPath(
    Path source, {
    double dashLength = 6,
    double gapLength = 4,
  }) {
    final Path destination = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double next = math.min(distance + dashLength, metric.length);
        destination.addPath(metric.extractPath(distance, next), Offset.zero);
        distance = next + gapLength;
      }
    }
    return destination;
  }

  /// Paleta categórica de séries — a paleta **decorativa** do tema (data-viz).
  static List<Color> colors(AppThemeData theme) =>
      theme.colorTheme.chartCategorical;

  /// Descreve valores não vazios para semântica.
  static String describeValues(Iterable<String> values) =>
      values.where((String value) => value.isNotEmpty).join(', ');

  /// Resolve a cor da série [index] (usa [color] se dado, senão a paleta).
  static Color resolveColor(AppThemeData theme, int index, {Color? color}) {
    final List<Color> palette = colors(theme);
    return color ?? palette[index % palette.length];
  }

  /// Formata um valor numérico curto para rótulos.
  static String valueLabel(double value) => value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);
}
