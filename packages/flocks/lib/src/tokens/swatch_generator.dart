import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:material_color_utilities/hct/hct.dart' show Hct;

import 'contrast.dart' show kAaNormal, toneDelta;

/// Os 11 stops de um swatch do Flocks, do mais claro (50) ao mais escuro (950).
///
/// É a mesma escada nas duas rampas — a cromática de [swatchFromSeed] e a neutra
/// de [neutralSwatchFromSeed] —, o que muda entre elas é o TOM de cada stop, não
/// quais stops existem. Público porque quem percorre um swatch precisa da lista:
/// um `ColorSwatch` não expõe as próprias chaves.
const List<int> kSwatchStops = <int>[
  50,
  100,
  200,
  300,
  400,
  500,
  600,
  700,
  800,
  900,
  950,
];

/// Tons (HCT tone, 0–100) de cada stop do swatch, do mais claro (50) ao mais
/// escuro (950) — mesma convenção dos swatches de `AppColors`.
///
/// O 950 existe porque as marcas escritas à mão o declaram, e a JotaPe ancora
/// o próprio `primary` nele. Sem o stop, uma marca gerada por semente ficava
/// com um degrau a menos que uma escrita à mão — `s950` cai em `s900`, então
/// nada quebrava, mas o extremo escuro chegava claro demais.
const Map<int, double> _stopTones = <int, double>{
  50: 95,
  100: 90,
  200: 80,
  300: 70,
  400: 60,
  500: 49,
  600: 40,
  700: 30,
  800: 20,
  900: 10,
  950: 6,
};

/// Gera um [ColorSwatch] de 11 stops (50–950) a partir de uma cor-seed usando
/// **HCT tone** (perceptualmente uniforme).
///
/// Preserva matiz e croma da marca e varia apenas o tom, dando contraste
/// consistente entre matizes — diferente de interpolar *lightness* em HSL. É a
/// base para o tema claro E escuro derivarem das cores de branding, o que todo
/// componente migrado declara como `themeAware` e
/// `tool/component_conformance.dart` cobra (Regra 9).
ColorSwatch<int> swatchFromSeed(Color seed) => _swatch(seed, _stopTones);

/// Tons da rampa **neutra**, que não é a mesma dos papéis cromáticos.
///
/// O tema usa a neutra em dois papéis com exigência de contraste entre si:
/// `surface` sai do stop 300 e `outline` do 600 (ver `toLightColorTheme`). Na
/// escada cromática esses dois ficam a 30 tons um do outro — razão 2.79, abaixo
/// do piso de 3.0 para componente de UI. Ou seja: **toda** marca gerada por
/// semente reprovaria o gate de contraste, no mesmo lugar.
///
/// Estes valores saem das rampas escritas à mão da JotaPe e da ZX, que passam:
/// a extremidade clara é comprimida (50–300 acima de tom 87, todos utilizáveis
/// como superfície) e a queda é rápida depois do 300.
const Map<int, double> _neutralStopTones = <int, double>{
  50: 98,
  100: 96,
  200: 92,
  300: 87,
  400: 69,
  500: 51,
  600: 40,
  700: 32,
  800: 21,
  900: 13,
  950: 8,
};

/// Gera a rampa **neutra** de uma marca a partir de uma semente.
///
/// Mesma ideia de [swatchFromSeed] — matiz e croma da semente preservados, só o
/// tom varia — com a escada de [_neutralStopTones]. Use esta para
/// `neutralLightColor`/`neutralDarkColor`; a outra reprova o contrato de
/// contraste entre `surface` e `outline`.
///
/// Uma semente com croma baixo (um cinza levemente tingido) dá o resultado
/// esperado: superfícies que parecem da mesma família que o primário, sem virar
/// uma rampa colorida.
ColorSwatch<int> neutralSwatchFromSeed(Color seed) =>
    _swatch(seed, _neutralStopTones);

/// Espelha um swatch: o valor do stop mais claro vai para o mais escuro.
///
/// É como a rampa neutra ESCURA de uma marca se obtém da clara. O tema espera de
/// toda rampa neutra a mesma semântica — `s50` é o fundo, `s900` é o conteúdo —
/// e no escuro isso significa que o `s50` precisa ser o tom mais escuro. Refletir
/// a rampa mantém essa semântica sem duplicar a escolha de cor: uma semente
/// gera as duas pontas.
///
/// O `value` do resultado é o do swatch de origem, ou seja, a semente sobrevive
/// ao espelhamento — é o que permite a uma marca gerada por semente continuar
/// se descrevendo pela semente depois de refletida.
ColorSwatch<int> flippedSwatch(ColorSwatch<int> swatch) =>
    ColorSwatch<int>(swatch.toARGB32(), <int, Color>{
      for (int i = 0; i < kSwatchStops.length; i++)
        kSwatchStops[i]: swatch[kSwatchStops[kSwatchStops.length - 1 - i]]!,
    });

ColorSwatch<int> _swatch(Color seed, Map<int, double> tones) {
  final Hct base = Hct.fromInt(seed.toARGB32());
  return ColorSwatch<int>(seed.toARGB32(), <int, Color>{
    for (final MapEntry<int, double> entry in tones.entries)
      entry.key: Color(Hct.from(base.hue, base.chroma, entry.value).toInt()),
  });
}

