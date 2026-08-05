import 'package:flutter/widgets.dart';

import '../brand/app_brand_typography.dart';
import '../theme/app_themes.dart';
import 'app_colors.dart';
import 'app_font_families.dart';

const package = 'flocks';

/// A class that contains the text styles for the App.
sealed class AppTextStyles {
  /// The values of the text styles.
  static List<TextStyle> values(AppThemeData theme) => [
    displayLarge.withColor(theme.colorTheme.onSurface),
    displayMedium.withColor(theme.colorTheme.onSurface),
    displaySmall.withColor(theme.colorTheme.onSurface),
    headlineLarge.withColor(theme.colorTheme.onSurface),
    headlineMedium.withColor(theme.colorTheme.onSurface),
    headlineSmall.withColor(theme.colorTheme.onSurface),
    titleLarge.withColor(theme.colorTheme.onSurface),
    titleMedium.withColor(theme.colorTheme.onSurface),
    titleSmall.withColor(theme.colorTheme.onSurface),
    bodyLarge.withColor(theme.colorTheme.onSurface),
    bodyMedium.withColor(theme.colorTheme.onSurface),
    bodySmall.withColor(theme.colorTheme.onSurface),
    labelLarge.withColor(theme.colorTheme.onSurface),
    labelMedium.withColor(theme.colorTheme.onSurface),
    labelSmall.withColor(theme.colorTheme.onSurface),
  ];

  /// Constroi um [AppTextTheme] aplicando [onSurface] como cor de todos os
  /// estilos e as famílias de [typography]. Usado pelos getters de tema
  /// ([AppThemeData.light]/[dark]) para que o texto adapte ao brilho
  /// (claro/escuro). Estilos que precisem de cor específica continuam usando
  /// `.withColor(...)` no ponto de uso.
  ///
  /// [typography] é o que torna a família tipográfica um eixo de marca:
  /// `display*`/`headline*` recebem a família de display, o resto a de corpo.
  /// Omitido, tudo fica na Poppins — o padrão do pacote.
  static AppTextTheme themeFor(
    Color onSurface, {
    AppBrandTypography typography = AppBrandTypography.standard,
  }) {
    TextStyle body(TextStyle s) => s
        .withColor(onSurface)
        .withFamily(
          typography.effectiveBodyFamily,
          package: typography.effectiveBodyPackage,
        );
    TextStyle display(TextStyle s) => s
        .withColor(onSurface)
        .withFamily(
          typography.effectiveDisplayFamily,
          package: typography.effectiveDisplayPackage,
        );
    return AppTextTheme(
      displayLarge: display(displayLarge),
      displayMedium: display(displayMedium),
      displaySmall: display(displaySmall),
      headlineLarge: display(headlineLarge),
      headlineMedium: display(headlineMedium),
      headlineSmall: display(headlineSmall),
      titleLarge: body(titleLarge),
      titleMedium: body(titleMedium),
      titleSmall: body(titleSmall),
      bodyLarge: body(bodyLarge),
      bodyMedium: body(bodyMedium),
      bodySmall: body(bodySmall),
      labelLarge: body(labelLarge),
      labelMedium: body(labelMedium),
      labelSmall: body(labelSmall),
    );
  }

