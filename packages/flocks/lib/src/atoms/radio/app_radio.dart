import 'package:flutter/widgets.dart';

import '../../foundation/foundation.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// Radio button circular do design system.
///
/// Reconstruído sobre [FlocksInteraction]: foco por Tab, ativação por
/// Enter/Space, hover e ring de foco (fora de toque). Expõe semântica de toggle
/// em grupo mutuamente exclusivo via [AppSemantics.toggle].
///
/// - Desmarcado: borda neutra (neutralPrimary), fundo transparente.
/// - Selecionado: borda/fundo no acento primário resolvido por brilho
///   ([AppColorTheme.primaryAccent] — base no claro, `s400` no escuro), ponto
///   interno em `surfaceContainer` (furo que revela a superfície).
/// - Selecionado desabilitado: acento esmaecido (mantém a identidade).
/// - Desmarcado desabilitado: cinza neutro preenchido.
///
/// Exemplo:
/// ```dart
/// AppRadio<Plan>(
///   value: Plan.basic,
///   groupValue: selected,
///   onChanged: (v) => setState(() => selected = v),
/// )
/// ```
final class AppRadio<T> extends StatelessWidget {
  const AppRadio({
    required this.groupValue,
    required this.value,
    this.enabled = true,
    this.onChanged,
    this.semanticLabel,
    this.style,
    this.radiusMode,
    this.radius,
    super.key,
  });

  /// Se o radio está habilitado.
  final bool enabled;

  /// Valor selecionado do grupo.
  final T? groupValue;

  /// Callback quando o valor muda.
  final ValueChanged<T?>? onChanged;

  /// Valor deste radio.
  final T value;

  /// Rótulo de acessibilidade do radio (opcional).
  final String? semanticLabel;

  /// Tratamento de container (borda/fundo/sombra) do eixo global [AppStyle].
  /// `null` (default) segue o global `theme.styleTheme.style`. Aditivo sobre o
  /// fill semântico do estado: marcado = `primary`; vazio = superfície
  /// (`surfaceContainer` em `filled`/`elevated`, ghost transparente em
  /// `outlined`).
  final AppStyle? style;

  /// Sobrescreve o modo de forma só deste radio (vence o global
  /// `theme.radiusTheme.mode`). Default do componente: [AppRadiusMode.circular].
  final AppRadiusMode? radiusMode;

  /// Override cru do raio externo — vence [radiusMode] e o global.
  final BorderRadius? radius;

  static const double _size = 24.0;
  static const double _dotSize = 12.0;

