import 'package:flutter/widgets.dart';

import '../../foundation/foundation.dart';
import '../../molecules/tooltip/tooltip.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// Checkbox do design system. Reconstruído sobre [FlocksInteraction] (foco por
/// Tab, Enter/Space, hover, ring de foco) com semântica de toggle.
///
/// - Marcado: borda/fundo no acento primário resolvido por brilho
///   ([AppColorTheme.primaryAccent] — base no claro, `s400` no escuro), checkmark
///   em `surfaceContainer` (furo que revela a superfície por baixo do fill).
/// - Desmarcado: borda neutra (`neutralPrimary`), fundo transparente.
/// - Desabilitado: `neutralPrimary` esmaecido.
///
/// Micro-interação: ao marcar, o checkmark é **desenhado** (traço 0→100%) e a
/// caixa dá um **bounce** (pulso de escala). Respeita reduce-motion / o global
/// [AppAnimationTheme] via [AppMotion].
///
/// Example:
/// ```dart
/// AppCheckbox(checked: v, onChanged: (nv) => setState(() => v = nv))
/// ```
final class AppCheckbox extends StatefulWidget {
  const AppCheckbox({
    required this.checked,
    this.enabled = true,
    this.onChanged,
    this.semanticLabel,
    this.tooltip,
    this.style,
    this.radiusMode,
    this.radius,
    super.key,
  });

  /// Se o checkbox está marcado.
  final bool checked;

  /// Se o checkbox está habilitado.
  final bool enabled;

  /// Callback quando o estado muda.
  final ValueChanged<bool>? onChanged;

  /// Rótulo de acessibilidade (opcional).
  final String? semanticLabel;

  /// Tooltip exibido ao passar o mouse.
  final String? tooltip;

  /// Tratamento de container (borda/fundo/sombra) do eixo global [AppStyle].
  /// `null` (default) segue o global `theme.styleTheme.style`. Aditivo sobre o
  /// fill semântico do estado: marcado = `primary`; vazio = superfície
  /// (`surfaceContainer` em `filled`/`elevated`, ghost transparente em
  /// `outlined`).
  final AppStyle? style;

  /// Sobrescreve o modo de forma só deste checkbox (vence o global
  /// `theme.radiusTheme.mode`). Default do componente: [AppRadiusMode.redondo].
  final AppRadiusMode? radiusMode;

  /// Override cru do raio da caixa — vence [radiusMode] e o global.
  final BorderRadius? radius;

  static const double _size = 24.0;

  @override
  State<AppCheckbox> createState() => _AppCheckboxState();
}

