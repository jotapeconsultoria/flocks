@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Matriz {claro,escuro} × {jotape,zxtrack} do AppDatePicker e AppDateRangePicker.
// Gerar: flutter test --update-goldens --tags golden
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  Widget host(AppThemeData data, Widget child) => Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: AppTheme(
        data: data,
        child: Container(
          key: const Key('golden'),
          color: data.colorTheme.surface,
          padding: const EdgeInsets.all(24),
          child: child,
        ),
      ),
    ),
  );

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('AppDatePicker · hoje marcado · $label', (tester) async {
        final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);
        await tester.pumpWidget(
          host(
            data,
            SizedBox(
              width: 320,
              child: AppDatePicker(
                initialDate: DateTime(2027, 9, 10),
                today: DateTime(2027, 9, 23),
                firstDate: DateTime(2027, 9, 5),
                lastDate: DateTime(2027, 9, 27),
                markToday: true,
                onDateSelected: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await expectLater(
          find.byKey(const Key('golden')),
          matchesGoldenFile('goldens/date_picker_today_$label.png'),
        );
      });

      testWidgets('AppDateRangePicker · intervalo completo · $label', (
        tester,
      ) async {
        final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);
        await tester.pumpWidget(
          host(
            data,
            SizedBox(
              width: 320,
              child: AppDateRangePicker(
                initialRange: AppDateRange(
                  DateTime(2027, 9, 9),
                  DateTime(2027, 9, 18),
                ),
                today: DateTime(2027, 9, 23),
                firstDate: DateTime(2027, 9),
                lastDate: DateTime(2027, 9, 30),
                markToday: true,
                onRangeSelected: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await expectLater(
          find.byKey(const Key('golden')),
          matchesGoldenFile('goldens/date_range_picker_$label.png'),
        );
      });
    }
  }
}
