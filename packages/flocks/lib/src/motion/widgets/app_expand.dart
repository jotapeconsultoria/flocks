import 'package:flutter/widgets.dart';

import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../app_motion.dart';

/// Revela por **tamanho** (expandir/colapsar) quando o filho muda de dimensão.
///
/// Para accordions, painéis colapsáveis e balões que "abrem" até o tamanho do
/// conteúdo. Recorta o excesso durante a transição. Respeita reduce-motion / o
/// global do DS.
class AppExpand extends StatelessWidget {
  /// Cria um [AppExpand].
  const AppExpand({
    required this.child,
    this.duration = AppDurations.medium,
    this.curve = AppCurves.standard,
    this.alignment = Alignment.topCenter,
    super.key,
  });

  /// Conteúdo cujo tamanho é animado.
  final Widget child;

  /// Duração (colapsa para zero sob reduce-motion / global off).
  final Duration duration;

  /// Curva da transição.
  final Curve curve;

  /// Ancoragem enquanto cresce/encolhe.
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: AppMotion.resolve(context, duration),
      curve: curve,
      alignment: alignment,
      child: child,
    );
  }
}
