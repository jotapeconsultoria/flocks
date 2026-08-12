import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'chart_foundation.dart';
import 'chart_models.dart';
import 'chart_tooltip.dart';

/// Gráfico de **medidor** (gauge): arco segmentado com rótulo central.
///
/// Para UM indicador contra uma escala — ocupação, saúde, percentual de meta.
/// `variant` escolhe entre meio-arco e arco completo. Vários indicadores lado a
/// lado pedem `AppBarChart`: medidores em série são difíceis de comparar.
///
/// ```dart
/// AppGaugeChart(
///   centerLabel: 'Ocupação',
///   centerValueLabel: '72%',
///   segments: <AppGaugeChartSegment>[
///     AppGaugeChartSegment(label: 'Usado', value: 72),
///     AppGaugeChartSegment(label: 'Livre', value: 28),
///   ],
/// )
/// ```
final class AppGaugeChart extends StatefulWidget {
  const AppGaugeChart({
    required this.segments,
    this.centerLabel,
    this.centerValueLabel,
    this.onSelectionChanged,
    this.valueFormatter,
    this.variant = AppGaugeChartVariant.half,
    super.key,
  }) : assert(segments.length > 0, 'segments must not be empty');

  final String? centerLabel;
  final String? centerValueLabel;
  final void Function(AppGaugeChartSelection selection)? onSelectionChanged;
  final List<AppGaugeChartSegment> segments;
  final AppChartValueFormatter? valueFormatter;
  final AppGaugeChartVariant variant;

  @override
  State<AppGaugeChart> createState() => _AppGaugeChartState();
}

class _AppGaugeChartState extends State<AppGaugeChart> {
  AppGaugeChartSelection? _selection;
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

