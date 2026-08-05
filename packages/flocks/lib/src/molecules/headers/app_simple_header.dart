import 'package:flutter/widgets.dart';

import '../../atoms/bars/app_bar_surface.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../foundation/app_overlay_bar.dart';
import '../../theme/theme.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_style.dart';

/// Altura FIXA do conteúdo (a faixa da status bar é somada por cima). Passe
/// `constraints.maxHeight` para uma faixa mais alta.
const double kAppSimpleHeaderContentHeight = 56.0;

/// Cabeçalho simples de página: uma faixa com [child] sobre o eixo de estilo
/// [AppStyle] (`filled`/`outlined`/`elevated`), com **semântica de barra**
/// (borda/sombra na aresta de baixo) e a safe-area do topo embutida. Participa
/// também do eixo glass ([glass] ou o global): glass = blur + gradiente Notes,
/// sobrepondo o conteúdo via [AppScaffold]. Altura fixa; cor 100% do tema;
/// marcado como cabeçalho.
///
/// ```dart
/// AppSimpleHeader(child: AppText('Título'))
/// ```
final class AppSimpleHeader extends StatelessWidget with AppOverlayBar {
  /// Cria um [AppSimpleHeader].
  const AppSimpleHeader({
    required this.child,
    this.style = AppStyle.filled,
    this.glass,
    this.radiusMode,
    this.constraints,
    this.decoration,
    this.padding,
    super.key,
  });

  /// Conteúdo do cabeçalho.
  final Widget child;

  /// Tratamento de container ([AppStyle]) do render **não-glass**. Default
  /// `filled` (visual atual).
  final AppStyle style;

  /// Override do eixo glass. `null` segue o global (`theme.glassTheme.enabled`).
  @override
  final bool? glass;

  /// Modo de forma. `null` = band quadrada full-bleed.
  final AppRadiusMode? radiusMode;

  /// Restrições. `maxHeight` sobrescreve a altura fixa do conteúdo.
  final BoxConstraints? constraints;

  /// Decoração custom — **escape hatch legado** (curto-circuita o eixo de style).
  final BoxDecoration? decoration;

  /// Padding interno. Default all `s4`.
  final EdgeInsets? padding;

  @override
  AppStyle get barStyle => style;

  @override
  BarEdge get barEdge => BarEdge.bottom;

  @override
  double resolveBarExtent(BuildContext context) =>
      MediaQuery.viewPaddingOf(context).top +
      (constraints?.maxHeight ?? kAppSimpleHeaderContentHeight);

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final double topInset = MediaQuery.viewPaddingOf(context).top;
    final EdgeInsets pad = padding ?? const EdgeInsets.all(AppSpacings.s4);
    final double contentHeight =
        constraints?.maxHeight ?? kAppSimpleHeaderContentHeight;

    final Widget content = SizedBox(
      height: contentHeight,
      child: Padding(padding: pad, child: child),
    );

    if (decoration != null) {
      return AppSemantics.header(
        DecoratedBox(
          decoration: decoration!.copyWith(
            color: decoration!.color ?? theme.colorTheme.surface,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: topInset),
              content,
            ],
          ),
        ),
      );
    }

    final BorderRadius? radius = radiusMode == null
        ? null
        : theme.radiusTheme.resolve(override: radiusMode);

    return AppSemantics.header(
      AppBarSurface(
        style: style,
        glass: resolveGlassOn(context),
        contentEdge: BarEdge.bottom,
        outerSafeAreaInset: topInset,
        borderRadius: radius,
        child: content,
      ),
    );
  }
}
