import 'dart:math';

import 'package:flutter/widgets.dart';

import '../../tokens/app_durations.dart';
import '../app_motion.dart';

/// Mixin para disparar um "shake" horizontal (ex.: erro de validação em um
/// campo). Requer [TickerProviderStateMixin].
///
/// Uso:
/// ```dart
/// class _MyState extends State<MyWidget>
///     with TickerProviderStateMixin<MyWidget>, AppShakeMixin<MyWidget> {
///   @override
///   Widget build(BuildContext context) =>
///       buildShake(child: /* ... */);
///   // chame shake() quando quiser disparar (ex.: no erro).
/// }
/// ```
mixin AppShakeMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  /// Controlador do shake. Exposto para composição avançada.
  late final AnimationController shakeController = AnimationController(
    vsync: this,
    duration: AppDurations.medium,
  );

  @override
  void dispose() {
    shakeController.dispose();
    super.dispose();
  }

  /// Dispara o shake do início. No-op sob reduce-motion.
  void shake() {
    if (AppMotion.enabled(context)) {
      shakeController.forward(from: 0);
    }
  }

  /// Embrulha [child] aplicando o deslocamento horizontal do shake.
  Widget buildShake({required Widget child}) {
    return AnimatedBuilder(
      animation: shakeController,
      builder: (BuildContext context, Widget? inner) {
        final double t = shakeController.value;
        final double dx = t == 0 ? 0.0 : sin(t * pi * 4) * 8.0 * (1 - t);
        return Transform.translate(offset: Offset(dx, 0), child: inner);
      },
      child: child,
    );
  }
}