  void _handleSelection(_AppGaugeGeometry geometry, Offset position) {
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
        final geometry = _AppGaugeGeometry.fromData(
          segments: widget.segments,
          size: size,
          theme: theme,
          variant: widget.variant,
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
                      painter: _AppGaugePainter(
                        geometry: geometry,
                        selectedIndex: _selection?.index,
                      ),
                    ),
                  ),
                  if (widget.centerLabel != null ||
                      widget.centerValueLabel != null)
                    _AppGaugeCenterLabels(
                      centerLabel: widget.centerLabel,
                      centerValueLabel: widget.centerValueLabel,
                      geometry: geometry,
                      theme: theme,
                      variant: widget.variant,
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

final class _AppGaugeCenterLabels extends StatelessWidget {
  const _AppGaugeCenterLabels({
    required this.centerLabel,
    required this.centerValueLabel,
    required this.geometry,
    required this.theme,
    required this.variant,
  });

  final String? centerLabel;
  final String? centerValueLabel;
  final _AppGaugeGeometry geometry;
  final AppThemeData theme;
  final AppGaugeChartVariant variant;

  @override
  Widget build(BuildContext context) {
    if (variant != AppGaugeChartVariant.half) {
      return Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (centerValueLabel != null)
              AppText(
                centerValueLabel!,
                style: theme.textTheme.headlineMedium.withColor(
                  theme.colorTheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            if (centerLabel != null)
              AppText(
                centerLabel!,
                style: theme.textTheme.bodySmall.withColor(
                  theme.colorTheme.neutralPrimary.s500,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      );
    }

    return SizedBox.expand(
      child: Stack(
        children: [
          if (centerLabel != null || centerValueLabel != null)
            Positioned(
              left: _resolvedSideLabelLeft(),
              top: _resolvedSideLabelTop(),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (centerValueLabel != null)
                      AppText(
                        centerValueLabel!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineMedium.withColor(
                          theme.colorTheme.onSurface,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    if (centerLabel != null)
                      AppText(
                        centerLabel!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall.withColor(
                          theme.colorTheme.neutralPrimary.s500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  double _resolvedSideLabelLeft() {
    if (geometry.arcs.isEmpty) {
      return AppSpacings.s8.toDouble();
    }

    final outerRadius = geometry.arcs
        .map((arc) => arc.outerRadius)
        .reduce(math.max);
    final preferredLeft = geometry.center.dx + (outerRadius * 0.5);

    return preferredLeft
        .clamp(
          AppSpacings.s8,
          math.max(geometry.size.width - 128, AppSpacings.s8),
        )
        .toDouble();
  }

  double _resolvedSideLabelTop() {
    if (geometry.arcs.isEmpty) {
      return AppSpacings.s8.toDouble();
    }

    final outerRadius = geometry.arcs
        .map((arc) => arc.outerRadius)
        .reduce(math.max);
    final preferredTop = geometry.center.dy - (outerRadius * 0.45);

    return preferredTop
        .clamp(
          AppSpacings.s8,
          math.max(geometry.size.height - 24, AppSpacings.s8),
        )
        .toDouble();
  }
}

final class _AppGaugeArc {
  const _AppGaugeArc({
    required this.center,
    required this.color,
    required this.endAngle,
    required this.index,
    required this.outerRadius,
    required this.startAngle,
    required this.strokeWidth,
    required this.sweepAngle,
  });

  final Offset center;
  final Color color;
  final double endAngle;
  final int index;
  final double outerRadius;
  final double startAngle;
  final double strokeWidth;
  final double sweepAngle;
}

final class _AppGaugeGeometry {
  const _AppGaugeGeometry({
    required this.arcs,
    required this.center,
    required this.semanticLabel,
    required this.segments,
    required this.size,
    required this.theme,
    required this.trackEndAngle,
    required this.trackStartAngle,
    required this.variant,
  });

  final List<_AppGaugeArc> arcs;
  final Offset center;
  final String semanticLabel;
  final List<AppGaugeChartSegment> segments;
  final Size size;
  final AppThemeData theme;
  final double trackEndAngle;
  final double trackStartAngle;
  final AppGaugeChartVariant variant;

  static _AppGaugeGeometry fromData({
    required List<AppGaugeChartSegment> segments,
    required Size size,
    required AppThemeData theme,
    required AppGaugeChartVariant variant,
  }) {
    final height = math.max(size.height, 180.0);
    final width = math.max(size.width, 180.0);
    final resolvedSize = Size(width, height);
    final center = Offset(
      width / 2,
      variant == AppGaugeChartVariant.half ? height * 0.8 : height / 2,
    );
    final baseRadius = math.min(width, height) / 2 - AppSpacings.s8;
    final strokeWidth = variant == AppGaugeChartVariant.half
        ? AppSizes.s16
        : AppSizes.s8 + AppSpacings.s4;
    const spacing = AppSpacings.s8;
    const radialTrackStartAngle = math.pi * 0.75;
    final trackStartAngle = variant == AppGaugeChartVariant.half
        ? math.pi
        : radialTrackStartAngle;
    final trackSweepAngle = variant == AppGaugeChartVariant.half
        ? math.pi
        : math.pi * 1.5;
    final arcs = <_AppGaugeArc>[];

    for (var index = 0; index < segments.length; index++) {
      final segment = segments[index];
      final radius = baseRadius - (index * (strokeWidth + spacing));
      final progress = (segment.value / math.max(segment.maxValue, 1)).clamp(
        0,
        1,
      );
      arcs.add(
        _AppGaugeArc(
          center: center,
          color: ChartFoundation.resolveColor(
            theme,
            index,
            color: segment.color,
          ),
          endAngle: trackStartAngle + (trackSweepAngle * progress),
          index: index,
          outerRadius: radius,
          startAngle: trackStartAngle,
          strokeWidth: strokeWidth,
          sweepAngle: trackSweepAngle * progress,
        ),
      );
    }

    final semanticLabel = ChartFoundation.describeValues(
      segments.map(
        (segment) =>
            segment.semanticLabel ??
            '${segment.label}: ${segment.value}/${segment.maxValue}',
      ),
    );

    return _AppGaugeGeometry(
      arcs: arcs,
      center: center,
      semanticLabel: semanticLabel,
      segments: segments,
      size: resolvedSize,
      theme: theme,
      trackEndAngle: trackStartAngle + trackSweepAngle,
      trackStartAngle: trackStartAngle,
      variant: variant,
    );
  }

  AppGaugeChartSelection? nearestSelection(Offset position) {
    final vector = position - center;
    final distance = vector.distance;
    final rawAngle = math.atan2(vector.dy, vector.dx);
    final angle = rawAngle < trackStartAngle
        ? rawAngle + (math.pi * 2)
        : rawAngle;

    for (final arc in arcs) {
      final outer = arc.outerRadius;
      final inner = outer - arc.strokeWidth;

      if (distance <= outer &&
          distance >= inner &&
          angle >= arc.startAngle &&
          angle <= arc.endAngle) {
        return AppGaugeChartSelection(
          index: arc.index,
          segment: segments[arc.index],
        );
      }
    }

    return null;
  }

  AppChartTooltipData tooltipData(
    AppGaugeChartSelection selection,
    AppChartValueFormatter? valueFormatter,
  ) {
    final arc = arcs[selection.index];
    final angle = arc.startAngle + (arc.sweepAngle / 2);
    final distance = arc.outerRadius - (arc.strokeWidth / 2);
    final offset = Offset(
      center.dx + math.cos(angle) * distance,
      center.dy + math.sin(angle) * distance,
    );

    return AppChartTooltipData(
      items: [
        AppChartTooltipItem(
          color: arc.color,
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

final class _AppGaugePainter extends CustomPainter {
  const _AppGaugePainter({required this.geometry, required this.selectedIndex});

  final _AppGaugeGeometry geometry;
  final int? selectedIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final trackSweepAngle = geometry.trackEndAngle - geometry.trackStartAngle;

    for (final arc in geometry.arcs) {
      final rect = Rect.fromCircle(
        center: geometry.center,
        radius: arc.outerRadius - (arc.strokeWidth / 2),
      );
      final backgroundPaint = Paint()
        ..color = geometry.theme.colorTheme.neutralPrimary.s100
        ..strokeCap = StrokeCap.round
        ..strokeWidth = arc.strokeWidth
        ..style = PaintingStyle.stroke;
      final foregroundPaint = Paint()
        ..color = selectedIndex == arc.index
            ? arc.color.withValues(alpha: 0.9)
            : arc.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = arc.strokeWidth
        ..style = PaintingStyle.stroke;

      canvas.drawArc(
        rect,
        geometry.trackStartAngle,
        trackSweepAngle,
        false,
        backgroundPaint,
      );
      canvas.drawArc(
        rect,
        arc.startAngle,
        arc.sweepAngle,
        false,
        foregroundPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_AppGaugePainter oldDelegate) {
    return geometry != oldDelegate.geometry ||
        selectedIndex != oldDelegate.selectedIndex;
  }
}
