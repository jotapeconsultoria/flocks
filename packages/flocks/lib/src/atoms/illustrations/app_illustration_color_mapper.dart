import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

/// Um [ColorMapper] que substitui as cores do SVG de ilustração do app.
///
/// O SVG possui dois grupos de cores, identificados pelo `id`:
/// - `baseColor*`: cor base (traços/estrutura).
/// - `accentColor*`: cor de destaque (marca).
///
/// As cores são **obrigatórias** e resolvidas pelo [AppIllustration] (que tem
/// acesso ao tema, permitindo defaults theme-aware). O mapper permanece puro —
/// sem depender de `AppColors` — para não violar o teste de arquitetura.
///
/// Example:
/// ```dart
/// SvgPicture.file(
///   file,
///   colorMapper: AppIllustrationColorMapper(baseColor: base, accentColor: accent),
/// );
/// ```
class AppIllustrationColorMapper extends ColorMapper {
  const AppIllustrationColorMapper({
    required this.accentColor,
    required this.baseColor,
  });

  /// Cor de destaque do SVG (grupo `accentColor*`).
  final Color accentColor;

  /// Cor base do SVG (grupo `baseColor*`).
  final Color baseColor;

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) {
    if (id?.startsWith('baseColor') ?? false) {
      return baseColor;
    }

    if (id?.startsWith('accentColor') ?? false) {
      return accentColor;
    }

    return color;
  }
}
