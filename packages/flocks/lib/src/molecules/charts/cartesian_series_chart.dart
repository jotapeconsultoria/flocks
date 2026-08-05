import 'dart:math' as math;

import 'package:meta/meta.dart';

import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'chart_foundation.dart';
import 'chart_models.dart';
import 'chart_tooltip.dart';

@internal
final class CartesianSeriesChart extends StatefulWidget {
  const CartesianSeriesChart({
    required this.series,
    this.areaOpacity = 0.18,
    this.maxY,
    this.minY = 0,
    this.onSelectionChanged,
    this.showArea = false,
    this.showGrid = true,
    this.valueFormatter,
    super.key,
  }) : assert(series.length > 0, 'series must not be empty');

  final double areaOpacity;
  final double? maxY;
  final double minY;
  final void Function(AppCartesianChartSelection selection)? onSelectionChanged;
  final List<AppCartesianChartSeries> series;
  final bool showArea;
  final bool showGrid;
  final AppChartValueFormatter? valueFormatter;

  @override
  State<CartesianSeriesChart> createState() => _AppCartesianSeriesChartState();
}

class _AppCartesianSeriesChartState extends State<CartesianSeriesChart> {
  AppChartTooltipData? _tooltipData;
  AppCartesianChartSelection? _selection;

  void _clearSelection() {
    if (_selection == null && _tooltipData == null) {
      return;
    }

    setState(() {
      _selection = null;
      _tooltipData = null;
    });
  }

