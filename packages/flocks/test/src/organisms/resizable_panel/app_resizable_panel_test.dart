import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const Key _panelKey = Key('panel');

/// O painel só faz sentido ao lado de quem cede espaço: o `Expanded` é o
/// "conteúdo", e o painel é o filho não flexível — a mesma montagem do
/// `AppShell` (aside).
Widget _host({
  required double initialWidth,
  required double maxWidth,
  double minWidth = 0,
  AppResizeEdge edge = AppResizeEdge.start,
  ValueChanged<double>? onWidthChanged,
  TextDirection textDirection = TextDirection.ltr,
}) => Directionality(
  textDirection: textDirection,
  child: MediaQuery(
    data: const MediaQueryData(size: Size(800, 400)),
    child: AppTheme(
      data: AppThemeData.light,
      child: SizedBox(
        width: 600,
        height: 300,
        child: Row(
          children: <Widget>[
            if (edge == AppResizeEdge.start) const Expanded(child: SizedBox()),
            AppResizablePanel(
              edge: edge,
              initialWidth: initialWidth,
              minWidth: minWidth,
              maxWidth: maxWidth,
              onWidthChanged: onWidthChanged,
              child: const SizedBox.expand(key: _panelKey),
            ),
            if (edge == AppResizeEdge.end) const Expanded(child: SizedBox()),
          ],
        ),
      ),
    ),
  ),
);

double _widthOf(WidgetTester tester) =>
    tester.getSize(find.byKey(_panelKey)).width;

/// A calha é o único `AppTooltip` da árvore.
Finder get _gutter => find.byType(AppTooltip);

/// Arrasta a calha em [dx] px **efetivos**.
///
/// O primeiro movimento paga o slop do reconhecedor (é descartado, não vira
/// delta) — sem ele, `tester.drag` entregaria `dx - kDragSlopDefault`.
Future<void> _dragGutter(WidgetTester tester, double dx) async {
  final TestGesture gesture = await tester.startGesture(
    tester.getCenter(_gutter),
  );
  await gesture.moveBy(Offset(dx.sign * kDragSlopDefault, 0));
  await gesture.moveBy(Offset(dx, 0));
  await gesture.up();
  // Deixa vencer o countdown do duplo-toque (40ms) armado no pointer down —
  // senão ele fica pendente e o teste falha por timer vivo.
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  testWidgets('AppResizablePanel começa na initialWidth', (tester) async {
    await tester.pumpWidget(_host(initialWidth: 200, maxWidth: 400));

    expect(_widthOf(tester), 200);
    expect(_gutter, findsOneWidget);
  });

  testWidgets('arrastar para fora cresce; para dentro encolhe (edge start)', (
    tester,
  ) async {
    final List<double> reported = <double>[];
    await tester.pumpWidget(
      _host(initialWidth: 200, maxWidth: 400, onWidthChanged: reported.add),
    );

    // Alça à esquerda: arrastar para a esquerda alarga o painel.
    await _dragGutter(tester, -60);
    expect(_widthOf(tester), 260);

    await _dragGutter(tester, 30);
    expect(_widthOf(tester), 230);

    expect(reported.last, 230);
  });

  testWidgets('edge end espelha o sinal do arraste', (tester) async {
    await tester.pumpWidget(
      _host(initialWidth: 200, maxWidth: 400, edge: AppResizeEdge.end),
    );

    // Alça à direita: agora é arrastar para a DIREITA que alarga.
    await _dragGutter(tester, 50);
    expect(_widthOf(tester), 250);
  });

  testWidgets('RTL espelha o sinal do arraste', (tester) async {
    await tester.pumpWidget(
      _host(initialWidth: 200, maxWidth: 400, textDirection: TextDirection.rtl),
    );

    // `start` no RTL é a borda direita: crescer é arrastar para a direita.
    await _dragGutter(tester, 50);
    expect(_widthOf(tester), 250);
  });

  testWidgets('trava no minWidth e no maxWidth', (tester) async {
    await tester.pumpWidget(
      _host(initialWidth: 200, minWidth: 150, maxWidth: 300),
    );

    await _dragGutter(tester, 500);
    expect(_widthOf(tester), 150);

    await _dragGutter(tester, -500);
    expect(_widthOf(tester), 300);
  });

  testWidgets('duplo-toque volta para a initialWidth', (tester) async {
    final List<double> reported = <double>[];
    await tester.pumpWidget(
      _host(
        initialWidth: 200,
        minWidth: 150,
        maxWidth: 400,
        onWidthChanged: reported.add,
      ),
    );

    await _dragGutter(tester, -80);
    expect(_widthOf(tester), 280);

    final Offset center = tester.getCenter(_gutter);
    await tester.tapAt(center);
    // Entre o mínimo do duplo-toque (40ms) e o timeout (300ms).
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tapAt(center);
    await tester.pumpAndSettle();

    expect(_widthOf(tester), 200);
    expect(reported.last, 200);
  });

  testWidgets('reclampa quando o maxWidth diminui (janela encolheu)', (
    tester,
  ) async {
    await tester.pumpWidget(_host(initialWidth: 300, maxWidth: 400));
    expect(_widthOf(tester), 300);

    await tester.pumpWidget(_host(initialWidth: 300, maxWidth: 220));
    expect(_widthOf(tester), 220);
  });

  testWidgets('minWidth vence quando os limites se cruzam', (tester) async {
    // Janela estreita demais: o piso é o que sobra de pé.
    await tester.pumpWidget(
      _host(initialWidth: 200, minWidth: 180, maxWidth: 100),
    );

    expect(_widthOf(tester), 180);
  });

  test('AppResizablePanel no catálogo como migrated', () {
    expect(
      flocksCatalog.any(
        (AppComponentMeta m) =>
            m.id == 'app_resizable_panel' &&
            m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
