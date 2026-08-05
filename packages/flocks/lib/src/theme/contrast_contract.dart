/// **Contrato de contraste do Flocks** — a fonte única da verdade sobre quais
/// pares de cor do tema precisam de qual contraste, iterável por marca × brilho
/// (espelha o padrão do `flocksCatalog`).
///
/// Consumido por:
/// - `test/src/theme/contrast_test.dart` — testes estritos (AA bloqueante);
/// - `test/src/theme/contrast_report_test.dart` — gera o relatório das marcas.
///
/// Cada regra é um par `(foreground, background)` resolvido a partir de um
/// [AppColorTheme]. Os pares cor↔on-color usam os swatches **como Color** (valor
/// base), que é como os componentes os consomem (ex.: `theme.colorTheme.primary`
/// como `Color` em `app_checkbox.dart`).
///
/// Ver a explicação das regras em `docs/COLOR_ACCESSIBILITY_RULES.md`.
library;

import 'package:flutter/widgets.dart';

import '../tokens/contrast.dart';
import 'app_themes.dart';

/// Seleciona uma cor a partir do [AppColorTheme] resolvido.
typedef ColorSelector = Color Function(AppColorTheme theme);

/// Categoria de uma [ContrastRule] — define os alvos de razão e ΔT.
enum ContrastTier {
  /// Texto normal sobre fundo. AA 4.5 / AAA 7 / ΔT ≥ [kToneDeltaText].
  text,

  /// Par preenchimento↔conteúdo (cor da marca/semântica + seu on-color).
  /// AA 4.5 / AAA 7 / ΔT ≥ [kToneDeltaText].
  onColor,

  /// Componente de UI: borda, ícone, divisória, anel de foco.
  /// 3:1 / ΔT ≥ [kToneDeltaLargeUi].
  uiComponent,

  /// Separação sutil de hierarquia/elevação (ex.: container sobre a superfície).
  /// Sem piso WCAG, mas ΔT ≥ [kMinSeparationLight] (claro) /
  /// [kMinSeparationDark] (escuro) — a regra de **dobrar a separação no escuro**.
  separation,
}

/// Alvos de contraste (razão WCAG + ΔT de tom) para um [ContrastTier] num brilho.
@immutable
class ContrastTarget {
  /// Cria um alvo com [minRatio] (razão WCAG) e [minToneDelta] (ΔT de tom).
  const ContrastTarget({
    required this.minRatio,
    required this.minToneDelta,
    this.aaaRatio,
  });

  /// Razão WCAG 2 mínima (piso AA/estrutural — bloqueante).
  final double minRatio;

  /// Delta de tom HCT mínimo (métrica perceptual — bloqueante).
  final double minToneDelta;

  /// Razão AAA aspiracional (não bloqueante); `null` quando não se aplica.
  final double? aaaRatio;
}

/// Resolve os alvos de [tier] para um [brightness] (só a separação varia por
/// brilho — a regra de amplificação no escuro).
ContrastTarget contrastTargetFor(ContrastTier tier, AppBrightness brightness) =>
    switch (tier) {
      ContrastTier.text => const ContrastTarget(
        minRatio: kAaNormal,
        minToneDelta: kToneDeltaText,
        aaaRatio: kAaaNormal,
      ),
      ContrastTier.onColor => const ContrastTarget(
        minRatio: kAaNormal,
        minToneDelta: kToneDeltaText,
        aaaRatio: kAaaNormal,
      ),
      ContrastTier.uiComponent => const ContrastTarget(
        minRatio: kUi,
        minToneDelta: kToneDeltaLargeUi,
      ),
      ContrastTier.separation => ContrastTarget(
        minRatio: 1,
        minToneDelta: brightness == AppBrightness.dark
            ? kMinSeparationDark
            : kMinSeparationLight,
      ),
    };

/// Uma regra do contrato: um par de cores do tema com um alvo por [tier].
@immutable
class ContrastRule {
  /// Cria uma regra identificada por [id], da categoria [tier], entre
  /// [foreground] e [background].
  const ContrastRule({
    required this.id,
    required this.tier,
    required this.foreground,
    required this.background,
    this.appliesTo,
  });

  /// Identificador legível (ex.: `onPrimary/primary`).
  final String id;

  /// Categoria — determina os alvos via [contrastTargetFor].
  final ContrastTier tier;

  /// Primeiro plano (texto/conteúdo/borda).
  final ColorSelector foreground;

  /// Fundo.
  final ColorSelector background;

  /// Se dado, a regra só vale para o brilho em que retorna `true`
  /// (ex.: regras estruturais só do tema escuro).
  final bool Function(AppBrightness brightness)? appliesTo;
}

// --- Seletores (tear-offs const p/ a lista `const`) --------------------------

