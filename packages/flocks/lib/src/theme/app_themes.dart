import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../brand/app_brand.dart';
import '../brand/app_brand_config.dart';
import '../foundation/icons/app_asset_icon_provider.dart';
import '../foundation/icons/app_icon_provider.dart';
import '../foundation/illustrations/app_asset_illustration_provider.dart';
import '../foundation/illustrations/app_illustration_provider.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_glass.dart';
import '../tokens/app_icon_token.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_style.dart';
import '../tokens/app_text_styles.dart';
import '../tokens/contrast.dart';

/// A class that contains the themes for the App.
final class AppTheme extends InheritedWidget {
  const AppTheme({required this.data, required super.child, super.key});

  final AppThemeData data;

  // The 'of' method is a convention to easily access the theme data.
  static AppThemeData of(BuildContext context) {
    final AppTheme? result = context
        .dependOnInheritedWidgetOfExactType<AppTheme>();
    assert(result != null, 'No AppTheme found in context');
    return result!.data;
  }

  // This method determines if widgets that depend on this theme
  // should be rebuilt when the theme data changes.
  @override
  bool updateShouldNotify(AppTheme oldWidget) {
    return data != oldWidget.data;
  }
}

/// A class that contains the text theme for the App.
///
/// [displayLarge] is the display large text style.
/// [displayMedium] is the display medium text style.
/// [displaySmall] is the display small text style.
/// [headlineLarge] is the headline large text style.
/// [headlineMedium] is the headline medium text style.
/// [headlineSmall] is the headline small text style.
/// [titleLarge] is the title large text style.
/// [titleMedium] is the title medium text style.
/// [titleSmall] is the title small text style.
/// [bodyLarge] is the body large text style.
/// [bodyMedium] is the body medium text style.
/// [bodySmall] is the body small text style.
/// [labelLarge] is the label large text style.
/// [labelMedium] is the label medium text style.
/// [labelSmall] is the label small text style.
class AppTextTheme extends Equatable {
  const AppTextTheme({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelMedium,
    required this.labelLarge,
    required this.labelSmall,
  });

  /// The display large text style.
  final TextStyle displayLarge;

  /// The display medium text style.
  final TextStyle displayMedium;

  /// The display small text style.
  final TextStyle displaySmall;

  /// The headline large text style.
  final TextStyle headlineLarge;

  /// The headline medium text style.
  final TextStyle headlineMedium;

  /// The headline small text style.
  final TextStyle headlineSmall;

  /// The title large text style.
  final TextStyle titleLarge;

  /// The title medium text style.
  final TextStyle titleMedium;

  /// The title small text style.
  final TextStyle titleSmall;

  /// The body large text style.
  final TextStyle bodyLarge;

  /// The body medium text style.
  final TextStyle bodyMedium;

  /// The body small text style.
  final TextStyle bodySmall;

  /// The label large text style.
  final TextStyle labelLarge;

  /// The label medium text style.
  final TextStyle labelMedium;

  /// The label small text style.
  final TextStyle labelSmall;

  /// Cópia com os estilos informados sobrescritos.
  ///
  /// É o escape hatch de tipografia: [AppBrandTypography] troca a FAMÍLIA dos
  /// dois papéis, e isto troca um estilo isolado (tamanho, peso, entrelinha).
  /// Sem ele, mudar `titleLarge` obrigava a repetir os outros 14 argumentos à
  /// mão — motivo pelo qual, na prática, ninguém mudava.
  ///
  /// ```dart
  /// AppThemeData.forBrand(brand, dark: false).copyWith(
  ///   textTheme: theme.textTheme.copyWith(
  ///     titleLarge: theme.textTheme.titleLarge.copyWith(letterSpacing: 0.5),
  ///   ),
  /// )
  /// ```
  AppTextTheme copyWith({
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? displaySmall,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
  }) => AppTextTheme(
    displayLarge: displayLarge ?? this.displayLarge,
    displayMedium: displayMedium ?? this.displayMedium,
    displaySmall: displaySmall ?? this.displaySmall,
    headlineLarge: headlineLarge ?? this.headlineLarge,
    headlineMedium: headlineMedium ?? this.headlineMedium,
    headlineSmall: headlineSmall ?? this.headlineSmall,
    titleLarge: titleLarge ?? this.titleLarge,
    titleMedium: titleMedium ?? this.titleMedium,
    titleSmall: titleSmall ?? this.titleSmall,
    bodyLarge: bodyLarge ?? this.bodyLarge,
    bodyMedium: bodyMedium ?? this.bodyMedium,
    bodySmall: bodySmall ?? this.bodySmall,
    labelLarge: labelLarge ?? this.labelLarge,
    labelMedium: labelMedium ?? this.labelMedium,
    labelSmall: labelSmall ?? this.labelSmall,
  );

