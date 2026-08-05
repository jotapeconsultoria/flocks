import 'package:flutter/widgets.dart';

/// Quem transforma um nome de ilustração em pixel.
///
/// Espelha o [AppIconProvider], e pelo mesmo motivo: `AppIllustrations`
/// interpolava a URL de um CDN privado dentro do pacote, servindo assets de um
/// set licenciado. Com o provider no tema, o nome vira contrato e o desenho
/// vira escolha.
///
/// Duas implementações vêm no pacote: [AppAssetIllustrationProvider] (o padrão,
/// SVG embutido, sem rede) e [AppNetworkIllustrationProvider] (busca num CDN).
///
/// Diferente do ícone, a ilustração tem **duas** cores: a tinta e o
/// preenchimento. Um provider recebe as duas já resolvidas pelo tema.
abstract interface class AppIllustrationProvider {
  /// Desenha [illustration] com [size] de lado.
  ///
  /// [baseColor] é a tinta (traço, áreas escuras); [accentColor] o
  /// preenchimento. O provider decide como aplicá-las — o de assets troca por
  /// `id` do nó SVG.
  ///
  /// [placeholder] é o que aparece enquanto o desenho não chegou. Quem sabe
  /// **quando** há espera é o provider (o de rede espera; o de asset quase
  /// não), mas quem decide **como** a espera aparece é o componente — por isso
  /// vem de fora, já construído.
  Widget build(
    BuildContext context,
    String illustration, {
    required Color accentColor,
    required Color baseColor,
    required WidgetBuilder placeholder,
    required double size,
  });
}
