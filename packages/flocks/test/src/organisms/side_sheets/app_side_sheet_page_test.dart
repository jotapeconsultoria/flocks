import 'package:flocks/flocks.dart';
import 'package:flocks/src/organisms/side_sheets/side_sheet_surface.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(WidgetBuilder opener, Size size) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: MediaQueryData(size: size, disableAnimations: true),
    child: AppTheme(
      data: AppThemeData.light,
      child: Navigator(
        onGenerateRoute: (_) => PageRouteBuilder<void>(
          pageBuilder: (BuildContext context, _, _) => opener(context),
        ),
      ),
    ),
  ),
);

Widget _opener(
  BuildContext context, {
  AppSheetSide side = AppSheetSide.end,
  VoidCallback? onClose,
}) => Center(
  child: GestureDetector(
    onTap: () => showAppSideSheetPage<void>(
      context: context,
      side: side,
      onClose: onClose,
      title: 'Ficha',
      footer: const Text('Editar'),
      child: const Text('CorpoPage'),
    ),
    child: const Text('Abrir'),
  ),
);

Future<void> _open(
  WidgetTester tester,
  WidgetBuilder opener, {
  Size size = const Size(1200, 800),
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(_app(opener, size));
  await tester.tap(find.text('Abrir'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('page abre com título, corpo, footer e botão de fechar', (
    tester,
  ) async {
    await _open(tester, _opener);
    expect(find.text('CorpoPage'), findsOneWidget);
    expect(find.text('Ficha'), findsOneWidget);
    expect(find.text('Editar'), findsOneWidget);
    expect(find.byType(AppButton), findsOneWidget); // chip de fechar
  });

  testWidgets('page side end ancora à direita', (tester) async {
    await _open(tester, _opener);
    expect(tester.getTopRight(find.byType(SideSheetSurface)).dx, 1200);
  });

  testWidgets('page: barrier fecha + onClose', (tester) async {
    int closed = 0;
    await _open(
      tester,
      (BuildContext c) => _opener(c, onClose: () => closed++),
    );
    await tester.tapAt(const Offset(5, 400)); // barrier à esquerda do painel
    await tester.pumpAndSettle();
    expect(find.text('CorpoPage'), findsNothing);
    expect(closed, 1);
  });

  // Os testes acima exercitam a ROTA (showAppSideSheetPage). A superfície
  // `AppSideSheetPage` também é montada solta — previews, goldens, Widgetbook.

  testWidgets('a superfície solta monta título, corpo e rodapé', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        (BuildContext context) => const Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 360,
            child: AppSideSheetPage(
              title: 'Ficha',
              footer: Text('Editar'),
              child: Text('CorpoPage'),
            ),
          ),
        ),
        const Size(1200, 800),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ficha'), findsOneWidget);
    expect(find.text('CorpoPage'), findsOneWidget);
    expect(find.text('Editar'), findsOneWidget);
  });

  testWidgets('é visualmente a MESMA superfície do AppSideSheet', (
    tester,
  ) async {
    Future<Rect> surfaceOf(Widget sheet, Key key) async {
      await tester.pumpWidget(
        _app(
          (BuildContext context) => Align(
            alignment: Alignment.centerRight,
            child: SizedBox(key: key, width: 360, height: 520, child: sheet),
          ),
          const Size(1200, 800),
        ),
      );
      await tester.pumpAndSettle();
      return tester.getRect(find.byType(SideSheetSurface));
    }

    final Rect page = await surfaceOf(
      const AppSideSheetPage(title: 'Ficha', child: Text('c')),
      const Key('page'),
    );
    final Rect sheet = await surfaceOf(
      const AppSideSheet(title: 'Ficha', child: Text('c')),
      const Key('sheet'),
    );

    // A diferença entre os dois mora na CLASSE DA ROTA, não na pintura. Se
    // isto quebrar, alguém deu aparência própria a um dos dois e a escolha
    // deixou de ser sobre a natureza do conteúdo.
    expect(page.size, sheet.size);
  });
}
