import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';

import 'demo_config.dart';

/// O slug da marca que a demo monta.
///
/// Vira o nome da variável no snippet que o visitante leva (`demoBrand`), e
/// nomeia a configuração como o `flocks` espera. Não é editável porque o
/// contrato de URL é fechado — um campo a mais aqui seria um campo que o link
/// compartilhado não carregaria.
const String kDemoSlug = 'demo';

/// A saturação e a luminosidade do neutro tingido.
///
/// Não são números escolhidos no olho: são os do `Color(0xFF6B7280)` que a
/// `flocksBrand` usa como semente da própria rampa neutra — uma cor que passa o
/// contrato de contraste do pacote. Reaproveitá-los faz o neutro do visitante
/// nascer na mesma vizinhança perceptual do neutro que já é testado.
const double _kNeutralSaturation = 0.09;
const double _kNeutralLightness = 0.46;

/// Monta a marca inteira a partir do que o visitante escolheu.
///
/// ## Por que o neutro também é tingido
///
/// Se só o primário seguisse a semente, a demo provaria pouco: botões e badges
/// coloridos sobre um cinza que continua sendo o cinza do Flocks. Tingir a rampa
/// neutra é o que faz a página, o rail e os cartões parecerem do MESMO sistema
/// da marca — a diferença entre "o app do Flocks com a cor dele" e "o app dele".
///
/// O tingimento é contido de propósito: a semente do visitante é rebaixada a uma
/// saturação baixa antes de virar rampa, senão uma marca saturada devolveria
/// superfícies berrantes e ilegíveis. O matiz sobrevive; o croma, não.
///
/// ## E por que `neutralSwatchFromSeed`, e não `swatchFromSeed`
///
/// São escadas de tom diferentes, e a cromática reprovaria o contraste entre
/// `surface` (s300) e `outline` (s600) em TODA marca gerada por semente — está
/// documentado na própria função do pacote. A rampa neutra existe exatamente
/// para este uso.
AppBrandConfig brandFromConfig(DemoConfig config) {
  final ColorSwatch<int> neutralLight = neutralSwatchFromSeed(
    _neutralSeed(config.seed),
  );
  return AppBrandConfig(
    clientSlug: kDemoSlug,
    primaryColor: swatchFromSeed(config.seed),
    neutralLightColor: neutralLight,
    // No escuro a rampa inverte: o s50 passa a ser o tom mais ESCURO. Espelhar
    // mantém a semântica que o tema espera sem uma segunda escolha de cor.
    neutralDarkColor: flippedSwatch(neutralLight),
    radiusTheme: AppRadiusTheme(mode: config.radius),
    styleTheme: AppStyleTheme(style: config.style),
    typography: AppBrandTypography(
      bodyFamily: config.font.family,
      displayFamily: config.font.family,
    ),
  );
}

/// O tema pronto para a árvore de widgets.
AppThemeData themeFromConfig(DemoConfig config) =>
    AppThemeData.forBrand(brandFromConfig(config), dark: config.dark);

/// A semente da rampa neutra: o matiz da marca, quase sem croma.
///
/// A conversão passa por HSL, e não por HCT, para não arrastar o
/// `material_color_utilities` até aqui — o `flocks` já faz o trabalho fino em
/// HCT dentro de `neutralSwatchFromSeed`, e o que esta função precisa é só
/// entregar um cinza tingido para ele.
Color _neutralSeed(Color seed) => HSLColor.fromColor(seed)
    .withSaturation(_kNeutralSaturation)
    .withLightness(_kNeutralLightness)
    .toColor();
