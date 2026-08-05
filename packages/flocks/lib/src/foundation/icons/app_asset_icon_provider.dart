import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../../tokens/app_icon_token.dart';
import 'app_icon_provider.dart';

/// O provider padrão: os SVGs que vêm dentro do pacote.
///
/// É o que faz o Flocks funcionar no primeiro `flutter run` — sem rede, sem
/// CDN, sem conta de terceiro, e determinístico em teste. Serve os 55
/// [AppIconToken] a partir de `assets/icons/<slug>.svg`.
///
/// Os desenhos são do [Phosphor Icons](https://phosphoricons.com) (MIT); a
/// licença e a tradução de cada nome estão em `assets/icons/`. Um slug fora do
/// contrato — os ~880 de [AppIcons] que não têm arquivo — cai no placeholder de
/// erro. Para o catálogo inteiro, use [AppNetworkIconProvider].
final class AppAssetIconProvider implements AppIconProvider {
  /// Cria o provider de assets. [package] é de onde os SVGs saem; o default é o
  /// próprio Flocks, e trocá-lo aponta para os assets de um pacote irmão que
  /// siga a mesma convenção de nome.
  const AppAssetIconProvider({this.package = 'flocks'});

  /// O pacote que empacota `assets/icons/`. `null` para os assets do próprio
  /// app.
  final String? package;

  @override
  Widget build(
    BuildContext context,
    String icon, {
    required double size,
    Color? color,
  }) => SvgPicture.asset(
    'assets/icons/$icon.svg',
    package: package,
    alignment: Alignment.center,
    colorFilter: color != null
        ? ColorFilter.mode(color, BlendMode.srcIn)
        : null,
    excludeFromSemantics: true,
    fit: BoxFit.contain,
    height: size,
    placeholderBuilder: (_) => SizedBox.square(dimension: size),
    width: size,
  );
}
