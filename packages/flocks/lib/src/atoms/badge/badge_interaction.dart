import 'package:flutter/widgets.dart';

import '../../tokens/tokens.dart';

/// Micro-animação de hover/press aplicada a um [AppBadge] clicável.
enum AppBadgeEffect {
  /// Sem escala — só o cursor de clique e o realce de hover.
  none,

  /// Encolhe ao pressionar (feedback de clique).
  scale,

  /// Cresce no hover e recua um pouco ao pressionar (destaque).
  lift,
}

/// Resolução visual de um conjunto de estados de interação de um badge:
/// a escala, o realce translúcido (overlay) e a sombra de "lift" (arraste).
///
/// - `scale`: fator de escala aplicado ao badge.
/// - `overlay`: cor translúcida sobreposta (hover/press/focus/dragged) ou `null`.
/// - `liftShadow`: sombra elevada exibida enquanto arrastado, ou `null`.
typedef BadgeInteraction = ({
  double scale,
  Color? overlay,
  List<BoxShadow>? liftShadow,
});

/// Função **pura** que mapeia `states` + [effect] para o visual de interação de
/// um badge. Sem dependência de `BuildContext` — testável diretamente (espelha
/// `resolveAvatarInteraction`).
///
/// Regras:
/// - **Escala** (MOVIMENTO): só quando [motionEnabled] (respeita o liga/desliga
///   global de animações). Ligada: `dragged` eleva para 1.08 (vence qualquer
///   [effect]); senão segue [effect] (`scale` encolhe no press; `lift` cresce no
///   hover / recua no press). Desligada: 1.0 (sem escala) — a escala é uma
///   micro-animação e não deve ocorrer com as animações desligadas.
/// - **Overlay** (estado, não movimento — permanece com animações off): escada de
///   prioridade única (nunca soma) — `pressed` 0.12 › `dragged` 0.10 ›
///   (`hovered` ou `focused`) 0.08 › nenhum. Assim o realce de foco existe além
///   do anel, sem dobrar com o hover.
/// - **liftShadow** (estado, não movimento — permanece com animações off): só
///   quando arrastado; usa a sombra canônica do DS
///   ([AppElevation.symmetricShadows]), theme-aware por [isDark].
BadgeInteraction resolveBadgeInteraction({
  required Set<WidgetState> states,
  required AppBadgeEffect effect,
  required Color onSurface,
  required bool isDark,
  required bool motionEnabled,
}) {
  final bool pressed = states.contains(WidgetState.pressed);
  final bool hovered = states.contains(WidgetState.hovered);
  final bool focused = states.contains(WidgetState.focused);
  final bool dragged = states.contains(WidgetState.dragged);

  final double scale = !motionEnabled
      ? 1.0
      : dragged
      ? 1.08
      : switch (effect) {
          AppBadgeEffect.none => 1.0,
          AppBadgeEffect.scale => pressed ? 0.94 : 1.0,
          AppBadgeEffect.lift =>
            pressed
                ? 1.02
                : hovered
                ? 1.06
                : 1.0,
        };

  final double? alpha = pressed
      ? 0.12
      : dragged
      ? 0.10
      : (hovered || focused)
      ? 0.08
      : null;
  final Color? overlay = alpha == null
      ? null
      : onSurface.withValues(alpha: alpha);

  final List<BoxShadow>? liftShadow = dragged
      ? AppElevation.symmetricShadows(isDark)
      : null;

  return (scale: scale, overlay: overlay, liftShadow: liftShadow);
}
