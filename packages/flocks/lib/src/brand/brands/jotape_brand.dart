import 'package:flutter/widgets.dart';

import '../../theme/app_themes.dart';
import '../../tokens/app_radius.dart';
import '../app_brand_config.dart';

/// Configuracao de white-label do cliente JotaPe Tecnologia (marca padrao).
///
/// Paleta completa (50–950). Base de cada cor no `value` do swatch:
/// primary=Tiber@950, secondary=Orange@500, tertiary=Sherpa@900,
/// neutral=Geyser@300, success=Malachite@400, warning=Sun@400, danger=Red@400,
/// info=Sky@500 (gerado).
const AppBrandConfig jotapeBrand = AppBrandConfig(
  clientSlug: 'jotape',
  primaryColor: _primary,
  secondaryColor: _secondary,
  tertiaryColor: _tertiary,
  neutralLightColor: _neutral,
  neutralDarkColor: _neutralDark,
  successColor: _success,
  warningColor: _warning,
  dangerColor: _danger,
  infoColor: _info,
  // Global de forma da marca: cantos redondos em todos os componentes.
  radiusTheme: AppRadiusTheme(mode: AppRadiusMode.redondo),
  // Eixo glass desligado: overlays/barras/FAB/Menu/Popover ficam opacos.
  glassTheme: AppGlassTheme(enabled: false),
);

// Tiber — Primary (base 950)
const _primary = ColorSwatch<int>(0xFF0C3235, <int, Color>{
  50: Color(0xFFF2FBFA),
  100: Color(0xFFD2F5F1),
  200: Color(0xFFA5EAE3),
  300: Color(0xFF70D8D2),
  400: Color(0xFF42BFBB),
  500: Color(0xFF29A3A1),
  600: Color(0xFF1E8283),
  700: Color(0xFF1C6869),
  800: Color(0xFF1B5254),
  900: Color(0xFF1A4647),
  950: Color(0xFF0C3235),
});

// Orange — Secondary (base 500)
// Rampa do laranja da marca. Os stops escuros são gerados com o MATIZ do
// laranja base (39) travado, preservando os tons originais — só a cor muda, a
// escada de luminância e os contrastes ficam onde estavam.
//
// Antes o matiz derivava conforme escurecia (47 → 31), e no tema claro isso
// aparecia: para alcançar 4.5 sobre um cartão quase branco o resolvedor
// precisa de `s700` ou mais escuro, e ali o laranja já tinha virado vermelho.
const _secondary = ColorSwatch<int>(0xFFFF5B04, <int, Color>{
  50: Color(0xFFFFF6ED),
  100: Color(0xFFFFEAD4),
  200: Color(0xFFFFD1A8),
  300: Color(0xFFFFB070),
  400: Color(0xFFFF8437),
  500: Color(0xFFFF5B04),
  600: Color(0xFFE75200),
  700: Color(0xFFBC4100),
  800: Color(0xFF973300),
  900: Color(0xFF7C2800),
  950: Color(0xFF431200),
});

// Sherpa Blue — Tertiary (base 900)
const _tertiary = ColorSwatch<int>(0xFF075056, <int, Color>{
  50: Color(0xFFEDFFFD),
  100: Color(0xFFC3FFFB),
  200: Color(0xFF87FFF9),
  300: Color(0xFF42FFFC),
  400: Color(0xFF0CF1F5),
  500: Color(0xFF00D2D9),
  600: Color(0xFF00A5AF),
  700: Color(0xFF00818A),
  800: Color(0xFF02656D),
  900: Color(0xFF075056),
  950: Color(0xFF003138),
});

// Geyser — Neutral (base 300)
const _neutral = ColorSwatch<int>(0xFFD3DDDE, <int, Color>{
  50: Color(0xFFF9FBFB),
  100: Color(0xFFF3F6F6),
  200: Color(0xFFE4EBEC),
  300: Color(0xFFD3DDDE),
  400: Color(0xFF9AAEB1),
  500: Color(0xFF697E82),
  600: Color(0xFF496365),
  700: Color(0xFF355053),
  800: Color(0xFF1D3739),
  900: Color(0xFF0F2529),
  950: Color(0xFF020F13),
});

// Geyser invertido — Neutral (dark)
// s50 é a superfície base do tema escuro: fica fora do preto puro (tom HCT em
// [6, 16]) para permitir elevação-por-clareamento (ver COLOR_ACCESSIBILITY_RULES).
const _neutralDark = ColorSwatch<int>(0xFF355053, <int, Color>{
  50: Color(0xFF0A1E22),
  100: Color(0xFF0F2529),
  200: Color(0xFF1D3739),
  300: Color(0xFF355053),
  400: Color(0xFF496365),
  500: Color(0xFF697E82),
  600: Color(0xFF9AAEB1),
  700: Color(0xFFD3DDDE),
  800: Color(0xFFE4EBEC),
  900: Color(0xFFF3F6F6),
  950: Color(0xFFF9FBFB),
});

// Malachite — Success (base 400)
const _success = ColorSwatch<int>(0xFF48CC33, <int, Color>{
  50: Color(0xFFF1FCEF),
  100: Color(0xFFDFF9D9),
  200: Color(0xFFBEF2B5),
  300: Color(0xFF8CE57D),
  400: Color(0xFF48CC33),
  500: Color(0xFF3DB12B),
  600: Color(0xFF29841B),
  700: Color(0xFF226818),
  800: Color(0xFF1F5218),
  900: Color(0xFF1A4415),
  950: Color(0xFF092507),
});

// Sun — Warning (base 400)
const _warning = ColorSwatch<int>(0xFFFDAB02, <int, Color>{
  50: Color(0xFFFFFAE8),
  100: Color(0xFFFEEFC0),
  200: Color(0xFFFEDD7B),
  300: Color(0xFFFDC536),
  400: Color(0xFFFDAB02),
  500: Color(0xFFE18404),
  600: Color(0xFFC76202),
  700: Color(0xFFA64204),
  800: Color(0xFF873309),
  900: Color(0xFF6E2A0B),
  950: Color(0xFF401401),
});

// Red — Error/Danger (base 400)
const _danger = ColorSwatch<int>(0xFFFB1504, <int, Color>{
  50: Color(0xFFFFEDEC),
  100: Color(0xFFFED8D5),
  200: Color(0xFFFEB7B2),
  300: Color(0xFFFD867D),
  400: Color(0xFFFB1504),
  500: Color(0xFFD61203),
  600: Color(0xFFB71306),
  700: Color(0xFF9B0E03),
  800: Color(0xFF7E1007),
  900: Color(0xFF68120B),
  950: Color(0xFF390501),
});

// Sky — Info (gerado, base 500)
const _info = ColorSwatch<int>(0xFF0EA5E9, <int, Color>{
  50: Color(0xFFF0F9FF),
  100: Color(0xFFE0F2FE),
  200: Color(0xFFBAE6FD),
  300: Color(0xFF7DD3FC),
  400: Color(0xFF38BDF8),
  500: Color(0xFF0EA5E9),
  600: Color(0xFF0284C7),
  700: Color(0xFF0369A1),
  800: Color(0xFF075985),
  900: Color(0xFF0C4A6E),
  950: Color(0xFF082F49),
});
