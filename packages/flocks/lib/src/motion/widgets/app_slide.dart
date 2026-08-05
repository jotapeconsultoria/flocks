import 'package:flutter/widgets.dart';

import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../app_motion.dart';

/// Translada o filho (entrada/saída pelas bordas) quando [offset] muda.
///
/// [offset] é em múltiplos do tamanho do filho (igual a `AnimatedSlide`): ex.:
/// `Offset(0, 0.1)` desliza 10% da altura para baixo. Respeita reduce-motion /
/// o global do DS. Compõe com [AppFade] para "slide + fade".
class AppSlide extends StatelessWidget {
  /// Cria um [AppSlide].
  const AppSlide({
    required this.child,
    this.offset = Offset.zero,
    this.duration = AppDurations.normal,
    this.curve = AppCurves.decelerate,
    super.key,
  });

  /// Conteúdo.
  final Widget child;

  /// Deslocamento em múltiplos do tamanho do filho.
  final Offset offset;

  /// Duração (colapsa para zero sob reduce-motion / global off).
  final Duration duration;

  /// Curva da transição.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: offset,
      duration: AppMotion.resolve(context, duration),
      curve: curve,
      child: child,
    );
  }
}
