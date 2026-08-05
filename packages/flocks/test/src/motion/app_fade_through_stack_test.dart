import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host({required int index, bool animations = true}) => AppTheme(
  data: animations
      ? AppThemeData.light
      : AppThemeData.light.copyWith(
          animationTheme: const AppAnimationTheme(enabled: false),
        ),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: AppFadeThroughStack(
      index: index,
      children: const [
        Text('um', key: Key('um')),
        Text('dois', key: Key('dois')),
      ],
    ),
  ),
);

double _opacityOf(WidgetTester tester, String key) => tester
    .widget<Opacity>(
      find.ancestor(of: find.byKey(Key(key)), matching: find.byType(Opacity)),
    )
    .opacity;

void main() {
  group('AppFadeThroughStack', () {
    testWidgets('em repouso só o ativo pinta', (tester) async {
      await tester.pumpWidget(_host(index: 0));
      await tester.pumpAndSettle();

      expect(_opacityOf(tester, 'um'), 1.0);
      // Opacidade 0 não pinta: o custo em repouso é o mesmo do IndexedStack.
      expect(_opacityOf(tester, 'dois'), 0.0);
    });

    testWidgets('os dois nunca aparecem juntos durante a troca', (
      tester,
    ) async {
      await tester.pumpWidget(_host(index: 0));
      await tester.pumpAndSettle();

      await tester.pumpWidget(_host(index: 1));
      for (int step = 0; step < 8; step++) {
        await tester.pump(const Duration(milliseconds: 20));
        final a = _opacityOf(tester, 'um');
        final b = _opacityOf(tester, 'dois');
        // Fade THROUGH: um apaga antes do outro acender. Sobrepostos, duas
        // tabelas semitransparentes viram um borrão.
        expect(a == 0.0 || b == 0.0, isTrue, reason: 'a=$a b=$b');
      }

      await tester.pumpAndSettle();
      expect(_opacityOf(tester, 'dois'), 1.0);
      expect(_opacityOf(tester, 'um'), 0.0);
    });

    testWidgets('as duas abas seguem montadas na troca', (tester) async {
      await tester.pumpWidget(_host(index: 0));
      await tester.pumpAndSettle();
      await tester.pumpWidget(_host(index: 1));
      await tester.pumpAndSettle();

      // O estado das abas inativas é o motivo de tudo isto existir.
      expect(find.byKey(const Key('um')), findsOneWidget);
      expect(find.byKey(const Key('dois')), findsOneWidget);
    });

    testWidgets('sem animação, troca seca via IndexedStack', (tester) async {
      await tester.pumpWidget(_host(index: 0, animations: false));
      await tester.pumpAndSettle();

      expect(find.byType(IndexedStack), findsOneWidget);
      expect(find.byType(Opacity), findsNothing);
    });
  });
}
