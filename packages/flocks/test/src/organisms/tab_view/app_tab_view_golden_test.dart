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

  List<AppTabViewItem> items() => <AppTabViewItem>[
    AppTabViewItem(
      label: 'Resumo',
      builder: (BuildContext _) => const AppText('Conteúdo do resumo'),
    ),
    AppTabViewItem(
      label: 'Detalhes',
      builder: (BuildContext _) => const AppText('Conteúdo dos detalhes'),
    ),
    AppTabViewItem(
      label: 'Histórico',
      builder: (BuildContext _) => const AppText('Conteúdo do histórico'),
    ),
  ];

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('AppTabView golden · $label', (tester) async {
        final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(600, 500)),
              child: AppTheme(
                data: data,
                child: Container(
                  key: const Key('golden'),
                  color: data.colorTheme.surface,
                  width: 480,
                  height: 220,
                  padding: const EdgeInsets.all(24),
                  child: AppTabView(items: items()),
                ),
              ),
            ),
          ),
        );

        await expectLater(
          find.byKey(const Key('golden')),
          matchesGoldenFile('goldens/app_tab_view_$label.png'),
        );
      });
    }
  }
}
