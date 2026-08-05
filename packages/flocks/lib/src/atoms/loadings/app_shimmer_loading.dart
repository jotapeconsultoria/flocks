import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// The App Shimmer Loading widget — placeholder com brilho animado.
///
/// Sob reduce-motion renderiza o box base estático (sem o brilho), respeitando
/// a preferência de acessibilidade.
///
/// Example:
/// ```dart
/// AppShimmerLoading(height: AppSizes.s16, width: AppSizes.s16)
/// ```
final class AppShimmerLoading extends StatelessWidget {
  const AppShimmerLoading({
    required this.height,
    this.color,
    this.borderRadius,
    this.highlightColor,
    this.margin,
    this.width = double.infinity,
    super.key,
  });

  /// The border radius of the shimmer. Quando `null`, usa o radius médio do
  /// tema (modo redondo, proporcional ao tamanho).
  final BorderRadius? borderRadius;

  /// The base color of the shimmer. Defaults to `onSurface` (barrier).
  final Color? color;

  /// The height of the shimmer.
  final double height;

  /// The highlight color of the shimmer. Defaults to `surface` (disabled).
  final Color? highlightColor;

  /// The margin of the shimmer. Defaults to [EdgeInsets.zero].
  final EdgeInsets? margin;

  /// The width of the shimmer. Defaults to [double.infinity].
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final Color base = (color ?? theme.colorTheme.onSurface).barrier();
    final BorderRadius radius =
        borderRadius ?? theme.radiusTheme.resolve(size: Size(width, height));
    final Widget box = DecoratedBox(
      decoration: BoxDecoration(color: base, borderRadius: radius),
    );

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: SizedBox(
        width: width,
        height: height,
        child: AppMotion.enabled(context)
            ? Shimmer.fromColors(
                baseColor: base,
                highlightColor: (highlightColor ?? theme.colorTheme.surface)
                    .disabled(),
                child: box,
              )
            : box,
      ),
    );
  }
}
