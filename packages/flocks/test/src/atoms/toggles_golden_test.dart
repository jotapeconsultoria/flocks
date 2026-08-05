@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Matriz {claro,escuro} × {jotape,zxtrack} dos toggles (checkbox + switch),
// nos estados on/off/disabled. `secondary` (acento) é brand-aware → Regra 9.
// disableAnimations congela o thumb do switch no estado final (determinístico).
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('Toggles golden · $label', (tester) async {
        final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: AppTheme(
                data: data,
                child: Container(
                  key: const Key('golden'),
                  color: data.colorTheme.surface,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 16,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 16,
                        children: [
                          AppCheckbox(checked: true, onChanged: (_) {}),
                          AppCheckbox(checked: false, onChanged: (_) {}),
                          const AppCheckbox(checked: true, enabled: false),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 16,
                        children: [
                          AppSwitch(value: true, onChanged: (_) {}),
                          AppSwitch(value: false, onChanged: (_) {}),
                          const AppSwitch(value: true, enabled: false),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        await expectLater(
          find.byKey(const Key('golden')),
          matchesGoldenFile('goldens/toggles_$label.png'),
        );
      });
    }
  }
}
