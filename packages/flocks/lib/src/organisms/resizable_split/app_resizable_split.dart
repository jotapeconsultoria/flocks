import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../resizable_panel/resize_gutter.dart';

/// A resizable split layout with a draggable divider between [first] and
/// [second].
///
/// Works in both orientations through [direction]:
/// - [Axis.horizontal] lays the panels out side by side (drag left/right);
/// - [Axis.vertical] stacks them (drag up/down).
///
/// The split is stored as the **fraction** the first panel occupies of the
/// available extent (0..1), so panels scale proportionally when the window is
/// resized. Persistência é responsabilidade do chamador (o DS não depende de
/// storage): passe o valor restaurado em [initialFirstFraction] e salve os novos
/// valores por [onFractionChanged].
///
/// Double tapping the divider resets the split to [initialFirstFraction].
///
/// Example:
/// ```dart
/// AppResizableSplit(
///   direction: Axis.horizontal,
///   initialFirstFraction: restoredFraction ?? 0.22,
///   onFractionChanged: (f) => storage.write('tracking_map.split', f),
///   minFirstSize: 260,
///   minSecondSize: 320,
///   first: vehiclesSidebar,
///   second: map,
/// )
/// ```
final class AppResizableSplit extends StatefulWidget {
  const AppResizableSplit({
    required this.first,
    required this.second,
    this.direction = Axis.horizontal,
    this.initialFirstFraction = 0.5,
    this.minFirstFraction = 0.15,
    this.maxFirstFraction = 0.85,
    this.minFirstSize,
    this.minSecondSize,
    this.thickness = kResizeGutterThickness,
    this.handleLength = kResizeHandleLength,
    this.handleThickness = kResizeHandleThickness,
    this.tooltip = 'Redimensionar',
    this.onFractionChanged,
    super.key,
  }) : assert(
         initialFirstFraction > 0 && initialFirstFraction < 1,
         'initialFirstFraction must be between 0 and 1',
       ),
       assert(
         minFirstFraction < maxFirstFraction,
         'minFirstFraction must be smaller than maxFirstFraction',
       );

  /// The leading panel (left when horizontal, top when vertical).
  final Widget first;

  /// The trailing panel (right when horizontal, bottom when vertical).
  final Widget second;

  /// The layout orientation. [Axis.horizontal] = side by side,
  /// [Axis.vertical] = stacked.
  final Axis direction;

  /// The first panel fraction (0..1) — o valor inicial (o chamador restaura a
  /// persistência e passa aqui).
  final double initialFirstFraction;

  /// Lower bound for the first panel as a fraction of the available extent.
  final double minFirstFraction;

  /// Upper bound for the first panel as a fraction of the available extent.
  final double maxFirstFraction;

  /// Optional absolute minimum size (px) for the first panel.
  final double? minFirstSize;

  /// Optional absolute minimum size (px) for the second panel.
  final double? minSecondSize;

  /// The draggable gutter cross-size — its width when horizontal, its height
  /// when vertical. Also the hover/hit area.
  final double thickness;

  /// The handle long-side length (along the divider).
  final double handleLength;

  /// The handle short-side thickness (across the divider).
  final double handleThickness;

  /// Tooltip shown while hovering the divider. Null disables it.
  final String? tooltip;

  /// Called with the new first-panel fraction whenever the user drags.
  final ValueChanged<double>? onFractionChanged;

  @override
  State<AppResizableSplit> createState() => _AppResizableSplitState();
}

class _AppResizableSplitState extends State<AppResizableSplit> {
  double? _fraction;

  bool get _isHorizontal => widget.direction == Axis.horizontal;

  /// Clamps a first-panel size (px) within the configured fraction and
  /// absolute bounds, degrading gracefully on very small extents.
  double _clampFirstSize(double size, double available) {
    var lo = widget.minFirstFraction * available;
    var hi = widget.maxFirstFraction * available;
    if (widget.minFirstSize != null) lo = math.max(lo, widget.minFirstSize!);
    if (widget.minSecondSize != null) {
      hi = math.min(hi, available - widget.minSecondSize!);
    }
    if (lo > hi) {
      final mid = (available / 2).clamp(0.0, available);
      lo = mid;
      hi = mid;
    }
    return size.clamp(lo, hi);
  }

  void _onDragUpdate(double delta, double firstSize, double available) {
    if (available <= 0) return;
    final newSize = _clampFirstSize(firstSize + delta, available);
    final newFraction = newSize / available;
    setState(() => _fraction = newFraction);
    widget.onFractionChanged?.call(newFraction);
  }

  void _onReset() {
    setState(() => _fraction = widget.initialFirstFraction);
    widget.onFractionChanged?.call(widget.initialFirstFraction);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final extent = _isHorizontal
            ? constraints.maxWidth
            : constraints.maxHeight;
        final available = math.max(0.0, extent - widget.thickness);
        final fraction = _fraction ?? widget.initialFirstFraction;
        final firstSize = _clampFirstSize(fraction * available, available);

        // RepaintBoundary isola cada painel em sua própria layer: redimensionar
        // o divisor (ou hover/seleção/refresh) deixa de repintar os dois lados
        // juntos — crítico quando um lado é uma platform view cara (ex.: mapa).
        final first = SizedBox(
          width: _isHorizontal ? firstSize : null,
          height: _isHorizontal ? null : firstSize,
          child: RepaintBoundary(child: widget.first),
        );
        final divider = RepaintBoundary(
          child: ResizeGutter(
            direction: widget.direction,
            onDragDelta: (delta) => _onDragUpdate(delta, firstSize, available),
            onReset: _onReset,
            thickness: widget.thickness,
            handleLength: widget.handleLength,
            handleThickness: widget.handleThickness,
            tooltip: widget.tooltip,
          ),
        );
        final second = Expanded(child: RepaintBoundary(child: widget.second));

        final children = [first, divider, second];

        return _isHorizontal
            ? Row(children: children)
            : Column(children: children);
      },
    );
  }
}