/// Deriva uma superfície **elevada** (card/sheet/popover) a partir de [surface]
/// deslocando o **tom HCT** por [deltaTone], preservando matiz e croma (fica
/// on-brand). No escuro ([isDark]) a elevação **clareia**; no claro, **escurece**
/// — "elevação por clareamento" no dark (ver COLOR_ACCESSIBILITY_RULES §4).
///
/// Brand-agnóstico: garante a separação de tom pedida pela regra de contraste
/// independente das quirks do ramp neutro de cada marca.
Color elevatedSurface(
  Color surface, {
  required bool isDark,
  required double deltaTone,
}) {
  final Hct hct = Hct.fromInt(surface.toARGB32());
  final double tone = (isDark ? hct.tone + deltaTone : hct.tone - deltaTone)
      .clamp(0.0, 100.0);
  return Color(Hct.from(hct.hue, hct.chroma, tone).toInt());
}

/// Razão de contraste WCAG entre [a] e [b] (1.0 a 21.0).
double contrastRatio(Color a, Color b) {
  final double la = a.computeLuminance();
  final double lb = b.computeLuminance();
  final double hi = math.max(la, lb);
  final double lo = math.min(la, lb);
  return (hi + 0.05) / (lo + 0.05);
}

/// Escolhe, dentro de [swatch], o stop com contraste ≥ [minRatio] sobre
/// [background] — para usar uma cor de marca/semântica como **elemento de UI**
/// (borda, ícone, texto de acento) sobre uma superfície, garantindo ≥ 3:1
/// (COLOR_ACCESSIBILITY_RULES §5). Em fundo claro varre preferindo stops
/// escuros; em fundo escuro, stops claros. Cai no stop de **maior** contraste se
/// nenhum atingir o alvo (torna a falha visível em teste, sem sumir).
Color readableStopOn(
  ColorSwatch<int> swatch,
  Color background, {
  double minRatio = 3.0,
}) {
  final bool darkBg = Hct.fromInt(background.toARGB32()).tone < 50;
  const List<int> onDark = <int>[
    300,
    400,
    200,
    500,
    100,
    600,
    700,
    800,
    900,
    50,
  ];
  const List<int> onLight = <int>[
    700,
    600,
    800,
    500,
    900,
    400,
    300,
    200,
    100,
    50,
  ];
  final List<int> order = darkBg ? onDark : onLight;
  Color best = swatch[order.first] ?? swatch;
  double bestRatio = contrastRatio(best, background);
  for (final int stop in order) {
    final Color? candidate = swatch[stop];
    if (candidate == null) continue;
    final double ratio = contrastRatio(candidate, background);
    if (ratio >= minRatio) return candidate;
    if (ratio > bestRatio) {
      best = candidate;
      bestRatio = ratio;
    }
  }
  return best;
}

/// Escolhe, dentro de [swatch], o preenchimento **mais suave** que ainda se
/// distingue de todas as superfícies em [surfaces] e mantém [content] legível.
///
/// Serve ao caso em que um preenchimento pode aparecer sobre mais de uma
/// superfície (um campo vive tanto na página quanto dentro de um cartão) e
/// nenhum stop fixo serve às duas: escolher por marca à mão não escala, porque
/// cada paleta distribui os stops de um jeito.
///
/// Diferente de [readableStopOn], não há a regra de separação a cumprir — este
/// preenchimento é **isento** dela (ver `contrast_contract`). [minSeparation] é
/// só um piso de perceptibilidade, bem abaixo da regra.
///
/// A busca devolve o **primeiro** stop que serve, varrendo do mais claro ao
/// mais escuro — ou seja, o mais discreto. Buscar o *mais separado* levaria
/// sempre ao extremo da rampa: um campo de erro vermelho-berrante em vez de um
/// fundo de aviso.
///
/// [content] é o que se escreve por cima, e sua legibilidade é inegociável:
/// stops abaixo de [minContentRatio] são descartados antes da escolha.
Color mostSeparatedStop(
  ColorSwatch<int> swatch, {
  required List<Color> surfaces,
  required Color content,
  double minSeparation = 5.0,
  double minContentRatio = kAaNormal,
  List<int> candidates = const <int>[
    50,
    100,
    200,
    300,
    400,
    500,
    600,
    700,
    800,
    900,
  ],
}) {
  Color? mostSeparated;
  double bestSeparation = -1;
  Color? mostLegible;
  double bestContentRatio = -1;

  for (final int stop in candidates) {
    final Color? candidate = swatch[stop];
    if (candidate == null) continue;

    final double contentRatio = contrastRatio(content, candidate);
    if (contentRatio > bestContentRatio) {
      bestContentRatio = contentRatio;
      mostLegible = candidate;
    }
    if (contentRatio < minContentRatio) continue;

    double separation = double.infinity;
    for (final Color surface in surfaces) {
      final double delta = toneDelta(candidate, surface);
      if (delta < separation) separation = delta;
    }
    if (separation >= minSeparation) return candidate;
    if (separation > bestSeparation) {
      bestSeparation = separation;
      mostSeparated = candidate;
    }
  }

  // Nenhum stop atinge o piso: fica o mais separado entre os legíveis; e se
  // nem legível houver, o mais legível — texto ilegível é pior que fundo raso.
  return mostSeparated ?? mostLegible ?? swatch;
}

/// Retorna preto ou branco — o que tiver **maior contraste** sobre
/// [background]. Usado para garantir on-colors legíveis por marca/brilho.
Color onColorFor(Color background) {
  const Color white = Color(0xFFFFFFFF);
  const Color black = Color(0xFF000000);
  return contrastRatio(background, white) >= contrastRatio(background, black)
      ? white
      : black;
}
