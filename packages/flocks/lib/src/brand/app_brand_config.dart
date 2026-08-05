import 'package:flutter/widgets.dart';

import '../theme/app_themes.dart';
import '../tokens/app_colors.dart';
import '../tokens/contrast.dart';
import '../tokens/swatch_generator.dart';
import 'app_brand_typography.dart';

// ---------------------------------------------------------------------------
// Separação shell ⇄ cartão
// ---------------------------------------------------------------------------

/// Quantos passos da rampa neutra separam a `surface` (rail, header,
/// assistente) do `surfaceContainer` (o cartão de conteúdo).
///
/// ## Por que um SHADE e não um ΔT
///
/// A rampa neutra já é assimétrica de propósito — passos finos perto do branco,
/// grossos perto do preto — e a versão escura é a clara invertida. Medindo o
/// acumulado a partir da base: `s50→s300` vale 11.1 tons no claro e 22.2 no
/// escuro, **exatamente 2×**. Ou seja: a regra de "dobrar a separação no
/// escuro" já está embutida na geometria da paleta.
///
/// Antes isto era um `deltaTone` fixo em HCT (14 no claro, 26 no escuro). Três
/// problemas: o valor caía FORA da rampa e não tinha nome de shade; o 2× tinha
/// de ser reaplicado à mão a cada ajuste; e nada impedia o valor de aterrissar
/// em cima de outro token — foi assim que o cartão escuro colidiu com o
/// preenchimento dos inputs (`s200`).
///
/// Com um shade, os três somem: o 2× vem da rampa e o valor é um stop nomeado.
const int kShellSeparationShade = 300;

/// Configuracao de white-label para um cliente especifico.
///
/// Centraliza o que o design system precisa para se vestir de uma marca: a
/// paleta completa (50–950 por papel), os eixos globais de tema (raio, animação,
/// estilo, glass, ícone, ilustração) e a tipografia. Nada além disso.
///
/// ## O que esta classe deliberadamente NÃO guarda
///
/// Nome do app, subtítulo, site, base de CDN, caminho de vídeo, URL de loja,
/// rótulo "powered by". Eram campos daqui, e nenhum era consumido por `lib/src`
/// — a classe os carregava só para o app lê-los de volta.
///
/// O custo não era o peso: os getters derivados de asset (`splashLogoUrl`,
/// `otpLogoUrl`, `railExpandedUrl` e companhia) **codificavam suposições sobre a
/// arquitetura de quem adota** — que existe splash, fluxo de OTP, nav rail,
/// fundo de autenticação, e que se publica na Play Store. Um design system que
/// afirma isso tem opinião sobre o produto alheio, que é a mesma classe de
/// acoplamento que o Flocks recusa no Material.
///
/// Esses campos viraram a ficha de identidade do app, e vivem na infraestrutura
/// de quem os usa (`AppIdentityConfig`, em `tracked_shared_pkg`), selecionada
/// pelo mesmo `--dart-define=CLIENT`. A marca continua sendo o que o tema lê;
/// a ficha, o que o app exibe sobre si.
///
/// **Fallbacks (marcas com paleta parcial):**
/// - `secondaryColor` ausente → usa `primaryColor`.
/// - `tertiaryColor` ausente → usa `secondaryColor` (ou `primaryColor`).
/// - `success/warning/danger/info/neutral` ausentes → usam os globais de
///   [AppColors] (a marca padrão JotaPe).
/// - `on*` ausentes → preto ou branco por contraste ([_bestOnColor]) sobre a base.
///
/// A **base** de cada cor é o `value` do [ColorSwatch] (1º argumento): pode
/// apontar para qualquer stop (ex.: primary da JotaPe = stop 950; da ZX = 600).
@immutable
final class AppBrandConfig {
  const AppBrandConfig({
    required this.clientSlug,
    required this.primaryColor,
    this.onPrimaryColor,
    this.secondaryColor,
    this.onSecondaryColor,
    this.tertiaryColor,
    this.onTertiaryColor,
    this.neutralLightColor,
    this.neutralDarkColor,
    this.successColor,
    this.warningColor,
    this.dangerColor,
    this.infoColor,
    this.radiusTheme = AppRadiusTheme.standard,
    this.animationTheme = AppAnimationTheme.standard,
    this.styleTheme = AppStyleTheme.standard,
    this.glassTheme = AppGlassTheme.standard,
    this.iconTheme = AppIconTheme.standard,
    this.illustrationTheme = AppIllustrationTheme.standard,
    this.typography = AppBrandTypography.standard,
  });

