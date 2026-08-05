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
  testWidgets('AppActionItem mostra texto e dispara onPressed', (tester) async {
    int taps = 0;
    await tester.pumpWidget(
      _host(
        AppActionItem(
          icon: AppIcons.infoCircle,
          text: 'Suporte',
          onPressed: () => taps++,
        ),
      ),
    );
    expect(find.text('Suporte'), findsOneWidget);
    await tester.tap(find.text('Suporte'));
    expect(taps, 1);
  });

  test('AppActionItem no catálogo como migrated', () {
    expect(
      flocksCatalog.any(
        (AppComponentMeta m) =>
            m.id == 'app_action_item' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
