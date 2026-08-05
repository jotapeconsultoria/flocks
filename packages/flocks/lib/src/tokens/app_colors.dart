import 'package:flutter/widgets.dart';

/// A class that contains the color palette for the App.
sealed class AppColors {
  // Brand

  // Primary
  static const ColorSwatch<int> brandPrimary =
      ColorSwatch<int>(0xFF0C3235, <int, Color>{
        50: Color(0xFFE6EAEA),
        100: Color(0xFFB3BFC0),
        200: Color(0xFF90A1A3),
        300: Color(0xFF5C7577),
        400: Color(0xFF3C5B5D),
        500: Color(0xFF0C3235),
        600: Color(0xFF0B2E30),
        700: Color(0xFF082325),
        800: Color(0xFF071C1D),
        900: Color(0xFF051516),
      });
  static const ColorSwatch<int> onBrandPrimary =
      ColorSwatch<int>(0xFFFFFFFF, <int, Color>{
        50: Color(0xFF848484),
        100: Color(0xFF9C9C9C),
        200: Color(0xFFB7B7B7),
        300: Color(0xFFD0D0D0),
        400: Color(0xFFEAEAEA),
        500: Color(0xFFFFFFFF),
        600: Color(0xFFFFFFFF),
        700: Color(0xFFFFFFFF),
        800: Color(0xFFFFFFFF),
        900: Color(0xFFFFFFFF),
      });

  /// On-color **claro** (base = branco): usado quando o legível sobre o fill é
  /// branco (fills escuros). Alias semântico de [onBrandPrimary].
  static const ColorSwatch<int> onColorLight = onBrandPrimary;

  /// On-color **escuro** (base = preto): usado quando o legível sobre o fill é
  /// preto (fills claros — warning/success/info/etc.). Escolhido por contraste
  /// em `AppBrandConfig._on`. A base preta é o que os componentes consomem.
  static const ColorSwatch<int> onColorDark =
      ColorSwatch<int>(0xFF000000, <int, Color>{
        50: Color(0xFF7B7B7B),
        100: Color(0xFF636363),
        200: Color(0xFF4F4F4F),
        300: Color(0xFF3B3B3B),
        400: Color(0xFF1F1F1F),
        500: Color(0xFF000000),
        600: Color(0xFF000000),
        700: Color(0xFF000000),
        800: Color(0xFF000000),
        900: Color(0xFF000000),
      });

  // Secondary
  static const ColorSwatch<int> brandSecondary =
      ColorSwatch<int>(0xFFFF5B04, <int, Color>{
        50: Color(0xFFFFA575),
        100: Color(0xFFFF9D68),
        200: Color(0xFFFF8C4F),
        300: Color(0xFFFF7C36),
        400: Color(0xFFFF6B1D),
        500: Color(0xFFFF5B04),
        600: Color(0xFFE55204),
        700: Color(0xFFCC4903),
        800: Color(0xFFB24003),
        900: Color(0xFF993702),
      });
  static const ColorSwatch<int> onBrandSecondary =
      ColorSwatch<int>(0xFFFFFFFF, <int, Color>{
        50: Color(0xFF848484),
        100: Color(0xFF9C9C9C),
        200: Color(0xFFB7B7B7),
        300: Color(0xFFD0D0D0),
        400: Color(0xFFEAEAEA),
        500: Color(0xFFFFFFFF),
        600: Color(0xFFFFFFFF),
        700: Color(0xFFFFFFFF),
        800: Color(0xFFFFFFFF),
        900: Color(0xFFFFFFFF),
      });

  // Tertiary
  static const ColorSwatch<int> brandTertiary =
      ColorSwatch<int>(0xFF075056, <int, Color>{
        50: Color(0xFFE6EEEF),
        100: Color(0xFFB1CBCD),
        200: Color(0xFF8CB2B5),
        300: Color(0xFF568F94),
        400: Color(0xFF367A7F),
        500: Color(0xFF075056),
        600: Color(0xFF06494E),
        700: Color(0xFF05393D),
        800: Color(0xFF042C2F),
        900: Color(0xFF032223),
      });
  static const ColorSwatch<int> onBrandTertiary =
      ColorSwatch<int>(0xFFFFFFFF, <int, Color>{
        50: Color(0xFF848484),
        100: Color(0xFF9C9C9C),
        200: Color(0xFFB7B7B7),
        300: Color(0xFFD0D0D0),
        400: Color(0xFFEAEAEA),
        500: Color(0xFFFFFFFF),
        600: Color(0xFFFFFFFF),
        700: Color(0xFFFFFFFF),
        800: Color(0xFFFFFFFF),
        900: Color(0xFFFFFFFF),
      });