  @override
  List<Object?> get props => [
    displayLarge,
    displayMedium,
    displaySmall,
    headlineLarge,
    headlineMedium,
    headlineSmall,
    titleLarge,
    titleMedium,
    titleSmall,
    bodyLarge,
    bodyMedium,
    bodySmall,
    labelLarge,
    labelMedium,
    labelSmall,
  ];
}

enum AppBrightness { light, dark }

/// Modo de tema escolhido pelo usuário.
///
/// [system] segue o brilho do sistema operacional; [light]/[dark] forçam o tema.
enum AppThemeMode { system, light, dark }

class AppColorTheme extends Equatable {
  const AppColorTheme({
    required this.surface,
    required this.onSurface,
    required this.transparent,
    required this.focusRing,
    required this.surfaceContainer,
    required this.outline,
    required this.primary,
    required this.onPrimary,
    required this.neutralBlack,
    required this.onNeutralBlack,
    required this.neutralPrimary,
    required this.onNeutralPrimary,
    required this.neutralWhite,
    required this.onNeutralWhite,
    required this.danger,
    required this.onDanger,
    required this.info,
    required this.onInfo,
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.secondary,
    required this.onSecondary,
    required this.tertiary,
    required this.onTertiary,
    required this.chartGood,
    required this.chartNeutral,
    required this.chartBad,
    required this.scoreLow,
    required this.scoreMid,
    required this.scoreHigh,
    required this.chartCategorical,
    this.neutralSecondary,
    this.onNeutralSecondary,
    this.neutralTertiary,
    this.onNeutralTertiary,
  });

  final Color surface;
  final Color onSurface;
  final Color transparent;

  /// Cor do anel de foco sobre a `surface`. Resolvida por brilho (RULES §5):
  /// no claro é a base do `primary`; no escuro, um stop claro do `primary` para
  /// manter contraste ≥ 3:1 sobre superfícies escuras.
  final Color focusRing;

  /// Passo de **elevação/container** sobre a `surface` (card, sheet, popover).
  /// Resolvido por brilho para garantir a separação de tom mínima da regra de
  /// contraste (ΔT ≥ 12 no claro / ≥ 24 no escuro — "dobrar no escuro"). É o
  /// token canônico para superfícies elevadas; `neutralPrimary.s100` segue como
  /// preenchimento sutil/desabilitado (isento), não como elevação.
  final Color surfaceContainer;

  /// Cor de **borda/contorno** de controles (checkbox, radio, switch, inputs)
  /// sobre a `surface`. Resolvida por brilho para garantir ≥ 3:1 / ΔT ≥ 40 vs a
  /// superfície — no escuro `neutral.s500`, no claro `neutral.s600` (mais escuro,
  /// pois a superfície clara pode ser um cinza elevado, não branco puro).
  final Color outline;
  final ColorSwatch<int> primary;
  final ColorSwatch<int> onPrimary;
  final ColorSwatch<int> secondary;
  final ColorSwatch<int> onSecondary;
  final ColorSwatch<int> tertiary;
  final ColorSwatch<int> onTertiary;
  final ColorSwatch<int> neutralBlack;
  final ColorSwatch<int> onNeutralBlack;
  final ColorSwatch<int> neutralPrimary;
  final ColorSwatch<int> onNeutralPrimary;
  final ColorSwatch<int>? neutralSecondary;
  final ColorSwatch<int>? onNeutralSecondary;
  final ColorSwatch<int>? neutralTertiary;
  final ColorSwatch<int>? onNeutralTertiary;
  final ColorSwatch<int> neutralWhite;
  final ColorSwatch<int> onNeutralWhite;
  final ColorSwatch<int> danger;
  final ColorSwatch<int> onDanger;
  final ColorSwatch<int> info;
  final ColorSwatch<int> onInfo;
  final ColorSwatch<int> success;
  final ColorSwatch<int> onSuccess;
  final ColorSwatch<int> warning;
  final ColorSwatch<int> onWarning;

