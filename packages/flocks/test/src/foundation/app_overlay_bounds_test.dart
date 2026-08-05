import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const Key _cardKey = Key('card');
const Key _sheetKey = Key('sheet');

/// Uma tela com um "cartão" que publica a própria área, e um gatilho FORA dele.
Future<void> _pump(WidgetTester tester, {BorderRadius? radius}) async {
  await tester.pumpWidget(
    AppTheme(
      data: AppThemeData.light,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(size: Size(1000, 800)),
          child: Navigator(
            onGenerateRoute: (_) => PageRouteBuilder<void>(
              pageBuilder: (_, _, _) => Column(
                children: [
                  // Fora da região: o gatilho "global".
                  SizedBox(
                    height: 200,
                    child: Builder(
                      builder: (context) => GestureDetector(
                        key: const Key('outside'),
                        onTap: () => showAppSideSheet<void>(
                          context: context,
                          child: const SizedBox(key: _sheetKey),
                        ),
                        child: const ColoredBox(
                          color: Color(0xFF000000),
                          child: SizedBox.expand(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: AppOverlayBoundsRegion(
                      borderRadius: radius,
                      child: KeyedSubtree(
                        key: _cardKey,
                        child: Builder(
                          builder: (context) => GestureDetector(
                            key: const Key('inside'),
                            onTap: () => showAppSideSheet<void>(
                              context: context,
                              child: const SizedBox(key: _sheetKey),
                            ),
                            child: const ColoredBox(
                              color: Color(0xFFFFFFFF),
                              child: SizedBox.expand(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
  // Um frame extra para o post-frame medir a região.
  await tester.pumpAndSettle();
}

void main() {
  group('AppOverlayBounds — alcance decidido pela origem', () {
    testWidgets('aberto de dentro da região, o modal se confina a ela', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(1000, 800)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await _pump(tester);
      final card = tester.getRect(find.byKey(_cardKey));

      await tester.tap(find.byKey(const Key('inside')));
      await tester.pumpAndSettle();

      final sheet = tester.getRect(find.byKey(_sheetKey));
      // Não passa do topo do cartão: é o que preserva rail e assistente à vista.
      expect(sheet.top, greaterThanOrEqualTo(card.top));
      expect(sheet.bottom, lessThanOrEqualTo(card.bottom));
    });

    testWidgets('o modal confinado é recortado pelos cantos da região', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(1000, 800)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await _pump(tester, radius: BorderRadius.circular(24));
      await tester.tap(find.byKey(const Key('inside')));
      await tester.pumpAndSettle();

      // Sem o recorte, o escurecimento vaza pelas quinas de um cartão
      // arredondado e o overlay lê como um retângulo colado por cima.
      final clip = tester.widgetList<ClipRRect>(
        find.descendant(
          of: find.byType(AppConfinedToBounds),
          matching: find.byType(ClipRRect),
        ),
      );
      expect(clip, isNotEmpty);
      expect(clip.first.borderRadius, BorderRadius.circular(24));
    });

    testWidgets('aberto de fora, ocupa a tela toda', (tester) async {
      tester.view
        ..physicalSize = const Size(1000, 800)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await _pump(tester);
      final card = tester.getRect(find.byKey(_cardKey));

      await tester.tap(find.byKey(const Key('outside')));
      await tester.pumpAndSettle();

      final sheet = tester.getRect(find.byKey(_sheetKey));
      // Sobe acima do cartão — o gatilho era global, o alcance também.
      expect(sheet.top, lessThan(card.top));
    });
  });
}
