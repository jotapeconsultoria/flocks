import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// The App Linear Loading widget — barra de progresso linear.
///
/// **Indeterminada** por padrão (anima via controller; sob reduce-motion fica
/// estática, sem travar `pumpAndSettle`). Informe [value] (0..1) para o modo
/// **determinado**: a barra preenche `value` da largura, sem animação.
///
/// Example:
/// ```dart
/// AppLinearLoading()            // indeterminada
/// AppLinearLoading(value: 0.7)  // 70%
/// ```
final class AppLinearLoading extends StatefulWidget {
  const AppLinearLoading({
    this.backgroundColor,
    this.color,
    this.height = AppSizes.s4,
    this.value,
    super.key,
  }) : assert(
         value == null || (value >= 0 && value <= 1),
         'value deve estar entre 0 e 1',
       );

  /// Cor do trilho (parte não preenchida). Default `surfaceContainer` — um passo
  /// de tom perceptível sobre a `surface` (o `surface` sumia no dark).
  final Color? backgroundColor;

  /// Cor do preenchimento. Default `focusRing` — o acento primário do DS
  /// resolvido por brilho para contrastar ≥3:1 com a superfície (o `primary`
  /// base é escuro demais como acento sobre a surface escura).
  final Color? color;

  /// The minimum height of the loading indicator. Defaults to [AppSizes.s4].
  final double height;

  /// Progresso 0..1. Quando `null` (padrão), a barra é **indeterminada**
  /// (animada); quando definido, é **determinada** (estática, preenche `value`).
  final double? value;

  @override
  State<AppLinearLoading> createState() => _AppLinearLoadingState();
}

class _AppLinearLoadingState extends State<AppLinearLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.loopSlow,
  );

  void _sync() {
    // Só anima no modo indeterminado e com motion habilitado.
    if (widget.value == null && AppMotion.enabled(context)) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      _controller
        ..stop()
        ..value = 0.5;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(AppLinearLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) _sync();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _AppLinearLoadingPainter(
                backgroundColor:
                    widget.backgroundColor ?? theme.colorTheme.surfaceContainer,
                color: widget.color ?? theme.colorTheme.focusRing,
                animationValue: _controller.value,
                value: widget.value,
                // Cantos arredondados seguindo o radius global (clampado à
                // altura → pill em barras finas, reto quando o radius é 0).
                cornerRadius: theme.radiusTheme.resolveRadius(),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// The painter for the linear loading.
class _AppLinearLoadingPainter extends CustomPainter {
  const _AppLinearLoadingPainter({
    required this.backgroundColor,
    required this.color,
    required this.animationValue,
    required this.cornerRadius,
    this.value,
  });

  final Color backgroundColor;
  final Color color;
  final double animationValue;
  final double cornerRadius;
  final double? value;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final double radius = cornerRadius < size.height / 2
        ? cornerRadius
        : size.height / 2;
    RRect rr(Rect r) => RRect.fromRectAndRadius(r, Radius.circular(radius));

    // Trilho.
    paint.color = backgroundColor;
    canvas.drawRRect(rr(Rect.fromLTWH(0, 0, size.width, size.height)), paint);

    paint.color = color;

    if (value != null) {
      // Determinado: preenche `value` da largura, da esquerda.
      final double w = (size.width * value!).clamp(0.0, size.width);
      if (w > 0) {
        canvas.drawRRect(rr(Rect.fromLTWH(0, 0, w, size.height)), paint);
      }
      return;
    }

    // Indeterminado: barra deslizante, recortada ao trilho arredondado.
    canvas.save();
    canvas.clipRRect(rr(Rect.fromLTWH(0, 0, size.width, size.height)));
    final barWidth = size.width * 0.4;
    final startX = lerpDouble(-barWidth, size.width, animationValue)!;
    canvas.drawRRect(
      rr(Rect.fromLTWH(startX, 0, barWidth, size.height)),
      paint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_AppLinearLoadingPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.color != color ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.cornerRadius != cornerRadius ||
        oldDelegate.value != value;
  }
}
