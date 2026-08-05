import 'package:flutter/widgets.dart';

import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../app_motion.dart';

/// Rotação animada (implícita) que respeita reduce-motion.
///
/// Substitui os `AnimatedRotation` de chevron duplicados pelo design system
/// (dropdowns, color picker, expansion tiles).
class AppAnimatedRotation extends StatelessWidget {
  /// Cria um [AppAnimatedRotation].
  const AppAnimatedRotation({
    required this.turns,
    required this.child,
    this.duration = AppDurations.normal,
    this.curve = AppCurves.standard,
    this.alignment = Alignment.center,
    super.key,
  });

  /// Quantidade de voltas (1.0 = 360°).
  final double turns;

  /// Conteúdo rotacionado.
  final Widget child;

  /// Duração da transição (colapsa para zero sob reduce-motion).
  final Duration duration;

  /// Curva da transição.
  final Curve curve;

  /// Alinhamento do eixo de rotação.
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: turns,
      duration: AppMotion.resolve(context, duration),
      curve: curve,
      alignment: alignment,
      child: child,
    );
  }
}