  /// Nome da marca. Identifica a configuração — é a chave do registry
  /// [AppBrand] e o rótulo que nomeia os goldens (`jotape_dark`) e os relatórios
  /// de contraste. Ex: 'jotape'.
  ///
  /// Já montou caminho de asset no CDN; hoje é só identificação, que é o que um
  /// nome tem de ser.
  final String clientSlug;

  // ---- Paleta (base = value do swatch) ----

  /// Cor primaria da marca (obrigatoria).
  final ColorSwatch<int> primaryColor;

  /// On-color da primaria (opcional; computada por contraste se ausente).
  final ColorSwatch<int>? onPrimaryColor;

  /// Cor secundaria. Ausente → cai em [primaryColor].
  final ColorSwatch<int>? secondaryColor;
  final ColorSwatch<int>? onSecondaryColor;

  /// Cor terciaria. Ausente → cai em [secondaryColor] (ou [primaryColor]).
  final ColorSwatch<int>? tertiaryColor;
  final ColorSwatch<int>? onTertiaryColor;

  /// Neutro (escala clara: 50 claro → 950 escuro). Ausente → global.
  final ColorSwatch<int>? neutralLightColor;

  /// Neutro (escala escura, invertida: 50 escuro → 950 claro). Ausente → global.
  final ColorSwatch<int>? neutralDarkColor;

  /// Semanticas. Ausentes → globais de [AppColors].
  final ColorSwatch<int>? successColor;
  final ColorSwatch<int>? warningColor;
  final ColorSwatch<int>? dangerColor;
  final ColorSwatch<int>? infoColor;

  /// Escala de radius (arredondamento) da marca. Default: standard.
  final AppRadiusTheme radiusTheme;

  /// Global de micro-interações da marca. Default: ligado ([AppAnimationTheme.standard]).
  final AppAnimationTheme animationTheme;

  /// Estilo de container da marca (borda/fundo/sombra). Default: preenchido
  /// ([AppStyleTheme.standard] = [AppStyle.filled]). Uma marca pode fixar outro
  /// default (ex.: `outlined`) para preservar um visual anterior.
  final AppStyleTheme styleTheme;

  /// Eixo glass da marca ("liquid glass"). Default: **desligado**
  /// ([AppGlassTheme.standard]). Uma marca liga (`AppGlassTheme(enabled: true)`)
  /// para aplicar o vidro à allow-list de superfícies flutuantes.
  final AppGlassTheme glassTheme;

  /// Quem desenha os ícones da marca. Default: os SVGs embutidos no pacote
  /// ([AppIconTheme.standard]). Uma marca com catálogo próprio aponta para o
  /// seu CDN via [AppNetworkIconProvider].
  final AppIconTheme iconTheme;

  /// Quem desenha as ilustrações da marca. Default: o SVG embutido
  /// ([AppIllustrationTheme.standard]). Um catálogo maior mora no CDN e é o APP
  /// que aponta, por `AppThemeScope(illustrationProvider:)`.
  final AppIllustrationTheme illustrationTheme;

  /// Famílias tipográficas da marca (display e corpo). Default: Poppins nos
  /// dois papéis ([AppBrandTypography.standard]).
  final AppBrandTypography typography;

