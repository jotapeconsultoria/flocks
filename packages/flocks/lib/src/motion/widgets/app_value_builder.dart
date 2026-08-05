import 'package:flutter/widgets.dart';

import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../app_motion.dart';

/// Anima um `double` até [value] e entrega o valor interpolado a [builder].
///
/// Primitivo genérico de motion — base para "desenhar/preencher/varrer" (ex.:
/// o traço do checkmark, uma barra que preenche, um ângulo que varre). No
/// primeiro build fica em [value] (sem animação); quando [value] muda, anima do
/// valor anterior até o novo. Respeita reduce-motion / o global do DS: com
/// motion desligado, salta direto para [value].
class AppValueBuilder extends StatelessWidget {
  /// Cria um [AppValueBuilder].
  const AppValueBuilder({
    required this.value,
    required this.builder,
    this.duration = AppDurations.normal,
    this.curve = AppCurves.standard,
    this.child,
    super.key,
  });

  /// Valor alvo.
  final double value;

  /// Constrói a partir do valor interpolado atual (e do [child] opcional).
  final ValueWidgetBuilder<double> builder;

  /// Duração (colapsa para zero sob reduce-motion / global off).
  final Duration duration;

  /// Curva da interpolação.
  final Curve curve;

  /// Subárvore constante repassada ao [builder] (otimização).
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: value),
      duration: AppMotion.resolve(context, duration),
      curve: curve,
      builder: builder,
      child: child,
    );
  }
}
