import 'package:flutter/widgets.dart';

import '../../atoms/bars/app_bar_surface.dart';
import '../../foundation/app_overlay_bar.dart';
import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_style.dart';

/// Altura máxima do conteúdo (a safe-area inferior é somada por baixo).
const double kAppSimpleFooterContentHeight = 80.0;

/// Rodapé simples: uma faixa com [child] sobre o eixo de estilo [AppStyle]
/// (`filled`/`outlined`/`elevated`), com **semântica de barra** (borda/sombra na
/// aresta de cima) e a safe-area inferior embutida. Participa também do eixo
/// glass ([glass] ou o global): glass = blur + gradiente Notes.
///
/// ```dart
/// AppSimpleFooter(child: AppText('© 2026'))
/// ```
final class AppSimpleFooter extends StatelessWidget with AppOverlayBar {
  /// Cria um [AppSimpleFooter].
  const AppSimpleFooter({
    required this.child,
    this.style = AppStyle.filled,
    this.glass,
    this.constraints,
    this.decoration,
    this.padding,
    super.key,
  });

  /// Conteúdo do rodapé.
  final Widget child;

  /// Tratamento de container ([AppStyle]) do render **não-glass**. Default
  /// `filled` (visual atual).
  final AppStyle style;

  /// Override do eixo glass. `null` segue o global (`theme.glassTheme.enabled`).
  @override
  final bool? glass;

  /// Restrições (`maxHeight` limita o conteúdo; a safe-area é somada por baixo).
  final BoxConstraints? constraints;

  /// Decoração custom — `color`/`borderRadius` alimentam a barra.
  final BoxDecoration? decoration;

  /// Padding interno. Default all `s16`.
  final EdgeInsets? padding;

  @override
  AppStyle get barStyle => style;

  @override
  BarEdge get barEdge => BarEdge.top;

  @override
  double resolveBarExtent(BuildContext context) =>
      MediaQuery.viewPaddingOf(context).bottom +
      (constraints?.maxHeight ?? kAppSimpleFooterContentHeight);

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final double bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final EdgeInsets base = padding ?? const EdgeInsets.all(AppSpacings.s16);

    final Widget content = ConstrainedBox(
      constraints:
          constraints ??
          const BoxConstraints(maxHeight: kAppSimpleFooterContentHeight),
      child: Padding(padding: base, child: child),
    );

    return AppBarSurface(
      style: style,
      glass: resolveGlassOn(context),
      contentEdge: BarEdge.top,
      outerSafeAreaInset: bottomInset,
      fill: decoration?.color ?? theme.colorTheme.surface,
      borderRadius: decoration?.borderRadius as BorderRadius?,
      child: content,
    );
  }
}
