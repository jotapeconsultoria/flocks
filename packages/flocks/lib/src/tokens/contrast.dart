/// Métricas e alvos de **contraste de acessibilidade** do Flocks.
///
/// Duas métricas complementares, ambas usadas pelas regras (ver
/// `doc/COLOR_ACCESSIBILITY_RULES.md`):
///
/// 1. **Razão WCAG 2** (`contrastRatio`, em `swatch_generator.dart`) — o piso
///    legal/normativo (1.0 a 21.0).
/// 2. **Delta de tom HCT** (`toneDelta`) — a medida perceptual amigável ao
///    designer. Tom (T) é o L\* de CIELAB, perceptualmente uniforme. A "regra
///    40/50" do Material 3: ΔT≥40 garante razão ≥3.0; ΔT≥50 garante ≥4.5.
///
/// Por que as duas: a fórmula WCAG 2 **superestima** o contraste quando as duas
/// cores são escuras, então no tema escuro o ΔT é o guia mais confiável — daí a
/// regra de **amplificar a separação no escuro** ([kMinSeparationDark] ≈ 2× a do
/// claro).
library;

import 'package:flutter/widgets.dart';
import 'package:material_color_utilities/hct/hct.dart' show Hct;

import 'swatch_generator.dart' show contrastRatio, onColorFor;

// ---------------------------------------------------------------------------
// Alvos de razão WCAG 2 (primeiro plano vs fundo).
// ---------------------------------------------------------------------------

/// AA para texto normal (< 18pt, ou < 14pt bold): **4.5:1**.
const double kAaNormal = 4.5;

/// AA para texto grande (≥ 18pt, ou ≥ 14pt bold): **3:1**.
const double kAaLarge = 3.0;

/// AA para componentes de UI, ícones, bordas, anéis de foco e gráficos: **3:1**.
const double kUi = 3.0;

/// AAA para texto normal: **7:1**.
const double kAaaNormal = 7.0;

/// AAA para texto grande: **4.5:1**.
const double kAaaLarge = 4.5;

// ---------------------------------------------------------------------------
// Alvos de delta de tom HCT (a "regra 40/50" do Material 3).
// ---------------------------------------------------------------------------

/// ΔT de tom HCT que garante razão ≥ 4.5 — equivalente perceptual de
/// [kAaNormal].
const double kToneDeltaText = 50.0;

/// ΔT de tom HCT que garante razão ≥ 3.0 — equivalente de [kAaLarge] / [kUi].
const double kToneDeltaLargeUi = 40.0;

// ---------------------------------------------------------------------------
// Regra de amplificação no tema escuro (separação de hierarquia/elevação).
// ---------------------------------------------------------------------------

/// Separação mínima de tom (ΔT) entre superfícies/containers adjacentes no tema
/// **claro** (ex.: card sobre o fundo).
///
/// O valor não é arbitrário: é a distância de **3 passos da rampa neutra**
/// (`s50→s300`), medida em 11.1. Antes era 12.0 — um número redondo que a rampa
/// simplesmente não tem: os acumulados a partir da base são 1.8, 5.9, 11.1 e
/// 28.8. Exigir 12 obrigava as superfícies a serem calculadas FORA da rampa,
/// que é como a regra de dobrar no escuro passou a depender de aritmética
/// manual em vez de vir da paleta.
///
/// Este tier não tem piso WCAG (`minRatio: 1`) — é hierarquia visual, não
/// legibilidade de texto.
const double kMinSeparationLight = 11.0;

/// Separação mínima de tom no tema **escuro** — 2× a do claro
/// ([kMinSeparationLight]). No escuro a luz é "absorvida" e o WCAG 2 superestima
/// o contraste, então uma separação que basta no claro fica imperceptível no
/// escuro. Dobrar o ΔT é a regra prática.
///
/// **A rampa já entrega isso.** Ela é assimétrica de propósito (passos finos
/// perto do branco, grossos perto do preto) e a versão escura é a clara
/// invertida: os mesmos 3 passos valem 11.1 tons no claro e 22.2 no escuro —
/// razão 2.00. Usar shades nos dois temas satisfaz a regra sem número nenhum
/// para manter sincronizado.
const double kMinSeparationDark = 22.0;

// ---------------------------------------------------------------------------
// Banda de tom da superfície escura (evitar preto puro).
// ---------------------------------------------------------------------------

/// Tom HCT mínimo da superfície base no tema escuro. Abaixo disso a superfície
/// é ~preto puro → halation e elevação (por clareamento) fica impossível.
const double kDarkSurfaceToneMin = 6.0;

/// Tom HCT máximo da superfície base no tema escuro (mantém o "escuro").
const double kDarkSurfaceToneMax = 16.0;

// ---------------------------------------------------------------------------
// Estados desabilitados (perceptíveis, sem opacidade). Ver RULES §7.
// ---------------------------------------------------------------------------

