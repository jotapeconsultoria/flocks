import 'package:flutter/widgets.dart';

import '../../foundation/foundation.dart';
import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../app_motion.dart';

/// Gatilho de interação que dispara a micro-animação de [AppInteractiveMotion].
enum AppMotionTrigger {
  /// Ao passar o mouse (hover).
  hover,

  /// Ao focar por teclado (Tab).
  focus,

  /// Ao pressionar/clicar (ou Enter/Space quando focado).
  press,
}

/// Aplica escala e/ou rotação a [child] enquanto o gatilho [trigger] está ativo,
/// animando de volta ao repouso quando ele sai.
///
/// Reúne hover, foco (Tab) e press sobre o primitivo [FlocksInteraction] e
/// respeita reduce-motion via [AppMotion] (a transição colapsa para instantânea).
///
/// Como hover/foco só são reportados quando o elemento é interativo, forneça um
/// [onPressed] (pode ser um no-op `() {}`) ao usar [AppMotionTrigger.hover] ou
/// [AppMotionTrigger.focus].
///
/// - [scale]: `1.0` = sem escala; `> 1` aumenta ("up"), `< 1` diminui ("down").
/// - [turns]: `1.0` = 360°; positivo = horário ("right"), negativo =
///   anti-horário ("left").
///
/// Exemplo:
/// ```dart
/// AppInteractiveMotion(
///   trigger: AppMotionTrigger.hover,
///   scale: 1.08,
///   onPressed: () {},
///   child: card,
/// )
/// ```
class AppInteractiveMotion extends StatelessWidget {
  /// Cria um [AppInteractiveMotion].
  const AppInteractiveMotion({
    required this.child,
    this.trigger = AppMotionTrigger.hover,
    this.scale = 1.0,
    this.turns = 0.0,
    this.onPressed,
    this.enabled = true,
    this.duration = AppDurations.fast,
    this.curve = AppCurves.standard,
    this.alignment = Alignment.center,
    this.focusNode,
    super.key,
  });

  /// Conteúdo animado.
  final Widget child;

  /// Gatilho de interação que ativa a animação.
  final AppMotionTrigger trigger;

  /// Escala-alvo quando ativo (`1.0` = sem escala).
  final double scale;

  /// Voltas-alvo quando ativo (`1.0` = 360°; negativo = anti-horário).
  final double turns;

  /// Acionado por tap/click e por Enter/Space quando focado. Necessário (mesmo
  /// como no-op) para os gatilhos [AppMotionTrigger.hover]/[AppMotionTrigger.focus].
  final VoidCallback? onPressed;

  /// Se está habilitado.
  final bool enabled;

  /// Duração da transição (colapsa para zero sob reduce-motion).
  final Duration duration;

  /// Curva da transição.
  final Curve curve;

  /// Alinhamento do eixo de escala/rotação.
  final Alignment alignment;

  /// Nó de foco externo (opcional).
  final FocusNode? focusNode;

  bool _isActive(Set<WidgetState> states) => switch (trigger) {
    AppMotionTrigger.hover => states.contains(WidgetState.hovered),
    AppMotionTrigger.focus => states.contains(WidgetState.focused),
    AppMotionTrigger.press => states.contains(WidgetState.pressed),
  };

  @override
  Widget build(BuildContext context) {
    return FlocksInteraction(
      onPressed: onPressed,
      enabled: enabled,
      focusNode: focusNode,
      builder: (BuildContext context, Set<WidgetState> states) {
        final bool active = _isActive(states);
        final Duration resolved = AppMotion.resolve(context, duration);
        return AnimatedScale(
          scale: active ? scale : 1.0,
          duration: resolved,
          curve: curve,
          alignment: alignment,
          child: AnimatedRotation(
            turns: active ? turns : 0.0,
            duration: resolved,
            curve: curve,
            alignment: alignment,
            child: child,
          ),
        );
      },
    );
  }
}
