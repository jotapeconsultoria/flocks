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
}
