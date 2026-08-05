import 'package:flutter/widgets.dart';

import '../../atoms/loadings/app_circular_loading.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../foundation/flocks_interaction.dart';
import '../../motion/app_motion.dart';
import '../../theme/theme.dart';
import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../../tokens/app_sizes.dart';
import '../../tokens/app_strokes.dart';
import '../tooltip/tooltip.dart';

/// Opacidade do [AppInteraction.child] quando `enabled: false` — dá o "muted"
/// de desabilitado sobre qualquer conteúdo (texto, ícone, card).
// TODO(flocks): tokenizar como AppOpacities.disabled quando existir.
const double _kDisabledOpacity = 0.38;

/// Micro-animação pré-setada aplicada por [AppInteraction] em hover/press.
///
/// Reusa o vocabulário de motion já existente no flocks: a curva de bounce do
/// `AppPop` ([AppCurves.emphasizedOvershoot]) e o modelo escala+rotação do
/// `AppInteractiveMotion`.
enum AppMotionPreset {
  /// Sem escala — só o realce de fundo (e o tooltip, se houver).
  none,

  /// Encolhe ao pressionar (feedback de clique — jeito "ícone de app").
  scale,

  /// Cresce no hover e recua um pouco ao pressionar (destaque).
  lift,

  /// Encolhe ao pressionar e volta com um leve overshoot (bounce) — mesma curva
  /// `emphasizedOvershoot` do `AppPop`.
  pop,

  /// Gira de leve (~14°) no hover/press, com um pequeno recuo de escala — reusa
  /// o modelo escala+rotação do `AppInteractiveMotion`.
  rotate,
}

/// Envolve **qualquer** widget com o comportamento de interação padrão do
/// Flocks — como o `InkWell` do Material, mas sobre a camada `widgets` e
/// dirigido por tokens.
///
/// Junta, num só wrapper reusável:
/// - **Gestos**: [onTap], [onDoubleTap], [onLongPress] (via [FlocksInteraction]).
/// - **Estados**: hover, foco (Tab, com anel de foco), pressed, disabled +
///   ativação por teclado (Enter/Space) e cursor de clique.
/// - **Realce de fundo** ([highlight]): overlay translúcido de `onSurface` que
///   surge no hover/press, com raio de [radius] (default: radius global).
/// - **Motion** ([motion]): uma micro-animação pré-setada ([AppMotionPreset])
///   que respeita o toggle global de animação e o reduce-motion (via
///   [AppMotion]).
/// - **Loading** ([loading]): bloqueia a interação e sobrepõe um spinner ao
///   [child] (renderizado invisível para preservar o tamanho).
/// - **Disabled**: quando `enabled: false`, esmaece o [child].
/// - **Tooltip** opcional ([tooltip]): mostra um [AppTooltip] no hover/foco.
///
/// Serve para tornar clicável um ícone, um texto, um card — sem reimplementar
/// hover/press/foco. É o substituto dos antigos `AppTextButton`/`AppIconButton`
/// ("texto clicável"/"ícone clicável"); a cor e o tamanho vêm do próprio
/// [child] (um [AppText]/[AppIcon] com a cor do papel). Para uma ação primária
/// com fundo, use `AppButton`.
///
/// ```dart
/// AppInteraction(
///   tooltip: 'Adicionar',
///   onTap: add,
///   padding: const EdgeInsets.all(AppSpacings.s8),
///   child: AppIcon(AppIconToken.plus),
/// )
/// ```
final class AppInteraction extends StatelessWidget {
  /// Cria um [AppInteraction] em torno de [child].
  const AppInteraction({
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.tooltip,
    this.tooltipPosition = AppTooltipPosition.top,
    this.motion = AppMotionPreset.scale,
    this.highlight = true,
    this.radius,
    this.padding = EdgeInsets.zero,
    this.enabled = true,
    this.loading = false,
    this.loadingSize = AppSizes.s24,
    this.mouseCursor,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    super.key,
  });

  /// Conteúdo tornado interativo (ícone, texto, card…).
  final Widget child;

  /// Acionado por tap/click e por Enter/Space quando focado.
  final VoidCallback? onTap;

  /// Acionado por double-tap/duplo-clique (opcional).
  final VoidCallback? onDoubleTap;

  /// Acionado por long-press (opcional).
  final VoidCallback? onLongPress;

  /// Texto do tooltip mostrado no hover/foco. `null` = sem tooltip.
  final String? tooltip;

  /// Posição do tooltip em relação ao [child].
  final AppTooltipPosition tooltipPosition;

  /// Micro-animação de hover/press. Default [AppMotionPreset.scale].
  final AppMotionPreset motion;

  /// Se pinta o realce de fundo translúcido no hover/press. Default `true`.
  final bool highlight;

  /// Raio do realce/anel de foco. Default: radius global (modo redondo).
  final BorderRadius? radius;

  /// Espaço interno entre o realce e o [child] (dê folga para o feel de "botão
  /// de ícone"). Default [EdgeInsets.zero].
  final EdgeInsetsGeometry padding;

  /// Se está habilitado. Quando `false` (ou sem nenhum handler), não reage; o
  /// [child] é esmaecido.
  final bool enabled;