Color _surface(AppColorTheme t) => t.surface;
Color _onSurface(AppColorTheme t) => t.onSurface;
Color _primary(AppColorTheme t) => t.primary;
Color _onPrimary(AppColorTheme t) => t.onPrimary;
Color _secondary(AppColorTheme t) => t.secondary;
Color _onSecondary(AppColorTheme t) => t.onSecondary;
Color _tertiary(AppColorTheme t) => t.tertiary;
Color _onTertiary(AppColorTheme t) => t.onTertiary;
Color _danger(AppColorTheme t) => t.danger;
Color _onDanger(AppColorTheme t) => t.onDanger;
Color _info(AppColorTheme t) => t.info;
Color _onInfo(AppColorTheme t) => t.onInfo;
Color _success(AppColorTheme t) => t.success;
Color _onSuccess(AppColorTheme t) => t.onSuccess;
Color _warning(AppColorTheme t) => t.warning;
Color _onWarning(AppColorTheme t) => t.onWarning;
Color _borderNeutral(AppColorTheme t) => t.outline;
Color _focusRing(AppColorTheme t) => t.focusRing;
Color _containerStep(AppColorTheme t) => t.surfaceContainer;
Color _neutralBlack(AppColorTheme t) => t.neutralBlack;
Color _onNeutralBlack(AppColorTheme t) => t.onNeutralBlack;
Color _neutralWhite(AppColorTheme t) => t.neutralWhite;
Color _onNeutralWhite(AppColorTheme t) => t.onNeutralWhite;
Color _chartGood(AppColorTheme t) => t.chartGood;
Color _chartNeutral(AppColorTheme t) => t.chartNeutral;
Color _chartBad(AppColorTheme t) => t.chartBad;
Color _scoreLow(AppColorTheme t) => t.scoreLow;
Color _scoreMid(AppColorTheme t) => t.scoreMid;
Color _scoreHigh(AppColorTheme t) => t.scoreHigh;

/// Todas as regras de contraste que toda marca × brilho deve satisfazer.
///
/// Alterar o tema (papéis de cor) → adicionar/ajustar a regra correspondente
/// aqui (parte da "Definition of Accessible").
const List<ContrastRule> flocksContrastContract = <ContrastRule>[
  // Texto de corpo.
  ContrastRule(
    id: 'onSurface/surface',
    tier: ContrastTier.text,
    foreground: _onSurface,
    background: _surface,
  ),

  // Pares preenchimento↔on-color (como `theme.colorTheme.X` é consumido: base).
  ContrastRule(
    id: 'onPrimary/primary',
    tier: ContrastTier.onColor,
    foreground: _onPrimary,
    background: _primary,
  ),
  ContrastRule(
    id: 'onSecondary/secondary',
    tier: ContrastTier.onColor,
    foreground: _onSecondary,
    background: _secondary,
  ),
  ContrastRule(
    id: 'onTertiary/tertiary',
    tier: ContrastTier.onColor,
    foreground: _onTertiary,
    background: _tertiary,
  ),
  ContrastRule(
    id: 'onDanger/danger',
    tier: ContrastTier.onColor,
    foreground: _onDanger,
    background: _danger,
  ),
  ContrastRule(
    id: 'onInfo/info',
    tier: ContrastTier.onColor,
    foreground: _onInfo,
    background: _info,
  ),
  ContrastRule(
    id: 'onSuccess/success',
    tier: ContrastTier.onColor,
    foreground: _onSuccess,
    background: _success,
  ),
  ContrastRule(
    id: 'onWarning/warning',
    tier: ContrastTier.onColor,
    foreground: _onWarning,
    background: _warning,
  ),

  // UI / bordas / foco (3:1).
  ContrastRule(
    id: 'border(outline)/surface',
    tier: ContrastTier.uiComponent,
    foreground: _borderNeutral,
    background: _surface,
  ),
  ContrastRule(
    id: 'focusRing/surface',
    tier: ContrastTier.uiComponent,
    foreground: _focusRing,
    background: _surface,
  ),

  // Elevação/container sobre a superfície — a regra de dobrar a separação no
  // tema escuro (ΔT ≥ 12 claro / ≥ 24 escuro).
  ContrastRule(
    id: 'surfaceContainer/surface',
    tier: ContrastTier.separation,
    foreground: _containerStep,
    background: _surface,
  ),

  // Neutros preto/branco (fills de overlay/chip) + seu on-color de máximo
  // contraste.
  ContrastRule(
    id: 'onNeutralBlack/neutralBlack',
    tier: ContrastTier.onColor,
    foreground: _onNeutralBlack,
    background: _neutralBlack,
  ),
  ContrastRule(
    id: 'onNeutralWhite/neutralWhite',
    tier: ContrastTier.onColor,
    foreground: _onNeutralWhite,
    background: _neutralWhite,
  ),

  // Data-viz **semântico** (gráficos/scores que carregam significado) sobre a
  // superfície — objeto gráfico, alvo 3:1 (WCAG 1.4.11). A série categórica
  // (`chartCategorical`) é decorativa (distinta por legenda/posição) e está
  // isenta por ora — ver `docs/COLOR_ACCESSIBILITY_RULES.md` §6.
  ContrastRule(
    id: 'chartGood/surface',
    tier: ContrastTier.uiComponent,
    foreground: _chartGood,
    background: _surface,
  ),
  ContrastRule(
    id: 'chartNeutral/surface',
    tier: ContrastTier.uiComponent,
    foreground: _chartNeutral,
    background: _surface,
  ),
  ContrastRule(
    id: 'chartBad/surface',
    tier: ContrastTier.uiComponent,
    foreground: _chartBad,
    background: _surface,
  ),
  ContrastRule(
    id: 'scoreLow/surface',
    tier: ContrastTier.uiComponent,
    foreground: _scoreLow,
    background: _surface,
  ),
  ContrastRule(
    id: 'scoreMid/surface',
    tier: ContrastTier.uiComponent,
    foreground: _scoreMid,
    background: _surface,
  ),
  ContrastRule(
    id: 'scoreHigh/surface',
    tier: ContrastTier.uiComponent,
    foreground: _scoreHigh,
    background: _surface,
  ),
];

