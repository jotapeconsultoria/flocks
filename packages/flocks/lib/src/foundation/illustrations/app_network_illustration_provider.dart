import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../../atoms/illustrations/app_illustration_color_mapper.dart';
import 'app_illustration_provider.dart';

/// Busca a ilustração num CDN.
///
/// É o comportamento que o pacote tinha por padrão, agora com o endereço vindo
/// de fora: o app declara o seu CDN em vez de o pacote embutir o de alguém.
/// Vale quando o catálogo é maior do que cabe no bundle.
///
/// Uma [illustration] que já seja `http://` ou `https://` passa direto, sem
/// concatenar [baseUrl] — compatibilidade com quem passava URL crua.
final class AppNetworkIllustrationProvider implements AppIllustrationProvider {
  /// Cria o provider apontando para [baseUrl].
  const AppNetworkIllustrationProvider({
    required this.baseUrl,
    this.extension = '.svg',
  });

  /// Raiz onde as ilustrações estão hospedadas, sem barra no fim.
  final String baseUrl;

  /// Sufixo do arquivo. Vazio para um CDN que serve sem extensão.
  final String extension;

  /// O endereço de [illustration] — ele mesmo, se já for absoluto.
  String urlFor(String illustration) =>
      illustration.startsWith('http://') || illustration.startsWith('https://')
      ? illustration
      : '$baseUrl/$illustration$extension';

  @override
  Widget build(
    BuildContext context,
    String illustration, {
    required Color accentColor,
    required Color baseColor,
    required WidgetBuilder placeholder,
    required double size,
  }) => SvgPicture.network(
    urlFor(illustration),
    alignment: Alignment.center,
    colorMapper: AppIllustrationColorMapper(
      accentColor: accentColor,
      baseColor: baseColor,
    ),
    excludeFromSemantics: true,
    fit: BoxFit.contain,
    height: size,
    placeholderBuilder: placeholder,
    width: size,
  );
}
