import 'package:flutter/widgets.dart';

import '../../theme/app_themes.dart';
import '../../tokens/app_radius.dart';
import '../app_brand_config.dart';

/// Configuracao de white-label da marca ZX Track.
///
/// Paleta parcial: primary (Persian Red @600), neutral (Chicago @600) e
/// semanticas (Malachite/Saffron/Cinnabar + info azul gerado). NÃO define
/// secondary/tertiary → caem no fallback (primary), conforme AppBrandConfig.
const AppBrandConfig zxtrackBrand = AppBrandConfig(
  clientSlug: 'zxtrack',
  primaryColor: _primary,
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

// Persian Red — Primary (base 600)
const _primary = ColorSwatch<int>(0xFFD03530, <int, Color>{
  50: Color(0xFFFDF3F3),
  100: Color(0xFFFCE5E4),
  200: Color(0xFFFBCECD),
  300: Color(0xFFF6ADAB),
  400: Color(0xFFEF7E7A),
  500: Color(0xFFE4544F),
  600: Color(0xFFD03530),
  700: Color(0xFFAF2A26),
  800: Color(0xFF912623),
  900: Color(0xFF792623),
  950: Color(0xFF41100E),
});

// Chicago — Neutral (base 600)
const _neutral = ColorSwatch<int>(0xFF575757, <int, Color>{
  50: Color(0xFFFAFAFA),
  100: Color(0xFFF5F5F5),
  200: Color(0xFFE6E6E6),
  300: Color(0xFFD3D3D3),
  400: Color(0xFFA3A3A3),
  500: Color(0xFF727272),
  600: Color(0xFF575757),
  700: Color(0xFF404040),
  800: Color(0xFF272727),
  900: Color(0xFF1A1A1A),
  950: Color(0xFF0B0B0B),
});

// Chicago invertido — Neutral (dark)
// s50 = superfície base do tema escuro: fora do preto puro (tom HCT em [6, 16]).
// Rampa escura. As pontas `s50` e `s300` são as superfícies do shell (página e
// cartão), e a distância entre elas precisa valer ≥ `kMinSeparationDark`.
//
// Com #161616 / #404040 ela dava 19.9 — abaixo da regra, porque esta rampa é
// mais comprimida perto da base que a da jotape. O ajuste foi dividido entre as
// duas pontas em vez de só clarear o cartão: `s50` desce até quase o piso de
// `kDarkSurfaceToneMin` (6.0), o que também deixa a página mais fechada, e
// `s300` sobe o restante. Resultado: 22.5.
const _neutralDark = ColorSwatch<int>(0xFFA3A3A3, <int, Color>{
  50: Color(0xFF151515), // tom 6.8 (era 7.2)
  100: Color(0xFF1A1A1A),
  200: Color(0xFF272727),
  300: Color(0xFF454545), // tom 29.3 (era 27.1)
  400: Color(0xFF575757),
  500: Color(0xFF727272),
  600: Color(0xFFA3A3A3),
  700: Color(0xFFD3D3D3),
  800: Color(0xFFE6E6E6),
  900: Color(0xFFF5F5F5),
  950: Color(0xFFFAFAFA),
});

// Malachite — Success (base 400)
const _success = ColorSwatch<int>(0xFF3CCF30, <int, Color>{
  50: Color(0xFFF0FCEF),
  100: Color(0xFFDCFAD8),
  200: Color(0xFFBAF3B4),
  300: Color(0xFF84E77B),
  400: Color(0xFF3CCF30),
  500: Color(0xFF31B427),
  600: Color(0xFF218719),
  700: Color(0xFF1C6A16),
  800: Color(0xFF1A5416),
  900: Color(0xFF174514),
  950: Color(0xFF072606),
});

// Saffron — Warning (base 600)
const _warning = ColorSwatch<int>(0xFFBA730C, <int, Color>{
  50: Color(0xFFFFFCE9),
  100: Color(0xFFFCF3C3),
  200: Color(0xFFF9E781),
  300: Color(0xFFF5D43F),
  400: Color(0xFFF2BF0D),
  500: Color(0xFFD39510),
  600: Color(0xFFBA730C),
  700: Color(0xFF9B520D),
  800: Color(0xFF7D4011),
  900: Color(0xFF673511),
  950: Color(0xFF3B1B05),
});

// Cinnabar — Error/Danger (base 400)
const _danger = ColorSwatch<int>(0xFFEA1521, <int, Color>{
  50: Color(0xFFFEEEEF),
  100: Color(0xFFFCDADC),
  200: Color(0xFFF9BCBF),
  300: Color(0xFFF58C91),
  400: Color(0xFFEA1521),
  500: Color(0xFFC6151E),
  600: Color(0xFF981E25),
  700: Color(0xFF80181D),
  800: Color(0xFF69171B),
  900: Color(0xFF57181B),
  950: Color(0xFF31080A),
});

// Blue — Info (gerado, base 500)
const _info = ColorSwatch<int>(0xFF3B82F6, <int, Color>{
  50: Color(0xFFEFF6FF),
  100: Color(0xFFDBEAFE),
  200: Color(0xFFBFDBFE),
  300: Color(0xFF93C5FD),
  400: Color(0xFF60A5FA),
  500: Color(0xFF3B82F6),
  600: Color(0xFF2563EB),
  700: Color(0xFF1D4ED8),
  800: Color(0xFF1E40AF),
  900: Color(0xFF1E3A8A),
  950: Color(0xFF172554),
});
