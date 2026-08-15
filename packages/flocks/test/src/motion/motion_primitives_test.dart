import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Host com `AppTheme` (para ler o global [AppAnimationTheme]) e controle do
/// reduce-motion do SO via [MediaQueryData.disableAnimations].
Widget _themed(
  Widget child, {
  required bool animEnabled,
  bool disableAnim = false,
}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: MediaQueryData(disableAnimations: disableAnim),
      child: AppTheme(
        data: AppThemeData.light.copyWith(
          animationTheme: AppAnimationTheme(enabled: animEnabled),
        ),
        child: Center(child: child),
      ),
    ),
  );
}

void main() {
  group('Global de motion (AppAnimationTheme via AppMotion)', () {
    testWidgets('global desligado ⇒ AppMotion.enabled = false', (tester) async {
      late bool enabled;
      await tester.pumpWidget(
        _themed(
          Builder(
            builder: (context) {
              enabled = AppMotion.enabled(context);
              return const SizedBox();
            },
          ),
          animEnabled: false,
        ),
      );
      expect(enabled, isFalse);
    });

    testWidgets('global ligado (default) ⇒ AppMotion.enabled = true', (
      tester,
    ) async {
      late bool enabled;
      await tester.pumpWidget(
        _themed(
          Builder(
            builder: (context) {
              enabled = AppMotion.enabled(context);
              return const SizedBox();
            },
          ),
          animEnabled: true,
        ),
      );
      expect(enabled, isTrue);
    });

    testWidgets('reduce-motion do SO vence o global ligado', (tester) async {
      late bool enabled;
      await tester.pumpWidget(
        _themed(
          Builder(
            builder: (context) {
              enabled = AppMotion.enabled(context);
              return const SizedBox();
            },
          ),
          animEnabled: true,
          disableAnim: true,
        ),
      );
      expect(enabled, isFalse);
    });
  });

  group('AppTypewriter', () {
    testWidgets('motion off ⇒ texto completo de imediato', (tester) async {
      await tester.pumpWidget(
        _themed(const AppTypewriter(text: 'Olá mundo'), animEnabled: false),
      );
      await tester.pump();
      expect(find.text('Olá mundo'), findsOneWidget);
    });

    testWidgets('motion on ⇒ digita ao longo do tempo', (tester) async {
      await tester.pumpWidget(
        _themed(const AppTypewriter(text: 'Olá mundo'), animEnabled: true),
      );
      await tester.pump(); // primeiro frame: ainda vazio/parcial
      expect(find.text('Olá mundo'), findsNothing);
      await tester.pumpAndSettle();
      expect(find.text('Olá mundo'), findsOneWidget);
    });
  });

  group('AppValueBuilder', () {
    testWidgets('motion off ⇒ salta para o valor final ao mudar', (
      tester,
    ) async {
      double seen = -1;
      Widget build(double value, bool anim) => _themed(
        AppValueBuilder(
          value: value,
          builder: (context, t, _) {
            seen = t;
            return const SizedBox();
          },
        ),
        animEnabled: anim,
      );

      // Primeiro build em 0.
      await tester.pumpWidget(build(0, false));
      // Muda para 1 com motion off → valor final imediato.
      await tester.pumpWidget(build(1, false));
      await tester.pump();
      expect(seen, 1.0);
    });
  });

  group('AppPop', () {
    testWidgets('escala nunca fica negativa (clamp no overshoot ao encolher)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _themed(
          const AppPop(visible: true, child: SizedBox(width: 20, height: 20)),
          animEnabled: true,
        ),
      );
      // Encolhe (1 → 0): a curva de overshoot passaria abaixo de 0; o AppPop
      // clampa. Varre a animação conferindo que nenhuma escala é negativa.
      await tester.pumpWidget(
        _themed(
          const AppPop(visible: false, child: SizedBox(width: 20, height: 20)),
          animEnabled: true,
        ),
      );
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 20));
        final transform = tester.widget<Transform>(find.byType(Transform));
        expect(transform.transform.storage[0], greaterThanOrEqualTo(0.0));
      }
    });
  });

  group('AppPulse', () {
    double opacityOf(WidgetTester tester) => tester
        .widget<FadeTransition>(find.byType(FadeTransition))
        .opacity
        .value;

    testWidgets('respira: cheio em t=0, vale na meia respiração', (
      tester,
    ) async {
      await tester.pumpWidget(
        _themed(
          const AppPulse(child: SizedBox(width: 16, height: 16)),
          animEnabled: true,
        ),
      );
      expect(opacityOf(tester), 1.0);

      // Meia respiração = uma perna do repeat(reverse) = period ~/ 2.
      await tester.pump(AppDurations.loop ~/ 2);
      expect(opacityOf(tester), moreOrLessEquals(0.45, epsilon: 0.01));

      // A volta: fecha o period inteiro de novo no cheio.
      await tester.pump(AppDurations.loop ~/ 2);
      expect(opacityOf(tester), moreOrLessEquals(1.0, epsilon: 0.01));
    });

    testWidgets('reduce-motion do SO congela no estado CHEIO', (tester) async {
      await tester.pumpWidget(
        _themed(
          const AppPulse(
            minScale: 0.85,
            child: SizedBox(width: 16, height: 16),
          ),
          animEnabled: true,
          disableAnim: true,
        ),
      );
      // A decisão registrada no dartdoc, executável: um laço PARA (não
      // encurta), e para no ACESO — congelar no vale leria como "desligado".
      expect(opacityOf(tester), 1.0);
      final scale = tester.widget<ScaleTransition>(
        find.byType(ScaleTransition),
      );
      expect(scale.scale.value, 1.0);
      await tester.pumpAndSettle();
      expect(opacityOf(tester), 1.0);
    });

    testWidgets('global AppAnimationTheme desligado congela igual', (
      tester,
    ) async {
      await tester.pumpWidget(
        _themed(
          const AppPulse(child: SizedBox(width: 16, height: 16)),
          animEnabled: false,
        ),
      );
      expect(opacityOf(tester), 1.0);
      await tester.pumpAndSettle();
      expect(opacityOf(tester), 1.0);
    });

    testWidgets('minScale default (1.0) não monta ScaleTransition', (
      tester,
    ) async {
      await tester.pumpWidget(
        _themed(
          const AppPulse(child: SizedBox(width: 16, height: 16)),
          animEnabled: true,
        ),
      );
      expect(find.byType(ScaleTransition), findsNothing);

      await tester.pumpWidget(
        _themed(
          const AppPulse(
            minScale: 0.85,
            child: SizedBox(width: 16, height: 16),
          ),
          animEnabled: true,
        ),
      );
      expect(find.byType(ScaleTransition), findsOneWidget);
    });

    testWidgets('trocar o period não recria o estado nem para o laço', (
      tester,
    ) async {
      await tester.pumpWidget(
        _themed(
          const AppPulse(child: SizedBox(width: 16, height: 16)),
          animEnabled: true,
        ),
      );
      await tester.pumpWidget(
        _themed(
          const AppPulse(
            period: Duration(milliseconds: 600),
            child: SizedBox(width: 16, height: 16),
          ),
          animEnabled: true,
        ),
      );
      // Meia respiração do period novo (600 ~/ 2 = 300ms) chega ao vale.
      await tester.pump(const Duration(milliseconds: 300));
      expect(opacityOf(tester), moreOrLessEquals(0.45, epsilon: 0.01));
    });

    testWidgets('religar o motion retoma o laço de onde congelou', (
      tester,
    ) async {
      await tester.pumpWidget(
        _themed(
          const AppPulse(child: SizedBox(width: 16, height: 16)),
          animEnabled: false,
        ),
      );
      expect(opacityOf(tester), 1.0);

      await tester.pumpWidget(
        _themed(
          const AppPulse(child: SizedBox(width: 16, height: 16)),
          animEnabled: true,
        ),
      );
      await tester.pump(AppDurations.loop ~/ 2);
      expect(opacityOf(tester), moreOrLessEquals(0.45, epsilon: 0.01));
    });
  });
}
