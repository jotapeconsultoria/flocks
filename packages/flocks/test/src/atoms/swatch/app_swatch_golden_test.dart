@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Matriz {claro,escuro} × {jotape,zxtrack} — a borda `outline` adapta ao brilho.
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];
  const List<Color> colors = <Color>[
    Color(0xFF1E88E5),
    Color(0xFFE53935),
    Color(0xFF43A047),
    Color(0xFFFFFFFF),
  ];

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('AppSwatch golden · $label', (tester) async {
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
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      for (final Color c in colors)
                        AppSwatch(color: c, size: 32),
                      for (final Color c in colors)
                        AppSwatch(
                          color: c,
                          size: 32,
                          shape: AppSwatchShape.circle,
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
          matchesGoldenFile('goldens/app_swatch_$label.png'),
        );
      });
    }
  }
}