class _AppCheckboxState extends State<AppCheckbox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounce = AnimationController(
    vsync: this,
    duration: AppDurations.medium,
  );

  // Pulso 1 → 1.08 → 1 (sobe com ênfase, assenta suave).
  late final Animation<double> _bounceScale =
      TweenSequence<double>(<TweenSequenceItem<double>>[
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1,
            end: 1.08,
          ).chain(CurveTween(curve: AppCurves.emphasized)),
          weight: 45,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1.08,
            end: 1,
          ).chain(CurveTween(curve: AppCurves.standard)),
          weight: 55,
        ),
      ]).animate(_bounce);

  @override
  void didUpdateWidget(covariant AppCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Bounce só ao MARCAR (não ao desmarcar) e se motion está ligado.
    if (!oldWidget.checked && widget.checked && AppMotion.enabled(context)) {
      _bounce.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _bounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget result = FlocksInteraction(
      selected: widget.checked,
      enabled: widget.enabled && widget.onChanged != null,
      mouseCursor: widget.enabled ? null : SystemMouseCursors.forbidden,
      onPressed: widget.onChanged == null
          ? null
          : () => widget.onChanged!(!widget.checked),
      builder: _buildVisual,
    );

    if (widget.tooltip != null) {
      result = AppTooltip(message: widget.tooltip!, child: result);
    }

    return AppSemantics.toggle(
      value: widget.checked,
      enabled: widget.enabled,
      label: widget.semanticLabel,
      child: result,
    );
  }

  Widget _buildVisual(BuildContext context, Set<WidgetState> states) {
    final theme = AppTheme.of(context);
    final selected = states.contains(WidgetState.selected);
    final disabled = states.contains(WidgetState.disabled);
    final focused = states.contains(WidgetState.focused);
    final hovered = states.contains(WidgetState.hovered);

    final colors = appCheckboxStateColors(
      theme.colorTheme,
      selected: selected,
      disabled: disabled,
      isDark: theme.brightness == AppBrightness.dark,
    );

    // Eixo de estilo global (filled/outlined/elevated), aditivo sobre o fill
    // semântico do estado. `container` (null quando vazio) vira o `ownFill`; a
    // cor de borda do estado vira o `outline`. Assim o `outlined` reproduz o
    // visual bordado clássico, `filled` cai em `surfaceContainer` quando vazio e
    // `elevated` acrescenta a sombra simétrica.
    final AppStyle style = widget.style ?? theme.styleTheme.style;
    final bool isDark = theme.brightness == AppBrightness.dark;
    final StyleDecoration deco = resolveStyleDecoration(
      style: style,
      isDark: isDark,
      outline: colors.border ?? theme.colorTheme.transparent,
      // Poço do vazio (filled/elevated): um neutro alguns tons ACIMA da
      // superfície — distinto de `surface` E de `surfaceContainer` (senão o
      // controle some sobre um card/painel). `s200` = dois passos em direção ao
      // contraste, tom-relativo nos dois temas.
      surfaceContainer: theme.colorTheme.neutralPrimary.s200,
      ownFill: colors.container,
    );

    // Forma da caixa. Default do checkbox: redondo (quadrado arredondado);
    // no "Circular" satura no círculo (metade da medida). `radius`/`radiusMode`
    // sobrescrevem.
    final BorderRadius boxBR =
        widget.radius ??
        theme.radiusTheme.resolve(
          componentDefault: AppRadiusMode.redondo,
          size: const Size.square(AppCheckbox._size),
          override: widget.radiusMode,
        );

    Widget box = SizedBox(
      height: AppCheckbox._size,
      width: AppCheckbox._size,
      child: AnimatedContainer(
        duration: AppMotion.resolve(context, AppDurations.normal),
        curve: AppCurves.standard,
        decoration: BoxDecoration(
          border: deco.border,
          color: deco.color,
          boxShadow: deco.boxShadow,
          borderRadius: boxBR,
        ),
        child: AppValueBuilder(
          value: selected ? 1.0 : 0.0,
          curve: AppCurves.emphasized,
          builder: (context, t, _) => CustomPaint(
            painter: AppCheckmarkPainter(color: colors.indicator, progress: t),
          ),
        ),
      ),
    );

    // Anel ao focar (teclado) OU ao passar o mouse — feedback de alvo tocável.
    // Mesmo raio da caixa (não `+ stroke`): com `strokeAlignOutside` sobre o
    // mesmo retângulo, os cantos do anel ficam paralelos aos da caixa em
    // qualquer preset de radius — o anel acompanha fielmente o formato.
    if (focused || hovered) {
      box = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: boxBR,
          border: Border.all(
            color: theme.colorTheme.focusRing,
            width: AppStrokes.m,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        child: box,
      );
    }

    return AnimatedBuilder(
      animation: _bounce,
      builder: (context, child) =>
          Transform.scale(scale: _bounceScale.value, child: child),
      child: box,
    );
  }
}

/// Cores do [AppCheckbox] por estado (função pura, testável — ver
/// `test/src/theme/component_state_contrast_test.dart`).
///
/// - `indicator`: o **checkmark** (marcado) ou a **borda** (desmarcado);
/// - `container`: o preenchimento (`null` = transparente);
/// - `border`: o contorno.
///
/// Desabilitado usa [AppColorTheme.disabledColor] (apagado por **tom**, não por
/// opacidade). Ver `docs/COLOR_ACCESSIBILITY_RULES.md` §7.
({Color indicator, Color? container, Color? border}) appCheckboxStateColors(
  AppColorTheme theme, {
  required bool selected,
  required bool disabled,
  required bool isDark,
}) {
  // Acento primário resolvido por brilho (base no claro, `s400` no escuro): o
  // `primary` cru é escuro demais como fill sobre a superfície escura e o
  // checkbox marcado sumia. O checkmark usa `surfaceContainer` — "vaza" a
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
