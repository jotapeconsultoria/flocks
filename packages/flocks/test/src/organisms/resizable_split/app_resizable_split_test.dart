import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(size: Size(800, 400)),
    child: AppTheme(
      data: AppThemeData.light,
      child: SizedBox(width: 600, height: 300, child: child),
    ),
  ),
);

void main() {
  testWidgets('AppResizableSplit renderiza os dois painéis', (tester) async {
    await tester.pumpWidget(
      _host(
        const AppResizableSplit(
          initialFirstFraction: 0.35,
          first: Text('lista'),
          second: Text('mapa'),
        ),
      ),
    );
    expect(find.text('lista'), findsOneWidget);
    expect(find.text('mapa'), findsOneWidget);
  });

  testWidgets('AppResizableSplit funciona na vertical (divisor arrastável)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppResizableSplit(
          direction: Axis.vertical,
          initialFirstFraction: 0.4,
          first: Text('topo'),
          second: Text('base'),
        ),
      ),
    );
    expect(find.text('topo'), findsOneWidget);
    expect(find.text('base'), findsOneWidget);
    // O divisor expõe um tooltip arrastável (sem depender de storage).
    expect(find.byType(AppTooltip), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('AppResizableSplit no catálogo como migrated', () {
    expect(
      flocksCatalog.any(
        (AppComponentMeta m) =>
            m.id == 'app_resizable_split' &&
            m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
