import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

double _r(BorderRadius br) => br.topLeft.x;

void main() {
  const size24 = Size.square(24);

  group('appResolveRadius', () {
    test('reto → 0 (com ou sem size)', () {
      expect(
        _r(
          appResolveRadius(
            mode: AppRadiusMode.reto,
            componentDefault: AppRadiusMode.redondo,
            size: size24,
          ),
        ),
        0,
      );
      expect(
        _r(
          appResolveRadius(
            mode: AppRadiusMode.reto,
            componentDefault: AppRadiusMode.circular,
          ),
        ),
        0,
      );
    });

    test('circular → metade do lado menor quando size é conhecido', () {
      expect(
        _r(
          appResolveRadius(
            mode: AppRadiusMode.circular,
            componentDefault: AppRadiusMode.redondo,
            size: size24,
          ),
        ),
        12,
      );
    });

    test('circular sem size → sentinela grande (Flutter satura no paint)', () {
      expect(
        _r(
          appResolveRadius(
            mode: AppRadiusMode.circular,
            componentDefault: AppRadiusMode.redondo,
          ),
        ),
        greaterThan(1000),
      );
    });

    test('redondo → fração do lado menor, com teto', () {
      // 24 * 0.25 = 6 (abaixo do teto).
      expect(
        _r(
          appResolveRadius(
            mode: AppRadiusMode.redondo,
            componentDefault: AppRadiusMode.circular,
            size: size24,
          ),
        ),
        24 * kRedondoFraction,
      );
      // Caixa grande → satura no teto.
      expect(
        _r(
          appResolveRadius(
            mode: AppRadiusMode.redondo,
            componentDefault: AppRadiusMode.circular,
            size: const Size.square(400),
          ),
        ),
        kRedondoCap,
      );
    });

    test('redondo sem size → teto', () {
      expect(
        _r(
          appResolveRadius(
            mode: AppRadiusMode.redondo,
            componentDefault: AppRadiusMode.circular,
          ),
        ),
        kRedondoCap,
      );
    });

    test('padrao delega ao componentDefault', () {
      // Default circular → círculo (metade da medida).
      expect(
        _r(
          appResolveRadius(
            mode: AppRadiusMode.padrao,
            componentDefault: AppRadiusMode.circular,
            size: size24,
          ),
        ),
        12,
      );
      // Default redondo → fração do tamanho.
      expect(
        _r(
          appResolveRadius(
            mode: AppRadiusMode.padrao,
            componentDefault: AppRadiusMode.redondo,
            size: size24,
          ),
        ),
        24 * kRedondoFraction,
      );
    });
  });

  group('tileRadius', () {
    BorderRadius tileFor(AppRadiusMode mode, [AppRadiusMode? override]) =>
        AppRadiusTheme(mode: mode).tileRadius(override);

    test('reto → 0', () {
      expect(_r(tileFor(AppRadiusMode.reto)), 0);
    });

    test('redondo/padrao → raio dedicado do tile', () {
      expect(_r(tileFor(AppRadiusMode.redondo)), kTileRedondoRadius);
      expect(_r(tileFor(AppRadiusMode.padrao)), kTileRedondoRadius);
    });

    test('circular → raio dedicado (não satura em oval)', () {
      expect(_r(tileFor(AppRadiusMode.circular)), kTileCircularRadius);
      // Pronunciado (> redondo do tile) mas longe da sentinela que vira oval.
      expect(kTileCircularRadius, greaterThan(kTileRedondoRadius));
      expect(kTileCircularRadius, lessThan(1000));
    });

    test('override local vence o modo global', () {
      // Global circular, override reto → 0.
      expect(_r(tileFor(AppRadiusMode.circular, AppRadiusMode.reto)), 0);
      // Global reto, override circular → raio dedicado.
      expect(
        _r(tileFor(AppRadiusMode.reto, AppRadiusMode.circular)),
        kTileCircularRadius,
      );
    });
  });

  group('surfaceCornerRadius', () {
    double surfaceFor(AppRadiusMode mode, [AppRadiusMode? override]) =>
        AppRadiusTheme(mode: mode).surfaceCornerRadius(override);

    test('reto → 0', () {
      expect(surfaceFor(AppRadiusMode.reto), 0);
    });

    test('redondo/padrao → raio dedicado da superfície', () {
      expect(surfaceFor(AppRadiusMode.redondo), kSurfaceRedondoRadius);
      expect(surfaceFor(AppRadiusMode.padrao), kSurfaceRedondoRadius);
    });

    test('circular → raio dedicado (não satura em oval)', () {
      expect(surfaceFor(AppRadiusMode.circular), kSurfaceCircularRadius);
      expect(kSurfaceCircularRadius, greaterThan(kSurfaceRedondoRadius));
      expect(kSurfaceCircularRadius, lessThan(1000));
    });

    test('superfície é maior que o tile na mesma escala', () {
      expect(kSurfaceRedondoRadius, greaterThan(kTileRedondoRadius));
      expect(kSurfaceCircularRadius, greaterThan(kTileCircularRadius));
    });

    test('override local vence o modo global', () {
      expect(surfaceFor(AppRadiusMode.circular, AppRadiusMode.reto), 0);
      expect(
        surfaceFor(AppRadiusMode.reto, AppRadiusMode.circular),
        kSurfaceCircularRadius,
      );
    });
  });
}
