import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/semantics.dart';
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
  testWidgets('onTap dispara no tap', (tester) async {
    int taps = 0;
    await tester.pumpWidget(
      _host(AppInteraction(onTap: () => taps++, child: const AppText('x'))),
    );
    await tester.tap(find.byType(AppInteraction));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('onDoubleTap dispara no duplo-tap', (tester) async {
    int doubles = 0;
    await tester.pumpWidget(
      _host(
        AppInteraction(onDoubleTap: () => doubles++, child: const AppText('x')),
      ),
    );
    final Offset c = tester.getCenter(find.byType(AppInteraction));
    await tester.tapAt(c);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tapAt(c);
    await tester.pumpAndSettle();
    expect(doubles, 1);
  });

  testWidgets('onLongPress dispara no long-press', (tester) async {
    int longs = 0;
    await tester.pumpWidget(
      _host(
        AppInteraction(onLongPress: () => longs++, child: const AppText('x')),
      ),
    );
    await tester.longPress(find.byType(AppInteraction));
    await tester.pump();
    expect(longs, 1);
  });

  testWidgets('disabled não dispara', (tester) async {
    int taps = 0;
    await tester.pumpWidget(
      _host(
        AppInteraction(
          onTap: () => taps++,
          enabled: false,
          child: const AppText('x'),
        ),
      ),
    );
    await tester.tap(find.byType(AppInteraction), warnIfMissed: false);
    await tester.pump();
    expect(taps, 0);
  });

  testWidgets('disabled esmaece o child (Opacity < 1)', (tester) async {
    await tester.pumpWidget(
      _host(
        AppInteraction(onTap: () {}, enabled: false, child: const AppText('x')),
      ),
    );
    final Iterable<Opacity> os = tester.widgetList<Opacity>(
      find.byType(Opacity),
    );
    expect(os.any((w) => w.opacity < 1), isTrue);
  });

  testWidgets('loading não dispara e mostra spinner', (tester) async {
    int taps = 0;
    await tester.pumpWidget(
      _host(
        AppInteraction(
          onTap: () => taps++,
          loading: true,
          child: const AppText('x'),
        ),
      ),
    );
    await tester.tap(find.byType(AppInteraction), warnIfMissed: false);
    await tester.pump();
    expect(taps, 0);
    expect(find.byType(AppCircularLoading), findsOneWidget);
  });

  testWidgets('tooltip → embrulha AppTooltip', (tester) async {
    await tester.pumpWidget(
      _host(
        AppInteraction(tooltip: 'Add', onTap: () {}, child: const AppText('x')),
      ),
    );
    expect(find.byType(AppTooltip), findsOneWidget);
  });

  testWidgets('expõe role de botão com semanticLabel', (tester) async {
    await tester.pumpWidget(
      _host(
        AppInteraction(
          onTap: () {},
          semanticLabel: 'Add',
          child: const SizedBox(width: 24, height: 24),
        ),
      ),
    );
    final SemanticsNode s = tester.getSemantics(find.byType(AppInteraction));
    expect(s.label, 'Add');
    expect(s.flagsCollection.isButton, isTrue);
  });

  testWidgets('torna o child passivo quando interativo (IgnorePointer)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(AppInteraction(onTap: () {}, child: const AppText('x'))),
    );
    final Iterable<IgnorePointer> ips = tester.widgetList<IgnorePointer>(
      find.byType(IgnorePointer),
    );
    expect(ips.any((w) => w.ignoring), isTrue);
  });

  testWidgets('motion pop → curva de overshoot (bounce)', (tester) async {
    await tester.pumpWidget(
      _host(
        AppInteraction(
          motion: AppMotionPreset.pop,
          onTap: () {},
          child: const AppText('x'),
        ),
      ),
    );
    final AnimatedScale s = tester.widget<AnimatedScale>(
      find.byType(AnimatedScale),
    );
    expect(s.curve, AppCurves.emphasizedOvershoot);
  });

  testWidgets('motion rotate → gira ao pressionar', (tester) async {
    await tester.pumpWidget(
      _host(
        AppInteraction(
          motion: AppMotionPreset.rotate,
          onTap: () {},
          child: const SizedBox(width: 40, height: 40),
        ),
      ),
    );
    expect(
      tester.widget<AnimatedRotation>(find.byType(AnimatedRotation)).turns,
      0.0,
    );
    final TestGesture g = await tester.startGesture(
      tester.getCenter(find.byType(AppInteraction)),
    );
    await tester.pump();
    expect(
      tester.widget<AnimatedRotation>(find.byType(AnimatedRotation)).turns,
      isNot(0.0),
    );
    await g.up();
  });

  testWidgets('reduce-motion: press não escala nem gira', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: AppTheme(
            data: AppThemeData.light,
            child: Center(
              // rotate exercita escala (0.96) E rotação (0.04) no press —
              // ambos devem ficar neutros com reduce-motion.
              child: AppInteraction(
                motion: AppMotionPreset.rotate,
                onTap: () {},
                child: const SizedBox(width: 40, height: 40),
              ),
            ),
          ),
        ),
      ),
    );
    final TestGesture g = await tester.startGesture(
      tester.getCenter(find.byType(AppInteraction)),
    );
    await tester.pump();
    expect(tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale, 1.0);
    expect(
      tester.widget<AnimatedRotation>(find.byType(AnimatedRotation)).turns,
      0.0,
    );
    await g.up();
  });

  testWidgets('está no catálogo como migrado', (tester) async {
    expect(
      flocksCatalog.any(
        (m) =>
            m.id == 'app_interaction' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
