@Tags(<String>['contrast'])
library;

import 'dart:io';

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Testa o `flocksContrastContract` para cada marca × brilho.
//
// AA + regras estruturais/perceptuais do Flocks são **bloqueantes** (falham de
// verdade). AAA é aspiracional: apenas reportado (nunca quebra o build).
//
// As duas marcas passam AA em todas as verificações (ver
// `docs/COLOR_ACCESSIBILITY_REPORT.md`). O gate segue ligado para impedir
// regressões — qualquer novo par/paleta fora do contrato reprova aqui.
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    flocksBrand,
    jotapeBrand,
    zxtrackBrand,
  ];

  AppColorTheme themeFor(AppBrandConfig brand, AppBrightness brightness) =>
      brightness == AppBrightness.dark
      ? brand.toDarkColorTheme()
      : brand.toLightColorTheme();

  group('WCAG AA + regras Flocks (bloqueante)', () {
    for (final AppBrandConfig brand in brands) {
      for (final AppBrightness brightness in AppBrightness.values) {
        final AppColorTheme theme = themeFor(brand, brightness);
        final String scope = '${brand.clientSlug}/${brightness.name}';

        for (final ContrastRule rule in flocksContrastContract) {
          if (rule.appliesTo != null && !rule.appliesTo!(brightness)) continue;
          final ContrastTarget target = contrastTargetFor(
            rule.tier,
            brightness,
          );

          test('$scope · ${rule.id} (${rule.tier.name})', () {
            final Color fg = rule.foreground(theme);
            final Color bg = rule.background(theme);
            final double ratio = contrastRatio(fg, bg);
            final double dt = toneDelta(fg, bg);

            expect(
              ratio,
              greaterThanOrEqualTo(target.minRatio),
              reason:
                  '$scope ${rule.id}: razão WCAG ${ratio.toStringAsFixed(2)} '
                  '< ${target.minRatio}',
            );
            expect(
              dt,
              greaterThanOrEqualTo(target.minToneDelta),
              reason:
                  '$scope ${rule.id}: ΔT ${dt.toStringAsFixed(1)} '
                  '< ${target.minToneDelta}',
            );
          });
        }

        // Regras estruturais (single-color) — iteradas da mesma fonte única.
        for (final StructuralRule rule in flocksStructuralContract) {
          if (rule.appliesTo != null && !rule.appliesTo!(brightness)) continue;
          test('$scope · ${rule.id}', () {
            expect(
              rule.check(theme),
              isTrue,
              reason:
                  '$scope ${rule.id}: ${rule.metricPrefix}'
                  '${rule.metric(theme).toStringAsFixed(1)} fora de '
                  '${rule.targetLabel}',
            );
          });
        }
      }
    }
  });

  // AAA — aspiracional, NÃO bloqueante: só reporta (sempre passa).
  test('AAA (aspiracional, informativo)', () {
    final StringBuffer out = StringBuffer('AAA (7:1 texto / 4.5 grande):\n');
    for (final AppBrandConfig brand in brands) {
      for (final AppBrightness brightness in AppBrightness.values) {
        final AppColorTheme theme = themeFor(brand, brightness);
        for (final ContrastRule rule in flocksContrastContract) {
          final ContrastTarget target = contrastTargetFor(
            rule.tier,
            brightness,
          );
          if (target.aaaRatio == null) continue;
          if (rule.appliesTo != null && !rule.appliesTo!(brightness)) continue;
          final double ratio = contrastRatio(
            rule.foreground(theme),
            rule.background(theme),
          );
          final bool ok = ratio >= target.aaaRatio!;
          out.writeln(
            '  ${ok ? 'AAA' : ' — '} ${brand.clientSlug}/${brightness.name} '
            '${rule.id}: ${ratio.toStringAsFixed(2)}',
          );
        }
      }
    }
    stdout.writeln(out.toString());
    expect(true, isTrue);
  });
}
