import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';

import 'generated/flocks_phosphor_bold.dart';
import 'generated/flocks_phosphor_duotone.dart';
import 'generated/flocks_phosphor_fill.dart';
import 'generated/flocks_phosphor_light.dart';
import 'generated/flocks_phosphor_regular.dart';
import 'generated/flocks_phosphor_thin.dart';
import 'generated/phosphor_contract.dart';
import 'phosphor_duotone_icon_data.dart';
import 'phosphor_icon.dart';
import 'phosphor_weight.dart';

/// Serve o contrato do Flocks com glifos do
/// [Phosphor](https://phosphoricons.com), em qualquer um dos 6 pesos.
///
/// ```dart
/// AppThemeScope(
///   iconProvider: const PhosphorIconProvider(weight: PhosphorWeight.bold),
///   builder: (context, theme) => MyApp(theme: theme),
/// )
/// ```
///
/// ## O que este provider resolve, e o que não
///
/// Resolve os [AppIconToken] — o contrato, 55 nomes — e mais nada. Não é
/// economia de digitação: é a condição do tree-shaking. O `--tree-shake-icons`
/// remonta cada fonte só com os codepoints que encontra escritos como constante
/// no app, e **tudo que este provider consegue alcançar conta como escrito**.
/// Um mapa dos 1.512 nomes deixaria os 1.512 alcançáveis e traria a fonte
/// inteira de volta — que é exatamente o defeito que a versão em SVG deste
/// pacote tinha, só que em outro formato.
///
/// Para os outros 1.457 ícones, escreva a classe do peso direto — aí o custo é
/// de quem usa, e é só o glifo citado:
///
/// ```dart
/// const PhosphorIcon(FlocksPhosphorBold.storefront)
/// ```
///
/// Quando um ícone precisa mesmo chegar por *slug* — porque quem chama é um
/// componente que recebe `String` —, declare-o em [extraIcons]. O mapa é seu, é
/// `const`, e carrega para o bundle exatamente os glifos que você listar:
///
/// ```dart
/// const PhosphorIconProvider(
///   extraIcons: <String, IconData>{
///     'storefront': FlocksPhosphorRegular.storefront,
///   },
/// )
/// ```
///
/// Um nome que não resolva em lugar nenhum desenha `question`. É deliberado que
/// apareça: ícone que não resolveu é bug de integração, e um espaço em branco
/// esconde isso até a revisão de layout.
final class PhosphorIconProvider implements AppIconProvider {
  /// Cria o provider. [weight] default [PhosphorWeight.regular], que é o peso
  /// com que o design system foi desenhado.
  const PhosphorIconProvider({
    this.extraDuotoneIcons = const <String, PhosphorDuotoneIconData>{},
    this.extraIcons = const <String, IconData>{},
    this.weight = PhosphorWeight.regular,
  });

  /// Slugs adicionais quando [weight] é [PhosphorWeight.duotone].
  ///
  /// Existe separado de [extraIcons] porque duotone é dois glifos, e o tipo
  /// registra isso. Ver [PhosphorDuotoneIconData].
  final Map<String, PhosphorDuotoneIconData> extraDuotoneIcons;

  /// Slugs adicionais para os cinco pesos de glifo único.
  ///
  /// Tem precedência sobre o contrato, então também serve para trocar o desenho
  /// de um token quando o padrão não serve.
  final Map<String, IconData> extraIcons;

  /// O peso servido. Trocar aqui restila o ícone do app inteiro.
  final PhosphorWeight weight;

  /// O glifo de [icon] neste peso, ou `null` se ele não resolve.
  ///
  /// Só responde pelos cinco pesos de glifo único — em [PhosphorWeight.duotone]
  /// devolve `null` sempre, porque ali um glifo só é meio ícone. Use
  /// [resolveDuotone].
  IconData? resolve(String icon) => weight == PhosphorWeight.duotone
      ? null
      : extraIcons[icon] ?? _contract[icon];

  /// O par de glifos de [icon] em [PhosphorWeight.duotone], ou `null`.
  ///
  /// Devolve `null` em qualquer outro peso.
  ///
  /// O par é montado aqui, em execução, a partir de dois mapas de `IconData`.
  /// Parece um rodeio — um mapa de [PhosphorDuotoneIconData] seria mais direto
  /// — e foi assim primeiro, até a medição mostrar que o `--tree-shake-icons`
  /// não enxerga `IconData` aninhado dentro de outro objeto constante dentro de
  /// um mapa constante: um app em `duotone` embarcava a fonte com ZERO glifos
  /// do contrato e desenhava tudo em branco, só no build de release. Montar o
  /// par aqui não custa nada (nenhum `IconData` é construído, só referenciado)
  /// e mantém os glifos na fonte.
  PhosphorDuotoneIconData? resolveDuotone(String icon) {
    if (weight != PhosphorWeight.duotone) {
      return null;
    }
    if (extraDuotoneIcons[icon] case final PhosphorDuotoneIconData glyph) {
      return glyph;
    }
    if (kPhosphorContractDuotoneFigure[icon] case final IconData figure) {
      return PhosphorDuotoneIconData(
        figure: figure,
        ground: kPhosphorContractDuotoneGround[icon],
      );
    }
    return null;
  }

  Map<String, IconData> get _contract => switch (weight) {
    PhosphorWeight.thin => kPhosphorContractThin,
    PhosphorWeight.light => kPhosphorContractLight,
    PhosphorWeight.regular => kPhosphorContractRegular,
    PhosphorWeight.bold => kPhosphorContractBold,
    PhosphorWeight.fill => kPhosphorContractFill,
    // O contrato de duotone tem outro tipo, e quem o lê é `resolveDuotone`.
    PhosphorWeight.duotone => const <String, IconData>{},
  };

  /// O glifo desenhado quando um slug não resolve.
  ///
  /// `question` no peso em vigor, e não um glifo fixo: um interrogação em
  /// `bold` no meio de uma interface `thin` seria um segundo defeito em cima do
  /// primeiro.
  IconData get _unknown => switch (weight) {
    PhosphorWeight.thin => FlocksPhosphorThin.question,
    PhosphorWeight.light => FlocksPhosphorLight.question,
    PhosphorWeight.regular => FlocksPhosphorRegular.question,
    PhosphorWeight.bold => FlocksPhosphorBold.question,
    PhosphorWeight.fill => FlocksPhosphorFill.question,
    PhosphorWeight.duotone => FlocksPhosphorDuotone.question.figure,
  };

  @override
  Widget build(
    BuildContext context,
    String icon, {
    required double size,
    Color? color,
  }) {
    if (resolveDuotone(icon) case final PhosphorDuotoneIconData glyph) {
      return PhosphorDuotoneIcon(glyph, color: color, size: size);
    }
    return PhosphorIcon(resolve(icon) ?? _unknown, color: color, size: size);
  }
}
