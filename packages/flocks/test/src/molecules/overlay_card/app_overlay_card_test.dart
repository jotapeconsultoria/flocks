import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: AppThemeData.light.copyWith(
        glassTheme: const AppGlassTheme(enabled: false),
      ),
      child: Center(child: child),
    ),
  ),
);

BoxDecoration _decoration(WidgetTester tester) =>
    tester
            .widget<DecoratedBox>(
              find.descendant(
                of: find.byType(AppOverlayCard),
                matching: find.byType(DecoratedBox),
              ),
            )
            .decoration
        as BoxDecoration;

void main() {
  testWidgets('AppOverlayCard renderiza o child; elevated tem sombra', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(const AppOverlayCard(child: Text('conteúdo'))),
    );
    expect(find.text('conteúdo'), findsOneWidget);
    expect(_decoration(tester).boxShadow, isNotEmpty);
  });

  testWidgets('AppOverlayCard outlined tem borda', (tester) async {
    await tester.pumpWidget(
      _host(const AppOverlayCard(style: AppStyle.outlined, child: Text('c'))),
    );
    expect(_decoration(tester).border, isNotNull);
  });

  test('AppOverlayCard no catálogo como migrated', () {
    expect(
      flocksCatalog.any(
        (AppComponentMeta m) =>
            m.id == 'app_overlay_card' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
