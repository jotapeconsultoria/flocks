@Tags(<String>['contrast'])
library;

import 'dart:io';

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Gera/atualiza o relatório de conformidade de contraste das marcas.
//
// Precisa de `dart:ui` (Color.computeLuminance) e das cores da marca (que
// importam Flutter), por isso vive como TESTE, não como `dart run tool/...`.
//
// Rodar como relatório vivo (só imprime):
//   flutter test test/src/theme/contrast_report_test.dart
// Gravar o markdown em doc/:
//   flutter test --dart-define=CONTRAST_REPORT=true \
//     test/src/theme/contrast_report_test.dart

const bool _write = bool.fromEnvironment('CONTRAST_REPORT');
const String _reportPath = 'doc/COLOR_ACCESSIBILITY_REPORT.md';

// A MESMA lista de `contrast_test.dart`, na mesma ordem, e isso é requisito: um
// gerador que mostra menos marcas que o gate bloqueante produz relatório que
// mente por omissão. A `flocksBrand` vem primeiro porque é a marca do próprio
// design system — quem abre o relatório procura o pacote, não os clientes dele.
final List<AppBrandConfig> _brands = <AppBrandConfig>[
  flocksBrand,
  jotapeBrand,
  zxtrackBrand,
];

String _hex(Color c) {
  final int v = c.toARGB32() & 0xFFFFFF;
  return '#${v.toRadixString(16).padLeft(6, '0').toUpperCase()}';
}

AppColorTheme _themeFor(AppBrandConfig brand, AppBrightness brightness) =>
    brightness == AppBrightness.dark
    ? brand.toDarkColorTheme()
    : brand.toLightColorTheme();

void main() {
  test('gera/atualiza o relatório de contraste', () {
    final StringBuffer md = StringBuffer()
      ..writeln('# Relatório de Contraste — Marcas Flocks')
      ..writeln()
      ..writeln(
        '> Gerado por `test/src/theme/contrast_report_test.dart`. Não editar à '
        'mão — rode `flutter test --dart-define=CONTRAST_REPORT=true '
        'test/src/theme/contrast_report_test.dart`.',
      )
      ..writeln()
      ..writeln(
        'Métrica dupla: **razão WCAG 2** (piso legal) + **ΔT de tom HCT** '
        '(perceptual). Alvos e o "porquê" em '
        '[`COLOR_ACCESSIBILITY_RULES.md`](COLOR_ACCESSIBILITY_RULES.md).',
      )
      ..writeln();

    int total = 0;
    int failures = 0;

    for (final AppBrandConfig brand in _brands) {
      for (final AppBrightness brightness in AppBrightness.values) {
        final AppColorTheme theme = _themeFor(brand, brightness);
        md
          ..writeln('## ${brand.clientSlug} · ${brightness.name}')
          ..writeln()
          ..writeln(
            '`surface` = ${_hex(theme.surface)} · '
            '`onSurface` = ${_hex(theme.onSurface)}',
          )
          ..writeln()
          ..writeln(
            '| Regra | Tier | fg / bg | Razão (alvo) | ΔT (alvo) | AA |',
          )
          ..writeln('|---|---|---|---|---|:--:|');

        for (final ContrastRule rule in flocksContrastContract) {
          if (rule.appliesTo != null && !rule.appliesTo!(brightness)) continue;
          final ContrastTarget target = contrastTargetFor(
            rule.tier,
            brightness,
          );
          final Color fg = rule.foreground(theme);
          final Color bg = rule.background(theme);
          final double ratio = contrastRatio(fg, bg);
          final double dt = toneDelta(fg, bg);
          final bool ok = ratio >= target.minRatio && dt >= target.minToneDelta;
          total++;
          if (!ok) failures++;
          md.writeln(
            '| `${rule.id}` | ${rule.tier.name} '
            '| ${_hex(fg)} / ${_hex(bg)} '
            '| ${ratio.toStringAsFixed(2)} (≥${target.minRatio}) '
            '| ${dt.toStringAsFixed(1)} (≥${target.minToneDelta.toStringAsFixed(0)}) '
            '| ${ok ? '✅' : '❌'} |',
          );
        }

        // Regras estruturais (single-color) — iteradas da mesma fonte única.
        for (final StructuralRule rule in flocksStructuralContract) {
          if (rule.appliesTo != null && !rule.appliesTo!(brightness)) continue;
          final bool ok = rule.check(theme);
          total++;
          if (!ok) failures++;
          md.writeln(
            '| `${rule.id}` | ${rule.label} '
            '| ${_hex(rule.subject(theme))} '
            '| ${rule.metricPrefix}${rule.metric(theme).toStringAsFixed(1)} '
            '| ${rule.targetLabel} '
            '| ${ok ? '✅' : '❌'} |',
          );
        }
        md.writeln();
      }
    }

    final String summary =
        '**Resumo:** $failures de $total verificações AA falham hoje.';
    md
      ..writeln('---')
      ..writeln()
      ..writeln(summary);

    stdout
      ..writeln(md.toString())
      ..writeln(summary);

    if (_write) {
      Directory('doc').createSync(recursive: true);
      File(_reportPath).writeAsStringSync(md.toString());
      stdout.writeln('Relatório gravado em $_reportPath');
    }

    expect(total, greaterThan(0));
  });
}