  // Neutrals

  // Black
  static const ColorSwatch<int> neutralBlackDark = ColorSwatch<int>(
    0xFF000000,
    <int, Color>{
      50: Color(0xFF000000), // 100%
      100: Color(0xE6000000), // 90%
      200: Color(0xCC000000), // 80%
      300: Color(0xB3000000), // 70%
      400: Color(0x99000000), // 60%
      500: Color(0x80000000), // 50%
      600: Color(0x66000000), // 40%
      700: Color(0x4D000000), // 30%
      800: Color(0x33000000), // 20%
      900: Color(0x1A000000), // 10%
    },
  );
  static const ColorSwatch<int> neutralBlackLight = ColorSwatch<int>(
    0xFF000000,
    <int, Color>{
      50: Color(0x1A000000), // 10%
      100: Color(0x33000000), // 20%
      200: Color(0x4D000000), // 30%
      300: Color(0x66000000), // 40%
      400: Color(0x80000000), // 50%
      500: Color(0x99000000), // 60%
      600: Color(0xB3000000), // 70%
      700: Color(0xCC000000), // 80%
      800: Color(0xE6000000), // 90%
      900: Color(0xFF000000), // 100%
    },
  );

  // Grey
  static const ColorSwatch<int> neutralGreyDark =
      ColorSwatch<int>(0xFF6B6B6B, <int, Color>{
        50: Color(0xFF323232),
        100: Color(0xFF3F3F3F),
        200: Color(0xFF4E4E4E),
        300: Color(0xFF5F5F5F),
        400: Color(0xFF6B6B6B),
        500: Color(0xFF848484),
        600: Color(0xFF9C9C9C),
        700: Color(0xFFB7B7B7),
        800: Color(0xFFD0D0D0),
        900: Color(0xFFEAEAEA),
      });
  static const ColorSwatch<int> neutralGreyLight =
      ColorSwatch<int>(0xFF6B6B6B, <int, Color>{
        50: Color(0xFFEAEAEA),
        100: Color(0xFFD0D0D0),
        200: Color(0xFFB7B7B7),
        300: Color(0xFF9C9C9C),
        400: Color(0xFF848484),
        500: Color(0xFF6B6B6B),
        600: Color(0xFF5F5F5F),
        700: Color(0xFF4E4E4E),
        800: Color(0xFF3F3F3F),
        900: Color(0xFF323232),
      });

  // White
  static const ColorSwatch<int> neutralWhiteDark = ColorSwatch<int>(
    0xFFFFFFFF,
    <int, Color>{
      50: Color(0xFFFFFFFF), // 100%
      100: Color(0xE6FFFFFF), // 90%
      200: Color(0xCCFFFFFF), // 80%
      300: Color(0xB3FFFFFF), // 70%
      400: Color(0x99FFFFFF), // 60%
      500: Color(0x80FFFFFF), // 50%
      600: Color(0x66FFFFFF), // 40%
      700: Color(0x4DFFFFFF), // 30%
      800: Color(0x33FFFFFF), // 20%
      900: Color(0x1AFFFFFF), // 10%
    },
  );
  static const ColorSwatch<int> neutralWhiteLight = ColorSwatch<int>(
    0xFFFFFFFF,
    <int, Color>{
      50: Color(0x1AFFFFFF), // 10%
      100: Color(0x33FFFFFF), // 20%
      200: Color(0x4DFFFFFF), // 30%
      300: Color(0x66FFFFFF), // 40%
      400: Color(0x80FFFFFF), // 50%
      500: Color(0x99FFFFFF), // 60%
      600: Color(0xB3FFFFFF), // 70%
      700: Color(0xCCFFFFFF), // 80%
      800: Color(0xE6FFFFFF), // 90%
      900: Color(0xFFFFFFFF), // 100%
    },
  );

