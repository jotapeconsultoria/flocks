import 'package:flutter/widgets.dart';

import '../../atoms/bars/app_bar_surface.dart';
import '../../foundation/app_overlay_bar.dart';
import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_style.dart';
import 'app_buttons_footer_alignment_enum.dart';
import 'app_buttons_footer_platform_enum.dart';
import 'app_buttons_footer_style_enum.dart';

/// Largura fixa de cada botão quando não expandido.
const double _kButtonFixedWidth = 192.0;

/// Estimativa de altura da barra para reservar padding quando glass sobrepõe.
const double _kButtonsFooterOverlayExtent = 88.0;

/// Rodapé de ações: um botão [primary] e um [secondary] opcional, em linha
/// (default) ou coluna.
///
/// Três eixos ortogonais: [platform] = cor de fundo, [style] = arredondamento
/// dos cantos, e o novo **[barStyle]** = tratamento de superfície ([AppStyle]:
/// borda/sombra na aresta de cima; glass). [expanded] controla a largura dos
/// botões:
/// - `true` → ocupam toda a largura (`Expanded`).
/// - `false` → largura fixa 192px.
/// - `null` (AUTO, default) → 192px se couber; senão expandem.
///
/// ```dart
/// AppButtonsFooter(
///   primary: AppButton(label: 'Salvar', onPressed: save),
///   secondary: AppButton(style: AppStyle.outlined, label: 'Cancelar', onPressed: cancel),
/// )
/// ```
final class AppButtonsFooter extends StatelessWidget with AppOverlayBar {
  /// Cria um [AppButtonsFooter].
  const AppButtonsFooter({
    required this.primary,
    this.axis,
    this.alignment,
    this.barStyle = AppStyle.filled,
    this.glass,
    this.expanded,
    this.constraints,
    this.decoration,
    this.padding,
    this.platform = AppButtonsPlatformStyle.desktop,
    this.secondary,
    this.style = AppButtonsFooterStyle.page,
    super.key,
  });

  /// Alinhamento dos botões.
  final AppButtonsFooterAlignment? alignment;

  /// Eixo (horizontal por default).
  final Axis? axis;

  /// Tratamento de superfície ([AppStyle]) do render **não-glass**. Default
  /// `filled` (visual atual).
  @override
  final AppStyle barStyle;

  /// Override do eixo glass. `null` segue o global (`theme.glassTheme.enabled`).
  @override
  final bool? glass;

  /// Modo de largura dos botões. `null` = AUTO (192 se couber, senão expande).
  final bool? expanded;

  /// Restrições (a safe-area inferior é somada à altura).
  final BoxConstraints? constraints;

  /// Decoração base (`color`/`borderRadius` vencem `platform`/`style`).
  final BoxDecoration? decoration;

  /// Padding (a safe-area inferior é somada por baixo, via barra).
  final EdgeInsets? padding;

  /// Estilo de plataforma (cor de fundo).
  final AppButtonsPlatformStyle platform;

  /// Botão primário.
  final Widget primary;

  /// Botão secundário (opcional).
  final Widget? secondary;

  /// Estilo de contexto (arredondamento dos cantos).
  final AppButtonsFooterStyle style;

  @override
  BarEdge get barEdge => BarEdge.top;

  @override
  double resolveBarExtent(BuildContext context) =>
      MediaQuery.viewPaddingOf(context).bottom +
      (constraints?.maxHeight ?? _kButtonsFooterOverlayExtent);

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final double bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final bool vertical = axis == Axis.vertical;
    final int n = secondary != null ? 2 : 1;
    final EdgeInsets base = padding ?? const EdgeInsets.all(AppSpacings.s16);
    final Color fill = platform.background(theme.colorTheme);
    final BorderRadius radius =
        (decoration?.borderRadius as BorderRadius?) ??
        style.bottomRadius(theme.radiusTheme.resolveRadius());

    final Widget bar = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints cts) {
        final double perRow = (vertical ? 1 : n).toDouble();
        final double spacing = (!vertical && n == 2) ? AppSpacings.s16 : 0.0;
        final double needed =
            base.horizontal + _kButtonFixedWidth * perRow + spacing;
        // AUTO: expande só quando não cabe(m) o(s) botão(ões) de 192.
        final bool full =
            expanded ?? (cts.maxWidth.isFinite && cts.maxWidth < needed);

        Widget wrap(Widget b) => full
            ? (vertical
                  ? SizedBox(width: double.infinity, child: b)
                  : Expanded(child: b))
            : SizedBox(width: _kButtonFixedWidth, child: b);

        final List<Widget> kids = <Widget>[
          wrap(primary),
          if (secondary != null) wrap(secondary!),
        ];

        final Widget content = vertical
            ? Column(
                crossAxisAlignment:
                    alignment?.crossAxisAlignment ?? CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                spacing: AppSpacings.s16,
                children: kids,
              )
            : Row(
                mainAxisAlignment:
                    alignment?.mainAxisAlignment ?? MainAxisAlignment.end,
                spacing: AppSpacings.s16,
                children: kids,
              );
        return Padding(padding: base, child: content);
      },
    );

    Widget surface = AppBarSurface(
      style: barStyle,
      glass: resolveGlassOn(context),
      contentEdge: BarEdge.top,
      outerSafeAreaInset: bottomInset,
      fill: fill,
      borderRadius: radius == BorderRadius.zero ? null : radius,
      child: bar,
    );

    if (constraints != null) {
      surface = ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: constraints!.maxHeight + bottomInset,
          minHeight: constraints!.minHeight + bottomInset,
          maxWidth: constraints!.maxWidth,
          minWidth: constraints!.minWidth,
        ),
        child: surface,
      );
    }
    return surface;
  }
}
