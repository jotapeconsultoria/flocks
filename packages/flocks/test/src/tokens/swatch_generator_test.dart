import 'package:flocks/tokens.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Cor primária escura da marca Jotape (#0C3235) — o caso que hoje quebra o
  // dark (mesmo swatch em claro/escuro deixa o primary quase-preto).
  const Color jotapePrimary = Color(0xFF0C3235);

  group('swatchFromSeed', () {
    test('gera os 11 stops (50–950)', () {
      final swatch = swatchFromSeed(jotapePrimary);
      for (final stop in <int>[
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
      ]) {
        expect(swatch[stop], isNotNull, reason: 'stop $stop ausente');
      }
    });

    test('stop claro (50) é mais luminoso que o escuro (900)', () {
      final swatch = swatchFromSeed(jotapePrimary);
      expect(
        swatch[50]!.computeLuminance(),
        greaterThan(swatch[900]!.computeLuminance()),
      );
    });

    test('preserva o matiz da seed entre os stops', () {
      const Color orange = Color(0xFFFF5B04);
      final swatch = swatchFromSeed(orange);
      // Um stop médio deve ser "alaranjado": vermelho > verde > azul.
      final mid = swatch[400]!;
      expect(mid.r, greaterThan(mid.g));
      expect(mid.g, greaterThan(mid.b));
    });

    test('marca escura ganha stop claro legível sobre superfície escura', () {
      // Essência do fix do dark: um tom mais claro do swatch (300) serve de
      // acento legível sobre um fundo escuro.
      final swatch = swatchFromSeed(jotapePrimary);
      const Color darkSurface = Color(0xFF121212);
      expect(
        contrastRatio(swatch[300]!, darkSurface),
        greaterThanOrEqualTo(3.0),
      );
    });
  });

  group('contrastRatio', () {
    test('preto sobre branco ≈ 21', () {
      expect(
        contrastRatio(const Color(0xFF000000), const Color(0xFFFFFFFF)),
        closeTo(21.0, 0.1),
      );
    });

    test('é simétrico', () {
      const a = Color(0xFF3366CC);
      const b = Color(0xFFFFFFFF);
      expect(contrastRatio(a, b), closeTo(contrastRatio(b, a), 0.0001));
    });
  });

  group('onColorFor', () {
    test('fundo claro → preto; fundo escuro → branco', () {
      expect(onColorFor(const Color(0xFFFFFFFF)), const Color(0xFF000000));
      expect(onColorFor(const Color(0xFF000000)), const Color(0xFFFFFFFF));
      expect(onColorFor(jotapePrimary), const Color(0xFFFFFFFF));
    });
  });
}
