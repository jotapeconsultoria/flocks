@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Matriz {claro,escuro} × {jotape,zxtrack} com os estados selected/unselected/
// disabled (a cor de acento `secondary` é brand-aware → Regra 9).
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('AppRadio golden · $label', (tester) async {
        final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(),
              child: AppTheme(
                data: data,
                child: Container(
                  key: const Key('golden'),
                  color: data.colorTheme.surface,
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 16,
                    children: [
                      AppRadio<int>(value: 1, groupValue: 1, onChanged: (_) {}),
                      AppRadio<int>(value: 1, groupValue: 2, onChanged: (_) {}),
                      const AppRadio<int>(
                        value: 1,
                        groupValue: 1,
                        enabled: false,
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
          matchesGoldenFile('goldens/app_radio_$label.png'),
        );
      });
    }
  }
}
