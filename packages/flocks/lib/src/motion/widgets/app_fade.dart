import 'package:flutter/widgets.dart';

import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../app_motion.dart';

/// Opacidade animada (implícita) que respeita reduce-motion / o global do DS.
///
/// Aparecer/sumir suave. Com motion desligado, salta direto para a opacidade
/// alvo. Compõe com [AppPop]/[AppSlide] por aninhamento.
class AppFade extends StatelessWidget {
  /// Cria um [AppFade].
  const AppFade({
    required this.child,
    this.visible = true,
    this.opacity,
    this.duration = AppDurations.normal,
    this.curve = AppCurves.standard,
    super.key,
  });

  /// Conteúdo.
  final Widget child;

  /// Atalho booleano: `true` → opacidade 1, `false` → 0. Ignorado quando
  /// [opacity] é informado.
  final bool visible;

  /// Opacidade alvo (0–1). Sobrepõe [visible] quando não-nulo.
  final double? opacity;

  /// Duração (colapsa para zero sob reduce-motion / global off).
  final Duration duration;

  /// Curva da transição.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity ?? (visible ? 1.0 : 0.0),
      duration: AppMotion.resolve(context, duration),
      curve: curve,
      child: child,
    );
  }
}
