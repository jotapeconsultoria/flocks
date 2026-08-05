import 'dart:math';

import 'package:flutter/widgets.dart';

import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// A widget that draws an animated border progress around its child.
///
/// The border starts from the bottom center and traces clockwise.
///
/// Supports two modes:
/// - **Controlled mode**: Pass a [progress] value (0.0 to 1.0).
/// - **Auto mode**: Pass a [duration] and the widget animates internally.
///
/// Acessibilidade: indicador visual. Onde o progresso/carregamento precisar ser
/// anunciado, envolva com `AppSemantics.liveRegion` + um rótulo.
///
/// Cores default: preenchimento `focusRing`, trilho `surfaceContainer` (mesma
/// regra dos demais loadings). As pontas seguem o radius (reto → quadradas).
///
/// Example (controlled):
/// ```dart
/// AppBorderProgress(
///   progress: 0.5,
///   borderRadius: theme.radiusTheme.resolve(),
///   child: MyWidget(),
/// )
/// ```
///
/// Example (auto):
/// ```dart
/// AppBorderProgress(
///   duration: Duration(seconds: 15),
///   repeat: true,
///   borderRadius: theme.radiusTheme.resolve(),
///   child: MyWidget(),
/// )
/// ```
final class AppBorderProgress extends StatefulWidget {
  const AppBorderProgress({
    required this.child,
    this.progress,
    this.duration,
    this.color,
    this.backgroundColor,
    this.strokeWidth = AppStrokes.l,
    this.borderRadius = BorderRadius.zero,
    this.onComplete,
    this.repeat = false,
    super.key,
  }) : assert(
         progress != null || duration != null,
         'Either progress or duration must be provided',
       ),
       assert(
         progress == null || duration == null,
         'Cannot provide both progress and duration',
       );

  /// The child widget to wrap.
  final Widget child;

  /// The progress value (0.0 to 1.0) for controlled mode.
  final double? progress;

  /// The duration for auto mode animation.
  final Duration? duration;

  /// The color of the progress border.
  ///
  /// Defaults to `focusRing` (acento resolvido p/ contrastar com a surface).
  final Color? color;

  /// The background color of the full border track.
  ///
  /// Defaults to `surfaceContainer` (trilho perceptível). Passe uma cor
  /// transparente para ocultar o trilho.
  final Color? backgroundColor;

  /// The stroke width of the border.
  ///
  /// Defaults to [AppStrokes.l].
  final double strokeWidth;

  /// The border radius of the progress border.
  ///
  /// Defaults to [BorderRadius.zero].
  final BorderRadiusGeometry borderRadius;

  /// Called when the auto animation completes a cycle.
  final VoidCallback? onComplete;

  /// Whether the auto animation should repeat.
  ///
  /// Defaults to false.
  final bool repeat;

  @override
  State<AppBorderProgress> createState() => _AppBorderProgressState();
}

class _AppBorderProgressState extends State<AppBorderProgress>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  bool get _isAutoMode => widget.duration != null;

  @override
  void initState() {
    super.initState();
    _setupController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotion();
  }

  @override
  void didUpdateWidget(AppBorderProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration ||
        oldWidget.repeat != widget.repeat) {
      _controller?.dispose();
      _controller = null;
      _setupController();
      _syncMotion();
    }
  }

  void _setupController() {
    if (!_isAutoMode) return;

    _controller = AnimationController(duration: widget.duration, vsync: this);

    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });
  }

  void _syncMotion() {
    final controller = _controller;
    if (controller == null) return;
    if (AppMotion.enabled(context)) {
      if (!controller.isAnimating) {
        if (widget.repeat) {
          controller.repeat();
        } else {
          controller.forward();
        }
      }
    } else {
      // Reduce-motion: mostra o estado final (borda completa) sem animar.
      controller
        ..stop()
        ..value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final resolvedRadius = widget.borderRadius.resolve(
      Directionality.of(context),
    );
    // Mesma regra dos demais loadings: fill = `focusRing` (acento resolvido p/
    // contrastar com a surface; o `primary` base sumia no dark), trilho =
    // `surfaceContainer` (passo de tom perceptível).
    final effectiveColor = widget.color ?? theme.colorTheme.focusRing;
    final effectiveBackground =
        widget.backgroundColor ?? theme.colorTheme.surfaceContainer;

    Widget buildPaint(double effectiveProgress) {
      return CustomPaint(
        foregroundPainter: _AppBorderProgressPainter(
          progress: effectiveProgress,
          color: effectiveColor,
          backgroundColor: effectiveBackground,
          strokeWidth: widget.strokeWidth,
          borderRadius: resolvedRadius,
          // Pontas seguem o radius: cantos arredondados → pontas arredondadas;
          // reto (radius 0) → pontas quadradas.
          roundCap: resolvedRadius.topLeft.x > 0,
        ),
        child: widget.child,
      );
    }

    if (_isAutoMode) {
      return AnimatedBuilder(
        animation: _controller!,
        builder: (context, _) => buildPaint(_controller!.value),
      );
    }

    return buildPaint(widget.progress!.clamp(0.0, 1.0));
  }
}

