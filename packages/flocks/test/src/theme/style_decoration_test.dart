import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const Color fill = Color(0xFF3366CC);
  const Color outline = Color(0xFF888888);
  const Color surfaceContainer = Color(0xFFEEEEEE);

  StyleDecoration res(
    AppStyle style, {
    Color? ownFill,
    Color? background,
    bool isDark = false,
  }) => resolveStyleDecoration(
    style: style,
    isDark: isDark,
    outline: outline,
    surfaceContainer: surfaceContainer,
    ownFill: ownFill,
    background: background,
  );

  Color borderColor(StyleDecoration d) => (d.border! as Border).top.color;

  group('filled', () {
    test('transparente ganha surfaceContainer, sem borda/sombra', () {
      final d = res(AppStyle.filled);
      expect(d.color, surfaceContainer);
      expect(d.border, isNull);
      expect(d.boxShadow, isNull);
    });
    test('preenchido mantém o próprio fill, sem borda', () {
      final d = res(AppStyle.filled, ownFill: fill);
      expect(d.color, fill);
      expect(d.border, isNull);
    });
  });

  group('outlined', () {
    test('transparente: sem fundo, com borda outline', () {
      final d = res(AppStyle.outlined);
      expect(d.color, isNull);
      expect(borderColor(d), outline);
      expect(d.boxShadow, isNull);
    });
    test('preenchido: mantém fill + borda outline', () {
      final d = res(AppStyle.outlined, ownFill: fill);
      expect(d.color, fill);
      expect(borderColor(d), outline);
    });
  });

  group('elevated', () {
    test('transparente: surfaceContainer + sombra, sem borda', () {
      final d = res(AppStyle.elevated);
      expect(d.color, surfaceContainer);
      expect(d.border, isNull);
      expect(d.boxShadow, isNotEmpty);
    });
    test('preenchido: fill + sombra, SEM borda', () {
      final d = res(AppStyle.elevated, ownFill: fill);
      expect(d.color, fill);
      expect(d.border, isNull);
      expect(d.boxShadow, isNotEmpty);
    });
    test('sombra mais forte no escuro', () {
      final light = AppElevation.symmetricShadows(false);
      final dark = AppElevation.symmetricShadows(true);
      expect(dark.first.color.a, greaterThan(light.first.color.a));
    });
  });

  // O tratamento `glass` deixou de ser um `AppStyle` (virou eixo próprio,
  // `AppGlassTheme`, resolvido pelo `AppGlassSurface`). O contrato tint/rim/sombra
  // é coberto pelos testes de widget das superfícies glass (ver card_glass_test).

  test('background sobrescreve o fundo em qualquer style', () {
    const bg = Color(0xFF00AA55);
    for (final s in AppStyle.values) {
      expect(
        res(s, ownFill: fill, background: bg).color,
        bg,
        reason: '$s',
      );
    }
  });

  test('borda usa o outline da marca × brilho', () {
    for (final brand in <AppBrandConfig>[jotapeBrand, zxtrackBrand]) {
      for (final colors in <AppColorTheme>[
        AppThemeData.forBrand(brand, dark: false).colorTheme,
        AppThemeData.forBrand(brand, dark: true).colorTheme,
      ]) {
        final d = resolveStyleDecoration(
          style: AppStyle.outlined,
          isDark: false,
          outline: colors.outline,
          surfaceContainer: colors.surfaceContainer,
        );
        expect((d.border! as Border).top.color, colors.outline);
      }
    }
  });
}
