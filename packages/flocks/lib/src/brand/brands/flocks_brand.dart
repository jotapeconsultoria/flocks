import 'package:flutter/widgets.dart';

import '../../theme/app_themes.dart';
import '../../tokens/app_font_families.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/swatch_generator.dart';
import '../app_brand_config.dart';
import '../app_brand_typography.dart';

/// A marca do próprio design system — e a prova viva da tese white-label.
///
/// As outras marcas escrevem 7 a 9 escalas de cor à mão, 11 stops cada: mais de
/// setenta valores hexadecimais que alguém precisou escolher e manter
/// coerentes. Aqui há **uma semente**, e [swatchFromSeed] deriva o resto
/// variando o tom em HCT (perceptualmente uniforme), o que preserva matiz e
/// croma e dá contraste consistente entre os stops — diferente de interpolar
/// luminosidade em HSL.
///
/// O que ela demonstra, junto:
///
/// - **cor**: a paleta inteira de um hex;
/// - **tipografia**: Space Grotesk na display, Poppins no corpo — o eixo que a
///   marca passou a controlar;
/// - **ícone**: sem provider declarado, cai no padrão do pacote (os SVGs
///   embutidos) — como todas, desde que a base de CDN saiu da marca.
///
/// Passa o mesmo contrato de contraste AA das outras
/// (`test/src/theme/contrast_test.dart`) — a semente foi escolhida para passar,
/// não o gate afrouxado para aceitá-la.
///
/// Não entra em `kGoldenBrands`: a matriz golden é marca × brilho, e uma
/// terceira marca levaria as 302 imagens a 453 sem provar nada que as duas já
/// não provem.
final AppBrandConfig flocksBrand = AppBrandConfig(
  clientSlug: 'flocks',
  primaryColor: _primary,
  secondaryColor: _secondary,
  neutralLightColor: _neutralLight,
  neutralDarkColor: _neutralDark,
  radiusTheme: const AppRadiusTheme(mode: AppRadiusMode.redondo),
  typography: const AppBrandTypography(
    displayFamily: AppFontFamilies.spaceGrotesk,
  ),
);

/// A semente da marca: um índigo profundo.
const Color _seed = Color(0xFF4F46E5);

/// A semente de apoio, usada em destaque e realce.
const Color _accentSeed = Color(0xFFE5484D);

final ColorSwatch<int> _primary = swatchFromSeed(_seed);
final ColorSwatch<int> _secondary = swatchFromSeed(_accentSeed);

/// O neutro puxa um pouco do matiz da marca em vez de ser cinza morto — é o que
/// faz a superfície parecer da mesma família que o primário.
final ColorSwatch<int> _neutralLight = neutralSwatchFromSeed(
  const Color(0xFF6B7280),
);

/// No escuro a rampa inverte: o stop 50 é o mais ESCURO. Reconstruir espelhando
/// os stops mantém a semântica que o resto do tema espera (`s50` = fundo,
/// `s900` = conteúdo) sem duplicar a escolha de cor.
final ColorSwatch<int> _neutralDark = flippedSwatch(_neutralLight);