  // Semantic
  static const ColorSwatch<int> semanticDanger =
      ColorSwatch<int>(0xFFD84315, <int, Color>{
        50: Color(0xFFF9E3CF),
        100: Color(0xFFF3BFA4),
        200: Color(0xFFEE9B7A),
        300: Color(0xFFE67852),
        400: Color(0xFFE05D33),
        500: Color(0xFFD84315),
        600: Color(0xFFBF3B12),
        700: Color(0xFFA2330F),
        800: Color(0xFF852B0C),
        900: Color(0xFF6A2309),
      });
  static const ColorSwatch<int> onSemanticDanger =
      ColorSwatch<int>(0xFFFFFFFF, <int, Color>{
        50: Color(0xFF848484),
        100: Color(0xFF9C9C9C),
        200: Color(0xFFB7B7B7),
        300: Color(0xFFD0D0D0),
        400: Color(0xFFEAEAEA),
        500: Color(0xFFFFFFFF),
        600: Color(0xFFFFFFFF),
        700: Color(0xFFFFFFFF),
        800: Color(0xFFFFFFFF),
        900: Color(0xFFFFFFFF),
      });
  static const ColorSwatch<int> semanticInfo =
      ColorSwatch<int>(0xFF0063B2, <int, Color>{
        50: Color(0xFFBDE6FA),
        100: Color(0xFF91CCF0),
        200: Color(0xFF66B2E5),
        300: Color(0xFF3D96D9),
        400: Color(0xFF1E7DC6),
        500: Color(0xFF0063B2),
        600: Color(0xFF00589F),
        700: Color(0xFF004E8D),
        800: Color(0xFF00427A),
        900: Color(0xFF003669),
      });
  static const ColorSwatch<int> onSemanticInfo =
      ColorSwatch<int>(0xFFFFFFFF, <int, Color>{
        50: Color(0xFF848484),
        100: Color(0xFF9C9C9C),
        200: Color(0xFFB7B7B7),
        300: Color(0xFFD0D0D0),
        400: Color(0xFFEAEAEA),
        500: Color(0xFFFFFFFF),
        600: Color(0xFFFFFFFF),
        700: Color(0xFFFFFFFF),
        800: Color(0xFFFFFFFF),
        900: Color(0xFFFFFFFF),
      });
  static const ColorSwatch<int> semanticSuccess =
      ColorSwatch<int>(0xFF008F4C, <int, Color>{
        50: Color(0xFFCFFFC3),
        100: Color(0xFFA3E8AA),
        200: Color(0xFF79D192),
        300: Color(0xFF4FBA7A),
        400: Color(0xFF26A563),
        500: Color(0xFF008F4C),
        600: Color(0xFF007F44),
        700: Color(0xFF006E3C),
        800: Color(0xFF005E34),
        900: Color(0xFF004E2C),
      });
  static const ColorSwatch<int> onSemanticSuccess =
      ColorSwatch<int>(0xFFFFFFFF, <int, Color>{
        50: Color(0xFF848484),
        100: Color(0xFF9C9C9C),
        200: Color(0xFFB7B7B7),
        300: Color(0xFFD0D0D0),
        400: Color(0xFFEAEAEA),
        500: Color(0xFFFFFFFF),
        600: Color(0xFFFFFFFF),
        700: Color(0xFFFFFFFF),
        800: Color(0xFFFFFFFF),
        900: Color(0xFFFFFFFF),
      });
  static const ColorSwatch<int> semanticWarning =
      ColorSwatch<int>(0xFFFFCB05, <int, Color>{
        50: Color(0xFFFFF8E0),
        100: Color(0xFFFFEFB5),
        200: Color(0xFFFFE58B),
        300: Color(0xFFFFDC58),
        400: Color(0xFFFFD42E),
        500: Color(0xFFFFCB05),
        600: Color(0xFFE6B804),
        700: Color(0xFFCC9F03),
        800: Color(0xFFA87F02),
        900: Color(0xFF866402),
      });
  static const ColorSwatch<int> onSemanticWarning =
      ColorSwatch<int>(0xFFFFFFFF, <int, Color>{
        50: Color(0xFF5F5F5F),
        100: Color(0xFF6B6B6B),
        200: Color(0xFF848484),
        300: Color(0xFF9C9C9C),
        400: Color(0xFFB7B7B7),
        500: Color(0xFFD0D0D0),
        600: Color(0xFFEAEAEA),
        700: Color(0xFFFFFFFF),
        800: Color(0xFFFFFFFF),
        900: Color(0xFFFFFFFF),
      });

  // Data-viz
  //
  // Cores de visualização de dados (gráficos/faixas/scores). Não pertencem à
  // marca: são compartilhadas entre clientes e têm par Light/Dark para legibilidade
  // sobre fundo claro/escuro. Consumir sempre via tokens do tema
  // (theme.colorTheme.chart* / score* / chartCategorical), nunca direto.

