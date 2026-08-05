import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../foundation/foundation.dart';
import '../../molecules/tooltip/tooltip.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// Switch (liga/desliga) do design system. Reconstruído sobre
/// [FlocksInteraction] (foco/teclado/hover/ring) com a animação do thumb via
/// [AppMotion] (respeita reduce-motion) e semântica de toggle.
///
/// Example:
/// ```dart
/// AppSwitch(value: on, onChanged: (v) => setState(() => on = v))
/// ```
final class AppSwitch extends StatelessWidget {
  const AppSwitch({
    required this.value,
    this.enabled = true,
    this.onChanged,
    this.semanticLabel,
    this.tooltip,
    this.style,
    this.radiusMode,
    this.radius,
    super.key,
  });

  /// Se o switch está ligado.
  final bool value;

  /// Se o switch está habilitado.
  final bool enabled;

  /// Callback quando o estado muda.
  final ValueChanged<bool>? onChanged;

  /// Rótulo de acessibilidade (opcional).
  final String? semanticLabel;

  /// Tooltip exibido ao passar o mouse.
  final String? tooltip;

  /// Tratamento de container (borda/fundo/sombra) do eixo global [AppStyle].
  /// `null` (default) segue o global `theme.styleTheme.style`. Ligado, o trilho
  /// é `primary`; desligado ele participa do eixo com fill nulo → `filled` cai
  /// em `surfaceContainer`, `outlined` fica vazado só com a borda `outline` e
  /// `elevated` acrescenta a sombra simétrica.
  final AppStyle? style;

  /// Sobrescreve o modo de forma só deste switch (vence o global
  /// `theme.radiusTheme.mode`). Default do componente: [AppRadiusMode.circular].
  final AppRadiusMode? radiusMode;

  /// Override cru do raio do trilho — vence [radiusMode] e o global.
  final BorderRadius? radius;

  static const double _width = 44.0;
  static const double _height = 24.0;
  static const double _thumbSize = 18.0;
  static const double _padding = 3.0;

  @override
  Widget build(BuildContext context) {
    Widget result = FlocksInteraction(
      selected: value,
      enabled: enabled && onChanged != null,
      mouseCursor: enabled ? null : SystemMouseCursors.forbidden,
      onPressed: onChanged == null ? null : () => onChanged!(!value),
      builder: _buildVisual,
    );

    if (tooltip != null) {
      result = AppTooltip(message: tooltip!, child: result);
    }

    return AppSemantics.toggle(
      value: value,
      enabled: enabled,
      label: semanticLabel,
      child: result,
    );
  }

  Widget _buildVisual(BuildContext context, Set<WidgetState> states) {
    final theme = AppTheme.of(context);
    final selected = states.contains(WidgetState.selected);
    final disabled = states.contains(WidgetState.disabled);
    final focused = states.contains(WidgetState.focused);
    final hovered = states.contains(WidgetState.hovered);
    final duration = AppMotion.resolve(context, AppDurations.normal);

    final bool isDark = theme.brightness == AppBrightness.dark;
    final colors = appSwitchStateColors(
      theme.colorTheme,
      selected: selected,
      disabled: disabled,
      isDark: isDark,
    );
    final Color thumbColor = colors.indicator;

    // Eixo de estilo global (filled/outlined/elevated), aditivo sobre o fill
    // semântico do trilho. Ligado o trilho é `primary`; desligado o `container`
    // é nulo → `filled` cai em `surfaceContainer`, `outlined` fica vazado (só
    // borda) e `elevated` acrescenta a sombra.
    final AppStyle style = this.style ?? theme.styleTheme.style;
    final StyleDecoration deco = resolveStyleDecoration(
      style: style,
      isDark: isDark,
      outline: colors.border ?? theme.colorTheme.transparent,
      // Trilho do desligado (filled/elevated): um neutro alguns tons ACIMA da
      // superfície — distinto de `surface` E de `surfaceContainer` (senão o
      // trilho some sobre um card/painel). `s200` = dois passos em direção ao
      // contraste, tom-relativo nos dois temas.
      surfaceContainer: theme.colorTheme.neutralPrimary.s200,
      ownFill: colors.container,
    );

    // Forma segue o eixo de radius. Default do switch: circular (pílula) →
    // no "Reto" vira retângulo; no "Redondo" um retângulo arredondado; no
    // "Circular"/"Padrão" a pílula. `radius`/`radiusMode` sobrescrevem.
    final AppRadiusMode mode = radiusMode ?? theme.radiusTheme.mode;
    final BorderRadius trackBR =
        radius ??
        appResolveRadius(
          mode: mode,
          componentDefault: AppRadiusMode.circular,
          size: const Size.square(_height),
        );
    final BorderRadius thumbBR = appResolveRadius(
      mode: mode,
      componentDefault: AppRadiusMode.circular,
      size: const Size.square(_thumbSize),
    );
    final double trackR = trackBR.topLeft.x;

    Widget sw = AnimatedContainer(
      curve: AppCurves.standard,
      duration: duration,
      height: _height,
      padding: const EdgeInsets.all(_padding),
      width: _width,
      decoration: BoxDecoration(
        borderRadius: trackBR,
        color: deco.color,
        boxShadow: deco.boxShadow,
      ),
      // Thumb: desliza da esquerda↔direita e "espreme" no meio do trajeto —
      // encolhe até metade (centralizado) e volta ao tamanho cheio nas pontas.
      // Posição e escala saem do mesmo `t` (0=off, 1=on) via AppValueBuilder.
      child: AppValueBuilder(
        value: selected ? 1.0 : 0.0,
        duration: AppDurations.normal,
        curve: AppCurves.standard,
        child: SizedBox(
          height: _thumbSize,
          width: _thumbSize,
          child: DecoratedBox(
            decoration: BoxDecoration(color: thumbColor, borderRadius: thumbBR),
          ),
        ),
        builder: (context, t, child) {
          final double clamped = t.clamp(0.0, 1.0);
          // 1 nas pontas (t=0,1), 0.5 no meio (t=0.5).
          final double scale = 1.0 - 0.5 * math.sin(clamped * math.pi);
          return Align(
            alignment: Alignment(-1.0 + 2.0 * clamped, 0),
            child: Transform.scale(scale: scale, child: child),
          );
        },
      ),
    );

    // Borda do `outlined` por cima do trilho (primeiro plano): não pode entrar
    // na decoração do AnimatedContainer, pois o `padding` + a borda estreitariam
    // a faixa e cortariam o thumb. A DecoratedBox de primeiro plano desenha o
    // contorno sem afetar o layout (mesmo padrão do AppBadge).
    if (deco.border != null) {
      sw = DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(border: deco.border, borderRadius: trackBR),
        child: sw,
      );
    }

