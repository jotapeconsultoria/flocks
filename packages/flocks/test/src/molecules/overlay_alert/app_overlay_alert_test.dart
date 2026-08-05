import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: AppThemeData.light,
      child: Center(child: child),
    ),
  ),
);

void main() {
  testWidgets('AppOverlayAlert renderiza título/descrição e é liveRegion', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppOverlayAlert(title: 'Falha', description: 'Detalhe do erro.'),
      ),
    );
    expect(find.text('Falha'), findsOneWidget);
    expect(find.text('Detalhe do erro.'), findsOneWidget);
    final s = tester.getSemantics(find.byType(AppOverlayAlert));
    expect(s.flagsCollection.isLiveRegion, isTrue);
  });

  test('AppOverlayAlert no catálogo como migrated', () {
    expect(
      flocksCatalog.any(
        (AppComponentMeta m) =>
            m.id == 'app_overlay_alert' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
