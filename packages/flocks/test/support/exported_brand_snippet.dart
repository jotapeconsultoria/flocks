// Marca gerada em flocks.live/demo.
//
// Cole num app que já dependa do `flocks`. Uma semente por papel de cor,
// e só os eixos que saem do padrão do design system.

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';

final AppBrandConfig acmeBrand = AppBrandConfig(
  clientSlug: 'acme',
  primaryColor: swatchFromSeed(const Color(0xFF4F46E5)),
  secondaryColor: swatchFromSeed(const Color(0xFFE5484D)),
  neutralLightColor: neutralSwatchFromSeed(const Color(0xFF6B7280)),
  neutralDarkColor: flippedSwatch(
    neutralSwatchFromSeed(const Color(0xFF6B7280)),
  ),
  radiusTheme: const AppRadiusTheme(mode: AppRadiusMode.redondo),
  typography: const AppBrandTypography(
    displayFamily: AppFontFamilies.spaceGrotesk,
  ),
);

// O tema: AppThemeData.forBrand(acmeBrand, dark: false).
