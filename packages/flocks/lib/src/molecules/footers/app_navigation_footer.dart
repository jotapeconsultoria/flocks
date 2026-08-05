import 'package:flutter/widgets.dart';

import '../../atoms/bars/app_bar_surface.dart';
import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../foundation/app_overlay_bar.dart';
import '../../foundation/flocks_interaction.dart';
import '../../motion/app_motion.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_strokes.dart';
import '../../tokens/app_style.dart';
import '../../tokens/swatch_generator.dart';
import 'app_navigation_footer_fab_alignment.dart';

/// Margem flutuante (L/R/bottom) da barra destacada.
const double _kNavFooterMargin = AppSpacings.s12;

/// Raio dos cantos — escala própria (como o bottom sheet), maior que o global.
const double _kNavFooterCornerRadius = 28.0;

/// Altura do conteúdo da barra (itens).
const double _kNavFooterHeight = 64.0;

/// Inset da pílula (indicador) e do realce de hover dentro da célula — os dois
/// compartilham este inset para casarem em tamanho e forma.
const EdgeInsets _kNavPillInset = EdgeInsets.all(AppSpacings.s4);

/// Posição-x do indicador para o item `i` de `n` (células iguais de 1/n).
double _navAlignX(int i, int n) => n <= 1 ? 0 : -1 + 2 * i / (n - 1);

/// Dados de um item do [AppNavigationFooter].
final class AppNavigationFooterItemData {
  /// Cria um [AppNavigationFooterItemData].
  const AppNavigationFooterItemData({
    required this.icon,
    required this.route,
    required this.onPressed,
    this.title,
    this.activeIcon,
    this.activeTitle,
    this.activeColor,
    this.inactiveColor,
  });

  /// URL do ícone (estado inativo).
  final String icon;

  /// Ícone do estado ativo. `null` → usa [icon].
  final String? activeIcon;

  /// Título (inativo, opcional).
  final String? title;

  /// Título do estado ativo. `null` → usa [title].
  final String? activeTitle;

  /// Cor do conteúdo ativo. `null` → acento legível de `secondary`.
  final Color? activeColor;

  /// Cor do conteúdo inativo. `null` → neutro legível.
  final Color? inactiveColor;

  /// Rota que o item representa.
  final String route;

  /// Navega para [route] quando o item é tocado.
  final void Function(BuildContext context, String route) onPressed;
}

/// Barra de navegação inferior **flutuante** (como o bottom sheet): margens
/// destacadas, cantos arredondados, participando do eixo de estilo [AppStyle]
/// (incl. `glass`). Um **indicador deslizante** (pílula) anima por trás do item
/// ativo (mecânica do `AppSegmentedButton`), e um **FAB isolado** opcional pode
/// aparecer ao lado (start/end), separado da barra.
///
/// Cada item suporta ícone/label/cor **ativo e inativo** (ativos opcionais, com
/// fallback para o inativo). Cores 100% do tema. Sob `glass`, sobrepõe o
/// conteúdo via [AppScaffold] (efeito Notes).
final class AppNavigationFooter extends StatelessWidget with AppOverlayBar {
  /// Cria um [AppNavigationFooter].
  const AppNavigationFooter({
    required this.items,
    required this.getCurrentRoute,
    this.style = AppStyle.filled,
    this.glass,
    this.radiusMode,
    this.radius,
    this.fab,
    this.fabAlignment = AppNavFooterFabAlignment.end,
    this.itemPadding,
    super.key,
  });

  /// Itens da barra.
  final List<AppNavigationFooterItemData> items;

  /// Rota atual (para destacar o item ativo).
  final String Function(BuildContext context) getCurrentRoute;

  /// Tratamento de container ([AppStyle]) do render **não-glass**. Default
  /// `filled`.
  final AppStyle style;

  /// Override do eixo glass. `null` segue o global (`theme.glassTheme.enabled`).
  @override
  final bool? glass;

  /// Modo de forma dos cantos. `reto` = quadrado; qualquer outro = 28px.
  final AppRadiusMode? radiusMode;

  /// Override cru do raio (vence [radiusMode]).
  final BorderRadius? radius;

  /// FAB isolado opcional (ex.: `AppFloatingButton`), **irmão** da barra.
  final Widget? fab;

  /// Lado do FAB isolado. Default `end`.
  final AppNavFooterFabAlignment fabAlignment;

  /// Padding de cada item. Default all `s8`.
  final EdgeInsets? itemPadding;

  @override
  AppStyle get barStyle => style;

  @override
  BarEdge get barEdge => BarEdge.top;

  @override
  double resolveBarExtent(BuildContext context) =>
      MediaQuery.viewPaddingOf(context).bottom +
      _kNavFooterMargin +
      _kNavFooterHeight;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final double bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    final AppRadiusMode radiusModeEff = radiusMode ?? theme.radiusTheme.mode;
    final double rr = radiusModeEff == AppRadiusMode.reto
        ? 0.0
        : _kNavFooterCornerRadius;
    final BorderRadius barBR = radius ?? BorderRadius.circular(rr);

