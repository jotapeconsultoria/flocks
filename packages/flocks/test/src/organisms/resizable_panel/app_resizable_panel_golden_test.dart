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

  Widget area(AppThemeData data, String label) => ColoredBox(
    color: data.colorTheme.surfaceContainer,
    child: Center(child: AppText(label)),
  );

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';
      testWidgets('AppResizablePanel golden · $label', (tester) async {
        final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(700, 400)),
              child: AppTheme(
                data: data,
                child: Container(
                  key: const Key('golden'),
                  color: data.colorTheme.surface,
                  width: 520,
                  height: 240,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: area(data, 'Conteúdo')),
                      AppResizablePanel(
                        initialWidth: 180,
                        minWidth: 120,
                        maxWidth: 320,
                        child: area(data, 'Assistente'),
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
          matchesGoldenFile('goldens/app_resizable_panel_$label.png'),
        );
      });
    }
  }
}
