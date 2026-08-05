import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(size: Size(400, 800)),
    child: AppTheme(
      data: AppThemeData.light.copyWith(
        glassTheme: const AppGlassTheme(enabled: false),
      ),
      child: Align(alignment: Alignment.bottomCenter, child: child),
    ),
  ),
);

Widget _app(WidgetBuilder body) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(size: Size(400, 800), disableAnimations: true),
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

BoxDecoration _sheetDecoration(WidgetTester tester) =>
    tester
            .widgetList<DecoratedBox>(
              find.descendant(
                of: find.byType(AppBottomSheet),
                matching: find.byType(DecoratedBox),
              ),
            )
            .first
            .decoration
        as BoxDecoration;

void main() {
  testWidgets('AppBottomSheet renderiza child e footer', (tester) async {
    await tester.pumpWidget(
      _host(
        const AppBottomSheet(footer: Text('Aplicar'), child: Text('Corpo')),
      ),
    );
    expect(find.text('Corpo'), findsOneWidget);
    expect(find.text('Aplicar'), findsOneWidget);
  });

  testWidgets('repouso é card destacado: 4 cantos arredondados', (
    tester,
  ) async {
    await tester.pumpWidget(_host(const AppBottomSheet(child: SizedBox())));
    final BorderRadius? br = _sheetDecoration(
      tester,
    ).borderRadius?.resolve(TextDirection.ltr);
    expect(br, isNotNull);
    expect(br!.topLeft.x, greaterThan(0));
    expect(br.bottomLeft.x, greaterThan(0)); // card destacado (não rente)
  });

  testWidgets('style default elevated tem sombra; outlined tem borda', (
    tester,
  ) async {
    await tester.pumpWidget(_host(const AppBottomSheet(child: SizedBox())));
    expect(_sheetDecoration(tester).boxShadow, isNotEmpty);

    await tester.pumpWidget(
      _host(const AppBottomSheet(style: AppStyle.outlined, child: SizedBox())),
    );
    expect(_sheetDecoration(tester).border, isNotNull);
  });

  testWidgets('botão de fechar aparece por padrão e chama onCloseButton', (
    tester,
  ) async {
    int closed = 0;
    await tester.pumpWidget(
      _host(
        AppBottomSheet(onCloseButton: () => closed++, child: const Text('X')),
      ),
    );
    expect(find.bySemanticsLabel('Fechar'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Fechar'));
    await tester.pump();
    expect(closed, 1);
  });

  testWidgets('showCloseButton: false esconde o botão', (tester) async {
    await tester.pumpWidget(
      _host(const AppBottomSheet(showCloseButton: false, child: Text('X'))),
    );
    expect(find.bySemanticsLabel('Fechar'), findsNothing);
  });

  testWidgets('showAppBottomSheet (estático) abre e o barrier fecha', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        (BuildContext context) => Center(
          child: GestureDetector(
            onTap: () => showAppBottomSheet<void>(
              context: context,
              child: const Text('CorpoSheet'),
            ),
            child: const Text('Abrir'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.text('CorpoSheet'), findsOneWidget);

    await tester.tapAt(const Offset(5, 5)); // barrier no topo
    await tester.pumpAndSettle();
    expect(find.text('CorpoSheet'), findsNothing);
  });

  testWidgets('arrastável: arrasta pra cima cresce (vira page)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        (BuildContext context) => Center(
          child: GestureDetector(
            onTap: () => showAppBottomSheet<void>(
              context: context,
              draggable: true,
              showHandle: true,
              title: 'Título',
              child: const SizedBox(height: 240, child: Text('CorpoSheet')),
            ),
            child: const Text('Abrir'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.text('CorpoSheet'), findsOneWidget);

    final double hRest = tester.getSize(find.byType(CustomScrollView)).height;
    await tester.drag(find.text('Título'), const Offset(0, -600));
    await tester.pumpAndSettle();
    final double hPage = tester.getSize(find.byType(CustomScrollView)).height;
    expect(hPage, greaterThan(hRest));
  });

  testWidgets('arrastável funciona com mouse (desktop/web)', (tester) async {
    await tester.pumpWidget(
      _app(
        (BuildContext context) => Center(
          child: GestureDetector(
            onTap: () => showAppBottomSheet<void>(
              context: context,
              draggable: true,
              showHandle: true,
              title: 'Título',
              child: const SizedBox(height: 240, child: Text('CorpoSheet')),
            ),
            child: const Text('Abrir'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    final double h0 = tester.getSize(find.byType(CustomScrollView)).height;

    // Arraste com o MOUSE (bloqueado sem o ScrollConfiguration.dragDevices).
    await tester.drag(
      find.text('Título'),
      const Offset(0, -600),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pumpAndSettle();
    expect(
      tester.getSize(find.byType(CustomScrollView)).height,
      greaterThan(h0),
    );
  });

  testWidgets('arrastável: arrasta pra baixo do repouso fecha', (tester) async {
    await tester.pumpWidget(
      _app(
        (BuildContext context) => Center(
          child: GestureDetector(
            onTap: () => showAppBottomSheet<void>(
              context: context,
              draggable: true,
              showHandle: true,
              title: 'Título',
              child: const SizedBox(height: 240, child: Text('CorpoSheet')),
            ),
            child: const Text('Abrir'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.text('CorpoSheet'), findsOneWidget);

    await tester.fling(find.text('Título'), const Offset(0, 600), 1200);
    await tester.pumpAndSettle();
    expect(find.text('CorpoSheet'), findsNothing);
  });

  testWidgets('onClose dispara ao fechar por qualquer meio', (tester) async {
    int closed = 0;
    await tester.pumpWidget(
      _app(
        (BuildContext context) => Center(
          child: GestureDetector(
            onTap: () => showAppBottomSheet<void>(
              context: context,
              onClose: () => closed++,
              child: const Text('CorpoSheet'),
            ),
            child: const Text('Abrir'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(closed, 1);
  });

  testWidgets('alwaysClose: arrasta pra baixo da page fecha', (tester) async {
    await tester.pumpWidget(
      _app(
        (BuildContext context) => Center(
          child: GestureDetector(
            onTap: () => showAppBottomSheet<void>(
              context: context,
              draggable: true,
              alwaysClose: true,
              showHandle: true,
              title: 'Título',
              child: const SizedBox(height: 200, child: Text('CorpoSheet')),
            ),
            child: const Text('Abrir'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.fling(find.text('Título'), const Offset(0, -700), 1400);
    await tester.pumpAndSettle();
    await tester.fling(find.text('Título'), const Offset(0, 500), 1000);
    await tester.pumpAndSettle();
    expect(find.text('CorpoSheet'), findsNothing);
  });

  testWidgets('sem alwaysClose: arrasta pra baixo da page volta ao repouso', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        (BuildContext context) => Center(
          child: GestureDetector(
            onTap: () => showAppBottomSheet<void>(
              context: context,
              draggable: true,
              showHandle: true,
              title: 'Título',
              child: const SizedBox(height: 200, child: Text('CorpoSheet')),
            ),
            child: const Text('Abrir'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.fling(find.text('Título'), const Offset(0, -700), 1400);
    await tester.pumpAndSettle();
    final double hPage = tester.getSize(find.byType(CustomScrollView)).height;

    // Arraste lento (velocidade ~0 no fim) → snap por posição, volta ao repouso.
    final TestGesture g = await tester.startGesture(
      tester.getCenter(find.text('Título')),
    );
    await g.moveBy(const Offset(0, 320));
    await tester.pump(const Duration(milliseconds: 200));
    await g.up();
    await tester.pumpAndSettle();

    expect(find.text('CorpoSheet'), findsOneWidget);
    final double hRest = tester.getSize(find.byType(CustomScrollView)).height;
    expect(hRest, lessThan(hPage));
  });

  test('AppBottomSheet(+Content/Page) no catálogo como migrated', () {
    for (final String id in <String>[
      'app_bottom_sheet',
      'app_bottom_sheet_content',
      'app_bottom_sheet_page',
    ]) {
      expect(
        flocksCatalog.any(
          (AppComponentMeta m) =>
              m.id == id && m.status == ComponentStatus.migrated,
        ),
        isTrue,
        reason: '$id deve estar migrated',
      );
    }
  });
}
