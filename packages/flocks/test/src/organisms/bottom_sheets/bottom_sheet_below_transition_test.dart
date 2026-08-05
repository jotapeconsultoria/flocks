import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Efeito iOS: ao subir uma sheet **page**, a tela de BAIXO encolhe, desce,
// arredonda os cantos e escurece (transição delegada via `delegatedTransition`).

const Key _belowKey = Key('below');

Widget _app(WidgetBuilder body, {bool animations = true}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: MediaQueryData(
      size: const Size(400, 800),
      disableAnimations: !animations,
    ),
    child: AppTheme(
      data: AppThemeData.light.copyWith(
        glassTheme: const AppGlassTheme(enabled: false),
      ),
      child: Navigator(
        onGenerateRoute: (_) => PageRouteBuilder<void>(
          pageBuilder: (BuildContext context, _, _) => body(context),
        ),
      ),
    ),
  ),
);

Widget _below(BuildContext context, VoidCallback onTap) => GestureDetector(
  onTap: onTap,
  child: const ColoredBox(
    color: Color(0xFF00FF00),
    child: SizedBox.expand(child: SizedBox(key: _belowKey)),
  ),
);

void main() {
  testWidgets('sheet PAGE encolhe e desce a tela de baixo', (tester) async {
    await tester.pumpWidget(
      _app(
        (BuildContext context) => _below(
          context,
          () => showAppBottomSheetPage<void>(
            context: context,
            child: const AppText('conteudo'),
          ),
        ),
      ),
    );

    final Rect before = tester.getRect(find.byKey(_belowKey));

    await tester.tap(find.byKey(_belowKey));
    await tester.pumpAndSettle();

    // A transição delegada é aplicada à rota de baixo.
    expect(
      find.ancestor(
        of: find.byKey(_belowKey),
        matching: find.byType(ScaleTransition),
      ),
      findsWidgets,
    );

    final Rect after = tester.getRect(find.byKey(_belowKey));
    expect(after.width, lessThan(before.width)); // encolheu
    expect(after.top, greaterThan(before.top)); // desceu
  });

  testWidgets('sheet comum NÃO mexe na tela de baixo', (tester) async {
    await tester.pumpWidget(
      _app(
        (BuildContext context) => _below(
          context,
          () => showAppBottomSheet<void>(
            context: context,
            child: const AppText('conteudo'),
          ),
        ),
      ),
    );

    final Rect before = tester.getRect(find.byKey(_belowKey));
    await tester.tap(find.byKey(_belowKey));
    await tester.pumpAndSettle();

    expect(tester.getRect(find.byKey(_belowKey)), before);
  });

  testWidgets('reduce-motion: tela de baixo fica parada', (tester) async {
    await tester.pumpWidget(
      _app(
        (BuildContext context) => _below(
          context,
          () => showAppBottomSheetPage<void>(
            context: context,
            child: const AppText('conteudo'),
          ),
        ),
        animations: false,
      ),
    );

    final Rect before = tester.getRect(find.byKey(_belowKey));
    await tester.tap(find.byKey(_belowKey));
    await tester.pumpAndSettle();

    expect(tester.getRect(find.byKey(_belowKey)), before);
  });
}
