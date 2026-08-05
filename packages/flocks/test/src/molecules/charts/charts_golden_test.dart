@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const List<AppPieChartSegment> _segments = <AppPieChartSegment>[
  AppPieChartSegment(label: 'A', value: 30),
  AppPieChartSegment(label: 'B', value: 45),
  AppPieChartSegment(label: 'C', value: 25),
];

// Matriz {claro,escuro} × {jotape,zxtrack} — pie+donut (CustomPaint
// determinístico, sem rede). Gerar: flutter test --update-goldens --tags golden
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('charts golden · $label', (tester) async {
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
                  padding: const EdgeInsets.all(16),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 16,
                    children: <Widget>[
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: AppPieChart(segments: _segments),
                      ),
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: AppDonutChart(segments: _segments),
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
          matchesGoldenFile('goldens/charts_$label.png'),
        );
      });
    }
  }
}