/// Painter that draws a rounded rectangle border progress starting from
/// the bottom center, going clockwise.
class _AppBorderProgressPainter extends CustomPainter {
  const _AppBorderProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
    required this.borderRadius,
    required this.roundCap,
    this.backgroundColor,
  });

  final double progress;
  final Color color;
  final Color? backgroundColor;
  final double strokeWidth;
  final BorderRadius borderRadius;

  /// Pontas do traço arredondadas (segue o radius; reto → quadradas).
  final bool roundCap;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0) {
      if (backgroundColor != null) {
        _drawPath(canvas, size, _buildFullPath(size), backgroundColor!);
      }
      return;
    }

    final fullPath = _buildFullPath(size);

    if (backgroundColor != null) {
      _drawPath(canvas, size, fullPath, backgroundColor!);
    }

    final metric = fullPath.computeMetrics().firstOrNull;
    if (metric == null) return;

    final drawLength = metric.length * progress.clamp(0.0, 1.0);
    final extractedPath = metric.extractPath(0, drawLength);

    _drawPath(canvas, size, extractedPath, color);
  }

  void _drawPath(Canvas canvas, Size size, Path path, Color drawColor) {
    final paint = Paint()
      ..color = drawColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = roundCap ? StrokeCap.round : StrokeCap.butt;

    canvas.drawPath(path, paint);
  }

  Path _buildFullPath(Size size) {
    final halfStroke = strokeWidth / 2;
    // Inset por `halfStroke`: a aresta EXTERNA do traço fica rente à borda do
    // child (traço todo por dentro, crescendo para dentro — sem folga que
    // pareça uma borda dupla). O raio recua `halfStroke`, mantendo os cantos
    // do traço CONCÊNTRICOS com os do child.
    final rect = Rect.fromLTWH(
      halfStroke,
      halfStroke,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    final maxRadius = min(rect.width, rect.height) / 2;
    double corner(double childRadius) =>
        (childRadius - halfStroke).clamp(0.0, maxRadius);
    final tlRadius = corner(borderRadius.topLeft.x);
    final trRadius = corner(borderRadius.topRight.x);
    final brRadius = corner(borderRadius.bottomRight.x);
    final blRadius = corner(borderRadius.bottomLeft.x);

    final left = rect.left;
    final top = rect.top;
    final right = rect.right;
    final bottom = rect.bottom;
    final centerX = rect.center.dx;

    final path = Path();

    // Start from bottom center, go clockwise (right).
    path.moveTo(centerX, bottom);

    // Bottom edge: center to bottom-right corner.
    path.lineTo(right - brRadius, bottom);

    // Bottom-right corner arc.
    if (brRadius > 0) {
      path.arcToPoint(
        Offset(right, bottom - brRadius),
        radius: Radius.circular(brRadius),
        clockwise: false,
      );
    }

    // Right edge: bottom to top.
    path.lineTo(right, top + trRadius);

    // Top-right corner arc.
    if (trRadius > 0) {
      path.arcToPoint(
        Offset(right - trRadius, top),
        radius: Radius.circular(trRadius),
        clockwise: false,
      );
    }

    // Top edge: right to left.
    path.lineTo(left + tlRadius, top);

    // Top-left corner arc.
    if (tlRadius > 0) {
      path.arcToPoint(
        Offset(left, top + tlRadius),
        radius: Radius.circular(tlRadius),
        clockwise: false,
      );
    }

    // Left edge: top to bottom.
    path.lineTo(left, bottom - blRadius);

    // Bottom-left corner arc.
    if (blRadius > 0) {
      path.arcToPoint(
        Offset(left + blRadius, bottom),
        radius: Radius.circular(blRadius),
        clockwise: false,
      );
    }

    // Bottom edge: bottom-left corner to center.
    path.lineTo(centerX, bottom);

    return path;
  }

  @override
  bool shouldRepaint(_AppBorderProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.roundCap != roundCap;
  }
}
