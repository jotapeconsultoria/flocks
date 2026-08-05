@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Prova de que o modo GLOBAL de radius molda o AppSegmentedButton: no "Reto" (0)
// trilho e pílula viram retângulos; no "Circular" a pílula encaixa concêntrica
// numa pílula-trilho; no "Redondo" cantos arredondados; no "Padrão" cai no
// default do componente (redondo). Só `styleTheme` default (filled), então o
// trilho mantém o fundo e a forma fica evidente. disableAnimations congela o
// estado final. Gerar:
//   flutter test --update-goldens --tags golden
AppThemeData _withMode(AppRadiusMode mode) {
  final AppThemeData base = AppThemeData.light;
  return AppThemeData(
    brightness: base.brightness,
    colorTheme: base.colorTheme,
    textTheme: base.textTheme,
    radiusTheme: AppRadiusTheme(mode: mode),
  );
}

void main() {
  const Map<String, AppRadiusMode> presets = <String, AppRadiusMode>{
    'Reto': AppRadiusMode.reto,
    'Circular': AppRadiusMode.circular,
    'Redondo': AppRadiusMode.redondo,
    'Padrão': AppRadiusMode.padrao,
  };

  testWidgets('Radius molda AppSegmentedButton', (tester) async {
    final Color surface = AppThemeData.forBrand(
      jotapeBrand,
      dark: false,
    ).colorTheme.surface;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Container(
            key: const Key('golden'),
            color: surface,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 18,
              children: <Widget>[
                for (final MapEntry<String, AppRadiusMode> entry
                    in presets.entries)
                  AppTheme(
                    data: _withMode(entry.value),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 18,
                      children: <Widget>[
                        SizedBox(width: 96, child: AppText(entry.key)),
                        AppSegmentedButton<int>(
                          value: 1,
                          onChanged: _noop,
                          segments: const <AppSegment<int>>[
                            AppSegment<int>(value: 0, label: 'Dia'),
                            AppSegment<int>(value: 1, label: 'Semana'),
                            AppSegment<int>(value: 2, label: 'Mês'),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    await expectLater(
      find.byKey(const Key('golden')),
      matchesGoldenFile('goldens/app_segmented_button_radius.png'),
    );
  });
}

void _noop(int _) {}
