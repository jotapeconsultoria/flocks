@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Matriz {claro,escuro} × {jotape,zxtrack}. Gerar:
//   flutter test --update-goldens --tags golden
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('AppScaffold golden · $label', (tester) async {
        final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(),
              child: AppTheme(
                data: data,
                child: SizedBox(
                  key: const Key('golden'),
                  width: 360,
                  height: 240,
                  child: AppScaffold(
                    header: Padding(
                      padding: const EdgeInsets.all(AppSpacings.s16),
                      child: AppText(
                        'Veículos',
                        style: data.textTheme.titleLarge,
                      ),
                    ),
                    footer: Padding(
                      padding: const EdgeInsets.all(AppSpacings.s16),
                      child: AppText(
                        'Salvar',
                        style: data.textTheme.titleMedium,
                      ),
                    ),
                    child: Center(
                      child: AppText(
                        'Conteúdo',
                        style: data.textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        await expectLater(
          find.byKey(const Key('golden')),
          matchesGoldenFile('goldens/app_scaffold_$label.png'),
        );
      });
    }
  }
}