    // Anel ao focar (teclado) OU ao passar o mouse.
    if (focused || hovered) {
      sw = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(trackR + AppStrokes.m),
          border: Border.all(
            color: theme.colorTheme.focusRing,
            width: AppStrokes.m,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        child: sw,
      );
    }

    return sw;
  }
}

/// Cores do [AppSwitch] por estado (função pura, testável — ver
/// `test/src/theme/component_state_contrast_test.dart`).
///
/// - `indicator`: o **thumb** (knob) — a marca que corre no trilho;
/// - `container`: o **trilho** (track); `null` no desligado (fill semântico
///   ausente) para o switch participar do eixo [AppStyle] como check/radio — o
///   resolver escolhe `surfaceContainer` (`filled`/`elevated`) ou deixa vazado
///   (`outlined`);
/// - `border`: cor do contorno do `outlined` (ligado = acento primário,
///   desligado = `outline`), consumida por `resolveStyleDecoration`.
///
/// Ligado o trilho usa o **acento primário resolvido por brilho**
/// ([AppColorTheme.primaryAccent]: base no claro, `s400` no escuro — o `primary`
/// cru é escuro demais no escuro e o trilho sumia), com o thumb em
/// `surfaceContainer` (furo que revela a superfície por baixo do trilho,
/// contrastando com o acento). Desligado o thumb usa `outline` (não mais
/// branco): como o trilho deixou de ser um cinza sólido, o thumb precisa de uma
/// cor que contraste ≥3:1 com a superfície do trilho nos dois temas.
///
/// Desabilitado usa [AppColorTheme.disabledColor] (apagado por **tom**, não por
/// opacidade). Ver `doc/COLOR_ACCESSIBILITY_RULES.md` §7.
({Color indicator, Color? container, Color? border}) appSwitchStateColors(
  AppColorTheme theme, {
  required bool selected,
  required bool disabled,
  required bool isDark,
}) {
  // Acento primário resolvido por brilho (base no claro, `s400` no escuro): o
  // `primary` cru é escuro demais como trilho sobre a superfície escura e o
  // switch ligado sumia. O thumb usa `surfaceContainer` — "vaza" a superfície
  // elevada por baixo do trilho (efeito de furo), contrastando com o acento nos
  // dois temas (acento e superfície ficam em pontas opostas).
  final Color accent = theme.primaryAccent(isDark: isDark);
  if (disabled) {
    if (selected) {
      final Color track = theme.disabledColor(accent);
      return (
        indicator: disabledIndicatorOn(track),
        container: track,
        border: track,
      );
    }
    // Desligado desabilitado: trilho ghost (fill nulo → `surfaceContainer` no
    // `filled`); thumb e borda num neutro apagado por tom.
    final Color muted = theme.disabledColor(theme.outline);
    return (indicator: muted, container: null, border: muted);
  }
  if (selected) {
    return (
      indicator: theme.surfaceContainer,
      container: accent,
      border: accent,
    );
  }
  // Desligado: fill semântico NULO (participa do eixo de style). O thumb usa
  // `outline` p/ contrastar com a superfície do trilho (`surfaceContainer` no
  // `filled`, a própria `surface` no `outlined` vazado).
  return (indicator: theme.outline, container: null, border: theme.outline);
}
