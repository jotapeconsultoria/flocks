import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(data: AppThemeData.light, child: child),
  ),
);

void main() {
  testWidgets('AppSimpleHeader renderiza o child e é header', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(width: 380, child: AppSimpleHeader(child: AppText('T'))),
      ),
    );
    expect(find.text('T'), findsOneWidget);
    final s = tester.getSemantics(find.byType(AppSimpleHeader));
    expect(s.flagsCollection.isHeader, isTrue);
  });

  testWidgets('AppPrimaryHeader mostra leading/child/trailing', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 380,
          child: AppPrimaryHeader(
            leading: AppText('L'),
            trailing: AppText('R'),
            child: AppText('C'),
          ),
        ),
      ),
    );
    expect(find.text('L'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
    expect(find.text('R'), findsOneWidget);
    final s = tester.getSemantics(find.byType(AppPrimaryHeader));
    expect(s.flagsCollection.isHeader, isTrue);
  });

  test('headers no catálogo como migrados', () {
    for (final String id in <String>[
      'app_simple_header',
      'app_primary_header',
    ]) {
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