  void _handleSelection(_AppCartesianChartGeometry geometry, Offset position) {
    final selection = geometry.nearestSelection(position);

    if (selection == null) {
      _clearSelection();
      return;
    }

    final tooltipData = geometry.tooltipData(selection, widget.valueFormatter);

    setState(() {
      _selection = selection;
      _tooltipData = tooltipData;
    });

    widget.onSelectionChanged?.call(selection);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final geometry = _AppCartesianChartGeometry.fromData(
          maxY: widget.maxY,
          minY: widget.minY,
          series: widget.series,
          size: size,
          theme: theme,
        );

        return MouseRegion(
          onExit: (_) => _clearSelection(),
          onHover: (event) => _handleSelection(geometry, event.localPosition),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (event) =>
                _handleSelection(geometry, event.localPosition),
            child: Semantics(
              label: geometry.semanticLabel,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _AppCartesianSeriesChartPainter(
                        areaOpacity: widget.areaOpacity,
                        geometry: geometry,
                        selectedPointIndex: _selection?.pointIndex,
                        showArea: widget.showArea,
                        showGrid: widget.showGrid,
                      ),
                    ),
                  ),
                  ...geometry.xLabels,
                  ...geometry.yLabels,
                  if (_tooltipData != null)
                    Positioned(
                      left: geometry.tooltipLeft(_tooltipData!),
                      top: geometry.tooltipTop(_tooltipData!),
                      child: IgnorePointer(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 180),
                          child: ChartTooltip(data: _tooltipData!),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

final class _AppCartesianChartGeometry {
  const _AppCartesianChartGeometry({
    required this.labels,
    required this.plotRect,
    required this.positions,
    required this.semanticLabel,
    required this.series,
    required this.size,
    required this.theme,
    required this.yTickValues,
  });

  final List<String> labels;
  final Rect plotRect;
  final List<List<Offset>> positions;
  final String semanticLabel;
  final List<AppCartesianChartSeries> series;
  final Size size;
  final AppThemeData theme;
  final List<double> yTickValues;

  static _AppCartesianChartGeometry fromData({
    required double? maxY,
    required double minY,
    required List<AppCartesianChartSeries> series,
    required Size size,
    required AppThemeData theme,
  }) {
    final labelCount = series.first.points.length;
    final labels = List<String>.generate(
      labelCount,
      (index) =>
          series.first.points[index].label ??
          series.first.points[index].x.toString(),
    );
    final values = series
        .expand((item) => item.points.map((point) => point.y))
        .toList();
    final resolvedMaxY = maxY ?? math.max(1, values.fold<double>(0, math.max));
    final resolvedMinY = math.min(minY, values.fold<double>(minY, math.min));
    final height = math.max(size.height, 180.0);
    final width = math.max(size.width, 180.0);
    final plotRect = Rect.fromLTWH(
      44,
      12,
      math.max(width - 56, 1),
      math.max(height - 52, 1),
    );
    final divisor = math.max(resolvedMaxY - resolvedMinY, 1);
    final step = labels.length > 1 ? plotRect.width / (labels.length - 1) : 0.0;
    final positions = List<List<Offset>>.generate(
      series.length,
      (seriesIndex) => List<Offset>.generate(
        series[seriesIndex].points.length,
        (pointIndex) {
          final point = series[seriesIndex].points[pointIndex];
          final dx = labels.length == 1
              ? plotRect.center.dx
              : plotRect.left + (step * pointIndex);
          final dy =
              plotRect.bottom -
              (((point.y - resolvedMinY) / divisor).clamp(0, 1) *
                  plotRect.height);
          return Offset(dx, dy);
        },
      ),
    );
    const tickCount = 5;
    final yTickValues = List<double>.generate(
      tickCount,
      (index) =>
          resolvedMinY +
          (((resolvedMaxY - resolvedMinY) / (tickCount - 1)) * index),
    );
    final semanticLabel = ChartFoundation.describeValues(
      series.expand(
        (item) => item.points.map(
          (point) =>
              point.semanticLabel ??
              '${item.label} ${point.label ?? point.x}: ${point.y}',
        ),
      ),
    );

    return _AppCartesianChartGeometry(
      labels: labels,
      plotRect: plotRect,
      positions: positions,
      semanticLabel: semanticLabel,
      series: series,
      size: Size(width, height),
      theme: theme,
      yTickValues: yTickValues,
    );
  }

  AppCartesianChartSelection? nearestSelection(Offset position) {
    AppCartesianChartSelection? result;
    var minDistance = double.infinity;

    for (var seriesIndex = 0; seriesIndex < positions.length; seriesIndex++) {
      for (
        var pointIndex = 0;
        pointIndex < positions[seriesIndex].length;
        pointIndex++
      ) {
        final distance =
            (positions[seriesIndex][pointIndex] - position).distanceSquared;

        if (distance < minDistance) {
          minDistance = distance;
          result = AppCartesianChartSelection(
            point: series[seriesIndex].points[pointIndex],
            pointIndex: pointIndex,
            series: series[seriesIndex],
            seriesIndex: seriesIndex,
          );
        }
      }
    }

    return result;
  }

  List<Widget> get xLabels {
    final step = labels.length > 1
        ? plotRect.width / (labels.length - 1)
        : plotRect.width;
    final labelWidth = step.clamp(48.0, 80.0);
    final halfWidth = labelWidth / 2;

    return List<Widget>.generate(labels.length, (index) {
      final point = positions.first[index];

      return Positioned(
        bottom: 0,
        left: point.dx - halfWidth,
        width: labelWidth,
        child: IgnorePointer(
          child: AppText(
            labels[index],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium.withColor(
              theme.colorTheme.neutralPrimary.s500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    });
  }

  List<Widget> get yLabels {
    return List<Widget>.generate(yTickValues.length, (index) {
      final ratio = index / (math.max(yTickValues.length - 1, 1));
      final dy = plotRect.bottom - (plotRect.height * ratio) - 8;

      return Positioned(
        left: 0,
        top: dy,
        width: 36,
        child: IgnorePointer(
          child: AppText(
            ChartFoundation.valueLabel(yTickValues[index]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium.withColor(
              theme.colorTheme.neutralPrimary.s500,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      );
    });
  }

  AppChartTooltipData tooltipData(
    AppCartesianChartSelection selection,
    AppChartValueFormatter? valueFormatter,
  ) {
    final items = List<AppChartTooltipItem>.generate(series.length, (index) {
      final point = series[index].points[selection.pointIndex];
      return AppChartTooltipItem(
        color: ChartFoundation.resolveColor(
          theme,
          index,
          color: series[index].color,
        ),
        label: series[index].label,
        value:
            valueFormatter?.call(point.y) ??
            ChartFoundation.valueLabel(point.y),
      );
    });
    final anchorY = positions
        .map((item) => item[selection.pointIndex].dy)
        .fold<double>(plotRect.bottom, math.min);

    return AppChartTooltipData(
      items: items,
      label: labels[selection.pointIndex],
      offset: Offset(positions.first[selection.pointIndex].dx, anchorY),
    );
  }

  double tooltipLeft(AppChartTooltipData tooltipData) {
    return (tooltipData.offset.dx - 72).clamp(8, math.max(size.width - 152, 8));
  }

  double tooltipTop(AppChartTooltipData tooltipData) {
    final preferred = tooltipData.offset.dy - 72;

    if (preferred >= 8) {
      return preferred;
    }

    return (tooltipData.offset.dy + 12).clamp(8, math.max(size.height - 72, 8));
  }
}

final class _AppCartesianSeriesChartPainter extends CustomPainter {
  const _AppCartesianSeriesChartPainter({
    required this.areaOpacity,
    required this.geometry,
    required this.selectedPointIndex,
    required this.showArea,
    required this.showGrid,
  });

  final double areaOpacity;
  final _AppCartesianChartGeometry geometry;
  final int? selectedPointIndex;
  final bool showArea;
  final bool showGrid;

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = geometry.theme.colorTheme.neutralPrimary.s100
      ..strokeWidth = AppStrokes.m;
    final markerPaint = Paint()
      ..color = geometry.theme.colorTheme.neutralWhite
      ..style = PaintingStyle.fill;
    final selectionPaint = Paint()
      ..color = geometry.theme.colorTheme.neutralPrimary.s200
      ..strokeWidth = AppStrokes.m;

    if (showGrid) {
      for (var index = 0; index < geometry.yTickValues.length; index++) {
        final ratio = index / (math.max(geometry.yTickValues.length - 1, 1));
        final y = geometry.plotRect.bottom - (geometry.plotRect.height * ratio);
        canvas.drawLine(
          Offset(geometry.plotRect.left, y),
          Offset(geometry.plotRect.right, y),
          axisPaint,
        );
      }
    }

    canvas.drawLine(
      Offset(geometry.plotRect.left, geometry.plotRect.bottom),
      Offset(geometry.plotRect.right, geometry.plotRect.bottom),
      axisPaint,
    );

    if (selectedPointIndex != null) {
      final selectedX = geometry.positions.first[selectedPointIndex!].dx;
      canvas.drawLine(
        Offset(selectedX, geometry.plotRect.top),
        Offset(selectedX, geometry.plotRect.bottom),
        selectionPaint,
      );
    }

    for (
      var seriesIndex = 0;
      seriesIndex < geometry.series.length;
      seriesIndex++
    ) {
      final color = ChartFoundation.resolveColor(
        geometry.theme,
        seriesIndex,
        color: geometry.series[seriesIndex].color,
      );
      final points = geometry.positions[seriesIndex];
      final strokePath = ChartFoundation.buildLinePath(
        geometry.series[seriesIndex].curveStyle,
        points,
      );
      final strokePaint = Paint()
        ..color = color
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = AppStrokes.l
        ..style = PaintingStyle.stroke;

      if (showArea) {
        final areaPath = Path.from(strokePath)
          ..lineTo(points.last.dx, geometry.plotRect.bottom)
          ..lineTo(points.first.dx, geometry.plotRect.bottom)
          ..close();
        final areaPaint = Paint()
          ..color = color.withValues(alpha: areaOpacity)
          ..style = PaintingStyle.fill;
        canvas.drawPath(areaPath, areaPaint);
      }

      if (geometry.series[seriesIndex].isDashed) {
        canvas.drawPath(
          ChartFoundation.buildDashedPath(strokePath),
          strokePaint,
        );
      } else {
        canvas.drawPath(strokePath, strokePaint);
      }

      if (geometry.series[seriesIndex].showPoints) {
        for (var pointIndex = 0; pointIndex < points.length; pointIndex++) {
          final point = points[pointIndex];
          canvas.drawCircle(point, AppSizes.s4, Paint()..color = color);
          canvas.drawCircle(point, AppSizes.s2, markerPaint);

          if (selectedPointIndex == pointIndex) {
            canvas.drawCircle(
              point,
              AppSizes.s8,
              Paint()
                ..color = color.withValues(alpha: 0.18)
                ..style = PaintingStyle.fill,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(_AppCartesianSeriesChartPainter oldDelegate) {
    return geometry != oldDelegate.geometry ||
        areaOpacity != oldDelegate.areaOpacity ||
        selectedPointIndex != oldDelegate.selectedPointIndex ||
        showArea != oldDelegate.showArea ||
        showGrid != oldDelegate.showGrid;
  }
}
