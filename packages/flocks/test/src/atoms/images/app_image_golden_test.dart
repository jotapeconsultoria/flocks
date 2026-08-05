@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Matriz {claro,escuro} × {jotape,zxtrack}. A rede é bloqueada no flutter_test,
// então o golden captura o estado de FALLBACK (caixa surfaceContainer arredondada
// — determinístico, theme-aware). Mesmo critério do AppIcon.
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('AppImage golden · $label', (tester) async {
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
                  child: const AppImage.network(
                    'https://invalid.invalid/x.png',
                    width: 160,
                    height: 100,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byKey(const Key('golden')),
          matchesGoldenFile('goldens/app_image_$label.png'),
        );
      });
    }
  }
}
