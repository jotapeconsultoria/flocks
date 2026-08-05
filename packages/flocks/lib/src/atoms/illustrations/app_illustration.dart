// coverage:ignore-file

import 'package:flutter/widgets.dart';

import '../../foundation/foundation.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import '../loadings/loadings.dart';
import 'app_illustration_size.dart';

/// The App Illustration widget.
///
/// Loads an SVG from network with local cache. Check the [SvgPicture]
/// documentation for more information click [here](https://pub.dev/packages/flutter_svg).
///
/// As cores base/destaque do SVG são resolvidas de forma theme-aware: quando não
/// informadas, usam `neutralPrimary.s900` (base) e `secondary` (destaque), que
/// adaptam a claro/escuro e à marca.
///
/// If the illustration is not found, a `danger` circle of the same size is
/// displayed. While it loads, a shimmer placeholder is shown (reduce-motion
/// aware via [AppShimmerLoading]).
///
/// [illustration] `null` desenha **nada**, e não o círculo de erro: falha e
/// ausência são estados diferentes. Um endereço que não resolve é defeito e
/// aparece; `null` é um app sem aquele asset declarado, e ali o certo é a tela
/// seguir sem ele.
///
/// Example:
/// ```dart
/// AppIllustration(
///   AppIllustrations.success,
///   size: AppIllustrationSize.xl,
/// );
/// ```
final class AppIllustration extends StatefulWidget {
  const AppIllustration(
    this.illustration, {
    this.accentColor,
    this.baseColor,
    this.size = AppIllustrationSize.l,
    this.semanticLabel,
    super.key,
  });

  /// The accent color of the illustration.
  ///
  /// When `null`, defaults to `theme.colorTheme.secondary`.
  final Color? accentColor;

  /// The base color of the illustration.
  ///
  /// When `null`, defaults to `theme.colorTheme.neutralPrimary.s900`.
  final Color? baseColor;

  /// The network url of the illustration.
  ///
  /// `null` = nada a desenhar (ver a doc da classe).
  final String? illustration;

  /// The size of the illustration.
  ///
  /// Defaults to [AppIllustrationSize.l].
  final AppIllustrationSize size;

  /// Rótulo de acessibilidade. Se `null` (padrão), a ilustração é decorativa
  /// (excluída da árvore de semântica). Forneça quando a imagem carregar
  /// informação que não esteja em texto ao lado.
  final String? semanticLabel;

  @override
  State<AppIllustration> createState() => _AppIllustrationState();
}

class _AppIllustrationState extends State<AppIllustration> {
  @override
  Widget build(BuildContext context) {
    final String? source = widget.illustration;
    if (source == null) return const SizedBox.shrink();

    final theme = AppTheme.of(context);
    final size = widget.size.value;

    final baseColor = widget.baseColor ?? theme.colorTheme.neutralPrimary.s900;
    // Neutro, não `secondary`. O preenchimento de uma ilustração é a ÁREA —
    // pele, roupa, superfície —, não um detalhe de destaque: pintá-la com a cor
    // da marca deixa a figura inteira monocromática na cor da marca. O neutro
    // claro/escuro inverte com o tema e devolve a leitura de "tinta sobre
    // papel". Quem quiser o acento de marca passa `accentColor:` no uso.
    final accentColor =
        widget.accentColor ?? theme.colorTheme.neutralPrimary.s100;

    final Widget illustration = AppCrossFade(
      child: KeyedSubtree(
        key: ValueKey<String>(source),
        child: theme.illustrationTheme.provider.build(
          context,
          source,
          accentColor: accentColor,
          baseColor: baseColor,
          placeholder: (BuildContext context) => AppShimmerLoading(
            height: size,
            width: size,
            borderRadius: theme.radiusTheme.resolve(size: Size.square(size)),
          ),
          size: size,
        ),
      ),
    );

    return widget.semanticLabel == null
        ? AppSemantics.decorative(illustration)
        : Semantics(
            image: true,
            label: widget.semanticLabel,
            child: illustration,
          );
  }
}