  /// Em loading: bloqueia a interação e mostra um spinner sobre o [child]
  /// (renderizado invisível para preservar o tamanho). Default `false`.
  final bool loading;

  /// Tamanho do spinner mostrado em [loading]. Default [AppSizes.s24].
  final double loadingSize;

  /// Cursor do mouse. Default: clique quando interativo.
  final MouseCursor? mouseCursor;

  /// Rótulo de acessibilidade do alvo (role de botão). `null` deixa a semântica
  /// do [child] descrever o alvo.
  final String? semanticLabel;

  /// Nó de foco externo (opcional).
  final FocusNode? focusNode;

  /// Se recebe foco ao montar.
  final bool autofocus;

  double _scaleFor(Set<WidgetState> states) {
    final bool pressed = states.contains(WidgetState.pressed);
    final bool hovered = states.contains(WidgetState.hovered);
    return switch (motion) {
      AppMotionPreset.none => 1.0,
      AppMotionPreset.scale => pressed ? 0.94 : 1.0,
      AppMotionPreset.lift =>
        pressed
            ? 1.02
            : hovered
            ? 1.06
            : 1.0,
      AppMotionPreset.pop => pressed ? 0.90 : 1.0,
      AppMotionPreset.rotate => pressed ? 0.96 : 1.0,
    };
  }

  /// Voltas (turns) do preset [AppMotionPreset.rotate]; `0` nos demais.
  double _turnsFor(Set<WidgetState> states) {
    if (motion != AppMotionPreset.rotate) return 0;
    final bool active =
        states.contains(WidgetState.pressed) ||
        states.contains(WidgetState.hovered);
    return active ? 0.04 : 0; // ~14°
  }

  /// Curva da micro-animação. [AppMotionPreset.pop] usa o overshoot (bounce);
  /// os demais usam a curva padrão.
  Curve get _motionCurve => motion == AppMotionPreset.pop
      ? AppCurves.emphasizedOvershoot
      : AppCurves.standard;

  /// Apresenta o [child] conforme o estado: spinner em [loading], esmaecido em
  /// disabled, ou cru.
  Widget _presentChild(AppThemeData theme) {
    if (loading) {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Opacity(opacity: 0, child: child),
          AppCircularLoading(
            color: theme.colorTheme.onSurface,
            size: loadingSize,
            stroke: AppStrokes.m,
          ),
        ],
      );
    }
    if (!enabled) return Opacity(opacity: _kDisabledOpacity, child: child);
    return child;
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final bool hasHandler =
        onTap != null || onDoubleTap != null || onLongPress != null;
    final bool interactive = enabled && hasHandler && !loading;
    final BorderRadius r = radius ?? theme.radiusTheme.resolve();

    final Widget core = FlocksInteraction(
      onPressed: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      enabled: interactive,
      focusNode: focusNode,
      autofocus: autofocus,
      mouseCursor: mouseCursor,
      builder: (BuildContext context, Set<WidgetState> states) {
        final bool pressed = states.contains(WidgetState.pressed);
        final bool hovered = states.contains(WidgetState.hovered);
        final bool focused = states.contains(WidgetState.focused);
        final Duration d = AppMotion.resolve(context, AppDurations.fast);
        // Micro-interações (escala/rotação por hover/press) só quando o motion
        // global está ligado; com reduce-motion, ficam no estado neutro.
        final bool motionEnabled = AppMotion.enabled(context);

        final Color overlay = !highlight
            ? const Color(0x00000000)
            : pressed
            ? theme.colorTheme.onSurface.withValues(alpha: 0.12)
            : hovered
            ? theme.colorTheme.onSurface.withValues(alpha: 0.08)
            : const Color(0x00000000);

        final Curve motionCurve = _motionCurve;
        return AnimatedScale(
          scale: motionEnabled ? _scaleFor(states) : 1.0,
          duration: d,
          curve: motionCurve,
          child: AnimatedRotation(
            turns: motionEnabled ? _turnsFor(states) : 0.0,
            duration: d,
            curve: motionCurve,
            child: AnimatedContainer(
              duration: d,
              curve: AppCurves.standard,
              decoration: BoxDecoration(
                color: overlay,
                borderRadius: r,
                // Borda sempre presente (transparente fora do foco) → o anel de
                // foco não desloca o layout ao aparecer.
                border: Border.all(
                  color: focused
                      ? theme.colorTheme.focusRing
                      : const Color(0x00000000),
                  width: AppStrokes.m,
                ),
              ),
              child: Padding(
                padding: padding,
                // Quando o wrapper trata o gesto, o [child] vira rótulo passivo:
                // sem isto, filhos que capturam ponteiro (ex.: o texto
                // selecionável do AppText) roubam o toque/foco em vez de acionar
                // o onTap.
                child: IgnorePointer(
                  ignoring: hasHandler,
                  child: _presentChild(theme),
                ),
              ),
            ),
          ),
        );
      },
    );

    Widget result = hasHandler
        ? AppSemantics.button(
            label: semanticLabel,
            enabled: enabled,
            loading: loading,
            onTap: onTap,
            child: core,
          )
        : core;

    if (tooltip != null) {
      result = AppTooltip(
        message: tooltip!,
        position: tooltipPosition,
        child: result,
      );
    }
    return result;
  }
}
