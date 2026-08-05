@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Matriz {claro,escuro} × {jotape,zxtrack} — prova visual da Regra 9. As 3
// variantes sobre a `surface` base (a elevação por tom aparece no contraste).
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('AppSurface golden · $label', (tester) async {
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
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AppSurface(
                        padding: EdgeInsets.all(20),
                        child: AppText('flat'),
                      ),
                      SizedBox(width: 16),
                      AppSurface(
                        variant: AppSurfaceVariant.raised,
                        padding: EdgeInsets.all(20),
                        child: AppText('raised'),
                      ),
                      SizedBox(width: 16),
                      AppSurface(
                        variant: AppSurfaceVariant.bordered,
                        padding: EdgeInsets.all(20),
                        child: AppText('bordered'),
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
          matchesGoldenFile('goldens/app_surface_$label.png'),
        );
      });
    }
  }
}
