import 'package:flutter/widgets.dart';

import '../../foundation/foundation.dart';
import '../../theme/theme.dart';
import '../../tokens/app_icon_token.dart';
import 'app_icon_size.dart';

/// The App Icon widget.
///
/// Desenha o ícone [icon] pelo [AppIconProvider] do tema
/// (`theme.iconTheme.provider`). O padrão do pacote são os SVGs embutidos, sem
/// rede; a marca pode apontar para um CDN, e um pacote irmão pode trazer outro
/// set inteiro. O widget não sabe de onde o desenho vem — essa é a questão.
///
/// [icon] é um slug: prefira [AppIconToken], que é o contrato que todo provider
/// garante servir. Uma URL crua também passa (o provider de rede a reconhece),
/// para compatibilidade com quem já endereçava direto.
///
/// Se o ícone não carregar, um disco do tamanho pedido aparece no lugar — um
/// asset ausente é bug de integração e não deve sumir em silêncio.
///
/// [icon] `null` é o caso oposto, e por isso é silencioso: nada é desenhado.
/// **Falha e ausência não são a mesma coisa.** Um slug que não resolve é
/// defeito, e grita; `null` é configuração — quem passa isso é um app que não
/// declarou aquele logo, e o certo ali é a tela seguir sem ele. Reservar a caixa
/// deixaria um buraco inexplicável, então o widget encolhe a zero.
///
/// Example:
/// ```dart
/// AppIcon(
///   AppIconToken.clock,
///   size: AppIconSize.xl,
/// );
/// ```
final class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    this.color,
    this.size = AppIconSize.m,
    this.customSize,
    this.semanticLabel,
    super.key,
  });

  /// O slug do ícone — normalmente um [AppIconToken].
  ///
  /// `null` = nada a desenhar (ver a doc da classe).
  final String? icon;

  /// The color of the icon.
  ///
  /// Quando `null`, o SVG mantém as próprias cores; caso contrário aplica um
  /// `ColorFilter` com esta cor. Prefira uma cor do tema (`AppTheme.of`).
  final Color? color;

  /// The size of the icon.
  ///
  /// Defaults to [AppIconSize.m].
  ///
  /// Ignored when [customSize] is provided.
  final AppIconSize size;

  /// An explicit size in logical pixels that overrides [size].
  ///
  /// Prefer [size] with an [AppIconSize] token. Use this only for the rare
  /// cases that require a value outside the design system scale.
  final double? customSize;

  /// Rótulo de acessibilidade. Se `null` (padrão), o ícone é decorativo
  /// (excluído da árvore de semântica). Forneça quando o ícone tiver
  /// significado próprio (ex.: ícone de status sem texto ao lado).
  final String? semanticLabel;

  /// Costura só-de-teste. Quando não-nulo, o [AppIcon] renderiza este builder
  /// síncrono em vez de consultar o provider do tema. É instalado por
  /// `test/flutter_test_config.dart` para que todo golden com ícone renderize
  /// um glifo determinístico, sem depender do provider em vigor. Recebe o
  /// contexto, o slug, a cor resolvida (`null` = herda a do desenho) e o
  /// tamanho em px. Sempre `null` em produção.
  @visibleForTesting
  static Widget Function(
    BuildContext context,
    String icon,
    Color? color,
    double size,
  )?
  debugIconBuilder;

  @override
  Widget build(BuildContext context) {
    final String? slug = this.icon;
    if (slug == null) return const SizedBox.shrink();

    final double resolvedSize = customSize ?? size.value;
    final Widget Function(BuildContext, String, Color?, double)? override =
        debugIconBuilder;
    final Widget icon = override != null
        ? override(context, slug, color, resolvedSize)
        : AppTheme.of(context).iconTheme.provider.build(
            context,
            slug,
            color: color,
            size: resolvedSize,
          );

    return semanticLabel == null
        ? AppSemantics.decorative(icon)
        : Semantics(image: true, label: semanticLabel, child: icon);
  }
}