  // Faixas de condução (good / neutral / bad)
  static const Color chartGoodLight = Color(0xFF3C6A19);
  static const Color chartGoodDark = Color(0xFF7CB342);
  static const Color chartNeutralLight = Color(0xFF5E5E5E);
  static const Color chartNeutralDark = Color(0xFF9E9E9E);
  static const Color chartBadLight = Color(0xFF904D00);
  static const Color chartBadDark = Color(0xFFE8A04D);

  // Score de ranking (low / mid / high)
  static const Color scoreLowLight = Color(0xFFB62226);
  static const Color scoreLowDark = Color(0xFFEF5350);
  static const Color scoreMidLight = Color(0xFF765B00);
  static const Color scoreMidDark = Color(0xFFE6C04A);
  static const Color scoreHighLight = Color(0xFF3C6A19);
  static const Color scoreHighDark = Color(0xFF7CB342);

  // Série categórica (8 cores cíclicas para séries de eventos)
  static const List<Color> chartCategoricalLight = <Color>[
    Color(0xFF5B8C5A), // verde musgo
    Color(0xFFE8915A), // laranja coral
    Color(0xFF6B9EC4), // azul steel
    Color(0xFFD4A843), // dourado
    Color(0xFF9B6B9E), // roxo suave
    Color(0xFFCC6666), // vermelho rosado
    Color(0xFF4DADA8), // teal
    Color(0xFF8B7355), // marrom café
  ];
  static const List<Color> chartCategoricalDark = <Color>[
    Color(0xFF7FB07E), // verde musgo (clareado)
    Color(0xFFF0AB7F), // laranja coral (clareado)
    Color(0xFF8FBADC), // azul steel (clareado)
    Color(0xFFE2C272), // dourado (clareado)
    Color(0xFFBF95C1), // roxo suave (clareado)
    Color(0xFFDB8F8F), // vermelho rosado (clareado)
    Color(0xFF79C9C4), // teal (clareado)
    Color(0xFFB39B7E), // marrom café (clareado)
  ];

  // Transparent
  static const Color transparent = Color(0x00000000);
}

/// An extension on [Color] that provides additional functionality.
extension AppColorOpacity on Color {
  /// The default opacity for barrier colors.
  ///
  /// This value is used to create a new [Color] with the [barrier] method.
  ///
  /// The default value is 40% (102 alpha).
  static const barrierOpacity = 102;

  /// Returns a new [Color] with an opacity of [AppColorOpacity.barrierOpacity].
  Color barrier() => withAlpha(barrierOpacity);

  /// The default opacity for disabled colors.
  ///
  /// This value is used to create a new [Color] with the [disabled] method.
  ///
  /// The default value is 50% (128 alpha).
  static const disabledOpacity = 128;

  /// Returns a new [Color] with an opacity of [AppColorOpacity.disabledOpacity].
  Color disabled() => withAlpha(disabledOpacity);

  /// Returns a new [Color] with an opacity of [percentage].
  ///
  /// The [percentage] must be between 0 and 1.
  Color customOpacity(double percentage) =>
      withAlpha((255 * percentage).toInt());
}

/// An extension on [ColorSwatch] that provides convenient getters for accessing
/// different shades of a color.
extension AppColorSwatch on ColorSwatch {
  /// Returns the primary color (shade 500) of the color swatch.
  Color get primary => this[500]!;

  /// Returns the lightest shade (50) of the color swatch.
  Color get s50 => this[50]!;

  /// Returns the second lightest shade (100) of the color swatch.
  Color get s100 => this[100]!;

  /// Returns the third lightest shade (200) of the color swatch.
  Color get s200 => this[200]!;

  /// Returns the fourth lightest shade (300) of the color swatch.
  Color get s300 => this[300]!;

  /// Returns the fifth lightest shade (400) of the color swatch.
  Color get s400 => this[400]!;

  /// Returns the primary shade (500) of the color swatch.
  Color get s500 => this[500]!;

  /// Returns the fifth darkest shade (600) of the color swatch.
  Color get s600 => this[600]!;

  /// Returns the fourth darkest shade (700) of the color swatch.
  Color get s700 => this[700]!;

  /// Returns the third darkest shade (800) of the color swatch.
  Color get s800 => this[800]!;

  /// Returns the second darkest shade (900) of the color swatch.
  Color get s900 => this[900]!;

  /// Returns the darkest shade (950) of the color swatch, quando presente;
  /// caso contrário cai no 900 (swatches legados não têm 950).
  Color get s950 => this[950] ?? this[900]!;
}
