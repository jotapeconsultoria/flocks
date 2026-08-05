import 'package:flutter/widgets.dart';

import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../foundation/flocks_interaction.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_strokes.dart';
import '../../tokens/app_style.dart';
import '../../tokens/contrast.dart';
import '../tooltip/tooltip.dart';

/// Tile expansível (cabeçalho clicável + corpo animado), sem Material.
///
/// O cabeçalho usa [FlocksInteraction] (hover/press/foco-Tab/anel + Enter/Space);
/// o chevron gira via [AppAnimatedRotation] e o corpo abre/fecha via [AppExpand]
/// — ambos passam por [AppMotion] (respeitam reduce-motion e o toggle global).
/// O tooltip do chevron reusa [AppTooltip]. Cores 100% do tema.
///
/// ```dart
/// AppExpansionTile(
///   title: 'Detalhes',
///   children: <Widget>[AppText('...')],
/// )
/// ```
final class AppExpansionTile extends StatefulWidget {
  /// Cria um [AppExpansionTile].
  const AppExpansionTile({
    required this.children,
    required this.title,
    this.collapsedIconTooltip = 'Abrir',
    this.enabled = true,
    this.expandedIconTooltip = 'Fechar',
    this.hoverEnabled = true,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.style,
    this.radiusMode,
    this.radius,
    this.background,
    super.key,
  });

  /// Conteúdo exibido quando o tile está expandido.
  final List<Widget> children;

  /// Tooltip do ícone quando fechado.
  final String collapsedIconTooltip;

  /// Se o tile está habilitado para interação.
  final bool enabled;

  /// Tooltip do ícone quando aberto.
  final String expandedIconTooltip;

  /// Se o realce de hover está habilitado.
  final bool hoverEnabled;

  /// Se o tile inicia expandido.
  final bool initiallyExpanded;

  /// Callback ao alternar a expansão.
  final ValueChanged<bool>? onExpansionChanged;

  /// Título do cabeçalho.
  final String title;

  /// Tratamento de container (borda/fundo/sombra) do eixo global [AppStyle],
  /// aplicado ao card inteiro (cabeçalho + corpo). `null` (default) segue o
  /// global `theme.styleTheme.style`. Container ghost: `filled`/`elevated` caem
  /// em `surfaceContainer`; `outlined` fica transparente com borda `outline`.
  final AppStyle? style;

  /// Sobrescreve o modo de forma só deste tile (vence o global
  /// `theme.radiusTheme.mode`). Default do componente: [AppRadiusMode.redondo].
  final AppRadiusMode? radiusMode;

  /// Override cru do raio do card — vence [radiusMode] e o global.
  final BorderRadius? radius;

  /// Sobrescreve o fundo do card (quando o [style] preenche). Default: derivado
  /// do estilo.
  final Color? background;

  @override
  State<AppExpansionTile> createState() => _AppExpansionTileState();
}

class _AppExpansionTileState extends State<AppExpansionTile> {
  late bool _isExpanded = widget.initiallyExpanded;

  @override
  void didUpdateWidget(covariant AppExpansionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initiallyExpanded != widget.initiallyExpanded) {
      _isExpanded = widget.initiallyExpanded;
    }
  }

  void _toggle() {
    if (!widget.enabled) return;
    setState(() => _isExpanded = !_isExpanded);
    widget.onExpansionChanged?.call(_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final Color content = widget.enabled
        ? colors.onSurface
        : mutedForDisabled(colors.onSurface, colors.surface);
    final String tooltip = _isExpanded
        ? widget.expandedIconTooltip
        : widget.collapsedIconTooltip;

    // Eixo de estilo global (filled/outlined/elevated) e forma (radius),
    // aplicados ao card inteiro. Container ghost (sem `ownFill`): `filled`/
    // `elevated` caem em `surfaceContainer`, `outlined` fica transparente com
    // borda `outline`. Espelha o padrão de `AppNumberStepper`/`AppSurface`.
    final AppStyle s = widget.style ?? theme.styleTheme.style;
    final BorderRadius r =
        widget.radius ?? theme.radiusTheme.tileRadius(widget.radiusMode);
    final StyleDecoration deco = resolveStyleDecoration(
      style: s,
      isDark: theme.brightness == AppBrightness.dark,
      outline: colors.outline,
      surfaceContainer: colors.surfaceContainer,
      background: widget.background,
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: deco.color,
        border: deco.border,
        boxShadow: deco.boxShadow,
        borderRadius: r,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppSemantics.button(
            label: widget.title,
            enabled: widget.enabled,
            onTap: _toggle,
            child: FlocksInteraction(
              onPressed: widget.enabled ? _toggle : null,
              enabled: widget.enabled,
              selected: _isExpanded,
              builder: (BuildContext context, Set<WidgetState> states) {
                final bool hovered =
                    widget.hoverEnabled && states.contains(WidgetState.hovered);
                final bool pressed = states.contains(WidgetState.pressed);
                final bool focused = states.contains(WidgetState.focused);
                final Color overlay = pressed
                    ? colors.onSurface.withValues(alpha: 0.12)
                    : hovered
                    ? colors.onSurface.withValues(alpha: 0.08)
                    : colors.transparent;

                return AnimatedContainer(
                  duration: AppMotion.resolve(context, AppDurations.fast),
                  curve: AppCurves.standard,
                  decoration: BoxDecoration(
                    color: overlay,
                    borderRadius: r,
                    border: Border.all(
                      color: focused ? colors.focusRing : colors.transparent,
                      width: AppStrokes.m,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacings.s16),
                    child: SelectionContainer.disabled(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: AppText(
                              widget.title,
                              style: theme.textTheme.titleSmall.copyWith(
                                color: content,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacings.s8),
                          AppTooltip(
                            message: tooltip,
                            enabled: widget.enabled && widget.hoverEnabled,
                            child: AppAnimatedRotation(
                              turns: _isExpanded ? 0.5 : 0.0,
                              child: AppIcon(
                                AppIconToken.chevronDown,
                                color: content,
                                size: AppIconSize.s,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          AppExpand(
            child: _isExpanded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: widget.children,
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
