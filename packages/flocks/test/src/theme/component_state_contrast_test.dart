@Tags(<String>['contrast'])
library;

import 'dart:math' as math;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Valida o **contraste por ESTADO** dos átomos interativos (radio/checkbox/
// switch) — a camada que o contrato de token (contrast_test.dart) não cobre.
//
// Para cada componente × on/off × marca × brilho, checa 3 coisas sobre as cores
// resolvidas pelos resolvers puros (`appRadioStateColors`, etc.):
//   1. Habilitado VISÍVEL      — elemento mais saliente vs surface ≥ kUi (3:1).
//   2. Desabilitado PERCEPTÍVEL — ≥ kDisabledMinRatio (WCAG isenta, Flocks não
//      deixa sumir).
//   3. Desabilitado DISTINTO   — indicator habilitado↔desabilitado ΔT ≥
//      kDisabledDistinctionTone (dá pra ver que está desabilitado).
//
// Ver `docs/COLOR_ACCESSIBILITY_RULES.md` §7.

typedef _StateColors = ({Color indicator, Color? container, Color? border});
typedef _Resolver =
    _StateColors Function(
      AppColorTheme theme, {
      required bool selected,
      required bool disabled,
      required bool isDark,
    });

void main() {
  const List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  final List<({String name, _Resolver resolve})> components =
      <({String name, _Resolver resolve})>[
        (name: 'AppRadio', resolve: appRadioStateColors),
        (name: 'AppCheckbox', resolve: appCheckboxStateColors),
        (name: 'AppSwitch', resolve: appSwitchStateColors),
      ];

  AppColorTheme themeFor(AppBrandConfig brand, AppBrightness brightness) =>
      brightness == AppBrightness.dark
      ? brand.toDarkColorTheme()
      : brand.toLightColorTheme();

  // Maior razão de contraste entre qualquer elemento pintado (indicator/
  // container/border, ignorando os nulos) e a superfície — "dá pra ver o
  // controle?".
  double salience(_StateColors c, Color surface) {
    final List<Color> painted = <Color>[
      c.indicator,
      if (c.container != null) c.container!,
      if (c.border != null) c.border!,
    ];
    return painted.map((Color x) => contrastRatio(x, surface)).reduce(math.max);
  }

  // Maior mudança de tom entre o estado habilitado e o desabilitado, comparando
  // cada elemento com seu correspondente — "dá pra ver que mudou de estado?".
  // Pega o máximo porque às vezes o indicator não muda (ex.: checkmark branco
  // nos dois) mas o preenchimento muda muito.
  double distinction(_StateColors on, _StateColors off) {
    double best = toneDelta(on.indicator, off.indicator);
    if (on.container != null && off.container != null) {
      best = math.max(best, toneDelta(on.container!, off.container!));
    }
    if (on.border != null && off.border != null) {
      best = math.max(best, toneDelta(on.border!, off.border!));
    }
    return best;
  }

  group('Contraste por estado de componente (bloqueante)', () {
    for (final ({String name, _Resolver resolve}) comp in components) {
      for (final AppBrandConfig brand in brands) {
        for (final AppBrightness brightness in AppBrightness.values) {
          final AppColorTheme theme = themeFor(brand, brightness);
          final Color surface = theme.surface;
          final bool isDark = brightness == AppBrightness.dark;

          for (final bool selected in <bool>[true, false]) {
            final _StateColors on = comp.resolve(
              theme,
              selected: selected,
              disabled: false,
              isDark: isDark,
            );
            final _StateColors off = comp.resolve(
              theme,
              selected: selected,
              disabled: true,
              isDark: isDark,
            );
            final String scope =
                '${comp.name} ${selected ? 'on' : 'off'} · '
                '${brand.clientSlug}/${brightness.name}';

            test('$scope · habilitado visível (≥$kUi)', () {
              final double s = salience(on, surface);
              expect(
                s,
                greaterThanOrEqualTo(kUi),
                reason: '$scope: saliência ${s.toStringAsFixed(2)} < $kUi',
              );
            });

            // O PREENCHIMENTO em si (não só o indicador mais saliente) precisa
            // aparecer sobre a `surface` no estado marcado/ligado. Sem isto, um
            // fill escuro sobre superfície escura sumia e só o check branco
            // passava no `salience` (máximo) — o bug do acento primário cru.
            if (selected && on.container != null) {
              test('$scope · fill marcado visível na surface (≥$kUi)', () {
                final double r = contrastRatio(on.container!, surface);
                expect(
                  r,
                  greaterThanOrEqualTo(kUi),
                  reason:
                      '$scope: fill marcado ${r.toStringAsFixed(2)} < $kUi '
                      '(preenchimento some na superfície)',
                );
              });
            }

            test('$scope · desabilitado perceptível (≥$kDisabledMinRatio)', () {
              final double s = salience(off, surface);
              expect(
                s,
                greaterThanOrEqualTo(kDisabledMinRatio),
                reason:
                    '$scope: desabilitado ${s.toStringAsFixed(2)} '
                    '< $kDisabledMinRatio (sumiu)',
              );
            });

            test(
              '$scope · desabilitado distinto (ΔT≥$kDisabledDistinctionTone)',
              () {
                final double dt = distinction(on, off);
                expect(
                  dt,
                  greaterThanOrEqualTo(kDisabledDistinctionTone),
                  reason:
                      '$scope: habilitado↔desabilitado ΔT ${dt.toStringAsFixed(1)} '
                      '< $kDisabledDistinctionTone (não dá pra ver que desabilitou)',
                );
              },
            );

            test('$scope · marca habilitada legível no fill (≥$kUi)', () {
              final Color? fill = on.container;
              // A marca (check/ponto/thumb) do selecionado usa `surfaceContainer`
              // — o "furo" precisa contrastar ≥3:1 com o fill de acento. Só onde
              // há marca distinta do fill.
              if (fill == null || on.indicator == fill) return;
              final double r = contrastRatio(on.indicator, fill);
              expect(
                r,
                greaterThanOrEqualTo(kUi),
                reason:
                    '$scope: marca habilitada ${r.toStringAsFixed(2)} < $kUi '
                    'sobre o fill (some no preenchimento)',
              );
            });

            test('$scope · marca desabilitada legível no fill (≥$kUi)', () {
              final Color? fill = off.container;
              // Só quando há uma marca (check/ponto/thumb) distinta sobre um
              // fill — nos estados sem marca, indicator == container.
              if (fill == null || off.indicator == fill) return;
              final double r = contrastRatio(off.indicator, fill);
              expect(
                r,
                greaterThanOrEqualTo(kUi),
                reason:
                    '$scope: marca desabilitada ${r.toStringAsFixed(2)} < $kUi '
                    'sobre o fill (some no preenchimento)',
              );
            });
          }
        }
      }
    }
  });
}
