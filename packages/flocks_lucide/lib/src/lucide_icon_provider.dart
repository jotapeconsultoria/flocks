import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';

import 'generated/flocks_lucide_icons.dart';
import 'generated/lucide_contract.dart';
import 'lucide_icon.dart';

/// Serve o contrato do Flocks com glifos do
/// [Lucide](https://lucide.dev), em fonte e com tree-shaking.
///
/// ```dart
/// AppThemeScope(
///   iconProvider: const LucideIconProvider(),
///   builder: (context, theme) => MyApp(theme: theme),
/// )
/// ```
///
/// ## O que este provider resolve, e o que não
///
/// Resolve os [AppIconToken] — o contrato, 55 nomes — e mais nada. Não é
/// economia de digitação: é a condição do tree-shaking. O `--tree-shake-icons`
/// remonta a fonte só com os codepoints que encontra escritos como constante no
/// app, e **tudo que este provider consegue alcançar conta como escrito**. Um
/// mapa dos 2.025 nomes deixaria os 2.025 alcançáveis e traria a fonte inteira
/// junto — 834 KB no bundle de quem instalasse o pacote, usasse ele vinte
/// ícones ou dois mil.
///
/// Para os outros, escreva a constante direto — aí o custo é de quem usa, e é
/// só o glifo citado:
///
/// ```dart
/// const LucideIcon(FlocksLucide.store)
/// ```
///
/// Quando um ícone precisa mesmo chegar por *slug* — porque quem chama é um
/// componente que recebe `String` —, declare-o em [extraIcons]. O mapa é seu, é
/// `const`, e carrega para o bundle exatamente os glifos que você listar:
///
/// ```dart
/// const LucideIconProvider(
///   extraIcons: <String, IconData>{'storefront': FlocksLucide.store},
/// )
/// ```
///
/// Um nome que não resolva em lugar nenhum desenha `circle-help`. É deliberado
/// que apareça: ícone que não resolveu é bug de integração, e um espaço em
/// branco esconde isso até a revisão de layout.
///
/// ## Um peso só
///
/// O Lucide é desenhado em stroke, e a espessura é propriedade do SVG, não uma
/// família à parte — não há aqui a matriz de seis pesos do `flocks_phosphor`,
/// porque o upstream não a publica. Uma TTF, uma família.
final class LucideIconProvider implements AppIconProvider {
  /// Cria o provider.
  const LucideIconProvider({
    this.extraIcons = const <String, IconData>{},
    this.unknown = FlocksLucide.circleHelp,
  });

  /// Slugs adicionais, além dos 55 do contrato.
  ///
  /// Tem precedência sobre o contrato, então também serve para trocar o desenho
  /// de um token quando o padrão não serve.
  final Map<String, IconData> extraIcons;

  /// O glifo desenhado quando um slug não resolve.
  final IconData unknown;

  /// O glifo de [icon], ou `null` se ele não resolve.
  IconData? resolve(String icon) => extraIcons[icon] ?? kLucideContract[icon];

  @override
  Widget build(
    BuildContext context,
    String icon, {
    required double size,
    Color? color,
  }) => LucideIcon(resolve(icon) ?? unknown, color: color, size: size);
}
