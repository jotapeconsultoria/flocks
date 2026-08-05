import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

AppThemeData _withRadius(AppRadiusTheme radius) {
  final base = AppThemeData.light;
  return AppThemeData(
    brightness: base.brightness,
    colorTheme: base.colorTheme,
    textTheme: base.textTheme,
    radiusTheme: radius,
  );
}

void main() {
  test('AppRadiusTheme.standard usa o modo padrao', () {
    expect(AppRadiusTheme.standard.mode, AppRadiusMode.padrao);
  });

  test('copyWith sobrescreve o modo', () {
    final t = AppRadiusTheme.standard.copyWith(mode: AppRadiusMode.circular);
    expect(t.mode, AppRadiusMode.circular);
  });

  // containedMode (dropdowns/pickers): reto=reto; redondo/padrão/circular=redondo
  // — evita a pílula/círculo gigante que corta o conteúdo dos painéis.
  test('containedMode: circular/padrão → redondo; reto → reto', () {
    AppRadiusMode contained(AppRadiusMode m) =>
        AppRadiusTheme(mode: m).containedMode();
    expect(contained(AppRadiusMode.reto), AppRadiusMode.reto);
    expect(contained(AppRadiusMode.redondo), AppRadiusMode.redondo);
    expect(contained(AppRadiusMode.padrao), AppRadiusMode.redondo);
    expect(contained(AppRadiusMode.circular), AppRadiusMode.redondo);
  });

  test('containedMode clampa também o override local', () {
    const t = AppRadiusTheme(mode: AppRadiusMode.reto);
    expect(t.containedMode(AppRadiusMode.circular), AppRadiusMode.redondo);
    expect(t.containedMode(AppRadiusMode.reto), AppRadiusMode.reto);
  });

  test('resolve() no modo padrao usa o default do componente', () {
    const theme = AppRadiusTheme(mode: AppRadiusMode.padrao);
    // Default circular + size → círculo (metade da medida).
    expect(
      theme
          .resolve(
            componentDefault: AppRadiusMode.circular,
            size: const Size.square(24),
          )
          .topLeft
          .x,
      12,
    );
    // override local vence o modo global.
    expect(
      theme
          .resolve(
            componentDefault: AppRadiusMode.circular,
            size: const Size.square(24),
            override: AppRadiusMode.reto,
          )
          .topLeft
          .x,
      0,
    );
  });

  testWidgets(
    'componente reflete o modo do tema (AppShimmerLoading, borderRadius=null)',
    (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            // reduce-motion → renderiza o box base (sem Shimmer) de forma determinística.
            data: const MediaQueryData(disableAnimations: true),
            child: AppTheme(
              data: _withRadius(const AppRadiusTheme(mode: AppRadiusMode.reto)),
              child: const Center(
                child: AppShimmerLoading(height: 40, width: 40),
              ),
            ),
          ),
        ),
      );

      final box = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
      final decoration = box.decoration as BoxDecoration;
      expect(
        decoration.borderRadius,
        const BorderRadius.all(Radius.circular(0)),
      );
    },
  );
}
