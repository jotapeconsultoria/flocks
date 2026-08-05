@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Os 3 tratamentos de container (filled/outlined/elevated) do AppBadge. Prova
// visual das correções: a borda do `outlined` não insere o texto nem muda o
// tamanho, e o fundo do `elevated` é opaco (a sombra não vaza por baixo).
// Matriz {jotape,zxtrack} × {claro,escuro}. Gerar:
//   flutter test --update-goldens --tags golden
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('AppBadge styles golden · $label', (tester) async {
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
                    spacing: 24,
                    children: <Widget>[
                      AppBadge(
                        'Filled',
                        color: AppBadgeColor.info,
                        style: AppStyle.filled,
                      ),
                      AppBadge(
                        'Outlined',
                        color: AppBadgeColor.info,
                        style: AppStyle.outlined,
                      ),
                      AppBadge(
                        'Elevated',
                        color: AppBadgeColor.info,
                        style: AppStyle.elevated,
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
          matchesGoldenFile('goldens/app_badge_styles_$label.png'),
        );
      });
    }
  }
}
