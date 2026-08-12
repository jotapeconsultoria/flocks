import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'chart_foundation.dart';
import 'chart_models.dart';
import 'chart_tooltip.dart';

/// Gráfico de **bolhas**: cada nó é um círculo cuja ÁREA representa o valor.
///
/// Use para mostrar magnitude relativa entre poucas categorias, quando a
/// posição exata não importa. Comparação precisa é trabalho do `AppBarChart` —
/// a área é notoriamente difícil de comparar a olho.
///
/// ```dart
/// AppBubbleChart(nodes: <AppBubbleChartNode>[
///   AppBubbleChartNode(label: 'Norte', value: 40),
///   AppBubbleChartNode(label: 'Sul', value: 25),
/// ])
/// ```
final class AppBubbleChart extends StatefulWidget {
  const AppBubbleChart({
    required this.nodes,
    this.onSelectionChanged,
    this.valueFormatter,
    super.key,
  }) : assert(nodes.length > 0, 'nodes must not be empty');

  final List<AppBubbleChartNode> nodes;
  final void Function(AppBubbleChartSelection selection)? onSelectionChanged;
  final AppChartValueFormatter? valueFormatter;

  @override
  State<AppBubbleChart> createState() => _AppBubbleChartState();
}

class _AppBubbleChartState extends State<AppBubbleChart> {
  AppBubbleChartSelection? _selection;
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

