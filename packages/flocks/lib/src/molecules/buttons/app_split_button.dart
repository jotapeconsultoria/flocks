import 'package:flutter/widgets.dart';

import '../../atoms/icons/icons.dart';
import '../../atoms/loadings/app_circular_loading.dart';
import '../../atoms/texts/texts.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../foundation/flocks_interaction.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../../tokens/app_elevation.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_strokes.dart';
import '../../tokens/app_style.dart';
import '../card/anchored_overlay.dart';
import '../menu/app_menu.dart';
import 'app_button_color.dart';
import 'app_button_size.dart';
import 'button_state_colors.dart';

/// Botão de **ação dividida**: uma ação primária + um caret que abre um
/// [AppMenu] de ações secundárias.
///
/// Segue as mesmas regras globais do [AppButton]: varia pelo eixo [AppStyle]
/// (`filled`/`outlined`/`elevated`, default = `theme.styleTheme.style`), aceita
/// override de forma por instância ([radiusMode]/[radius]) e reusa o modelo de
/// cor dos botões do DS (`appFilledButtonColors` / `appGhostButtonColors`).
///
/// Micro-interações por segmento (paridade com o [AppButton]): tanto o segmento
/// primário quanto o caret são [FlocksInteraction] reais — hover/press/foco por
/// teclado, anel de foco no lado correto e press-scale, tudo gated por
/// [AppMotion]. As `menuEntries` alimentam um [AppMenu] ancorado ao caret.
///
/// ```dart
/// AppSplitButton(
///   label: 'Salvar',
///   onPressed: save,
///   menuEntries: <AppMenuEntry>[
///     AppMenuItem(label: 'Salvar e sair', onPressed: saveAndExit),
///     AppMenuItem(label: 'Salvar como rascunho', onPressed: draft),
///   ],
/// )
/// ```
final class AppSplitButton extends StatefulWidget {
  /// Cria um [AppSplitButton].
  const AppSplitButton({
    required this.label,
    required this.onPressed,
    required this.menuEntries,
    this.style,
    this.color = AppButtonColor.primary,
    this.size = AppButtonSize.l,
    this.icon,
    this.enabled = true,
    this.loading = false,
    this.radiusMode,
    this.radius,
    this.menuSemanticsLabel = 'Mais ações',
    this.menuStyle,
    super.key,
  });

  /// Rótulo da ação primária.
  final String label;

  /// Ação primária. `null` desabilita o botão inteiro.
  final VoidCallback? onPressed;

  /// Ações secundárias do menu do caret.
  final List<AppMenuEntry> menuEntries;

  /// Tratamento de container do eixo global [AppStyle]. `null` (default) segue
  /// `theme.styleTheme.style`. `filled`=preenchido, `outlined`=contornado,
  /// `elevated`=preenchido + sombra.
  final AppStyle? style;

  /// Papel de cor.
  final AppButtonColor color;

  /// Tamanho (altura).
  final AppButtonSize size;

  /// URL do ícone da ação primária (opcional).
  final String? icon;

  /// Se está habilitado.
  final bool enabled;

  /// Se está em loading (mostra spinner no segmento primário).
  final bool loading;

  /// Sobrescreve o modo de forma só deste botão (vence o global).
  final AppRadiusMode? radiusMode;

  /// Override cru do raio (vence [radiusMode] e o global).
  final BorderRadius? radius;

  /// Rótulo de acessibilidade do caret.
  final String menuSemanticsLabel;

  /// Tratamento de container do menu do caret no eixo [AppStyle]. `null`
  /// (default) = [AppStyle.elevated] (sombra).
  final AppStyle? menuStyle;

  @override
  State<AppSplitButton> createState() => _AppSplitButtonState();
}

class _AppSplitButtonState extends State<AppSplitButton> {
  final AppMenuController _menu = AppMenuController();
  bool _menuOpen = false;

  bool get _interactive =>
      widget.enabled && !widget.loading && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final bool isDark = theme.brightness == AppBrightness.dark;

    // Eixo global [AppStyle], igual ao AppButton/ButtonCore.
    final AppStyle style = widget.style ?? theme.styleTheme.style;
    final bool filled = style == AppStyle.filled || style == AppStyle.elevated;
    final bool elevated = style == AppStyle.elevated;
    final bool bordered = style == AppStyle.outlined;

    // Raio global com override por instância (raw vence radiusMode vence global).
    final BorderRadius radius =
        widget.radius ?? theme.radiusTheme.resolve(override: widget.radiusMode);
    // Cada segmento arredonda só o seu lado; a divisória fica reta no meio.
    final BorderRadius primaryRadius = BorderRadius.only(
      topLeft: radius.topLeft,
      bottomLeft: radius.bottomLeft,
    );
    final BorderRadius caretRadius = BorderRadius.only(
      topRight: radius.topRight,
      bottomRight: radius.bottomRight,
    );

    // Cores em repouso (para a borda/divisória e o fundo do container externo).
    final ButtonColors rest = filled
        ? appFilledButtonColors(
            colors,
            widget.color.role(colors),
            widget.color.onRole(colors),
            hovered: false,
            pressed: false,
            disabled: !_interactive,
          )
        : appGhostButtonColors(
            colors,
            widget.color.role(colors),
            bordered: true,
            hovered: false,
            pressed: false,
            disabled: !_interactive,
          );

    final Color dividerColor = filled
        ? Color.alphaBlend(
            rest.foreground.withValues(alpha: 0.28),
            rest.background,
          )
        : rest.border;

