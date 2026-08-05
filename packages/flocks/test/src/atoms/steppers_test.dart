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

Widget _hostScaled(double scale, Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: MediaQueryData(textScaler: TextScaler.linear(scale)),
    child: AppTheme(
      data: AppThemeData.light,
      child: Center(child: child),
    ),
  ),
);

const _steps = <AppStepData>[
  AppStepData(title: 'Dados'),
  AppStepData(title: 'Trigger'),
  AppStepData(title: 'Ações'),
];

void main() {
  group('AppDotsIndicator', () {
    testWidgets('anuncia a posição via semântica de status', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(const AppDotsIndicator(currentStep: 1, totalSteps: 4)),
      );
      expect(find.bySemanticsLabel('Passo 2 de 4'), findsOneWidget);
      handle.dispose();
    });
  });

  group('AppStepper', () {
    testWidgets('mostra os títulos dos passos', (tester) async {
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 400,
            child: AppStepper(currentStep: 0, steps: _steps),
          ),
        ),
      );
      expect(find.text('Dados'), findsOneWidget);
      expect(find.text('Trigger'), findsOneWidget);
      expect(find.text('Ações'), findsOneWidget);
    });

    testWidgets('passo ativo exibe o número', (tester) async {
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 400,
            child: AppStepper(currentStep: 0, steps: _steps),
          ),
        ),
      );
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('tocar passo concluído chama onStepTapped', (tester) async {
      final handle = tester.ensureSemantics();
      int? tapped;
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 400,
            child: AppStepper(
              currentStep: 2,
              onStepTapped: (i) => tapped = i,
              steps: _steps,
            ),
          ),
        ),
      );
      await tester.tap(find.bySemanticsLabel(RegExp('Passo 1:')));
      expect(tapped, 0);
      handle.dispose();
    });

    testWidgets('passos concluídos são interativos (FlocksInteraction)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 400,
            child: AppStepper(
              currentStep: 2,
              onStepTapped: (_) {},
              steps: _steps,
            ),
          ),
        ),
      );
      // Passos 0 e 1 estão concluídos → 2 FlocksInteraction (foco/teclado/ring).
      expect(find.byType(FlocksInteraction), findsNWidgets(2));
    });

    testWidgets('o nó do passo escala com o textScaler (preserva padding)', (
      tester,
    ) async {
      Finder nodeOf() => find
          .ancestor(
            of: find.text('1'),
            matching: find.byType(AnimatedContainer),
          )
          .first;

      Widget indicator() => SizedBox(
        width: 400,
        child: AppStepper(currentStep: 0, steps: _steps),
      );

      await tester.pumpWidget(_hostScaled(1.0, indicator()));
      await tester.pumpAndSettle();
      final base = tester.getSize(nodeOf());

      await tester.pumpWidget(_hostScaled(2.0, indicator()));
      await tester.pumpAndSettle();
      final scaled = tester.getSize(nodeOf());

      expect(base.width, appStepperCircleSize); // 36 em escala 1.0
      expect(scaled.width, closeTo(appStepperCircleSize * 2, 0.5));
    });

    testWidgets('passo pendente não é tocável', (tester) async {
      int? tapped;
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 400,
            child: AppStepper(
              currentStep: 0,
              onStepTapped: (i) => tapped = i,
              steps: _steps,
            ),
          ),
        ),
      );
      await tester.tap(find.text('3'), warnIfMissed: false);
      expect(tapped, isNull);
    });
  });

  group('Estados de interação', () {
    // Overlay do press: DecoratedBox com onSurface @0.12 (ladder de estado).
    bool hasPressOverlay(WidgetTester tester) {
      final Color press = AppThemeData.light.colorTheme.onSurface.withValues(
        alpha: 0.12,
      );
      return find
          .byWidgetPredicate((w) {
            if (w is! DecoratedBox) return false;
            final d = w.decoration;
            return d is BoxDecoration && d.color == press;
          })
          .evaluate()
          .isNotEmpty;
    }

    testWidgets('AppStepper: pressionar um passo tocável mostra o overlay', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 400,
            child: AppStepper(
              currentStep: 0,
              allStepsTappable: true,
              onStepTapped: (_) {},
              steps: _steps,
            ),
          ),
        ),
      );
      expect(hasPressOverlay(tester), isFalse);

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('1')),
      );
      await tester.pump();
      expect(hasPressOverlay(tester), isTrue);
      await gesture.up();
      await tester.pump();
      expect(hasPressOverlay(tester), isFalse);
    });

    testWidgets(
      'AppDotsIndicator: pressionar um dot tocável mostra o overlay',
      (tester) async {
        await tester.pumpWidget(
          _host(
            AppDotsIndicator(
              currentStep: 2,
              totalSteps: 4,
              onStepTapped: (_) {},
            ),
          ),
        );
        expect(hasPressOverlay(tester), isFalse);

        // Dot 0 é anterior ao atual → tocável.
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(FlocksInteraction).first),
        );
        await tester.pump();
        expect(hasPressOverlay(tester), isTrue);
        await gesture.up();
        await tester.pump();
      },
    );
  });

  test('steppers no catálogo como migrados', () {
    for (final id in <String>['app_dots_indicator', 'app_stepper']) {
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
