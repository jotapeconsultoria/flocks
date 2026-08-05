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
      testWidgets('AppOverlayCard golden · $label', (tester) async {
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
                  width: 320,
                  padding: const EdgeInsets.all(24),
                  child: const SizedBox(
                    width: 240,
                    child: AppOverlayCard(
                      child: AppText('Painel flutuante sobre o mapa'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await expectLater(
          find.byKey(const Key('golden')),
          matchesGoldenFile('goldens/app_overlay_card_$label.png'),
        );
      });
    }
  }
}