/// Deslocamento de tom (ΔT vs `surface`) de um elemento **desabilitado**.
///
/// O disabled é apagado por **tom** (não por opacidade): a cor vai para
/// `toneDaSurface ± kDisabledProminenceTone`, no sentido da cor original. Assim
/// fica perceptível nos dois temas — no escuro, reduzir opacidade aproximaria do
/// fundo escuro e **sumiria**.
const double kDisabledProminenceTone = 22.0;

/// Fração do croma preservada no estado desabilitado (dessatura o disabled).
const double kDisabledChromaRetention = 0.4;

/// Razão mínima de um elemento **desabilitado** vs `surface`. A WCAG isenta
/// controles inativos, mas o Flocks exige um piso de **perceptibilidade** para
/// o disabled não sumir.
const double kDisabledMinRatio = 1.5;

/// ΔT mínimo entre a versão **habilitada** e a **desabilitada** de um elemento —
/// garante que dá para **perceber que está desabilitado**.
const double kDisabledDistinctionTone = 10.0;

/// Fração que o **indicador desabilitado** (check/ponto/thumb) recua da sua
/// on-color em direção ao tom do fill. Pequena de propósito: o indicador precisa
/// ficar **claro sobre fill escuro** (e vice-versa) para não sumir — só um pouco
/// mais apagado que o habilitado.
const double kDisabledIndicatorRetention = 0.25;

// ---------------------------------------------------------------------------
// Funções.
// ---------------------------------------------------------------------------

/// Tom HCT (T, 0–100) de [color] — lightness perceptual (o L\* de CIELAB).
double hctTone(Color color) => Hct.fromInt(color.toARGB32()).tone;

/// Diferença absoluta de tom HCT entre [a] e [b] (0–100).
double toneDelta(Color a, Color b) => (hctTone(a) - hctTone(b)).abs();

/// Versão **desabilitada** de [content] sobre [surface]: dessatura ([kDisabledChromaRetention])
/// e desloca o tom para `tomDaSurface ± `[kDisabledProminenceTone] no sentido da
/// cor original.
///
/// Substitui o idioma de opacidade (`Color.disabled()`), que some no tema escuro
/// (dark sobre dark). Preserva a matiz (identidade da marca) e garante
/// perceptibilidade + distinção do estado habilitado. Ver RULES §7.
Color mutedForDisabled(Color content, Color surface) {
  final Hct c = Hct.fromInt(content.toARGB32());
  final Hct s = Hct.fromInt(surface.toARGB32());
  final double direction = c.tone >= s.tone ? 1.0 : -1.0;
  final double tone = (s.tone + direction * kDisabledProminenceTone).clamp(
    0.0,
    100.0,
  );
  return Color(
    Hct.from(c.hue, c.chroma * kDisabledChromaRetention, tone).toInt(),
  );
}

/// Cor do **indicador desabilitado** (check/ponto/thumb) sobre [container].
///
/// Parte da on-color legível do [container] ([onColorFor] — preto **ou** branco,
/// polaridade correta por brilho) e recua [kDisabledIndicatorRetention] em
/// direção ao tom do fill. Assim o check/ponto continua **visível sobre o fill
/// apagado** (claro no dark, escuro no claro) em vez de sumir junto com ele —
/// diferente de [mutedForDisabled], que apaga rumo à `surface`.
Color disabledIndicatorOn(Color container) {
  final Hct on = Hct.fromInt(onColorFor(container).toARGB32());
  final Hct c = Hct.fromInt(container.toARGB32());
  final double tone =
      on.tone + kDisabledIndicatorRetention * (c.tone - on.tone);
  return Color(
    Hct.from(on.hue, on.chroma * kDisabledChromaRetention, tone).toInt(),
  );
}

/// Tamanho de texto para fins de contraste WCAG.
enum WcagTextSize {
  /// Texto normal (< 18pt / < 14pt bold): alvo AA 4.5, AAA 7.
  normal,

  /// Texto grande (≥ 18pt / ≥ 14pt bold): alvo AA 3, AAA 4.5.
  large,
}

/// Nível de conformidade WCAG.
enum WcagLevel {
  /// Nível AA — piso obrigatório do Flocks.
  aa,

  /// Nível AAA — meta aspiracional (não bloqueante).
  aaa,
}

/// Razão de contraste **mínima** exigida para [size] no [level].
double wcagMinRatio(WcagTextSize size, WcagLevel level) =>
    switch ((size, level)) {
      (WcagTextSize.normal, WcagLevel.aa) => kAaNormal,
      (WcagTextSize.large, WcagLevel.aa) => kAaLarge,
      (WcagTextSize.normal, WcagLevel.aaa) => kAaaNormal,
      (WcagTextSize.large, WcagLevel.aaa) => kAaaLarge,
    };

/// `true` se [fg] sobre [bg] atinge o alvo WCAG de [size]/[level].
///
/// Usa a razão WCAG 2 ([contrastRatio]). Para a métrica perceptual, use
/// [toneDelta] com [kToneDeltaText] / [kToneDeltaLargeUi].
bool meetsWcag(
  Color fg,
  Color bg, {
  WcagTextSize size = WcagTextSize.normal,
  WcagLevel level = WcagLevel.aa,
}) => contrastRatio(fg, bg) >= wcagMinRatio(size, level);
