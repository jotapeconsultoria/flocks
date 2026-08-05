import 'package:flutter/widgets.dart';

import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import 'app_value_builder.dart';

/// Escala animada com **overshoot contido** — o "pop"/bounce das micro-
/// interações (checkbox, radio, tooltip).
///
/// Anima a escala do filho quando o alvo muda (ex.: 0→1 ao aparecer, com um
/// leve passar-do-ponto e assentar via [AppCurves.emphasizedOvershoot]). O
/// overshoot para baixo é **clampado em 0** (nunca inverte/espelha ao encolher),
/// então é seguro nos dois sentidos. Respeita reduce-motion / o global do DS.
///
/// Compõe [AppValueBuilder] — demonstra a filosofia de motions combináveis.
class AppPop extends StatelessWidget {
  /// Cria um [AppPop].
  const AppPop({
    required this.child,
    this.visible = true,
    this.scale,
    this.duration = AppDurations.normal,
    this.curve = AppCurves.emphasizedOvershoot,
    this.alignment = Alignment.center,
    super.key,
  });

  /// Conteúdo.
  final Widget child;

  /// Atalho booleano: `true` → escala 1, `false` → 0. Ignorado quando [scale]
  /// é informado.
  final bool visible;

  /// Escala alvo. Sobrepõe [visible] quando não-nulo.
  final double? scale;

  /// Duração (colapsa para zero sob reduce-motion / global off).
  final Duration duration;

  /// Curva — default overshoot contido (o "bounce").
  final Curve curve;

  /// Ponto de ancoragem da escala.
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final double target = scale ?? (visible ? 1.0 : 0.0);
    return AppValueBuilder(
      value: target,
      duration: duration,
      curve: curve,
      child: child,
      builder: (context, v, child) => Transform.scale(
        scale: v < 0 ? 0.0 : v,
        alignment: alignment,
        child: child,
      ),
    );
  }
}