  /// Cor de faixa "boa" em gráficos de telemetria (data-viz).
  final Color chartGood;

  /// Cor de faixa "neutra" em gráficos de telemetria (data-viz).
  final Color chartNeutral;

  /// Cor de faixa "ruim" em gráficos de telemetria (data-viz).
  final Color chartBad;

  /// Cor de score baixo em rankings (data-viz).
  final Color scoreLow;

  /// Cor de score médio em rankings (data-viz).
  final Color scoreMid;

  /// Cor de score alto em rankings (data-viz).
  final Color scoreHigh;

  /// Paleta categórica cíclica para séries de eventos (data-viz).
  final List<Color> chartCategorical;

  /// Theme light construido a partir da marca ativa ([AppBrand.current]).
  static AppColorTheme get light => AppBrand.current.toLightColorTheme();

  /// Theme dark construido a partir da marca ativa ([AppBrand.current]).
  static AppColorTheme get dark => AppBrand.current.toDarkColorTheme();

  /// Versão **desabilitada** de [content] sobre esta [surface]: apagada por
  /// deslocamento de **tom** (não opacidade), dessaturada, mantendo-se
  /// perceptível nos dois temas. Ver `mutedForDisabled` e RULES §7.
  Color disabledColor(Color content) => mutedForDisabled(content, surface);

  /// **Divisória** sutil que separa conteúdo (linhas de um card, itens de um
  /// grupo, seções de um menu): um leve `onSurface`, que se adapta a claro/escuro
  /// e é mais neutra que o [outline] — este último é a borda/contorno de controles
  /// (≥ 3:1), forte demais como régua interna. É o padrão do `AppDivider`.
  Color get divider => onSurface.withValues(alpha: 0.10);

  /// Acento primário **resolvido por brilho** para pintar o `primary` como
  /// preenchimento/conteúdo sobre a `surface`: a **base** do `primary` no claro;
  /// um stop claro (`primary.s400`) no **escuro** — a base é escura demais como
  /// acento sobre superfícies escuras (mesma lógica de [focusRing] e do accent
  /// dos steppers/loadings). Componentes que pintam o primary como fill/acento
  /// (check/radio/switch selecionados, badge `primary`, steppers) devem consumir
  /// este helper, **não** o `primary` cru — que não se clareia no escuro e some
  /// no fundo. A on-color legível sobre o resultado sai de `onColorFor`.
  Color primaryAccent({required bool isDark}) =>
      isDark ? primary.s400 : primary as Color;

  /// Acento **terciário** resolvido por brilho — irmão de [primaryAccent].
  ///
  /// A base do `tertiary` no claro; um stop claro (`tertiary.s400`) no
  /// **escuro**. Diferente da neutra, o swatch `tertiary` é o **mesmo** nos dois
  /// temas (ver `AppBrandConfig.toLightColorTheme`/`toDarkColorTheme`), então a
  /// base — escura por definição na marca — some no fundo escuro. Quem pinta o
  /// tertiary como fill/acento sobre a `surface` deve consumir este helper, e
  /// **não** o `tertiary` cru.
  Color tertiaryAccent({required bool isDark}) =>
      isDark ? tertiary.s400 : tertiary as Color;

