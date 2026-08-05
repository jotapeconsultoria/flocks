import 'package:flocks/motion.dart';
import 'package:flocks/tokens.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child, {bool disableAnim = false}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: MediaQueryData(disableAnimations: disableAnim),
    child: Center(child: child),
  ),
);

void main() {
  group('AppMotion', () {
    testWidgets(
      'enabled=true por padrão; false e resolve=zero sob reduce-motion',
      (tester) async {
        late bool normal;
        await tester.pumpWidget(
          _host(
            Builder(
              builder: (context) {
                normal = AppMotion.enabled(context);
                return const SizedBox();
              },
            ),
          ),
        );
        expect(normal, isTrue);

        late bool reduced;
        late Duration resolved;
        await tester.pumpWidget(
          _host(
            Builder(
              builder: (context) {
                reduced = AppMotion.enabled(context);
                resolved = AppMotion.resolve(context, AppDurations.normal);
                return const SizedBox();
              },
            ),
            disableAnim: true,
          ),
        );
        expect(reduced, isFalse);
        expect(resolved, Duration.zero);
      },
    );
  });

  group('AppAnimatedRotation', () {
    testWidgets('usa a duração do token por padrão', (tester) async {
      await tester.pumpWidget(
        _host(
          const AppAnimatedRotation(
            turns: 0.5,
            child: SizedBox(width: 20, height: 20),
          ),
        ),
      );
      final anim = tester.widget<AnimatedRotation>(
        find.byType(AnimatedRotation),
      );
      expect(anim.duration, AppDurations.normal);
    });

    testWidgets('colapsa para duração zero sob reduce-motion', (tester) async {
      await tester.pumpWidget(
        _host(
          const AppAnimatedRotation(
            turns: 0.5,
            child: SizedBox(width: 20, height: 20),
          ),
          disableAnim: true,
        ),
      );
      final anim = tester.widget<AnimatedRotation>(
        find.byType(AnimatedRotation),
      );
      expect(anim.duration, Duration.zero);
    });
  });

  group('AppScaleOnTap', () {
    testWidgets('aciona onPressed', (tester) async {
      var count = 0;
      await tester.pumpWidget(
        _host(
          AppScaleOnTap(
            onPressed: () => count++,
            child: const SizedBox(width: 40, height: 40),
          ),
        ),
      );
      await tester.tap(find.byType(SizedBox));
      await tester.pumpAndSettle();
      expect(count, 1);
    });
  });

  group('AppSpin', () {
    testWidgets('sob reduce-motion fica estático e pumpAndSettle não trava', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppSpin(child: SizedBox(width: 20, height: 20)),
          disableAnim: true,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AppSpin), findsOneWidget);
    });
  });

  group('AppShakeMixin', () {
    testWidgets('dispara e finaliza sem travar', (tester) async {
      await tester.pumpWidget(_host(const _ShakeHost()));
      await tester.tap(find.byType(SizedBox));
      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsOneWidget);
    });
  });

  group('AppInteractiveMotion', () {
    testWidgets('press aplica a escala-alvo', (tester) async {
      await tester.pumpWidget(
        _host(
          AppInteractiveMotion(
            trigger: AppMotionTrigger.press,
            scale: 1.3,
            onPressed: () {},
            child: const SizedBox(width: 40, height: 40),
          ),
        ),
      );
      expect(
        tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale,
        1.0,
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(SizedBox)),
      );
      await tester.pump();
      expect(
        tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale,
        1.3,
      );
      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('hover aplica a rotação-alvo', (tester) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      await tester.pumpWidget(
        _host(
          AppInteractiveMotion(
            trigger: AppMotionTrigger.hover,
            turns: 0.25,
            onPressed: () {},
            child: const SizedBox(width: 40, height: 40),
          ),
        ),
      );
      expect(
        tester.widget<AnimatedRotation>(find.byType(AnimatedRotation)).turns,
        0.0,
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(tester.getCenter(find.byType(SizedBox)));
      await tester.pumpAndSettle();
      expect(
        tester.widget<AnimatedRotation>(find.byType(AnimatedRotation)).turns,
        0.25,
      );
    });

    testWidgets('focus aplica a escala-alvo', (tester) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        _host(
          AppInteractiveMotion(
            trigger: AppMotionTrigger.focus,
            scale: 1.2,
            focusNode: node,
            onPressed: () {},
            child: const SizedBox(width: 40, height: 40),
          ),
        ),
      );
      node.requestFocus();
      await tester.pumpAndSettle();
      expect(
        tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale,
        1.2,
      );
    });

    testWidgets('reduce-motion colapsa a duração', (tester) async {
      await tester.pumpWidget(
        _host(
          AppInteractiveMotion(
            trigger: AppMotionTrigger.press,
            scale: 1.2,
            onPressed: () {},
            child: const SizedBox(width: 40, height: 40),
          ),
          disableAnim: true,
        ),
      );
      expect(
        tester.widget<AnimatedScale>(find.byType(AnimatedScale)).duration,
        Duration.zero,
      );
    });
  });
}

class _ShakeHost extends StatefulWidget {
  const _ShakeHost();

  @override
  State<_ShakeHost> createState() => _ShakeHostState();
}

class _ShakeHostState extends State<_ShakeHost>
    with TickerProviderStateMixin<_ShakeHost>, AppShakeMixin<_ShakeHost> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: shake,
      child: buildShake(child: const SizedBox(width: 40, height: 40)),
    );
  }
}
