import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'chart_foundation.dart';
import 'chart_models.dart';
import 'chart_tooltip.dart';

final class RadialDistributionChart extends StatefulWidget {
  const RadialDistributionChart({
    required this.segments,
    this.innerRadiusFactor = 0,
    this.onSelectionChanged,
    this.valueFormatter,
    super.key,
  });

  final double innerRadiusFactor;
  final void Function(AppPieChartSelection selection)? onSelectionChanged;
  final List<AppPieChartSegment> segments;
  final AppChartValueFormatter? valueFormatter;

  @override
  State<RadialDistributionChart> createState() =>
      _RadialDistributionChartState();
}

class _RadialDistributionChartState extends State<RadialDistributionChart> {
  AppPieChartSelection? _selection;
  AppChartTooltipData? _tooltipData;

  void _clearSelection() {
    if (_selection == null && _tooltipData == null) {
      return;
    }

    setState(() {
      _selection = null;
      _tooltipData = null;
    });
  }

  void _handleSelection(_RadialDistributionGeometry geometry, Offset position) {
    final selection = geometry.nearestSelection(position);

    if (selection == null) {
      _clearSelection();
      return;
    }

    setState(() {
      _selection = selection;
      _tooltipData = geometry.tooltipData(selection, widget.valueFormatter);
    });

    widget.onSelectionChanged?.call(selection);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final geometry = _RadialDistributionGeometry.fromData(
          innerRadiusFactor: widget.innerRadiusFactor,
          segments: widget.segments,
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
                      painter: _RadialDistributionPainter(
                        geometry: geometry,
                        selectedIndex: _selection?.index,
                      ),
                    ),
                  ),
                  if (_tooltipData != null)
                    Positioned(
                      left: geometry.tooltipLeft(_tooltipData!),
                      top: geometry.tooltipTop(_tooltipData!),
                      // `SelectionContainer.disabled` pelo motivo detalhado em
                      // `molecules/input/app_input.dart`: na web um
                      // `SelectableRegion` monta platform view DOM que engole o
                      // `mousedown`, e o `IgnorePointer` não o alcança.
                      child: SelectionContainer.disabled(
                        child: IgnorePointer(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 180),
                            child: ChartTooltip(data: _tooltipData!),
                          ),
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

final class _RadialDistributionGeometry {
  const _RadialDistributionGeometry({
    required this.center,
    required this.innerRadiusFactor,
    required this.radius,
    required this.semanticLabel,
    required this.segments,
    required this.size,
    required this.slices,
    required this.theme,
  });

  final Offset center;
  final double innerRadiusFactor;
  final double radius;
  final String semanticLabel;
  final List<AppPieChartSegment> segments;
  final Size size;
  final List<_RadialSlice> slices;
  final AppThemeData theme;

  static _RadialDistributionGeometry fromData({
    required double innerRadiusFactor,
    required List<AppPieChartSegment> segments,
    required Size size,
    required AppThemeData theme,
  }) {
    final height = math.max(size.height, 180.0);
    final width = math.max(size.width, 180.0);
    final resolvedSize = Size(width, height);
    final center = Offset(width / 2, height / 2);
    final radius = math.min(width, height) / 2 - AppSpacings.s8;
    final total = math.max(
      segments.fold<double>(0, (sum, item) => sum + item.value),
      1,
    );
    final slices = <_RadialSlice>[];
    final segmentGapAngle = innerRadiusFactor > 0 && segments.length > 1
        ? 0.08
        : 0.0;
    var startAngle = -math.pi / 2;

    for (var index = 0; index < segments.length; index++) {
      final rawSweepAngle = (segments[index].value / total) * math.pi * 2;
      final resolvedGapAngle = rawSweepAngle > (segmentGapAngle * 1.5)
          ? segmentGapAngle
          : 0.0;
      final sliceStartAngle = startAngle + (resolvedGapAngle / 2);
      final sweepAngle = math
          .max(rawSweepAngle - resolvedGapAngle, 0)
          .toDouble();
      slices.add(
        _RadialSlice(
          color: ChartFoundation.resolveColor(
            theme,
            index,
            color: segments[index].color,
          ),
          endAngle: sliceStartAngle + sweepAngle,
          index: index,
          startAngle: sliceStartAngle,
          sweepAngle: sweepAngle,
        ),
      );
      startAngle += rawSweepAngle;
    }

    final semanticLabel = ChartFoundation.describeValues(
      segments.map(
        (segment) =>
            segment.semanticLabel ?? '${segment.label}: ${segment.value}',
      ),
    );

    return _RadialDistributionGeometry(
      center: center,
      innerRadiusFactor: innerRadiusFactor,
      radius: radius,
      semanticLabel: semanticLabel,
      segments: segments,
      size: resolvedSize,
      slices: slices,
      theme: theme,
    );
  }

  AppPieChartSelection? nearestSelection(Offset position) {
    final vector = position - center;
    final distance = vector.distance;
    final normalizedAngle = math.atan2(vector.dy, vector.dx);
    final angle = normalizedAngle < -math.pi / 2
        ? normalizedAngle + (math.pi * 2)
        : normalizedAngle;
    final innerRadius = radius * innerRadiusFactor;

    if (distance > radius || distance < innerRadius) {
      return null;
    }

    for (final slice in slices) {
      if (angle >= slice.startAngle && angle <= slice.endAngle) {
        return AppPieChartSelection(
          index: slice.index,
          segment: segments[slice.index],
        );
      }
    }

    return null;
  }

  AppChartTooltipData tooltipData(
    AppPieChartSelection selection,
    AppChartValueFormatter? valueFormatter,
  ) {
    final slice = slices[selection.index];
    final midAngle = slice.startAngle + (slice.sweepAngle / 2);
    final distance = radius * ((1 + innerRadiusFactor) / 2);
    final offset = Offset(
      center.dx + math.cos(midAngle) * distance,
      center.dy + math.sin(midAngle) * distance,
    );

    return AppChartTooltipData(
      items: [
        AppChartTooltipItem(
          color: slice.color,
          label: selection.segment.label,
          value:
              valueFormatter?.call(selection.segment.value) ??
              ChartFoundation.valueLabel(selection.segment.value),
        ),
      ],
      label: selection.segment.label,
      offset: offset,
    );
  }

  double tooltipLeft(AppChartTooltipData tooltipData) {
    return (tooltipData.offset.dx - 72).clamp(8, math.max(size.width - 152, 8));
  }

  double tooltipTop(AppChartTooltipData tooltipData) {
    return (tooltipData.offset.dy - 56).clamp(8, math.max(size.height - 64, 8));
  }
}

final class _RadialDistributionPainter extends CustomPainter {
  const _RadialDistributionPainter({
    required this.geometry,
    required this.selectedIndex,
  });

  final _RadialDistributionGeometry geometry;
  final int? selectedIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Rect.fromCircle(
      center: geometry.center,
      radius: geometry.radius,
    );
    final caps = <_RadialCap>[];

    for (final slice in geometry.slices) {
      final isSelected = selectedIndex == slice.index;
      final midAngle = slice.startAngle + (slice.sweepAngle / 2);
      final offset = isSelected
          ? Offset(
              math.cos(midAngle) * AppSpacings.s4,
              math.sin(midAngle) * AppSpacings.s4,
            )
          : Offset.zero;
      final rect = bounds.shift(offset);
      final paint = Paint()
        ..color = slice.color
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      if (geometry.innerRadiusFactor == 0) {
        paint.style = PaintingStyle.fill;
        final path = Path()
          ..moveTo(
            geometry.center.dx + offset.dx,
            geometry.center.dy + offset.dy,
          )
          ..arcTo(rect, slice.startAngle, slice.sweepAngle, false)
          ..close();
        canvas.drawPath(path, paint);
      } else {
        paint
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.butt
          ..strokeWidth = geometry.radius * (1 - geometry.innerRadiusFactor);
        final arcRect = rect.deflate(paint.strokeWidth / 2);
        canvas.drawArc(
          arcRect,
          slice.startAngle,
          slice.sweepAngle,
          false,
          paint,
        );

        // Donut slices use a single rounded tip at the segment end.
        final capAngle = slice.startAngle + slice.sweepAngle;
        final capCenter = Offset(
          arcRect.center.dx + (math.cos(capAngle) * (arcRect.width / 2)),
          arcRect.center.dy + (math.sin(capAngle) * (arcRect.height / 2)),
        );
        caps.add(
          _RadialCap(
            center: capCenter,
            color: slice.color,
            radius: paint.strokeWidth / 2,
          ),
        );
      }
    }

    // Draw tips after all arcs so the rounded end always stays on top.
    for (final cap in caps) {
      final capPaint = Paint()
        ..color = cap.color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(cap.center, cap.radius, capPaint);
    }
  }

  @override
  bool shouldRepaint(_RadialDistributionPainter oldDelegate) {
    return geometry != oldDelegate.geometry ||
        selectedIndex != oldDelegate.selectedIndex;
  }
}

final class _RadialCap {
  const _RadialCap({
    required this.center,
    required this.color,
    required this.radius,
  });

  final Offset center;
  final Color color;
  final double radius;
}

final class _RadialSlice {
  const _RadialSlice({
    required this.color,
    required this.endAngle,
    required this.index,
    required this.startAngle,
    required this.sweepAngle,
  });

  final Color color;
  final double endAngle;
  final int index;
  final double startAngle;
  final double sweepAngle;
}