    final Widget primary = _SplitSegment(
      filled: filled,
      color: widget.color,
      size: widget.size,
      radius: primaryRadius,
      enabled: widget.enabled,
      loading: widget.loading,
      onPressed: _interactive ? widget.onPressed : null,
      semanticsLabel: widget.label,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacings.s16),
      builder: (Color fg) => Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacings.s8,
        children: <Widget>[
          if (widget.icon != null)
            AppIcon(widget.icon!, size: AppIconSize.s, color: fg),
          Flexible(
            child: AppText(
              widget.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium.copyWith(color: fg),
            ),
          ),
        ],
      ),
    );

    final Widget caret = _buildCaret(filled, caretRadius);

    final Widget row = SizedBox(
      height: widget.size.height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          primary,
          Container(width: AppStrokes.s, color: dividerColor),
          caret,
        ],
      ),
    );

    // Container externo: fundo-base, borda (outlined) e sombra (elevated) com o
    // raio cheio. Sem ClipRRect — cada segmento clipa o próprio fundo, e os
    // anéis de foco (strokeAlignOutside) precisam extrapolar os limites.
    return DecoratedBox(
      decoration: BoxDecoration(
        color: filled ? rest.background : colors.transparent,
        borderRadius: radius,
        border: bordered
            ? Border.all(
                color: rest.border,
                width: AppStrokes.m,
                strokeAlign: BorderSide.strokeAlignInside,
              )
            : null,
        boxShadow: elevated ? AppElevation.symmetricShadows(isDark) : null,
      ),
      child: row,
    );
  }

  Widget _buildCaret(bool filled, BorderRadius caretRadius) {
    final Widget segment = _SplitSegment(
      filled: filled,
      color: widget.color,
      size: widget.size,
      radius: caretRadius,
      enabled: widget.enabled,
      loading: false,
      onPressed: _interactive ? _menu.toggle : null,
      semanticsLabel: widget.menuSemanticsLabel,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacings.s12),
      builder: (Color fg) => AppAnimatedRotation(
        turns: _menuOpen ? 0.5 : 0.0,
        child: AppIcon(
          AppIconToken.chevronDown,
          size: AppIconSize.s,
          color: fg,
        ),
      ),
    );

    if (!_interactive) return segment;

    return AppMenu(
      controller: _menu,
      entries: widget.menuEntries,
      placement: AppOverlayPlacement.bottomEnd,
      style: widget.menuStyle,
      onOpenChanged: (bool open) => setState(() => _menuOpen = open),
      trigger: segment,
    );
  }
}

/// Um segmento tocável do split button, com paridade ao `ButtonCore`: estados
/// via [FlocksInteraction] (hover/press/foco), cor por estado, **anel de foco**
/// (strokeAlignOutside) e **press-scale** — tudo gated por [AppMotion]. O
/// [radius] é assimétrico (só o lado externo do segmento); a borda/sombra do
/// conjunto ficam no container externo.
class _SplitSegment extends StatelessWidget {
  const _SplitSegment({
    required this.filled,
    required this.color,
    required this.size,
    required this.radius,
    required this.enabled,
    required this.loading,
    required this.onPressed,
    required this.padding,
    required this.builder,
    required this.semanticsLabel,
  });

  final bool filled;
  final AppButtonColor color;
  final AppButtonSize size;
  final BorderRadius radius;
  final bool enabled;
  final bool loading;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;
  final Widget Function(Color foreground) builder;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final bool interactive = enabled && !loading && onPressed != null;
    final bool motionEnabled = AppMotion.enabled(context);

    return AppSemantics.button(
      label: semanticsLabel,
      enabled: enabled,
      loading: loading,
      onTap: onPressed,
      child: FlocksInteraction(
        onPressed: interactive ? onPressed : null,
        enabled: interactive,
        builder: (BuildContext context, Set<WidgetState> states) {
          final bool hovered = states.contains(WidgetState.hovered);
          final bool pressed = states.contains(WidgetState.pressed);
          final bool focused = states.contains(WidgetState.focused);
          final bool disabled = !interactive;

          final ButtonColors c = filled
              ? appFilledButtonColors(
                  colors,
                  color.role(colors),
                  color.onRole(colors),
                  hovered: hovered,
                  pressed: pressed,
                  disabled: disabled,
                )
              : appGhostButtonColors(
                  colors,
                  color.role(colors),
                  bordered: false,
                  hovered: hovered,
                  pressed: pressed,
                  disabled: disabled,
                );

          final Widget inner = AnimatedContainer(
            duration: AppMotion.resolve(context, AppDurations.normal),
            curve: AppCurves.standard,
            alignment: Alignment.center,
            padding: padding,
            decoration: BoxDecoration(
              color: c.background,
              borderRadius: radius,
            ),
            // Conteúdo passivo — não deixar o texto selecionável roubar o clique.
            child: SelectionContainer.disabled(
              child: loading
                  ? AppCircularLoading(
                      color: c.foreground,
                      size: size.loadingSize,
                      stroke: size.loadingStroke,
                    )
                  : builder(c.foreground),
            ),
          );

          // Anel de foco por fora (não desloca layout; some no toque via
          // FlocksInteraction) — segue o raio assimétrico do segmento.
          final Widget ringed = DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(
                color: focused ? colors.focusRing : colors.transparent,
                width: AppStrokes.m,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
            child: inner,
          );

          return AnimatedScale(
            scale: (motionEnabled && pressed) ? 0.97 : 1.0,
            duration: AppMotion.resolve(context, AppDurations.fast),
            curve: AppCurves.standard,
            child: ringed,
          );
        },
      ),
    );
  }
}