  void _handleSelection(_AppBubbleChartGeometry geometry, Offset position) {
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
        final geometry = _AppBubbleChartGeometry.fromData(
          nodes: widget.nodes,
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
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _AppBubbleChartPainter(
                        geometry: geometry,
                        selectedIndex: _selection?.index,
                      ),
                    ),
                  ),
                  ...geometry.valueLabels,
                  if (_tooltipData != null)
                    Positioned(
                      left: geometry.tooltipLeft(_tooltipData!),
                      top: geometry.tooltipTop(_tooltipData!),
                      // `SelectionContainer.disabled` pelo motivo detalhado em
                      // `molecules/input/app_input.dart`: na web um
                      // `SelectableRegion` monta platform view DOM sobre a área,
                      // e o `IgnorePointer` não o alcança.
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

final class _AppBubble {
  const _AppBubble({
    required this.center,
    required this.color,
    required this.index,
    required this.radius,
  });

  final Offset center;
  final Color color;
  final int index;
  final double radius;
}

final class _AppBubbleChartGeometry {
  const _AppBubbleChartGeometry({
    required this.bubbles,
    required this.nodes,
    required this.semanticLabel,
    required this.size,
    required this.theme,
  });

  final List<_AppBubble> bubbles;
  final List<AppBubbleChartNode> nodes;
  final String semanticLabel;
  final Size size;
  final AppThemeData theme;

  static _AppBubbleChartGeometry fromData({
    required List<AppBubbleChartNode> nodes,
    required Size size,
    required AppThemeData theme,
  }) {
    final height = size.height.isFinite ? math.max(size.height, 80.0) : 240.0;
    final width = size.width.isFinite ? math.max(size.width, 80.0) : 240.0;
    final resolvedSize = Size(width, height);
    final maxValue = math.max(
      nodes.fold<double>(0, (current, node) => math.max(current, node.value)),
      1,
    );
    final sortedIndexes = nodes.asMap().keys.toList(growable: false)
      ..sort((left, right) => nodes[right].value.compareTo(nodes[left].value));
    // Scale radius using the geometric mean of width and height so wide
    // layouts get larger bubbles instead of being constrained by height alone.
    // Cap maxRadius so bubbles never exceed half the available height.
    final dim = math.sqrt(width * height);
    final minRadius = dim * 0.06;
    final maxRadius = math.min(dim * 0.20, (height / 2) - AppSpacings.s16);
    final bubbles = <_AppBubble>[];
    final baseCenter = Offset(width * 0.5, height * 0.48);

    for (
      var sortedPosition = 0;
      sortedPosition < sortedIndexes.length;
      sortedPosition++
    ) {
      final index = sortedIndexes[sortedPosition];
      final value = nodes[index].value;
      final radius =
          minRadius + ((math.sqrt(value / maxValue)) * (maxRadius - minRadius));

      if (sortedPosition == 0) {
        bubbles.add(
          _AppBubble(
            center: Offset(width * 0.35, height * 0.45),
            color: ChartFoundation.resolveColor(
              theme,
              index,
              color: nodes[index].color,
            ),
            index: index,
            radius: radius,
          ),
        );
        continue;
      }

      var placedCenter = baseCenter;

      // Spiral outward from base center with a wider horizontal bias
      // so bubbles spread across the available width.
      for (var attempt = 0; attempt < 1200; attempt++) {
        final angle = attempt * 0.35;
        final distance =
            (radius + (sortedPosition * AppSpacings.s8)) + (attempt * 0.3);
        final candidate = Offset(
          baseCenter.dx + (math.cos(angle) * distance),
          baseCenter.dy + (math.sin(angle) * distance * 0.7),
        );
        final isInside =
            candidate.dx - radius >= AppSpacings.s8 &&
            candidate.dx + radius <= width - AppSpacings.s8 &&
            candidate.dy - radius >= AppSpacings.s8 &&
            candidate.dy + radius <= height - AppSpacings.s8;
        final hasOverlap = bubbles.any(
          (bubble) =>
              (bubble.center - candidate).distance <
              (bubble.radius + radius + AppSpacings.s4),
        );

        if (isInside && !hasOverlap) {
          placedCenter = candidate;
          break;
        }
      }

      bubbles.add(
        _AppBubble(
          center: placedCenter,
          color: ChartFoundation.resolveColor(
            theme,
            index,
            color: nodes[index].color,
          ),
          index: index,
          radius: radius,
        ),
      );
    }

    final semanticLabel = ChartFoundation.describeValues(
      nodes.map((node) => node.semanticLabel ?? '${node.label}: ${node.value}'),
    );

    return _AppBubbleChartGeometry(
      bubbles: bubbles,
      nodes: nodes,
      semanticLabel: semanticLabel,
      size: resolvedSize,
      theme: theme,
    );
  }

  AppBubbleChartSelection? nearestSelection(Offset position) {
    for (final bubble in bubbles) {
      if ((bubble.center - position).distance <= bubble.radius) {
        return AppBubbleChartSelection(
          index: bubble.index,
          node: nodes[bubble.index],
        );
      }
    }

    return null;
  }

  AppChartTooltipData tooltipData(
    AppBubbleChartSelection selection,
    AppChartValueFormatter? valueFormatter,
  ) {
    final bubble = bubbles.firstWhere((item) => item.index == selection.index);

    return AppChartTooltipData(
      items: [
        AppChartTooltipItem(
          color: bubble.color,
          label: selection.node.label,
          value:
              valueFormatter?.call(selection.node.value) ??
              ChartFoundation.valueLabel(selection.node.value),
        ),
      ],
      label: selection.node.label,
      offset: bubble.center,
    );
  }

  double tooltipLeft(AppChartTooltipData tooltipData) {
    return (tooltipData.offset.dx - 72).clamp(8, math.max(size.width - 152, 8));
  }

  double tooltipTop(AppChartTooltipData tooltipData) {
    return (tooltipData.offset.dy - 56).clamp(8, math.max(size.height - 64, 8));
  }

  List<Widget> get valueLabels {
    return bubbles
        .map((bubble) {
          final height = bubble.radius * 0.92;
          final node = nodes[bubble.index];
          final width = bubble.radius * 1.6;
          // Adaptive text style based on bubble size.
          final textStyle = bubble.radius >= 26
              ? theme.textTheme.headlineSmall
              : bubble.radius >= 16
              ? theme.textTheme.bodySmall
              : theme.textTheme.labelSmall;

          return Positioned(
            left: bubble.center.dx - (width / 2),
            height: height,
            top: bubble.center.dy - (height / 2),
            width: width,
            // O rótulo fica EM CIMA da bolha, que é o alvo do toque: sem
            // desligar a seleção, o platform view DOM da região cobre a bolha
            // inteira na web, oferecendo seleção e menu de contexto sobre o que
            // devia ser só alvo. Ver `molecules/input/app_input.dart`.
            child: SelectionContainer.disabled(
              child: IgnorePointer(
                child: Center(
                  child: AppText(
                    ChartFoundation.valueLabel(node.value),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle.withColor(bubble.color),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        })
        .toList(growable: false);
  }
}

final class _AppBubbleChartPainter extends CustomPainter {
  const _AppBubbleChartPainter({
    required this.geometry,
    required this.selectedIndex,
  });

  final _AppBubbleChartGeometry geometry;
  final int? selectedIndex;

  @override
  void paint(Canvas canvas, Size size) {
    for (final bubble in geometry.bubbles) {
      final isSelected = selectedIndex == bubble.index;
      final fillPaint = Paint()
        ..color = bubble.color.withValues(alpha: isSelected ? 0.28 : 0.18)
        ..style = PaintingStyle.fill;
      final strokePaint = Paint()
        ..color = bubble.color
        ..strokeWidth = isSelected ? AppStrokes.l : AppStrokes.m
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(bubble.center, bubble.radius, fillPaint);
      canvas.drawCircle(bubble.center, bubble.radius, strokePaint);
    }
  }

  @override
  bool shouldRepaint(_AppBubbleChartPainter oldDelegate) {
    return geometry != oldDelegate.geometry ||
        selectedIndex != oldDelegate.selectedIndex;
  }
}
