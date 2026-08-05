@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Matriz {claro,escuro} × {jotape,zxtrack} — os três tipos. Gerar:
//   flutter test --update-goldens --tags golden
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('AppSnackbar golden · $label', (tester) async {
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
                  width: 420,
                  padding: const EdgeInsets.all(24),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 16,
                    children: <Widget>[
                      AppSnackbar(
                        title: 'Salvo',
                        description: 'As alterações foram aplicadas.',
                        type: AppSnackbarType.success,
                      ),
                      AppSnackbar(
                        title: 'Atenção',
                        description: 'Verifique os dados informados.',
                        type: AppSnackbarType.info,
                      ),
                      AppSnackbar(
                        title: 'Falha ao salvar',
                        description: 'Tente novamente em instantes.',
                        type: AppSnackbarType.error,
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
          matchesGoldenFile('goldens/app_snackbar_$label.png'),
        );
      });
    }
  }
}
