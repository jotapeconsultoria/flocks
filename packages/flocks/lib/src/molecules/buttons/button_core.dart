import 'package:flutter/widgets.dart';

import '../../atoms/glass/app_glass_surface.dart';
import '../../atoms/icons/icons.dart';
import '../../atoms/loadings/app_circular_loading.dart';
import '../../atoms/shortcut/app_shortcut_hint.dart';
import '../../atoms/texts/texts.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../foundation/flocks_interaction.dart';
import '../../motion/app_motion.dart';
import '../../theme/theme.dart';
import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../../tokens/app_elevation.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_strokes.dart';
import 'app_button_color.dart';
import 'app_button_size.dart';
import 'button_state_colors.dart';

/// Variante visual de um botão.
enum ButtonVariant {
  /// Preenchido (ação primária).
  fill,

  /// Contornado (ação secundária).
  line,

  /// Preenchido + sombra simétrica, sem borda (elevação real).
  elevated,

  /// Só texto (ação terciária/link).
  text,

  /// Só ícone.
  icon,
}

/// Núcleo compartilhado dos botões do Flocks — não é API pública (os 4 botões
/// `App*` delegam a ele). Centraliza estados ([FlocksInteraction]), cores por
/// estado (resolvers puros), anel de foco, press-scale ([AppMotion]),
/// loading e acessibilidade.
class ButtonCore extends StatelessWidget {
  /// Cria um [ButtonCore].
  const ButtonCore({
    required this.variant,
    required this.color,
    required this.onPressed,
    this.onLongPress,
    this.label,
    this.icon,
    this.trailing,
    this.iconSize = AppIconSize.m,
    this.size = AppButtonSize.l,
    this.enabled = true,
    this.loading = false,
    this.expandedWidth,
    this.fixedWidth,
    this.isDense = false,
    this.radiusMode,
    this.radius,
    this.componentDefaultRadius = AppRadiusMode.redondo,
    this.elevate = false,
    this.glass = false,
    this.iconOnlyGlyphSize,
    this.semanticsLabel,
    super.key,
  });

  /// Variante visual.
  final ButtonVariant variant;

  /// Papel de cor.
  final AppButtonColor color;

  /// Ação de clique/Enter/Space.
  final VoidCallback? onPressed;

  /// Ação de long-press (opcional).
  final VoidCallback? onLongPress;

  /// Rótulo textual (opcional).
  final String? label;

  /// URL do ícone (opcional; obrigatório na variante [ButtonVariant.icon]).
  final String? icon;

  /// Conteúdo acessório à DIREITA do rótulo, dentro do botão (tipicamente um
  /// [AppShortcutHint]). Passivo: não recebe toque — o clique é do botão
  /// inteiro. Ignorado nas variantes só-ícone.
  final Widget? trailing;

  /// Tamanho do ícone (usado quando há [icon]).
  final AppIconSize iconSize;

  /// Tamanho do botão (altura). Ignorado na variante [ButtonVariant.icon].
  final AppButtonSize size;

  /// Se está habilitado.
  final bool enabled;

  /// Se está em loading (mostra spinner, bloqueia interação).
  final bool loading;

  /// Se ocupa toda a largura disponível.
  final bool? expandedWidth;

  /// Largura fixa (opcional).
  final double? fixedWidth;

  /// Botão de ícone compacto (padding menor). Só na variante icon.
  final bool isDense;

  /// Sobrescreve o modo de forma só deste botão (vence o global).
  final AppRadiusMode? radiusMode;

  /// Override cru do raio (vence [radiusMode] e o global).
  final BorderRadius? radius;

  /// Modo de raio natural do componente, usado quando o modo ativo é
  /// [AppRadiusMode.padrao]. Default [AppRadiusMode.redondo] (botões comuns); um
  /// FAB passa [AppRadiusMode.circular].
  final AppRadiusMode componentDefaultRadius;

  /// Força a sombra simétrica ([AppElevation]) mesmo fora da variante
  /// [ButtonVariant.elevated]. Default `false`. Um FAB flutua → sempre `true`.
  final bool elevate;