  /// Cópia com os campos informados sobrescritos.
  ///
  /// Existe para derivar uma marca de outra em runtime — trocar só a semente de
  /// cor ou só a fonte e ver o sistema inteiro responder, sem reescrever os
  /// campos todos. É o que uma demo de white-label precisa, e o que um teste de
  /// alcance de eixo usa para provar que a marca chega ao pixel.
  ///
  /// Campo opcional informado como `null` é lido como "não informado" e mantém
  /// o valor atual; para de fato apagar um opcional, construa direto.
  AppBrandConfig copyWith({
    AppAnimationTheme? animationTheme,
    String? clientSlug,
    ColorSwatch<int>? dangerColor,
    AppGlassTheme? glassTheme,
    AppIconTheme? iconTheme,
    AppIllustrationTheme? illustrationTheme,
    ColorSwatch<int>? infoColor,
    ColorSwatch<int>? neutralDarkColor,
    ColorSwatch<int>? neutralLightColor,
    ColorSwatch<int>? onPrimaryColor,
    ColorSwatch<int>? onSecondaryColor,
    ColorSwatch<int>? onTertiaryColor,
    ColorSwatch<int>? primaryColor,
    AppRadiusTheme? radiusTheme,
    ColorSwatch<int>? secondaryColor,
    AppStyleTheme? styleTheme,
    ColorSwatch<int>? successColor,
    ColorSwatch<int>? tertiaryColor,
    AppBrandTypography? typography,
    ColorSwatch<int>? warningColor,
  }) => AppBrandConfig(
    clientSlug: clientSlug ?? this.clientSlug,
    primaryColor: primaryColor ?? this.primaryColor,
    onPrimaryColor: onPrimaryColor ?? this.onPrimaryColor,
    secondaryColor: secondaryColor ?? this.secondaryColor,
    onSecondaryColor: onSecondaryColor ?? this.onSecondaryColor,
    tertiaryColor: tertiaryColor ?? this.tertiaryColor,
    onTertiaryColor: onTertiaryColor ?? this.onTertiaryColor,
    neutralLightColor: neutralLightColor ?? this.neutralLightColor,
    neutralDarkColor: neutralDarkColor ?? this.neutralDarkColor,
    successColor: successColor ?? this.successColor,
    warningColor: warningColor ?? this.warningColor,
    dangerColor: dangerColor ?? this.dangerColor,
    infoColor: infoColor ?? this.infoColor,
    radiusTheme: radiusTheme ?? this.radiusTheme,
    animationTheme: animationTheme ?? this.animationTheme,
    styleTheme: styleTheme ?? this.styleTheme,
    glassTheme: glassTheme ?? this.glassTheme,
    iconTheme: iconTheme ?? this.iconTheme,
    illustrationTheme: illustrationTheme ?? this.illustrationTheme,
    typography: typography ?? this.typography,
  );

  // ---- Resolucao de paleta (fallbacks) ----

  ColorSwatch<int> get _secondary => secondaryColor ?? primaryColor;
  ColorSwatch<int> get _tertiary =>
      tertiaryColor ?? secondaryColor ?? primaryColor;
  ColorSwatch<int> get _neutralLight =>
      neutralLightColor ?? AppColors.neutralGreyLight;
  ColorSwatch<int> get _neutralDark =>
      neutralDarkColor ?? AppColors.neutralGreyDark;
  ColorSwatch<int> get _success => successColor ?? AppColors.semanticSuccess;
  ColorSwatch<int> get _warning => warningColor ?? AppColors.semanticWarning;
  ColorSwatch<int> get _danger => dangerColor ?? AppColors.semanticDanger;
  ColorSwatch<int> get _info => infoColor ?? AppColors.semanticInfo;

  /// On-color de [base]: usa [override] se dado; senão escolhe a rampa clara
  /// (branco) ou escura (preto) que **satisfaz o gate do Flocks** sobre a base
  /// (razão AA **e** ΔT de tom) — ver [_bestOnColor].
  static ColorSwatch<int> _on(
    ColorSwatch<int> base,
    ColorSwatch<int>? override,
  ) {
    if (override != null) return override;
    return _bestOnColor(base) == const Color(0xFFFFFFFF)
        ? AppColors
              .onColorLight // base branca
        : AppColors.onColorDark; // base preta
  }

  /// Escolhe preto ou branco como on-color sobre [base], ciente do gate do
  /// Flocks: prefere o que satisfaz razão AA **e** ΔT de tom; se ambos ou
  /// nenhum satisfazem, cai no de **maior razão** (como [onColorFor]).
  ///
  /// Difere de [onColorFor] (que só olha a razão) porque uma cor de tom médio
  /// pode ter razão levemente maior no preto, mas só o branco atingir o ΔT ≥
  /// [kToneDeltaText] — e vice-versa.
  static Color _bestOnColor(Color base) {
    const Color white = Color(0xFFFFFFFF);
    const Color black = Color(0xFF000000);
    bool passes(Color on) =>
        contrastRatio(base, on) >= kAaNormal &&
        toneDelta(base, on) >= kToneDeltaText;
    final bool whitePasses = passes(white);
    final bool blackPasses = passes(black);
    if (whitePasses != blackPasses) return whitePasses ? white : black;
    return contrastRatio(base, white) >= contrastRatio(base, black)
        ? white
        : black;
  }

  // ---- Conversao para themes do design system ----

