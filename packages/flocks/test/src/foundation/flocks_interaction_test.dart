import 'package:flocks/foundation.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: Center(child: child),
  ),
);

void main() {
  testWidgets('tap aciona onPressed quando habilitado', (tester) async {
    var count = 0;
    await tester.pumpWidget(
      _host(
        FlocksInteraction(
          onPressed: () => count++,
          builder: (_, _) => const SizedBox(width: 48, height: 48),
        ),
      ),
    );

    await tester.tap(find.byType(SizedBox));
    expect(count, 1);
  });

  testWidgets('disabled reporta WidgetState.disabled e ignora tap', (
    tester,
  ) async {
    var count = 0;
    late Set<WidgetState> states;
    await tester.pumpWidget(
      _host(
        FlocksInteraction(
          enabled: false,
          onPressed: () => count++,
          builder: (_, s) {
            states = s;
            return const SizedBox(width: 48, height: 48);
          },
        ),
      ),
    );

    expect(states.contains(WidgetState.disabled), isTrue);
    await tester.tap(find.byType(SizedBox), warnIfMissed: false);
    expect(count, 0);
  });

  testWidgets('hover adiciona e remove WidgetState.hovered', (tester) async {
    final previousStrategy = FocusManager.instance.highlightStrategy;
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
    addTearDown(
      () => FocusManager.instance.highlightStrategy = previousStrategy,
    );

    late Set<WidgetState> states;
    await tester.pumpWidget(
      _host(
        FlocksInteraction(
          onPressed: () {},
          builder: (_, s) {
            states = s;
            return const SizedBox(width: 48, height: 48);
          },
        ),
      ),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);

    await gesture.moveTo(tester.getCenter(find.byType(SizedBox)));
    await tester.pump();
    expect(states.contains(WidgetState.hovered), isTrue);

    await gesture.moveTo(const Offset(-100, -100));
    await tester.pump();
    expect(states.contains(WidgetState.hovered), isFalse);
  });

  testWidgets('pressed entra no tap-down e sai no tap-up', (tester) async {
    late Set<WidgetState> states;
    await tester.pumpWidget(
      _host(
        FlocksInteraction(
          onPressed: () {},
          builder: (_, s) {
            states = s;
            return const SizedBox(width: 48, height: 48);
          },
        ),
      ),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(SizedBox)),
    );
    await tester.pump();
    expect(states.contains(WidgetState.pressed), isTrue);

    await gesture.up();
    await tester.pump();
    expect(states.contains(WidgetState.pressed), isFalse);
  });

  testWidgets('teclado: Enter aciona onPressed quando focado', (tester) async {
    var count = 0;
    final node = FocusNode();
    addTearDown(node.dispose);
    await tester.pumpWidget(
      _host(
        FlocksInteraction(
          focusNode: node,
          onPressed: () => count++,
          builder: (_, _) => const SizedBox(width: 48, height: 48),
        ),
      ),
    );

    node.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(count, 1);
  });

  testWidgets('selected reflete WidgetState.selected', (tester) async {
    late Set<WidgetState> states;
    await tester.pumpWidget(
      _host(
        FlocksInteraction(
          selected: true,
          onPressed: () {},
          builder: (_, s) {
            states = s;
            return const SizedBox(width: 48, height: 48);
          },
        ),
      ),
    );

    expect(states.contains(WidgetState.selected), isTrue);
  });

  MouseCursor cursorOf(WidgetTester tester) => tester
      .widget<FocusableActionDetector>(find.byType(FocusableActionDetector))
      .mouseCursor;

  testWidgets('cursor: click quando interativo', (tester) async {
    await tester.pumpWidget(
      _host(
        FlocksInteraction(
          onPressed: () {},
          builder: (_, _) => const SizedBox(width: 48, height: 48),
        ),
      ),
    );

    expect(cursorOf(tester), SystemMouseCursors.click);
  });

  testWidgets('cursor: forbidden quando desabilitado', (tester) async {
    await tester.pumpWidget(
      _host(
        FlocksInteraction(
          enabled: false,
          onPressed: () {},
          builder: (_, _) => const SizedBox(width: 48, height: 48),
        ),
      ),
    );

    expect(cursorOf(tester), SystemMouseCursors.forbidden);
  });

  testWidgets('cursor: basic quando decorativo (habilitado, sem handler)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        FlocksInteraction(
          builder: (_, _) => const SizedBox(width: 48, height: 48),
        ),
      ),
    );

    expect(cursorOf(tester), SystemMouseCursors.basic);
  });
}