    final String current = getCurrentRoute(context);
    final int selectedIndex = items.indexWhere(
      (AppNavigationFooterItemData it) => it.route == current,
    );

    final bool glassOn = resolveGlassOn(context);
    final Widget bar = AppBarSurface(
      style: style,
      glass: glassOn,
      floating: true,
      contentEdge: BarEdge.top,
      borderRadius: barBR,
      child: SizedBox(
        height: _kNavFooterHeight,
        child: _NavBarBody(
          items: items,
          selectedIndex: selectedIndex,
          itemPadding: itemPadding,
        ),
      ),
    );

    Widget floating = bar;
    final Widget? fabWidget = fab;
    if (fabWidget != null) {
      final Widget barExpanded = Expanded(child: bar);
      floating = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: fabAlignment == AppNavFooterFabAlignment.end
            ? <Widget>[
                barExpanded,
                const SizedBox(width: _kNavFooterMargin),
                fabWidget,
              ]
            : <Widget>[
                fabWidget,
                const SizedBox(width: _kNavFooterMargin),
                barExpanded,
              ],
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        left: _kNavFooterMargin,
        right: _kNavFooterMargin,
        bottom: _kNavFooterMargin + bottomInset,
      ),
      child: floating,
    );
  }
}

/// Corpo da barra: indicador deslizante (Stack) + linha de itens iguais.
class _NavBarBody extends StatelessWidget {
  const _NavBarBody({
    required this.items,
    required this.selectedIndex,
    required this.itemPadding,
  });

  final List<AppNavigationFooterItemData> items;
  final int selectedIndex;
  final EdgeInsets? itemPadding;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final int n = items.length;
    final Color active = readableStopOn(colors.primary, colors.surface);

    final Widget indicator = selectedIndex < 0 || n == 0
        ? const SizedBox.shrink()
        : Positioned.fill(
            child: AnimatedAlign(
              alignment: Alignment(_navAlignX(selectedIndex, n), 0),
              duration: AppMotion.resolve(context, AppDurations.normal),
              curve: AppCurves.standard,
              child: FractionallySizedBox(
                widthFactor: 1 / n,
                heightFactor: 1,
                child: Padding(
                  padding: _kNavPillInset,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      // Pílula sutil (não sólida) para o conteúdo ativo ficar
                      // legível. Chapada nos DOIS eixos, de propósito: no vidro
                      // quem ganha rim/brilho é a **estrutura** (a cápsula, via
                      // AppGlassSurface), nunca o seletor — senão o efeito lê
                      // invertido, como se o item ativo fosse o vidro.
                      color: active.withValues(alpha: 0.14),
                      borderRadius: theme.radiusTheme.resolve(),
                    ),
                  ),
                ),
              ),
            ),
          );

    return Stack(
      children: <Widget>[
        indicator,
        Row(
          children: <Widget>[
            for (int i = 0; i < n; i++)
              Expanded(
                child: _NavItem(
                  item: items[i],
                  isSelected: i == selectedIndex,
                  padding: itemPadding,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.item, required this.isSelected, this.padding});

  final AppNavigationFooterItemData item;
  final bool isSelected;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final Color content = isSelected
        ? (item.activeColor ?? readableStopOn(colors.primary, colors.surface))
        : (item.inactiveColor ?? colors.neutralPrimary.s600);
    final String icon = isSelected ? (item.activeIcon ?? item.icon) : item.icon;
    final String? title = isSelected
        ? (item.activeTitle ?? item.title)
        : item.title;
    void onTap() => item.onPressed(context, item.route);

    return AppSemantics.button(
      label: title,
      onTap: onTap,
      child: FlocksInteraction(
        onPressed: onTap,
        selected: isSelected,
        builder: (BuildContext context, Set<WidgetState> states) {
          final bool hovered = states.contains(WidgetState.hovered);
          final bool pressed = states.contains(WidgetState.pressed);
          final bool focused = states.contains(WidgetState.focused);
          final Color overlay = pressed
              ? colors.onSurface.withValues(alpha: 0.12)
              : hovered
              ? colors.onSurface.withValues(alpha: 0.08)
              : colors.transparent;

          // O alvo de toque é a célula inteira (FlocksInteraction hit-test
          // opaco), mas o realce visual fica INSET, igual à pílula do indicador.
          return Padding(
            padding: _kNavPillInset,
            child: AnimatedContainer(
              duration: AppMotion.resolve(context, AppDurations.fast),
              curve: AppCurves.standard,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: overlay,
                borderRadius: theme.radiusTheme.resolve(),
                border: Border.all(
                  color: focused ? colors.focusRing : colors.transparent,
                  width: AppStrokes.m,
                ),
              ),
              padding: padding ?? const EdgeInsets.all(AppSpacings.s4),
              child: SelectionContainer.disabled(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  spacing: AppSpacings.s4,
                  children: <Widget>[
                    AppIcon(icon, size: AppIconSize.m, color: content),
                    if (title != null)
                      AppText(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelMedium.copyWith(
                          color: content,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