  /// **Tint** translúcido de uma superfície glass (frosted): o
  /// [surfaceContainer] com alpha, pintado por cima do backdrop desfocado.
  /// Resolvido por brilho ([AppGlass.tintAlphaLight]/`Dark`).
  ///
  /// Usa `surfaceContainer` (a cor das superfícies **flutuantes** — no claro,
  /// branco) e NÃO `surface` (a cor da **página**, que no claro é cinza): o vidro
  /// é a versão translúcida do mesmo painel que dialog/card/menu pintam opaco.
  /// Tintar com a cor da página era o que fazia o vidro ler como cinza lavado.
  ///
  /// Consumido pelo `AppGlassSurface` — os componentes não pintam este token
  /// diretamente. Helper computado (como [primaryAccent]/[disabledColor]), não um
  /// campo do tema.
  Color glassTint({required bool isDark}) => surfaceContainer.withValues(
    alpha: isDark ? AppGlass.tintAlphaDark : AppGlass.tintAlphaLight,
  );

  /// **Sheen** de uma superfície glass: branco com alpha para o brilho no topo
  /// do vidro (o gradiente vai deste stop até transparente). Branco nos dois
  /// temas — é luz refletida na quina, não o `onSurface`.
  Color glassHighlight({required bool isDark}) =>
      const Color(0xFFFFFFFF).withValues(
        alpha: isDark
            ? AppGlass.highlightAlphaDark
            : AppGlass.highlightAlphaLight,
      );

  /// **Rim** de uma superfície glass: borda hairline branca (a quina brilhante
  /// do vidro), desenhada como overlay dentro do clip. Traço em `AppStrokes.xs`.
  Color glassBorder({required bool isDark}) =>
      const Color(0xFFFFFFFF).withValues(
        alpha: isDark ? AppGlass.borderAlphaDark : AppGlass.borderAlphaLight,
      );

  AppColorTheme copyWith({
    Color? surface,
    Color? onSurface,
    Color? transparent,
    Color? focusRing,
    Color? surfaceContainer,
    Color? outline,
    ColorSwatch<int>? primary,
    ColorSwatch<int>? onPrimary,
    ColorSwatch<int>? secondary,
    ColorSwatch<int>? onSecondary,
    ColorSwatch<int>? tertiary,
    ColorSwatch<int>? onTertiary,
    ColorSwatch<int>? neutralBlack,
    ColorSwatch<int>? onNeutralBlack,
    ColorSwatch<int>? neutralPrimary,
    ColorSwatch<int>? onNeutralPrimary,
    ColorSwatch<int>? neutralWhite,
    ColorSwatch<int>? onNeutralWhite,
    ColorSwatch<int>? danger,
    ColorSwatch<int>? onDanger,
    ColorSwatch<int>? info,
    ColorSwatch<int>? onInfo,
    ColorSwatch<int>? success,
    ColorSwatch<int>? onSuccess,
    ColorSwatch<int>? warning,
    ColorSwatch<int>? onWarning,
    Color? chartGood,
    Color? chartNeutral,
    Color? chartBad,
    Color? scoreLow,
    Color? scoreMid,
    Color? scoreHigh,
    List<Color>? chartCategorical,
    ColorSwatch<int>? neutralSecondary,
    ColorSwatch<int>? onNeutralSecondary,
    ColorSwatch<int>? neutralTertiary,
    ColorSwatch<int>? onNeutralTertiary,
  }) => AppColorTheme(
    surface: surface ?? this.surface,
    onSurface: onSurface ?? this.onSurface,
    transparent: transparent ?? this.transparent,
    focusRing: focusRing ?? this.focusRing,
    surfaceContainer: surfaceContainer ?? this.surfaceContainer,
    outline: outline ?? this.outline,
    primary: primary ?? this.primary,
    onPrimary: onPrimary ?? this.onPrimary,
    secondary: secondary ?? this.secondary,
    onSecondary: onSecondary ?? this.onSecondary,
    tertiary: tertiary ?? this.tertiary,
    onTertiary: onTertiary ?? this.onTertiary,
    neutralBlack: neutralBlack ?? this.neutralBlack,
    onNeutralBlack: onNeutralBlack ?? this.onNeutralBlack,
    neutralPrimary: neutralPrimary ?? this.neutralPrimary,
    onNeutralPrimary: onNeutralPrimary ?? this.onNeutralPrimary,
    neutralWhite: neutralWhite ?? this.neutralWhite,
    onNeutralWhite: onNeutralWhite ?? this.onNeutralWhite,
    danger: danger ?? this.danger,
    onDanger: onDanger ?? this.onDanger,
    info: info ?? this.info,
    onInfo: onInfo ?? this.onInfo,
    success: success ?? this.success,
    onSuccess: onSuccess ?? this.onSuccess,
    warning: warning ?? this.warning,
    onWarning: onWarning ?? this.onWarning,
    chartGood: chartGood ?? this.chartGood,
    chartNeutral: chartNeutral ?? this.chartNeutral,
    chartBad: chartBad ?? this.chartBad,
    scoreLow: scoreLow ?? this.scoreLow,
    scoreMid: scoreMid ?? this.scoreMid,
    scoreHigh: scoreHigh ?? this.scoreHigh,
    chartCategorical: chartCategorical ?? this.chartCategorical,
    neutralSecondary: neutralSecondary ?? this.neutralSecondary,
    onNeutralSecondary: onNeutralSecondary ?? this.onNeutralSecondary,
    neutralTertiary: neutralTertiary ?? this.neutralTertiary,
    onNeutralTertiary: onNeutralTertiary ?? this.onNeutralTertiary,
  );

