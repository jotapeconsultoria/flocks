import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: AppThemeData.light,
      child: Overlay(
        initialEntries: <OverlayEntry>[OverlayEntry(builder: (_) => child)],
      ),
    ),
  ),
);

void main() {
  testWidgets('usa o cursor de texto (I-beam) na seleção', (tester) async {
    await tester.pumpWidget(
      _host(const AppSelectionRegion(child: Text('sel'))),
    );

    // Trava a regressão da linha `mouseCursor`: texto selecionável deve mostrar
    // o I-beam, não a seta padrão (`MouseCursor.defer`).
    final style = tester.widget<DefaultSelectionStyle>(
      find.byType(DefaultSelectionStyle),
    );
    expect(style.mouseCursor, SystemMouseCursors.text);
    expect(find.byType(SelectableRegion), findsOneWidget);
  });
}
