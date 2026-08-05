import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const List<AppPieChartSegment> _segments = <AppPieChartSegment>[
  AppPieChartSegment(label: 'A', value: 30),
  AppPieChartSegment(label: 'B', value: 45),
  AppPieChartSegment(label: 'C', value: 25),
];

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: AppThemeData.light,
      child: Center(child: SizedBox(width: 200, height: 200, child: child)),
    ),
  ),
);

void main() {
  testWidgets('AppPieChart renderiza com semântica agregada', (tester) async {
    await tester.pumpWidget(_host(const AppPieChart(segments: _segments)));
    expect(find.byType(AppPieChart), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('AppDonutChart renderiza', (tester) async {
    await tester.pumpWidget(_host(const AppDonutChart(segments: _segments)));
    expect(find.byType(AppDonutChart), findsOneWidget);
  });

  testWidgets('pie: hover emite seleção', (tester) async {
    AppPieChartSelection? sel;
    await tester.pumpWidget(
      _host(
        AppPieChart(segments: _segments, onSelectionChanged: (s) => sel = s),
      ),
    );
    final Offset center = tester.getCenter(find.byType(AppPieChart));
    final TestGesture g = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await g.addPointer(location: Offset.zero);
    addTearDown(g.removePointer);
    await g.moveTo(center + const Offset(0, -40)); // fatia superior
    await tester.pump();
    expect(sel, isNotNull);
  });

  test('charts no catálogo como migrados', () {
    for (final String id in <String>['app_pie_chart', 'app_donut_chart']) {
      expect(
        flocksCatalog.any(
          (m) => m.id == id && m.status == ComponentStatus.migrated,
        ),
        isTrue,
        reason: '$id ausente',
      );
    }
  });
}