  bool get _isSelected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    return AppSemantics.toggle(
      value: _isSelected,
      enabled: enabled,
      mutuallyExclusive: true,
      label: semanticLabel,
      child: FlocksInteraction(
        selected: _isSelected,
        enabled: enabled && onChanged != null,
        mouseCursor: enabled ? null : SystemMouseCursors.forbidden,
        onPressed: onChanged == null ? null : () => onChanged!(value),
        builder: _buildVisual,
      ),
    );
  }

  Widget _buildVisual(BuildContext context, Set<WidgetState> states) {
    final theme = AppTheme.of(context);
    final selected = states.contains(WidgetState.selected);
    final disabled = states.contains(WidgetState.disabled);
    final focused = states.contains(WidgetState.focused);
    final hovered = states.contains(WidgetState.hovered);

    // Endpoints (desmarcado ↔ marcado) para encadear caixa e ponto. Desabilitado
    // é estático (não se alterna), então os endpoints já saem certos.
    final bool isDark = theme.brightness == AppBrightness.dark;
    final selCol = appRadioStateColors(
      theme.colorTheme,
      selected: true,
      disabled: disabled,
      isDark: isDark,
    );
    final unselCol = appRadioStateColors(
      theme.colorTheme,
      selected: false,
      disabled: disabled,
      isDark: isDark,
    );
    final Color transparent = theme.colorTheme.transparent;

    // Eixo de estilo global (filled/outlined/elevated), aditivo sobre o fill
    // semântico. Resolvemos a decoração dos DOIS endpoints (desmarcado/marcado)
    // para interpolar o fundo — e a borda quando `outlined`. `filled`/`elevated`
    // caem em `surfaceContainer` no vazio; `elevated` acrescenta a sombra.
    final AppStyle style = this.style ?? theme.styleTheme.style;
    // Poço do vazio (filled/elevated): um neutro alguns tons ACIMA da superfície
    // — distinto de `surface` E de `surfaceContainer` (senão o controle some
    // sobre um card/painel). `s200` = dois passos em direção ao contraste,
    // tom-relativo nos dois temas.
    final Color surfaceContainer = theme.colorTheme.neutralPrimary.s200;
    final StyleDecoration selDeco = resolveStyleDecoration(
      style: style,
      isDark: isDark,
      outline: selCol.border ?? transparent,
      surfaceContainer: surfaceContainer,
      ownFill: selCol.container,
    );
    final StyleDecoration unselDeco = resolveStyleDecoration(
      style: style,
      isDark: isDark,
      outline: unselCol.border ?? transparent,
      surfaceContainer: surfaceContainer,
      ownFill: unselCol.container,
    );
    // A borda só existe no `outlined`; a sombra (constante) só no `elevated`.
    final bool showBorder = selDeco.border != null;
    final List<BoxShadow>? boxShadow = selDeco.boxShadow;

    // Forma segue o eixo de radius. Default do radio: circular (metade da
    // medida) → no "Reto" vira quadrado; no "Redondo" um quadrado arredondado;
    // no "Circular"/"Padrão" o círculo. `radius`/`radiusMode` sobrescrevem.
    final AppRadiusMode mode = radiusMode ?? theme.radiusTheme.mode;
    final BorderRadius outerBR =
        radius ??
        appResolveRadius(
          mode: mode,
          componentDefault: AppRadiusMode.circular,
          size: const Size.square(_size),
        );
    final BorderRadius dotBR = appResolveRadius(
      mode: mode,
      componentDefault: AppRadiusMode.circular,
      size: const Size.square(_dotSize),
    );
    final double outerR = outerBR.topLeft.x;

    // Encadeamento a partir de um único `t` (0=desmarcado, 1=marcado):
    // - fundo (borda/fill) na 1ª metade; ponto (escala) na 2ª metade.
    // Ao ENTRAR (t:0→1): fundo faz fade, depois o ponto cresce de zero.
    // Ao SAIR   (t:1→0): o ponto encolhe até zero, depois o fundo faz fade.
    Widget dot = SizedBox(
      height: _size,
      width: _size,
      child: AppValueBuilder(
        value: selected ? 1.0 : 0.0,
        duration: AppDurations.medium,
        curve: AppCurves.linear,
        builder: (context, t, _) {
          final double clamped = t.clamp(0.0, 1.0);
          final double fillT = const Interval(
            0,
            0.6,
            curve: AppCurves.standard,
          ).transform(clamped);
          final double dotT = const Interval(
            0.4,
            1,
            curve: AppCurves.emphasizedOvershoot,
          ).transform(clamped);
          final Color border = Color.lerp(
            unselCol.border ?? transparent,
            selCol.border ?? transparent,
            fillT,
          )!;
          final Color fill = Color.lerp(
            unselDeco.color ?? transparent,
            selDeco.color ?? transparent,
            fillT,
          )!;
          return DecoratedBox(
            decoration: BoxDecoration(
              border: showBorder
                  ? Border.all(color: border, width: AppStrokes.m)
                  : null,
              borderRadius: outerBR,
              color: fill,
              boxShadow: boxShadow,
            ),
            child: Center(
              child: Transform.scale(
                scale: dotT < 0 ? 0.0 : dotT,
                child: SizedBox(
                  height: _dotSize,
                  width: _dotSize,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: selCol.indicator,
                      borderRadius: dotBR,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    // Anel ao focar (teclado) OU ao passar o mouse.
    if (focused || hovered) {
      dot = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(outerR + AppStrokes.m),
          border: Border.all(
            color: theme.colorTheme.focusRing,
            width: AppStrokes.m,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        child: dot,
      );
    }

    return dot;
  }
}

/// Cores do [AppRadio] por estado (função pura, testável — ver
/// `test/src/theme/component_state_contrast_test.dart`).
///
/// - `indicator`: o **ponto** (selecionado) ou a **borda** (não selecionado) — o
///   que comunica o estado;
/// - `container`: o preenchimento (`null` = transparente);
/// - `border`: o contorno.
///
/// Desabilitado usa [AppColorTheme.disabledColor] (apagado por **tom**, não por
/// opacidade), garantindo perceptibilidade e distinção do habilitado nos dois
/// temas. Ver `docs/COLOR_ACCESSIBILITY_RULES.md` §7.
({Color indicator, Color? container, Color? border}) appRadioStateColors(
  AppColorTheme theme, {
  required bool selected,
  required bool disabled,
  required bool isDark,
}) {
  // Acento primário resolvido por brilho (base no claro, `s400` no escuro): o
  // `primary` cru é escuro demais como fill sobre a superfície escura e o radio
  // selecionado sumia. O ponto interno usa `surfaceContainer` — "vaza" a
  // superfície elevada por baixo do fill (efeito de furo), contrastando com o
  // acento nos dois temas (acento e superfície ficam em pontas opostas).
  final Color accent = theme.primaryAccent(isDark: isDark);
  if (disabled) {
    if (selected) {
      final Color fill = theme.disabledColor(accent);
      return (
        indicator: disabledIndicatorOn(fill),
        container: fill,
        border: fill,
      );
    }
    final Color muted = theme.disabledColor(theme.outline);
    return (indicator: muted, container: muted, border: muted);
  }
  if (selected) {
    return (
      indicator: theme.surfaceContainer,
      container: accent,
      border: accent,
    );
  }
  return (indicator: theme.outline, container: null, border: theme.outline);
}
