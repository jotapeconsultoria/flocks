import 'package:flutter/widgets.dart';

import '../../foundation/a11y/app_semantics.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../loadings/loadings.dart';

enum _AppImageSource { network, asset }

/// Placeholder mostrado enquanto uma imagem de rede carrega.
enum AppImageLoading {
  /// Spinner centralizado ([AppCircularLoading]).
  spinner,

  /// Esqueleto que preenche a caixa ([AppShimmerLoading]).
  skeleton,
}

/// Imagem raster (rede ou asset) do Flocks, com loading e fallback padronizados.
///
/// Complementa [AppIllustration] (SVG) e [AppAvatar] (circular). Recorta ao
/// [radius] do tema, faz cross-fade do placeholder para a imagem quando a rede
/// termina, e cai num [fallback] theme-aware em erro.
///
/// ```dart
/// AppImage.network(url, width: 64, height: 64)
///
/// AppImage.asset('assets/banner.png', fit: BoxFit.cover, height: 120)
/// ```
final class AppImage extends StatelessWidget {
  /// Imagem carregada da rede (com placeholder + fallback).
  const AppImage.network(
    this.src, {
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.radius,
    this.semanticLabel,
    this.fallback,
    this.loading = AppImageLoading.spinner,
    super.key,
  }) : _source = _AppImageSource.network;

  /// Imagem empacotada como asset (com fallback).
  const AppImage.asset(
    this.src, {
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.radius,
    this.semanticLabel,
    this.fallback,
    this.loading = AppImageLoading.spinner,
    super.key,
  }) : _source = _AppImageSource.asset;

  /// URL de rede ou caminho de asset.
  final String src;

  final _AppImageSource _source;

  /// Como a imagem preenche a caixa. Default [BoxFit.cover].
  final BoxFit fit;

  /// Largura da caixa (opcional).
  final double? width;

  /// Altura da caixa (opcional).
  final double? height;

  /// Raio dos cantos. Default: global (modo redondo), proporcional à caixa.
  final BorderRadius? radius;

  /// Rótulo de acessibilidade. `null` (padrão) → imagem decorativa.
  final String? semanticLabel;

  /// Widget exibido quando a imagem falha ao carregar. Default: caixa
  /// `surfaceContainer` (placeholder neutro theme-aware).
  final Widget? fallback;

  /// Placeholder durante o carregamento de rede.
  final AppImageLoading loading;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final BorderRadius r =
        radius ??
        theme.radiusTheme.resolve(
          size: (width != null && height != null)
              ? Size(width!, height!)
              : null,
        );

    final Widget image = switch (_source) {
      _AppImageSource.network => Image.network(
        src,
        fit: fit,
        width: width,
        height: height,
        loadingBuilder: (context, child, progress) => AppCrossFade(
          child: progress == null
              ? KeyedSubtree(key: const ValueKey<String>('image'), child: child)
              : _placeholder(theme),
        ),
        errorBuilder: (context, error, stackTrace) => _fallback(theme),
      ),
      _AppImageSource.asset => Image.asset(
        src,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => _fallback(theme),
      ),
    };

    final Widget content = ClipRRect(borderRadius: r, child: image);

    return semanticLabel == null
        ? AppSemantics.decorative(content)
        : Semantics(
            image: true,
            label: semanticLabel,
            container: true,
            child: ExcludeSemantics(child: content),
          );
  }

  Widget _placeholder(AppThemeData theme) {
    final Widget child = switch (loading) {
      AppImageLoading.spinner => const Center(
        key: ValueKey<String>('loading'),
        child: AppCircularLoading(size: 24),
      ),
      AppImageLoading.skeleton => AppShimmerLoading(
        key: const ValueKey<String>('loading'),
        height: height ?? 120,
        width: width ?? double.infinity,
      ),
    };
    return SizedBox(width: width, height: height, child: child);
  }

  Widget _fallback(AppThemeData theme) =>
      fallback ??
      SizedBox(
        width: width,
        height: height,
        child: ColoredBox(color: theme.colorTheme.surfaceContainer),
      );
}
