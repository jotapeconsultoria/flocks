import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';

import '../../foundation/a11y/app_semantics.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../loadings/loadings.dart';

enum _AppImageSource { network, asset, memory }

/// Placeholder mostrado enquanto uma imagem de rede carrega.
enum AppImageLoading {
  /// Spinner centralizado ([AppCircularLoading]).
  spinner,

  /// Esqueleto que preenche a caixa ([AppShimmerLoading]).
  skeleton,
}

/// Imagem raster (rede, asset ou bytes em memória) do Flocks, com loading e
/// fallback padronizados.
///
/// Complementa [AppIllustration] (SVG) e [AppAvatar] (circular). Recorta ao
/// [radius] do tema, faz cross-fade do placeholder para a imagem quando a
/// decodificação termina, e cai num [fallback] theme-aware em erro.
///
/// ```dart
/// AppImage.network(url, width: 64, height: 64)
///
/// AppImage.asset('assets/banner.png', fit: BoxFit.cover, height: 120)
///
/// AppImage.memory(qrBytes, width: 200, height: 200,
///     semanticLabel: 'QR Code do PIX')
/// ```
final class AppImage extends StatelessWidget {
  /// Imagem carregada da rede (com placeholder + fallback).
  const AppImage.network(
    String this.src, {
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.radius,
    this.semanticLabel,
    this.fallback,
    this.loading = AppImageLoading.spinner,
    super.key,
  }) : bytes = null,
       _source = _AppImageSource.network;

  /// Imagem empacotada como asset (com fallback).
  const AppImage.asset(
    String this.src, {
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.radius,
    this.semanticLabel,
    this.fallback,
    this.loading = AppImageLoading.spinner,
    super.key,
  }) : bytes = null,
       _source = _AppImageSource.asset;

  /// Imagem já **em memória** — bytes vindos da API, de um arquivo escolhido
  /// pelo usuário ou de um base64 decodificado (ver [decodeBase64]).
  ///
  /// É o caminho de um QR de PIX, de um preview de anexo, de um gráfico que o
  /// backend renderiza. Decodifica de forma assíncrona como a de rede: enquanto
  /// o primeiro frame não chega, mostra o [loading]; bytes corrompidos ou
  /// vazios caem no [fallback], nunca num frame quebrado.
  ///
  /// Usa `gaplessPlayback`: trocar [bytes] mantém o frame antigo até o novo
  /// decodificar (sem piscada). Passe uma **nova** [Uint8List] quando o
  /// conteúdo mudar — mutar a lista no lugar não invalida o cache de imagem.
  ///
  /// Pensada para payload pequeno vindo da API (um QR, um thumbnail). Arquivo
  /// grande é caso de [AppImage.network] — os bytes ficam retidos no
  /// `ImageCache` enquanto a chave viver.
  ///
  /// ```dart
  /// AppImage.memory(qrBytes, width: 200, height: 200,
  ///     semanticLabel: 'QR Code do PIX')
  /// ```
  const AppImage.memory(
    Uint8List this.bytes, {
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.radius,
    this.semanticLabel,
    this.fallback,
    this.loading = AppImageLoading.spinner,
    super.key,
  }) : src = null,
       _source = _AppImageSource.memory;

  /// URL de rede (`.network`) ou caminho de asset (`.asset`).
  /// `null` **apenas** na variante `.memory`.
  final String? src;

  /// Bytes já decodificados (`.memory`). `null` nas demais variantes.
  final Uint8List? bytes;

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

  /// Placeholder durante o carregamento/decodificação.
  final AppImageLoading loading;

  /// Decodifica base64 em bytes tolerando o que o backend costuma mandar:
  /// espaços e quebras de linha, prefixo `data:image/png;base64,` e padding
  /// ausente. Devolve `null` para nulo, vazio ou base64 inválido — o chamador
  /// testa o `null` e escolhe entre [AppImage.memory] e um estado vazio.
  ///
  /// **Decodifique UMA vez**, fora do `build` (no `initState`, no callback que
  /// recebeu a resposta): base64 de 200×200 custa alocação a cada frame.
  /// É por isso que não existe um construtor `AppImage.base64(String)`.
  ///
  /// ```dart
  /// final Uint8List? qr = AppImage.decodeBase64(res['pix_qr_base64'] as String?);
  /// // ...
  /// if (qr != null)
  ///   AppImage.memory(qr, width: 200, height: 200,
  ///       semanticLabel: 'QR Code do PIX'),
  /// ```
  static Uint8List? decodeBase64(String? source) {
    if (source == null) return null;
    final String cleaned = source
        .replaceAll(RegExp(r'\s'), '')
        .replaceFirst(RegExp('^data:[^;,]*;base64,'), '');
    if (cleaned.isEmpty) return null;
    final int rest = cleaned.length % 4;
    final String padded = rest == 0
        ? cleaned
        : cleaned.padRight(cleaned.length + (4 - rest), '=');
    try {
      return base64Decode(padded);
    } on FormatException {
      return null;
    }
  }

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
        src!,
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
        src!,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => _fallback(theme),
      ),
      // Mesmas ValueKeys ('image'/'loading') do branch de rede, para o
      // AppCrossFade casar o par e o teste achar os mesmos nós.
      _AppImageSource.memory =>
        bytes!.isEmpty
            ? _fallback(theme)
            : Image.memory(
                bytes!,
                fit: fit,
                width: width,
                height: height,
                gaplessPlayback: true,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
                    wasSynchronouslyLoaded
                    ? child
                    : AppCrossFade(
                        child: frame == null
                            ? _placeholder(theme)
                            : KeyedSubtree(
                                key: const ValueKey<String>('image'),
                                child: child,
                              ),
                      ),
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
