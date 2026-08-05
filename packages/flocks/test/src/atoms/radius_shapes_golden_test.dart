@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Prova de que o modo GLOBAL de radius molda checkbox/switch/radio: no "Reto"
// (0) os elementos viram quadrados; no "Circular" viram círculo/pílula; no
// "Redondo" quadrados arredondados; no "Padrão" cada um segue o seu default
// (radio circular, checkbox redondo). disableAnimations congela o estado final.
AppThemeData _withMode(AppRadiusMode mode) {
  final base = AppThemeData.light;
  return AppThemeData(
    brightness: base.brightness,
    colorTheme: base.colorTheme,
    textTheme: base.textTheme,
    radiusTheme: AppRadiusTheme(mode: mode),
  );
}

void main() {
  const presets = <String, AppRadiusMode>{
    'Reto': AppRadiusMode.reto,
    'Circular': AppRadiusMode.circular,
    'Redondo': AppRadiusMode.redondo,
    'Padrão': AppRadiusMode.padrao,
  };

  testWidgets('Radius molda checkbox/switch/radio', (tester) async {
    final surface = AppThemeData.forBrand(
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
              children: [
                for (final entry in presets.entries)
                  AppTheme(
                    data: _withMode(entry.value),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 18,
                      children: [
                        SizedBox(width: 118, child: AppText(entry.key)),
                        AppCheckbox(checked: true, onChanged: (_) {}),
                        AppSwitch(value: true, onChanged: (_) {}),
                        AppRadio<int>(
                          value: 1,
                          groupValue: 1,
                          onChanged: (_) {},
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
      matchesGoldenFile('goldens/radius_shapes.png'),
    );
  });
}
