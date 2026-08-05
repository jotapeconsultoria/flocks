@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];
  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';
      testWidgets('AppOverlayAlert golden · $label', (tester) async {
        final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);
        final AppColorTheme c = data.colorTheme;
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(),
              child: AppTheme(
                data: data,
                child: Container(
                  key: const Key('golden'),
                  color: c.surface,
                  width: 380,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 16,
                    children: <Widget>[
                      AppOverlayAlert(
                        title: 'Salvo',
                        description: 'Alterações aplicadas.',
                        color: c.success,
                      ),
                      AppOverlayAlert(
                        title: 'Falha ao salvar',
                        description: 'Tente novamente.',
                        color: c.danger,
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
          matchesGoldenFile('goldens/app_overlay_alert_$label.png'),
        );
      });
    }
  }
}
