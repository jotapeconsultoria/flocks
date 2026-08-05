import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(disableAnimations: true),
    child: AppTheme(
      data: AppThemeData.light,
      child: Center(child: child),
    ),
  ),
);

void main() {
  testWidgets('+ e − emitem valor clampado, respeitando step', (tester) async {
    num? emitted;
    await tester.pumpWidget(
      _host(
        AppNumberStepper(
          value: 5,
          min: 0,
          max: 10,
          step: 2,
          onChanged: (v) => emitted = v,
        ),
      ),
    );
    // Botão 0 = −, botão 1 = +.
    await tester.tap(find.byType(AppInteraction).at(1));
    await tester.pump();
    expect(emitted, 7);
    await tester.tap(find.byType(AppInteraction).at(0));
    await tester.pump();
    expect(emitted, 3);
  });

  testWidgets('+ desabilita no máximo', (tester) async {
    num? emitted;
    await tester.pumpWidget(
      _host(
        AppNumberStepper(
          value: 10,
          min: 0,
          max: 10,
          onChanged: (v) => emitted = v,
        ),
      ),
    );
    await tester.tap(find.byType(AppInteraction).at(1), warnIfMissed: false);
    await tester.pump();
    expect(emitted, isNull);
  });

  testWidgets('− desabilita no mínimo', (tester) async {
    num? emitted;
    await tester.pumpWidget(
      _host(
        AppNumberStepper(
          value: 0,
          min: 0,
          max: 10,
          onChanged: (v) => emitted = v,
        ),
      ),
    );
    await tester.tap(find.byType(AppInteraction).at(0), warnIfMissed: false);
    await tester.pump();
    expect(emitted, isNull);
  });

  group('contraste (jotape/zxtrack × claro/escuro)', () {
    final List<AppBrandConfig> brands = <AppBrandConfig>[
      jotapeBrand,
      zxtrackBrand,
    ];
    for (final AppBrandConfig brand in brands) {
      for (final bool dark in <bool>[false, true]) {
        final String bl = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';
        final AppColorTheme c = dark
            ? brand.toDarkColorTheme()
            : brand.toLightColorTheme();
        test('valor/ícones sobre a surface · $bl', () {
          expect(
            meetsWcag(c.onSurface, c.surface),
            isTrue,
            reason: 'valor onSurface < 4.5 sobre surface em $bl',
          );
          expect(
            meetsWcag(
              readableStopOn(c.neutralPrimary, c.surface, minRatio: 4.5),
              c.surface,
            ),
            isTrue,
            reason: 'ícone neutro < 4.5 sobre surface em $bl',
          );
        });
      }
    }
  });

  test('está no catálogo como migrado', () {
    expect(
      flocksCatalog.any(
        (m) =>
            m.id == 'app_number_stepper' &&
            m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
