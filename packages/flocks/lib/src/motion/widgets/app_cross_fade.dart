import 'package:flutter/widgets.dart';

import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../app_motion.dart';

/// Troca de conteúdo com **cross-fade** (o antigo some, o novo aparece).
///
/// Troque a `key` (ou o tipo) do [child] para disparar a transição — ex.:
/// spinner→imagem, placeholder→conteúdo. Respeita reduce-motion / o global do
/// DS (troca instantânea quando desligado).
class AppCrossFade extends StatelessWidget {
  /// Cria um [AppCrossFade].
  const AppCrossFade({
    required this.child,
    this.duration = AppDurations.normal,
    this.curve = AppCurves.standard,
    this.alignment = Alignment.center,
    super.key,
  });

  /// Filho atual — a troca de `key`/tipo dispara o cross-fade.
  final Widget child;

  /// Duração (colapsa para zero sob reduce-motion / global off).
  final Duration duration;

  /// Curva de entrada e saída.
  final Curve curve;

  /// Alinhamento durante a sobreposição.
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppMotion.resolve(context, duration),
      switchInCurve: curve,
      switchOutCurve: curve,
      layoutBuilder: (currentChild, previousChildren) => Stack(
        alignment: alignment,
        children: <Widget>[...previousChildren, ?currentChild],
      ),
      child: child,
    );
  }
}