  /// The text theme for the App.
  static const textTheme = AppTextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );

  /// The display large text style for the App.
  static const displayLarge = TextStyle(
    color: AppColors.neutralBlackLight,
    fontFamily: AppFontFamilies.poppins,
    fontSize: 57.0,
    height: 64.0 / 57.0,
    fontWeight: FontWeight.w400,
    package: package,
  );

  /// The display medium text style for the App.
  static const displayMedium = TextStyle(
    color: AppColors.neutralBlackLight,
    fontFamily: AppFontFamilies.poppins,
    fontSize: 45.0,
    height: 52.0 / 45.0,
    fontWeight: FontWeight.w400,
    package: package,
  );

  /// The display small text style for the App.
  static const displaySmall = TextStyle(
    color: AppColors.neutralBlackLight,
    fontFamily: AppFontFamilies.poppins,
    fontSize: 36.0,
    height: 44.0 / 36.0,
    fontWeight: FontWeight.w400,
    package: package,
  );

  /// The headline large text style for the App.
  static const headlineLarge = TextStyle(
    color: AppColors.neutralBlackLight,
    fontFamily: AppFontFamilies.poppins,
    fontSize: 32.0,
    height: 40.0 / 32.0,
    fontWeight: FontWeight.w500,
    package: package,
  );

  /// The headline medium text style for the App.
  static const headlineMedium = TextStyle(
    color: AppColors.neutralBlackLight,
    fontFamily: AppFontFamilies.poppins,
    fontSize: 28.0,
    height: 36.0 / 28.0,
    fontWeight: FontWeight.w500,
    package: package,
  );

  /// The headline small text style for the App.
  static const headlineSmall = TextStyle(
    color: AppColors.neutralBlackLight,
    fontFamily: AppFontFamilies.poppins,
    fontSize: 24.0,
    height: 32.0 / 24.0,
    fontWeight: FontWeight.w500,
    package: package,
  );

  /// The title large text style for the App.
  static const titleLarge = TextStyle(
    color: AppColors.neutralBlackLight,
    fontFamily: AppFontFamilies.poppins,
    fontSize: 22.0,
    height: 28.0 / 22.0,
    fontWeight: FontWeight.w600,
    package: package,
  );

  /// The title medium text style for the App.
  static const titleMedium = TextStyle(
    color: AppColors.neutralBlackLight,
    fontFamily: AppFontFamilies.poppins,
    fontSize: 16.0,
    height: 24.0 / 16.0,
    fontWeight: FontWeight.w600,
    package: package,
  );

  /// The title small text style for the App.
  static const titleSmall = TextStyle(
    color: AppColors.neutralBlackLight,
    fontFamily: AppFontFamilies.poppins,
    fontSize: 14.0,
    height: 20.0 / 14.0,
    fontWeight: FontWeight.w600,
    package: package,
  );

  /// The body large text style for the App.
  static const bodyLarge = TextStyle(
    color: AppColors.neutralBlackLight,
    fontFamily: AppFontFamilies.poppins,
    fontSize: 16.0,
    height: 24.0 / 16.0,
    fontWeight: FontWeight.w400,
    package: package,
  );

  /// The body medium text style for the App.
  static const bodyMedium = TextStyle(
    color: AppColors.neutralBlackLight,
    fontFamily: AppFontFamilies.poppins,
    fontSize: 14.0,
    height: 20.0 / 14.0,
    fontWeight: FontWeight.w400,
    package: package,
  );

  /// The body small text style for the App.
  static const bodySmall = TextStyle(
    color: AppColors.neutralBlackLight,
    fontFamily: AppFontFamilies.poppins,
    fontSize: 12.0,
    height: 16.0 / 12.0,
    fontWeight: FontWeight.w400,
    package: package,
  );

  /// The label large text style for the App.
  ///
  /// Peso 500, não 400: os `label*` eram Neutrek, cuja regular lia bem mais
  /// pesada que a da Poppins. Mantê-los em 400 na troca de família apagava a
  /// separação entre rótulo e corpo (cabeçalho de tabela, chip, item de menu
  /// ficavam do mesmo peso do texto ao lado).
  static const labelLarge = TextStyle(
    color: AppColors.neutralBlackLight,
    fontFamily: AppFontFamilies.poppins,
    fontSize: 14.0,
    height: 20.0 / 14.0,
    fontWeight: FontWeight.w500,
    package: package,
  );

  /// The label medium text style for the App.
  ///
  /// Peso 500 pelo mesmo motivo de [labelLarge].
  static const labelMedium = TextStyle(
    color: AppColors.neutralBlackLight,
    fontFamily: AppFontFamilies.poppins,
    fontSize: 12.0,
    height: 16.0 / 12.0,
    fontWeight: FontWeight.w500,
    package: package,
  );

  /// The label small text style for the App.
  ///
  /// Peso 500 pelo mesmo motivo de [labelLarge].
  static const labelSmall = TextStyle(
    color: AppColors.neutralBlackLight,
    fontFamily: AppFontFamilies.poppins,
    fontSize: 11.0,
    height: 16.0 / 11.0,
    fontWeight: FontWeight.w500,
    package: package,
  );
}

extension AppTypographyColors on TextStyle {
  TextStyle withColor(Color color) => copyWith(color: color);

  /// Troca a família (e o pacote) do estilo.
  ///
  /// Duas armadilhas do [TextStyle] justificam o formato:
  ///
  /// 1. O `package:` do construtor **não é um campo** — ele concatena
  ///    `packages/<pacote>/<família>` dentro do `fontFamily`. Passar a família
  ///    já endereçada produz `packages/flocks/packages/flocks/Poppins`.
  /// 2. O estilo guarda o pacote com que nasceu e o **reaplica** em toda cópia,
  ///    e `copyWith(package: null)` não limpa nada — `null` ali é "não
  ///    informado", então o pacote antigo volta.
  ///
  /// Por (2), a fonte sem pacote (declarada no `pubspec.yaml` do próprio app)
  /// só se alcança reconstruindo o estilo. É o único caminho, não preferência.
  TextStyle withFamily(String family, {required String? package}) =>
      package != null
      ? copyWith(fontFamily: family, package: package)
      : TextStyle(
          color: color,
          fontFamily: family,
          fontSize: fontSize,
          fontStyle: fontStyle,
          fontWeight: fontWeight,
          height: height,
          letterSpacing: letterSpacing,
          wordSpacing: wordSpacing,
        );

  TextStyle get bold => copyWith(fontWeight: FontWeight.w600);
}
