import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../../atoms/illustrations/app_illustration_color_mapper.dart';
import 'app_illustration_provider.dart';

/// O provider padrão: os SVGs que vêm dentro do pacote.
///
/// Serve o contrato de `AppIllustrationToken` a partir de
/// `assets/illustrations/<slug>.svg`, sem rede. As ilustrações são do
/// [Open Peeps](https://www.openpeeps.com) sob CC0 — licença e procedência em
/// `assets/illustrations/`.
///
/// Um slug fora do contrato cai no placeholder de erro. Para um catálogo maior,
/// use o [AppNetworkIllustrationProvider].
final class AppAssetIllustrationProvider implements AppIllustrationProvider {
  /// Cria o provider de assets. [package] é de onde os SVGs saem.
  const AppAssetIllustrationProvider({this.package = 'flocks'});

  /// O pacote que empacota `assets/illustrations/`. `null` para os do app.
  final String? package;

  @override
  Widget build(
    BuildContext context,
    String illustration, {
    required Color accentColor,
    required Color baseColor,
    required WidgetBuilder placeholder,
    required double size,
  }) => SvgPicture.asset(
    'assets/illustrations/$illustration.svg',
    package: package,
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
