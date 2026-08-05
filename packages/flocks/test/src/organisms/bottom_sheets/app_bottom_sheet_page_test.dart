import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(WidgetBuilder body) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(size: Size(400, 800), disableAnimations: true),
    child: AppTheme(
      data: AppThemeData.light,
      child: Navigator(
        onGenerateRoute: (_) => PageRouteBuilder<void>(
          pageBuilder: (BuildContext context, _, _) => body(context),
        ),
      ),
    ),
  ),
);

Widget _opener(
  BuildContext context, {
  AppSheetCloseSide closeSide = AppSheetCloseSide.end,
  VoidCallback? onCloseButton,
}) => Center(
  child: GestureDetector(
    onTap: () => showAppBottomSheetPage<void>(
      context: context,
      title: 'Ajustes',
      closeSide: closeSide,
      onCloseButton: onCloseButton,
      child: const SizedBox(height: 300, child: Text('CorpoPage')),
    ),
    child: const Text('Abrir'),
  ),
);

void main() {
  testWidgets('page abre com título e botão de fechar', (tester) async {
    await tester.pumpWidget(_app(_opener));
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.text('CorpoPage'), findsOneWidget);
    expect(find.text('Ajustes'), findsOneWidget);
    expect(find.byType(AppButton), findsOneWidget);
  });

  testWidgets('page: swipe pra baixo fecha', (tester) async {
    await tester.pumpWidget(_app(_opener));
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.text('CorpoPage'), findsOneWidget);

    await tester.fling(find.text('Ajustes'), const Offset(0, 600), 1200);
    await tester.pumpAndSettle();
    expect(find.text('CorpoPage'), findsNothing);
  });

  testWidgets('page: barrier fecha', (tester) async {
    await tester.pumpWidget(_app(_opener));
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(find.text('CorpoPage'), findsNothing);
  });

  testWidgets('closeSide.end (default) fica à direita', (tester) async {
    await tester.pumpWidget(_app(_opener));
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(tester.getCenter(find.byType(AppButton)).dx, greaterThan(200));
  });

  testWidgets('closeSide.start fica à esquerda', (tester) async {
    await tester.pumpWidget(
      _app(
        (BuildContext context) =>
            _opener(context, closeSide: AppSheetCloseSide.start),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(tester.getCenter(find.byType(AppButton)).dx, lessThan(200));
  });

  testWidgets('page: onCloseButton customiza (não dá pop automático)', (
    tester,
  ) async {
    int closed = 0;
    await tester.pumpWidget(
      _app(
        (BuildContext context) =>
            _opener(context, onCloseButton: () => closed++),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(AppButton));
    await tester.pump();
    expect(closed, 1);
    expect(find.text('CorpoPage'), findsOneWidget); // custom não deu pop
  });

  // Os testes acima exercitam a ROTA (showAppBottomSheetPage). A superfície
  // `AppBottomSheetPage` também é usada solta — em previews, goldens e no
  // Widgetbook —, e é o contrato dela que estes travam.

  testWidgets('a superfície solta monta título, corpo e rodapé', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        (BuildContext context) => const AppBottomSheetPage(
          title: 'Ajustes',
          footer: Text('Aplicar'),
          child: Text('CorpoPage'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ajustes'), findsOneWidget);
    expect(find.text('CorpoPage'), findsOneWidget);
    expect(find.text('Aplicar'), findsOneWidget);
  });

  testWidgets('a superfície é edge-to-edge (é PÁGINA, não card destacado)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        (BuildContext context) =>
            const AppBottomSheetPage(child: Text('CorpoPage')),
      ),
    );
    await tester.pumpAndSettle();

    // Comparado com a área disponível, não com números fixos: o
    // `MediaQueryData.size` do host não restringe layout, quem manda é a
    // superfície do teste.
    final Rect page = tester.getRect(find.byType(AppBottomSheetPage));
    final Rect host = tester.getRect(find.byType(Navigator));
    expect(page.left, host.left);
    expect(page.right, host.right);
    expect(page.bottom, host.bottom);
  });

  testWidgets('sem título e sem "X" a barra de topo some', (tester) async {
    await tester.pumpWidget(
      _app(
        (BuildContext context) => const AppBottomSheetPage(
          showCloseButton: false,
          child: Text('CorpoPage'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Sem nada para carregar, a barra não deve sobrar como um vão de 64px.
    expect(find.byType(AppButton), findsNothing);
  });

  test('AppBottomSheetPage no catálogo como migrated', () {
    expect(
      flocksCatalog.any(
        (AppComponentMeta m) =>
            m.id == 'app_bottom_sheet_page' &&
            m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
