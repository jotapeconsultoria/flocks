import 'package:flutter/widgets.dart';
import '../../tokens/app_icon_token.dart';

/// Quem transforma um nome de ícone em pixel.
///
/// Antes disso, `AppIcon.icon` era literalmente uma URL: o pacote embutia o
/// endereço de um CDN privado, e todo adotante herdava a disponibilidade, a
/// banda e a conta de outra pessoa — além do set de ícones licenciado por ela.
/// Com o provider no tema, o nome vira contrato e o desenho vira escolha.
///
/// Duas implementações vêm no pacote: [AppAssetIconProvider] (o padrão, SVG
/// embutido, sem rede) e [AppNetworkIconProvider] (busca num CDN). Um set novo
/// — Material, Lucide, os SVGs de uma empresa — é uma classe a mais, e pode
/// morar num pacote irmão.
///
/// **O adaptador de Material precisa ser um pacote separado.** O core do Flocks
/// não importa `material.dart`, e há teste de arquitetura que barra. É essa
/// regra que sustenta a tese de "zero Material"; um provider que a viole passa
/// a valer para o pacote inteiro.
///
/// O [icon] chega como slug ([AppIconToken] é um deles). Um provider pode
/// aceitar outras formas — o [AppNetworkIconProvider] deixa passar URL crua,
/// para compatibilidade com quem já passava endereço direto.
abstract interface class AppIconProvider {
  /// Desenha [icon] com [size] de lado.
  ///
  /// [color] nulo significa "use as cores do próprio desenho" — um ícone
  /// multicolorido ou um emblema de marca. Caso contrário o desenho é tingido.
  ///
  /// Recebe o [BuildContext] porque o provider pode precisar do tema (a cor do
  /// placeholder de erro, por exemplo) e porque um provider assíncrono devolve
  /// o próprio widget com estado — é o que mantém o [AppIcon] sem `initState`.
  Widget build(
    BuildContext context,
    String icon, {
    required double size,
    Color? color,
  });
}
