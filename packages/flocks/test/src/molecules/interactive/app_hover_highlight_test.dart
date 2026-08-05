import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(disableAnimations: true),
    child: AppTheme(
      data: AppThemeData.light,
      child: Center(child: child),
    ),
  ),
);

/// A cor pintada pelo realce agora.
Color? _highlight(WidgetTester tester) {
  final AnimatedContainer box = tester.widget<AnimatedContainer>(
    find.descendant(
      of: find.byType(AppHoverHighlight),
      matching: find.byType(AnimatedContainer),
    ),
  );
  return (box.decoration! as BoxDecoration).color;
}

Future<TestGesture> _hover(WidgetTester tester, Finder target) async {
  final TestGesture gesture = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
  );
  await gesture.addPointer(location: Offset.zero);
  addTearDown(gesture.removePointer);
  await gesture.moveTo(tester.getCenter(target));
  await tester.pumpAndSettle();
  return gesture;
}

void main() {
  testWidgets('pinta o realce no hover e o retira ao sair', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(const AppHoverHighlight(child: AppText('alvo'))),
    );

    // Repouso: transparente (não `null`, para o AnimatedContainer ter o que
    // interpolar).
    expect(_highlight(tester)?.a, 0);

    final TestGesture gesture = await _hover(
      tester,
      find.byType(AppHoverHighlight),
    );
    expect(_highlight(tester)!.a, greaterThan(0));

    await gesture.moveTo(Offset.zero);
    await tester.pumpAndSettle();
    expect(_highlight(tester)?.a, 0);
  });

  testWidgets('NÃO cria alvo de gesto — o clique atravessa para quem tem', (
    WidgetTester tester,
  ) async {
    int outerTaps = 0;
    await tester.pumpWidget(
      _host(
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => outerTaps++,
          child: const AppHoverHighlight(
            padding: EdgeInsets.all(AppSpacings.s8),
            child: AppText('alvo'),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(AppHoverHighlight));
    await tester.pumpAndSettle();

    // A razão de o componente existir: o gatilho de fora continua sendo o
    // único dono do gesto (senão o overlay abriria e fecharia no mesmo toque).
    expect(outerTaps, 1);
  });

  testWidgets('NÃO cria parada de Tab', (WidgetTester tester) async {
    await tester.pumpWidget(
      _host(const AppHoverHighlight(child: AppText('alvo'))),
    );

    expect(
      find.descendant(
        of: find.byType(AppHoverHighlight),
        matching: find.byType(Focus),
      ),
      findsNothing,
    );
  });

  testWidgets('o padding é o que dá corpo à área pintada', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppHoverHighlight(
          padding: EdgeInsets.all(AppSpacings.s16),
          child: SizedBox(key: Key('child'), width: 40, height: 20),
        ),
      ),
    );

    final Size painted = tester.getSize(find.byType(AppHoverHighlight));
    final Size child = tester.getSize(find.byKey(const Key('child')));
    expect(painted.width - child.width, AppSpacings.s16 * 2);
    expect(painted.height - child.height, AppSpacings.s16 * 2);
  });

  test('AppHoverHighlight no catálogo como migrated', () {
    expect(
      flocksCatalog.any(
        (AppComponentMeta m) =>
            m.id == 'app_hover_highlight' &&
            m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
