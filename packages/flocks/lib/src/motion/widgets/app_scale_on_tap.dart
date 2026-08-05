import 'package:flutter/widgets.dart';

import '../../foundation/foundation.dart';
import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../app_motion.dart';

/// Embrulho que aplica uma leve escala ao pressionar, integrando a
/// micro-interação de press ao primitivo [FlocksInteraction] (foco/teclado/
/// hover incluídos). Respeita reduce-motion.
class AppScaleOnTap extends StatelessWidget {
  /// Cria um [AppScaleOnTap].
  const AppScaleOnTap({
    required this.child,
    this.onPressed,
    this.enabled = true,
    this.scale = 0.96,
    this.duration = AppDurations.fast,
    super.key,
  });

  /// Conteúdo pressionável.
  final Widget child;

  /// Acionado por tap/click e por Enter/Space quando focado.
  final VoidCallback? onPressed;

  /// Se está habilitado.
  final bool enabled;

  /// Escala aplicada enquanto pressionado.
  final double scale;

  /// Duração da transição de escala.
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return FlocksInteraction(
      onPressed: onPressed,
      enabled: enabled,
      builder: (BuildContext context, Set<WidgetState> states) {
        final bool pressed = states.contains(WidgetState.pressed);
        return AnimatedScale(
          scale: pressed ? scale : 1.0,
          duration: AppMotion.resolve(context, duration),
          curve: AppCurves.standard,
          child: child,
        );
      },
    );
  }
}