  @override
  List<Object?> get props => [
    surface,
    onSurface,
    transparent,
    focusRing,
    surfaceContainer,
    outline,
    primary,
    onPrimary,
    secondary,
    onSecondary,
    tertiary,
    onTertiary,
    neutralBlack,
    onNeutralBlack,
    neutralPrimary,
    onNeutralPrimary,
    neutralSecondary,
    onNeutralSecondary,
    neutralTertiary,
    onNeutralTertiary,
    neutralWhite,
    onNeutralWhite,
    danger,
    onDanger,
    info,
    onInfo,
    success,
    onSuccess,
    warning,
    onWarning,
    chartGood,
    chartNeutral,
    chartBad,
    scoreLow,
    scoreMid,
    scoreHigh,
    chartCategorical,
  ];
}

/// Eixo global de **forma dos cantos** do tema.
///
/// Guarda o [AppRadiusMode] ativo (default [AppRadiusMode.padrao] = cada
/// componente segue o seu próprio default de forma). Configurável por
/// marca/sistema para deixar TODOS os componentes retos, redondos ou circulares
/// de uma vez. Componentes resolvem o raio com `appResolveRadius`, passando o
/// próprio tamanho e default; e podem sobrescrever por uso (`radiusMode:` /
/// `radius:`).
///
/// Exemplo (marca sempre circular):
/// ```dart
/// const AppRadiusTheme(mode: AppRadiusMode.circular);
/// // ou a partir do padrão:
/// AppRadiusTheme.standard.copyWith(mode: AppRadiusMode.redondo);
/// ```
///
/// Componentes resolvem o raio com `appResolveRadius` (atalho
/// `radiusTheme.resolve(...)`), passando o próprio tamanho e default.
class AppRadiusTheme extends Equatable {
  const AppRadiusTheme({this.mode = AppRadiusMode.padrao});

  /// Modo de forma ativo. Ver [AppRadiusMode].
  final AppRadiusMode mode;

  /// Padrão do design system: [AppRadiusMode.padrao].
  static const AppRadiusTheme standard = AppRadiusTheme();

  /// Cópia com [mode] sobrescrito.
  AppRadiusTheme copyWith({AppRadiusMode? mode}) =>
      AppRadiusTheme(mode: mode ?? this.mode);

  @override
  List<Object?> get props => [mode];
}

