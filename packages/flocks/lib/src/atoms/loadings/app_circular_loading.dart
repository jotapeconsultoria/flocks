import 'dart:math';

import 'package:flutter/widgets.dart';

import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// The App Circular Loading widget — anel de progresso.
///
/// **Indeterminado** por padrão: gira continuamente via [AppSpin] — respeita
/// reduce-motion (fica estático) e pausa fora de tela (TickerMode). Informe
/// [value] (0..1) para o modo **determinado**: o arco preenche `value` da volta
/// e não gira.
///
/// Acessibilidade: é um indicador visual. Onde o carregamento precisar ser
/// anunciado, envolva com `AppSemantics.liveRegion` + um rótulo (ex.:
/// "Carregando…").
///
/// Example:
/// ```dart
/// AppCircularLoading(size: AppSizes.s32)   // indeterminado
/// AppCircularLoading(size: 32, value: 0.7) // 70%
/// ```
final class AppCircularLoading extends StatelessWidget {
  const AppCircularLoading({
    this.backgroundColor,
    this.color,
    this.size = AppSizes.s16,
    this.stroke = AppStrokes.xl,
    this.value,
    super.key,
  }) : assert(
         value == null || (value >= 0 && value <= 1),
         'value deve estar entre 0 e 1',
       );

  /// Cor do trilho (arco de fundo). Default `surfaceContainer` — passo de tom
  /// perceptível sobre a `surface` (o `surface` sumia no dark).
  final Color? backgroundColor;

  /// Cor do arco de progresso. Default `focusRing` — acento primário resolvido
  /// para contrastar ≥3:1 com a superfície (o `primary` base é escuro demais
  /// como acento sobre a surface escura).
  final Color? color;

  /// The size of the loading. Defaults to [AppSizes.s16].
  final double size;

  /// The stroke width of the loading indicator. Defaults to [AppStrokes.xl].
  final double stroke;

  /// Progresso 0..1. `null` (padrão) = indeterminado (gira); definido =
  /// determinado (arco estático de `value` da volta).
  final double? value;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    // Indeterminado usa 3/4 de volta girando; determinado usa `value` da volta.
    final double sweep = value == null ? pi * 1.5 : pi * 2 * value!;
    final Widget painter = CustomPaint(
      painter: _AppCircularLoadingPainter(
        color: color ?? theme.colorTheme.focusRing,
        // Trilho (anel de fundo) sempre presente — dá o "total" tanto no
        // spinner quanto no modo determinado.
        backgroundColor: backgroundColor ?? theme.colorTheme.surfaceContainer,
        strokeWidth: stroke,
        sweep: sweep,
        // Pontas do arco seguem o radius global (modo reto → quadradas).
        roundCap: theme.radiusTheme.mode != AppRadiusMode.reto,
      ),
    );

    return SizedBox(
      height: size,
      width: size,
      child: value == null
          ? AppSpin(period: AppDurations.loop, child: painter)
          : painter,
    );
  }
}

/// The painter for the circular loading.
class _AppCircularLoadingPainter extends CustomPainter {
  const _AppCircularLoadingPainter({
    required this.backgroundColor,
    required this.color,
    required this.strokeWidth,
    required this.sweep,
    required this.roundCap,
  });

  final Color backgroundColor;
  final Color color;
  final double strokeWidth;

  /// Ângulo varrido pelo arco (radianos), a partir do topo (-pi/2).
  final double sweep;

  /// Pontas do arco arredondadas (segue o radius; reto → quadradas).
  final bool roundCap;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) - strokeWidth) / 2;

    if (backgroundColor.a != 0) {
      final backgroundPaint = Paint()
        ..color = backgroundColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, radius, backgroundPaint);
    }

    final foregroundPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = roundCap ? StrokeCap.round : StrokeCap.butt;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweep,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(_AppCircularLoadingPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.sweep != sweep ||
        oldDelegate.roundCap != roundCap;
  }
}