/// Regra estrutural do tema **escuro**: a superfície base não pode ser preto
/// puro — seu tom HCT deve ficar em `[`[kDarkSurfaceToneMin]`,`
/// [kDarkSurfaceToneMax]`]`.
bool darkSurfaceInBand(AppColorTheme theme) {
  final double tone = hctTone(theme.surface);
  return tone >= kDarkSurfaceToneMin && tone <= kDarkSurfaceToneMax;
}

// --- Regras estruturais (single-color, não-pareadas) -------------------------

/// Regra **estrutural** do tema: uma checagem sobre **uma** cor (não um par
/// `fg/bg`), como "a superfície escura não é preto puro". Vive na mesma fonte
/// única que [flocksContrastContract] e é iterada pelos mesmos consumidores
/// (testes + relatório), eliminando o `if (brightness == dark)` duplicado.
@immutable
class StructuralRule {
  /// Cria uma regra estrutural identificada por [id].
  const StructuralRule({
    required this.id,
    required this.label,
    required this.subject,
    required this.metric,
    required this.metricPrefix,
    required this.targetLabel,
    required this.check,
    this.appliesTo,
  });

  /// Identificador legível (ex.: `surface fora do preto puro`).
  final String id;

  /// Rótulo da categoria (coluna "Tier" do relatório, ex.: `darkSurface`).
  final String label;

  /// Cor avaliada — usada para exibir o hex no relatório.
  final ColorSelector subject;

  /// Métrica numérica avaliada (ex.: o tom HCT da superfície).
  final double Function(AppColorTheme theme) metric;

  /// Prefixo da métrica no relatório (ex.: `T=`).
  final String metricPrefix;

  /// Rótulo do alvo no relatório e nas mensagens de falha (ex.: `[6.0, 16.0]`).
  final String targetLabel;

  /// `true` quando a regra é satisfeita pelo tema.
  final bool Function(AppColorTheme theme) check;

  /// Se dado, a regra só vale para o brilho em que retorna `true`
  /// (ex.: regras só do tema escuro).
  final bool Function(AppBrightness brightness)? appliesTo;
}

Color _surfaceSubject(AppColorTheme t) => t.surface;
double _surfaceTone(AppColorTheme t) => hctTone(t.surface);
bool _darkOnly(AppBrightness brightness) => brightness == AppBrightness.dark;

/// Rótulo do alvo da banda de superfície escura (`[6.0, 16.0]`).
const String _darkSurfaceTargetLabel =
    '[$kDarkSurfaceToneMin, $kDarkSurfaceToneMax]';

/// Regras estruturais (single-color) que toda marca × brilho deve satisfazer.
///
/// Junto de [flocksContrastContract], compõe a fonte única da verdade de
/// acessibilidade de cor do Flocks.
const List<StructuralRule> flocksStructuralContract = <StructuralRule>[
  StructuralRule(
    id: 'surface fora do preto puro',
    label: 'darkSurface',
    subject: _surfaceSubject,
    metric: _surfaceTone,
    metricPrefix: 'T=',
    targetLabel: _darkSurfaceTargetLabel,
    check: darkSurfaceInBand,
    appliesTo: _darkOnly,
  ),
];
