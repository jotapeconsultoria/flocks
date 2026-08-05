import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flocks/src/organisms/side_sheets/side_sheet_surface.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
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
  bool draggable = false,
  bool alwaysClose = false,
  AppSideSheetSnap initialSnap = AppSideSheetSnap.rest,
  VoidCallback? onClose,
}) => Center(
  child: GestureDetector(
    onTap: () => showAppSideSheet<void>(
      context: context,
      side: side,
      draggable: draggable,
      alwaysClose: alwaysClose,
      initialSnap: initialSnap,
      onClose: onClose,
      title: 'Veículo',
      footer: const Text('Editar'),
      child: const Text('CorpoSide'),
    ),
    child: const Text('Abrir'),
  ),
);

double _panelWidth(WidgetTester tester) =>
    tester.getSize(find.byType(SideSheetSurface)).width;

/// Borda interna (x) do painel `end` = borda esquerda do painel.
double _innerEdgeX(WidgetTester tester) =>
    tester.getTopLeft(find.byType(SideSheetSurface)).dx;

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
  testWidgets('abre com título, corpo, footer e botão de fechar', (
    tester,
  ) async {
    await _open(tester, _opener);
    expect(find.text('CorpoSide'), findsOneWidget);
    expect(find.text('Veículo'), findsOneWidget);
    expect(find.text('Editar'), findsOneWidget);
    expect(find.byType(AppButton), findsOneWidget); // botão de fechar (chip)
  });

  testWidgets('side end ancora à direita', (tester) async {
    await _open(tester, _opener);
    expect(tester.getTopRight(find.byType(SideSheetSurface)).dx, 1200);
  });

  group('initialSnap', () {
    testWidgets('rest (default) abre no menor snap', (tester) async {
      await _open(tester, _opener);
      // Tela larga (1200 > 1024): 1º snap = 40%.
      expect(_panelWidth(tester), closeTo(1200 * 0.40, 1));
    });

    testWidgets('full abre no maior snap, sem precisar arrastar', (
      tester,
    ) async {
      await _open(
        tester,
        (BuildContext c) => _opener(c, initialSnap: AppSideSheetSnap.full),
      );
      // Full = largura toda menos o respiro da borda oposta (edgePeek).
      expect(_panelWidth(tester), closeTo(1200 - kSideSheetEdgePeek, 1));
    });

    testWidgets('full também vale em tela estreita', (tester) async {
      await _open(
        tester,
        (BuildContext c) => _opener(c, initialSnap: AppSideSheetSnap.full),
        size: const Size(800, 900),
      );
      expect(_panelWidth(tester), closeTo(800 - kSideSheetEdgePeek, 1));
    });
  });

  testWidgets('side start ancora à esquerda', (tester) async {
    await _open(
      tester,
      (BuildContext c) => _opener(c, side: AppSheetSide.start),
    );
    expect(tester.getTopLeft(find.byType(SideSheetSurface)).dx, 0);
  });

  testWidgets('não-arrastável: largura ≈ 40% no wide (>1024)', (tester) async {
    await _open(tester, _opener);
    expect(_panelWidth(tester), closeTo(0.40 * 1200, 1));
  });

  testWidgets('não-arrastável: largura ≈ 70% no narrow (<=1024)', (
    tester,
  ) async {
    await _open(tester, _opener, size: const Size(900, 800));
    expect(_panelWidth(tester), closeTo(0.70 * 900, 1));
  });

  testWidgets('barrier fecha + onClose', (tester) async {
    int closed = 0;
    await _open(
      tester,
      (BuildContext c) => _opener(c, onClose: () => closed++),
    );
    await tester.tapAt(const Offset(5, 400)); // peek/barrier à esquerda
    await tester.pumpAndSettle();
    expect(find.text('CorpoSide'), findsNothing);
    expect(closed, 1);
  });

  testWidgets('arrastável: arrasta a borda interna e cresce', (tester) async {
    await _open(tester, (BuildContext c) => _opener(c, draggable: true));
    final double w0 = _panelWidth(tester);
    // Gutter na borda interna (esquerda) do painel end.
    await tester.dragFrom(
      Offset(_innerEdgeX(tester) + (kSideSheetHandleHitWidth / 2), 400),
      const Offset(-500, 0),
    );
    await tester.pumpAndSettle();
    expect(_panelWidth(tester), greaterThan(w0 + 100));
  });

  testWidgets('arrastável funciona com mouse', (tester) async {
    await _open(tester, (BuildContext c) => _opener(c, draggable: true));
    final double w0 = _panelWidth(tester);
    await tester.dragFrom(
      Offset(_innerEdgeX(tester) + (kSideSheetHandleHitWidth / 2), 400),
      const Offset(-500, 0),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pumpAndSettle();
    expect(_panelWidth(tester), greaterThan(w0 + 100));
  });

  testWidgets('arrastável: over-drag pra dentro fecha', (tester) async {
    await _open(tester, (BuildContext c) => _opener(c, draggable: true));
    await tester.dragFrom(
      Offset(_innerEdgeX(tester) + (kSideSheetHandleHitWidth / 2), 400),
      const Offset(600, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('CorpoSide'), findsNothing);
  });

  testWidgets('alwaysClose: da full, encolher fecha', (tester) async {
    await _open(
      tester,
      (BuildContext c) => _opener(c, draggable: true, alwaysClose: true),
    );
    // Cresce até a full.
    await tester.dragFrom(
      Offset(_innerEdgeX(tester) + (kSideSheetHandleHitWidth / 2), 400),
      const Offset(-900, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('CorpoSide'), findsOneWidget);
    // Encolhe (fling pra dentro/direita) → com alwaysClose, fecha.
    await tester.flingFrom(
      Offset(_innerEdgeX(tester) + (kSideSheetHandleHitWidth / 2), 400),
      const Offset(300, 0),
      1200,
    );
    await tester.pumpAndSettle();
    expect(find.text('CorpoSide'), findsNothing);
  });

  test('AppSideSheet no catálogo como migrated', () {
    expect(
      flocksCatalog.any(
        (AppComponentMeta m) =>
            m.id == 'app_side_sheet' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