  /// Constroi o [AppColorTheme] light aplicando as cores da marca.
  AppColorTheme toLightColorTheme() {
    final neutral = _neutralLight;
    final secondary = _secondary;
    final tertiary = _tertiary;
    final success = _success;
    final warning = _warning;
    final danger = _danger;
    final info = _info;
    return AppColorTheme(
      // Claro: página cinza + cards brancos (surface = tom elevado; container =
      // neutral.s50). Convenção de elevação do tema claro.
      // Claro: o CARTÃO é a base (branco) e a página se afasta dela.
      surface: neutral[kShellSeparationShade]!,
      onSurface: neutral.s900,
      transparent: AppColors.transparent,
      // Foco no claro: stop escuro do primary (s700) — contrasta com a superfície
      // clara mesmo quando ela é um cinza elevado (não branco puro).
      focusRing: primaryColor.s700,
      surfaceContainer: neutral.s50,
      // Borda no claro: s600 (mais escura) p/ ≥3:1 sobre a superfície cinza.
      outline: neutral.s600,
      primary: primaryColor,
      onPrimary: _on(primaryColor, onPrimaryColor),
      secondary: secondary,
      onSecondary: _on(secondary, onSecondaryColor),
      tertiary: tertiary,
      onTertiary: _on(tertiary, onTertiaryColor),
      neutralBlack: AppColors.neutralBlackLight,
      onNeutralBlack: AppColors.neutralWhiteLight,
      neutralPrimary: neutral,
      onNeutralPrimary: _neutralDark,
      neutralWhite: AppColors.neutralWhiteLight,
      onNeutralWhite: AppColors.neutralBlackLight,
      danger: danger,
      onDanger: _on(danger, null),
      info: info,
      onInfo: _on(info, null),
      success: success,
      onSuccess: _on(success, null),
      warning: warning,
      onWarning: _on(warning, null),
      chartGood: AppColors.chartGoodLight,
      chartNeutral: AppColors.chartNeutralLight,
      chartBad: AppColors.chartBadLight,
      scoreLow: AppColors.scoreLowLight,
      scoreMid: AppColors.scoreMidLight,
      scoreHigh: AppColors.scoreHighLight,
      chartCategorical: AppColors.chartCategoricalLight,
    );
  }

  /// Constroi o [AppColorTheme] dark aplicando as cores da marca.
  AppColorTheme toDarkColorTheme() {
    final neutral = _neutralDark;
    final secondary = _secondary;
    final tertiary = _tertiary;
    final success = _success;
    final warning = _warning;
    final danger = _danger;
    final info = _info;
    return AppColorTheme(
      surface: neutral.s50,
      onSurface: neutral.s900,
      transparent: AppColors.transparent,
      // Foco no escuro: um stop claro do primary (RULES §5) — a base é escura
      // demais para contrastar com a superfície escura.
      focusRing: primaryColor.s400,
      // Elevação no escuro: clareia a superfície por tom HCT (ΔT ≥ 24 —
      // "dobrar no escuro").
      // Escuro: a PÁGINA é a base (preta) e o cartão se afasta dela. A direção
      // inverte entre os temas — é o que mantém o cartão mais claro que a
      // página nos dois — mas o número de passos é o mesmo.
      surfaceContainer: neutral[kShellSeparationShade]!,
      // Borda no escuro: s500 contrasta com a superfície escura.
      outline: neutral.s500,
      primary: primaryColor,
      onPrimary: _on(primaryColor, onPrimaryColor),
      secondary: secondary,
      onSecondary: _on(secondary, onSecondaryColor),
      tertiary: tertiary,
      onTertiary: _on(tertiary, onTertiaryColor),
      neutralBlack: AppColors.neutralBlackDark,
      onNeutralBlack: AppColors.neutralWhiteDark,
      neutralPrimary: neutral,
      onNeutralPrimary: _neutralLight,
      neutralWhite: AppColors.neutralWhiteDark,
      onNeutralWhite: AppColors.neutralBlackDark,
      danger: danger,
      onDanger: _on(danger, null),
      info: info,
      onInfo: _on(info, null),
      success: success,
      onSuccess: _on(success, null),
      warning: warning,
      onWarning: _on(warning, null),
      chartGood: AppColors.chartGoodDark,
      chartNeutral: AppColors.chartNeutralDark,
      chartBad: AppColors.chartBadDark,
      scoreLow: AppColors.scoreLowDark,
      scoreMid: AppColors.scoreMidDark,
      scoreHigh: AppColors.scoreHighDark,
      chartCategorical: AppColors.chartCategoricalDark,
    );
  }
}