  /// Renderiza uma superfície frosted glass real ([AppGlassSurface], com blur)
  /// em vez do `BoxDecoration`. Default `false`. O ícone/label usa a cor de
  /// acento (papel) sobre o vidro; a sombra é a própria do [AppGlassSurface].
  final bool glass;

  /// Tamanho do glifo quando é **só-ícone** (sem [label]) num variant não-icon
  /// (ex.: FAB circular). `null` (default) mantém o glifo casado com o texto
  /// ([AppIconSize.s]) — comportamento do [AppButton] só-ícone.
  final AppIconSize? iconOnlyGlyphSize;

  /// Rótulo de acessibilidade. Default: [label] ou o nome do [icon].
  final String? semanticsLabel;

  bool get _iconOnly => icon != null && label == null;

  bool get _filled =>
      variant == ButtonVariant.fill || variant == ButtonVariant.elevated;

  /// O nome acessível do botão — ou `null` quando o próprio conteúdo já o dá.
  ///
  /// O `label` visível NÃO é repetido aqui. O nó do botão mescla a semântica
  /// dos filhos, e o `AppText` do rótulo já contribui o texto: devolver `label`
  /// fazia o nó nascer com "Salvar\nSalvar" e o leitor de tela anunciar
  /// **duas vezes**. Só entram os casos em que não há texto para mesclar:
  ///
  /// - `semanticsLabel` explícito (override de quem chama);
  /// - botão só-ícone, cujo nome sai do nome do arquivo do ícone — um glifo
  ///   não tem texto, e sem isto o botão seria anunciado como "botão", sem
  ///   dizer qual.
  String? get _a11yLabel {
    if (semanticsLabel != null) return semanticsLabel;
    if (label != null) return null;
    if (icon != null) {
      return icon!.split('/').last.replaceAll('.svg', '').replaceAll('-', ' ');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final bool interactive = enabled && !loading && onPressed != null;
    final bool isDark = theme.brightness == AppBrightness.dark;
    // Micro-interações (press-scale) só quando o motion global está ligado.
    final bool motionEnabled = AppMotion.enabled(context);
    final BorderRadius radius =
        this.radius ??
        theme.radiusTheme.resolve(
          override: radiusMode,
          componentDefault: componentDefaultRadius,
        );

    return AppSemantics.button(
      label: _a11yLabel,
      enabled: enabled,
      loading: loading,
      onTap: onPressed,
      child: FlocksInteraction(
        onPressed: interactive ? onPressed : null,
        onLongPress: interactive ? onLongPress : null,
        enabled: interactive,
        builder: (BuildContext context, Set<WidgetState> states) {
          final bool hovered = states.contains(WidgetState.hovered);
          final bool pressed = states.contains(WidgetState.pressed);
          final bool focused = states.contains(WidgetState.focused);
          final bool disabled = !interactive;

          // Glass usa o modelo fantasma (acento legível sobre a surface): o
          // ícone/label fica tingido do papel sobre o vidro translúcido; o realce
          // de hover/press (neutro) vira um véu sobre o vidro.
          final ButtonColors c = glass
              ? appGhostButtonColors(
                  colors,
                  color.role(colors),
                  bordered: false,
                  hovered: hovered,
                  pressed: pressed,
                  disabled: disabled,
                )
              : _filled
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
                  bordered: variant == ButtonVariant.line,
                  hovered: hovered,
                  pressed: pressed,
                  disabled: disabled,
                );

          final double height = variant == ButtonVariant.icon
              ? _iconSide
              : size.height;
          final double? width = variant == ButtonVariant.icon
              ? ((expandedWidth ?? false) ? double.infinity : _iconSide)
              : _iconOnly
              ? size.height
              : fixedWidth ??
                    ((expandedWidth ?? false) ? double.infinity : null);

          final Widget content = loading
              ? _loader(c.foreground)
              : _content(theme, c.foreground);

          final Widget inner;
          if (glass) {
            // Glass real: a superfície frosted (BackdropFilter) não cabe num
            // BoxDecoration → delega ao AppGlassSurface (que já traz blur, tint,
            // rim, sheen e sombra própria, e degrada p/ elevated opaco quando a
            // transparência está reduzida). O `c.background` (fantasma) é o véu
            // de hover/press sobre o vidro.
            Widget body = Padding(padding: _padding, child: content);
            if (width != null) body = Center(child: body);
            inner = AppGlassSurface(
              borderRadius: radius,
              child: SizedBox(
                height: height,
                width: width,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: c.background),
                  child: body,
                ),
              ),
            );
          } else {
            // Quando o botão paira ([elevate]), o fundo precisa ser OPACO para a
            // sombra não vazar pelo miolo (o outlined/ghost é transparente por
            // padrão): compõe o fundo sobre a `surface`. Nos preenchidos o fundo
            // já é opaco → no-op.
            final Color fill = elevate
                ? Color.alphaBlend(c.background, colors.surface)
                : c.background;
            inner = AnimatedContainer(
              duration: AppMotion.resolve(context, AppDurations.normal),
              curve: AppCurves.standard,
              height: height,
              width: width,
              alignment: width != null ? Alignment.center : null,
              padding: _padding,
              decoration: BoxDecoration(
                color: fill,
                borderRadius: radius,
                border: variant == ButtonVariant.line
                    ? Border.all(
                        color: c.border,
                        width: AppStrokes.m,
                        strokeAlign: BorderSide.strokeAlignInside,
                      )
                    : null,
                boxShadow: (variant == ButtonVariant.elevated || elevate)
                    ? AppElevation.symmetricShadows(isDark)
                    : null,
              ),
              child: content,
            );
          }

          // Anel de foco por fora (não desloca layout); some no toque via
          // FlocksInteraction.
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

  double get _iconSide =>
      iconSize.value + (isDense ? AppSpacings.s8 : AppSpacings.s16) * 2;

  EdgeInsetsGeometry get _padding {
    if (variant == ButtonVariant.icon) {
      return EdgeInsets.all(isDense ? AppSpacings.s8 : AppSpacings.s16);
    }
    return label != null
        ? const EdgeInsets.symmetric(horizontal: AppSpacings.s16)
        : EdgeInsets.zero;
  }

  Widget _loader(Color fg) => Center(
    child: AppCircularLoading(
      color: fg,
      size: variant == ButtonVariant.icon ? iconSize.value : size.loadingSize,
      stroke: variant == ButtonVariant.icon ? AppStrokes.l : size.loadingStroke,
    ),
  );

  Widget _content(AppThemeData theme, Color fg) {
    if (variant == ButtonVariant.icon) {
      return AppIcon(icon!, size: iconSize, color: fg);
    }
    // Só-ícone (sem label) num variant não-icon — ex.: FAB circular. Usa o glifo
    // prominente [iconOnlyGlyphSize] quando informado; senão o tamanho que casa
    // com o texto ([AppIconSize.s]), preservando o AppButton só-ícone.
    if (_iconOnly) {
      return AppIcon(
        icon!,
        size: iconOnlyGlyphSize ?? AppIconSize.s,
        color: fg,
      );
    }
    // Conteúdo passivo — não roubar o clique via seleção de texto.
    return SelectionContainer.disabled(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacings.s8,
        children: <Widget>[
          // Ícone de rótulo casa com o tamanho do texto (titleMedium, 16px) —
          // não usa o default AppIconSize.m (24px), que fica grande demais.
          if (icon != null) AppIcon(icon!, size: AppIconSize.s, color: fg),
          if (label != null)
            Flexible(
              child: AppText(
                label!,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium.copyWith(color: fg),
              ),
            ),
          // Acessório (ex.: selo de atalho) DENTRO do botão, à direita do
          // rótulo. Nunca recebe ponteiro: quem clica é o botão inteiro, e um
          // filho com gesto próprio abriria um buraco no alvo de clique.
          //
          // O acessório herda o FOREGROUND do botão: sobre um preenchimento, um
          // selo que escolhe a própria cor pela superfície do tema desaparece.
          if (trailing != null)
            IgnorePointer(
              child: AppShortcutHintColor(color: fg, child: trailing!),
            ),
        ],
      ),
    );
  }
}