/// Global de **micro-interações** do Flocks (espelha [AppRadiusTheme]).
///
/// [enabled] liga/desliga as animações do design system. Default: **ligado**.
/// É um AND com o reduce-motion do SO (ver [AppMotion.enabled]) — o SO sempre
/// vence: se o usuário pediu "reduzir movimento", as animações não tocam mesmo
/// com [enabled] true.
class AppAnimationTheme extends Equatable {
  /// Cria o global de animações. [enabled] default `true`.
  const AppAnimationTheme({this.enabled = true});

  /// Se as micro-interações do design system estão ligadas.
  final bool enabled;

  /// Padrão do design system: animações ligadas.
  static const AppAnimationTheme standard = AppAnimationTheme();

  /// Cópia com [enabled] sobrescrito.
  AppAnimationTheme copyWith({bool? enabled}) =>
      AppAnimationTheme(enabled: enabled ?? this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Gate de **acessibilidade** de transparência do Flocks (espelha
/// [AppAnimationTheme]).
///
/// [enabled] liga/desliga os tratamentos translúcidos do design system (o eixo
/// glass, ver [AppGlassTheme]). Default: **ligado**. É um AND com os proxies de
/// "reduzir transparência" do SO (ver `AppTransparency.enabled`) — como o Flutter
/// ainda não expõe reduce-transparency, o proxy é `highContrast`/`invertColors`
/// do `MediaQuery`. Desligado (por aqui ou pelo SO), superfícies glass caem para
/// o caminho opaco (sem `BackdropFilter`).
///
/// Ortogonal a [AppGlassTheme]: este diz se a translucidez *pode* ser renderizada
/// (a11y, default ON); o [AppGlassTheme] diz se o vidro está *desejado* na marca
/// (estética, default OFF).
class AppTransparencyTheme extends Equatable {
  /// Cria o global de transparência. [enabled] default `true`.
  const AppTransparencyTheme({this.enabled = true});

  /// Se os tratamentos translúcidos (glass) do design system estão ligados.
  final bool enabled;

  /// Padrão do design system: transparência ligada.
  static const AppTransparencyTheme standard = AppTransparencyTheme();

  /// Cópia com [enabled] sobrescrito.
  AppTransparencyTheme copyWith({bool? enabled}) =>
      AppTransparencyTheme(enabled: enabled ?? this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Eixo de **glass** ("liquid glass") do Flocks — um tratamento aditivo,
/// ortogonal ao [AppStyleTheme], aplicado só à allow-list de superfícies
/// flutuantes (overlays, barras, FAB, Menu/Popover). Espelha
/// [AppTransparencyTheme], mas o default é **desligado** (opt-in por marca),
/// enquanto a transparência é um gate de acessibilidade (default ligado).
///
/// Quando [enabled], os componentes da allow-list delegam ao `AppGlassSurface`,
/// que ainda cai para o opaco `elevated` sob `AppTransparency` reduzido. Não é um
/// valor de [AppStyle]: o `style` de cada componente continua governando o render
/// **não-glass** (o fallback). Cada componente aceita um override local
/// `glass:` (`glass ?? theme.glassTheme.enabled`).
class AppGlassTheme extends Equatable {
  /// Cria o eixo glass. [enabled] default `false` (opt-in por marca).
  const AppGlassTheme({this.enabled = false});

  /// Se o eixo glass do design system está ligado.
  final bool enabled;

  /// Padrão do design system: glass **desligado**.
  static const AppGlassTheme standard = AppGlassTheme();

  /// Cópia com [enabled] sobrescrito.
  AppGlassTheme copyWith({bool? enabled}) =>
      AppGlassTheme(enabled: enabled ?? this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// O eixo de ilustração: quem desenha a ilustração que os componentes pedem.
///
/// Mesma história do ícone, num canto que sobreviveu mais tempo:
/// `AppIllustrations` interpolava a URL de um CDN privado dentro do pacote.
/// Default: [AppAssetIllustrationProvider], que serve o contrato de dentro.
class AppIllustrationTheme extends Equatable {
  /// Cria o eixo. [provider] default: os SVGs embutidos.
  const AppIllustrationTheme({
    this.provider = const AppAssetIllustrationProvider(),
  });

  /// Quem resolve nome de ilustração em widget.
  final AppIllustrationProvider provider;

  /// Padrão do design system: os SVGs que vêm no pacote.
  static const AppIllustrationTheme standard = AppIllustrationTheme();

  /// Cópia com [provider] sobrescrito.
  AppIllustrationTheme copyWith({AppIllustrationProvider? provider}) =>
      AppIllustrationTheme(provider: provider ?? this.provider);

  @override
  List<Object?> get props => [provider];
}

/// O eixo de ícone: quem desenha o ícone que os componentes pedem.
///
/// Antes disto o desenho era um endereço fixo — `AppIcons` interpolava a URL de
/// um CDN privado dentro do próprio pacote, sem passar pela marca. Como eixo, o
/// set inteiro se troca num lugar só, em runtime: os SVGs embutidos, o CDN, um
/// adaptador de Material num pacote irmão.
///
/// Default: [AppAssetIconProvider], que serve os 55 [AppIconToken] de dentro do
/// pacote. É o que faz o Flocks desenhar no primeiro `flutter run`, sem rede.
class AppIconTheme extends Equatable {
  /// Cria o eixo de ícone. [provider] default: os SVGs embutidos.
  const AppIconTheme({this.provider = const AppAssetIconProvider()});

  /// Quem resolve nome de ícone em widget.
  final AppIconProvider provider;

  /// Padrão do design system: os SVGs que vêm no pacote.
  static const AppIconTheme standard = AppIconTheme();

  /// Cópia com [provider] sobrescrito.
  AppIconTheme copyWith({AppIconProvider? provider}) =>
      AppIconTheme(provider: provider ?? this.provider);

  @override
  List<Object?> get props => [provider];
}

/// Global de **estilo de container** do Flocks (espelha [AppRadiusTheme] e
/// [AppAnimationTheme]).
///
/// [style] define o tratamento de borda/fundo/sombra aplicado aos componentes
/// que não sobrescrevem `style` localmente (o fallback global). Default:
/// **[AppStyle.filled]**. Ver [AppStyle] para a semântica de cada valor.
class AppStyleTheme extends Equatable {
  /// Cria o global de estilo. [style] default [AppStyle.filled].
  const AppStyleTheme({this.style = AppStyle.filled});

  /// Estilo de container padrão do design system.
  final AppStyle style;

  /// Padrão do design system: [AppStyle.filled].
  static const AppStyleTheme standard = AppStyleTheme();

  /// Cópia com [style] sobrescrito.
  AppStyleTheme copyWith({AppStyle? style}) =>
      AppStyleTheme(style: style ?? this.style);

  @override
  List<Object?> get props => [style];
}

class AppThemeData extends Equatable {
  const AppThemeData({
    required this.brightness,
    required this.colorTheme,
    required this.textTheme,
    this.radiusTheme = AppRadiusTheme.standard,
    this.animationTheme = AppAnimationTheme.standard,
    this.styleTheme = AppStyleTheme.standard,
    this.transparencyTheme = AppTransparencyTheme.standard,
    this.glassTheme = AppGlassTheme.standard,
    this.iconTheme = AppIconTheme.standard,
    this.illustrationTheme = AppIllustrationTheme.standard,
  });

  final AppBrightness brightness;
  final AppColorTheme colorTheme;
  final AppTextTheme textTheme;
  final AppRadiusTheme radiusTheme;
  final AppAnimationTheme animationTheme;
  final AppStyleTheme styleTheme;
  final AppTransparencyTheme transparencyTheme;
  final AppGlassTheme glassTheme;
  final AppIconTheme iconTheme;
  final AppIllustrationTheme illustrationTheme;

  /// Cópia com um ou mais campos sobrescritos.
  AppThemeData copyWith({
    AppBrightness? brightness,
    AppColorTheme? colorTheme,
    AppTextTheme? textTheme,
    AppRadiusTheme? radiusTheme,
    AppAnimationTheme? animationTheme,
    AppStyleTheme? styleTheme,
    AppTransparencyTheme? transparencyTheme,
    AppGlassTheme? glassTheme,
    AppIconTheme? iconTheme,
    AppIllustrationTheme? illustrationTheme,
  }) => AppThemeData(
    brightness: brightness ?? this.brightness,
    colorTheme: colorTheme ?? this.colorTheme,
    textTheme: textTheme ?? this.textTheme,
    radiusTheme: radiusTheme ?? this.radiusTheme,
    animationTheme: animationTheme ?? this.animationTheme,
    styleTheme: styleTheme ?? this.styleTheme,
    transparencyTheme: transparencyTheme ?? this.transparencyTheme,
    glassTheme: glassTheme ?? this.glassTheme,
    iconTheme: iconTheme ?? this.iconTheme,
    illustrationTheme: illustrationTheme ?? this.illustrationTheme,
  );

  @override
  List<Object?> get props => [
    brightness,
    colorTheme,
    textTheme,
    radiusTheme,
    animationTheme,
    styleTheme,
    transparencyTheme,
    glassTheme,
    iconTheme,
    illustrationTheme,
  ];

  /// Tema de uma marca **explícita**, sem passar pelo registry global.
  ///
  /// [light]/[dark] leem `AppBrand.current` — um singleton de processo. Isso
  /// serve ao app (uma marca por execução) e atrapalha em dois lugares:
  ///
  /// - **teste**: trocar a marca global entre casos é estado compartilhado, e
  ///   uma suíte golden que roda em paralelo passa a depender da ordem;
  /// - **tela que mostra DUAS marcas ao mesmo tempo** (um seletor de marca,
  ///   uma prévia de white-label): com o singleton isso é impossível.
  ///
  /// Aqui a marca é argumento, então o tema é uma função pura dela.
  static AppThemeData forBrand(AppBrandConfig brand, {required bool dark}) {
    final AppColorTheme colorTheme = dark
        ? brand.toDarkColorTheme()
        : brand.toLightColorTheme();
    return AppThemeData(
      brightness: dark ? AppBrightness.dark : AppBrightness.light,
      colorTheme: colorTheme,
      textTheme: AppTextStyles.themeFor(
        colorTheme.onSurface,
        typography: brand.typography,
      ),
      radiusTheme: brand.radiusTheme,
      animationTheme: brand.animationTheme,
      styleTheme: brand.styleTheme,
      glassTheme: brand.glassTheme,
      iconTheme: brand.iconTheme,
      illustrationTheme: brand.illustrationTheme,
    );
  }

  static AppThemeData get light {
    final colorTheme = AppColorTheme.light;
    return AppThemeData(
      brightness: AppBrightness.light,
      colorTheme: colorTheme,
      textTheme: AppTextStyles.themeFor(
        colorTheme.onSurface,
        typography: AppBrand.current.typography,
      ),
      radiusTheme: AppBrand.current.radiusTheme,
      animationTheme: AppBrand.current.animationTheme,
      styleTheme: AppBrand.current.styleTheme,
      glassTheme: AppBrand.current.glassTheme,
      iconTheme: AppBrand.current.iconTheme,
      illustrationTheme: AppBrand.current.illustrationTheme,
    );
  }

  static AppThemeData get dark {
    final colorTheme = AppColorTheme.dark;
    return AppThemeData(
      brightness: AppBrightness.dark,
      colorTheme: colorTheme,
      textTheme: AppTextStyles.themeFor(
        colorTheme.onSurface,
        typography: AppBrand.current.typography,
      ),
      radiusTheme: AppBrand.current.radiusTheme,
      animationTheme: AppBrand.current.animationTheme,
      styleTheme: AppBrand.current.styleTheme,
      glassTheme: AppBrand.current.glassTheme,
      iconTheme: AppBrand.current.iconTheme,
      illustrationTheme: AppBrand.current.illustrationTheme,
    );
  }
}
