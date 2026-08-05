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

  const List<String> cols = <String>['Placa', 'Modelo', 'Status'];
  final List<List<Widget>> rows = List<List<Widget>>.generate(
    4,
    (int i) => <Widget>[
      AppText('ABC-${1000 + i}'),
      const AppText('GV75'),
      AppText(i.isEven ? 'Online' : 'Offline'),
    ],
  );

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('AppDataTable golden · $label', (tester) async {
        final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(760, 520)),
              child: AppTheme(
                data: data,
                child: Container(
                  key: const Key('golden'),
                  color: data.colorTheme.surface,
                  width: 760,
                  padding: const EdgeInsets.all(24),
                  child: AppDataTable(
                    columnLabels: cols,
                    rows: rows,
                    page: 1,
                    perPage: 16,
                    total: 4,
                    totalPages: 1,
                    columnSortOrders: const <AppDataTableSortOrder>[
                      AppDataTableSortOrder.asc,
                      AppDataTableSortOrder.none,
                      AppDataTableSortOrder.none,
                    ],
                    onColumnSortTap: (_) {},
                    onPageChange: (_) {},
                    onPerPageChange: (_) {},
                  ),
                ),
              ),
            ),
          ),
        );

        await expectLater(
          find.byKey(const Key('golden')),
          matchesGoldenFile('goldens/app_data_table_$label.png'),
        );
      });
    }
  }
}
