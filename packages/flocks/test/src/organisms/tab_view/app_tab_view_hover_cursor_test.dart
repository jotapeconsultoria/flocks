import 'package:flocks/flocks.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host() => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(size: Size(320, 600)),
    child: AppTheme(
      data: AppThemeData.light,
      child: AppTabView(
        items: <AppTabViewItem>[
          for (int i = 0; i < 8; i++)
            AppTabViewItem(
              label: 'Aba muito comprida $i',
              builder: (_) => const SizedBox.shrink(),
            ),
        ],
      ),
    ),
  ),
);

void main() {
  testWidgets('a aba inativa ganha pílula de hover, como as workspace tabs', (
    tester,
  ) async {
    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    // A pílula veste o RÓTULO (o indicador ficou de fora dela): é a primeira
    // superfície decorada dentro da aba, logo acima do texto.
    Color? fillOf(int index) {
      final Finder pill = find.descendant(
        of: find.byKey(ValueKey<String>('app_tab_view_tab_$index')),
        matching: find.byType(DecoratedBox),
      );
      final BoxDecoration deco =
          tester.widget<DecoratedBox>(pill.first).decoration as BoxDecoration;
      return deco.color;
    }

    final Color? idle = fillOf(1);

    final TestGesture pointer = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    addTearDown(pointer.removePointer);
    await pointer.addPointer(
      location: tester.getCenter(
        find.byKey(const ValueKey<String>('app_tab_view_tab_1')),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      fillOf(1),
      isNot(idle),
      reason: 'sem realce de fundo o alvo de clique fica implícito',
    );
  });
}
