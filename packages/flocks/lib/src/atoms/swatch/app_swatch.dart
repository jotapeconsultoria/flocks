import 'package:flutter/widgets.dart';

import '../../foundation/a11y/app_semantics.dart';
import '../../theme/theme.dart';
import '../../tokens/app_strokes.dart';

/// Formato do [AppSwatch] (amostra de cor).
enum AppSwatchShape {
  /// Quadrado com cantos arredondados.
  square,

  /// Círculo.
  circle,
}

/// Amostra de cor: um quadrado arredondado (ou círculo) pintado com [color].
///
/// Uma folha reusável para exibir uma cor em listas, grids e no color picker.
/// A borda sutil (`outline` do tema) destaca cores claras contra a superfície.
///
/// ```dart
/// AppSwatch(color: Color(0xFF1E88E5), semanticLabel: 'Azul')
/// ```
final class AppSwatch extends StatelessWidget {
  /// Cria um [AppSwatch].
  const AppSwatch({
    required this.color,
    this.size = 20,
    this.shape = AppSwatchShape.square,
    this.borderColor,
    this.semanticLabel,
    super.key,
  });

  /// Cor exibida.
  final Color color;

  /// Lado (ou diâmetro) do swatch em pixels lógicos.
  final double size;

  /// Formato do swatch.
  final AppSwatchShape shape;

  /// Cor da borda; quando `null` usa `theme.colorTheme.outline`.
  final Color? borderColor;

  /// Rótulo de acessibilidade (ex.: nome da cor). `null` (padrão) → decorativo.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final bool isCircle = shape == AppSwatchShape.circle;

    final Widget box = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle
            ? null
            : theme.radiusTheme.resolve(size: Size.square(size)),
        border: Border.all(
          color: borderColor ?? theme.colorTheme.outline,
          width: AppStrokes.s,
        ),
      ),
    );

    return semanticLabel == null
        ? AppSemantics.decorative(box)
        : AppSemantics.label(label: semanticLabel!, child: box);
  }
}
