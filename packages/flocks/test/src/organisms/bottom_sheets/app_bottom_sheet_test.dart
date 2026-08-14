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

/// Como o [_app], mas com `viewInsets` parametrizado — re-pumpar com um inset
/// novo simula o teclado abrindo. (O harness monta o MediaQuery à mão, então
/// `tester.view.viewInsets` não chegaria aqui.) `animations: true` liga o
/// motion para os testes que precisam da JANELA da animação do inset.
Widget _appInsets(
  EdgeInsets viewInsets,
  WidgetBuilder body, {
  bool animations = false,
}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: MediaQueryData(
      size: const Size(400, 800),
      disableAnimations: !animations,
      viewInsets: viewInsets,
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

/// A grabber da barra de topo: `Opacity(1|0)` sobre um `SizedBox` 32×4 — o
/// espaço é reservado sempre; só a visibilidade muda.
Opacity _handleOpacity(WidgetTester tester) => tester.widget<Opacity>(
  find.byWidgetPredicate(
    (Widget w) =>
        w is Opacity &&
        w.child is SizedBox &&
        (w.child! as SizedBox).width == 32 &&
        (w.child! as SizedBox).height == 4,
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

  testWidgets('showHandle: true desenha a grabber no card estático', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(const AppBottomSheet(showHandle: true, child: Text('X'))),
    );
    expect(_handleOpacity(tester).opacity, 1);
  });

  testWidgets('showHandle default: grabber invisível (espaço reservado)', (
    tester,
  ) async {
    await tester.pumpWidget(_host(const AppBottomSheet(child: Text('X'))));
    expect(_handleOpacity(tester).opacity, 0);
  });

  testWidgets('showAppBottomSheet(showHandle) chega ao card estático', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        (BuildContext context) => Center(
          child: GestureDetector(
            onTap: () => showAppBottomSheet<void>(
              context: context,
              showHandle: true,
              child: const Text('CorpoSheet'),
            ),
            child: const Text('Abrir'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(_handleOpacity(tester).opacity, 1);
  });

  testWidgets('teclado: a sheet estática sobe pelo viewInsets', (tester) async {
    final TextEditingController controller = TextEditingController();
    addTearDown(controller.dispose);
    Widget build(EdgeInsets insets) => _appInsets(
      insets,
      (BuildContext context) => Center(
        child: GestureDetector(
          onTap: () => showAppBottomSheet<void>(
            context: context,
            child: AppInput(controller: controller, label: 'Campo'),
          ),
          child: const Text('Abrir'),
        ),
      ),
    );

    await tester.pumpWidget(build(EdgeInsets.zero));
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(AppInput)); // foca o campo
    await tester.pumpAndSettle();

    final double screenBottom = tester.getRect(find.byType(Navigator)).bottom;
    // Sem teclado, o campo mora na zona que o teclado vai cobrir.
    expect(tester.getRect(find.byType(AppInput)).bottom, greaterThan(300));

    await tester.pumpWidget(build(const EdgeInsets.only(bottom: 300)));
    await tester.pumpAndSettle();
    expect(
      tester.getRect(find.byType(AppInput)).bottom,
      lessThanOrEqualTo(screenBottom - 300),
    );
  });

  testWidgets('teclado: a sheet arrastável sobe e não pisca no ajuste', (
    tester,
  ) async {
    Widget build(EdgeInsets insets) => _appInsets(
      insets,
      (BuildContext context) => Center(
        child: GestureDetector(
          onTap: () => showAppBottomSheet<void>(
            context: context,
            draggable: true,
            title: 'Título',
            child: const SizedBox(height: 200, child: Text('CorpoSheet')),
          ),
          child: const Text('Abrir'),
        ),
      ),
    );

    await tester.pumpWidget(build(EdgeInsets.zero));
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.text('CorpoSheet'), findsOneWidget);

    await tester.pumpWidget(build(const EdgeInsets.only(bottom: 300)));
    // Um frame só: a sheet não pode sumir enquanto o engine se ajusta (o
    // teclado só muda a ALTURA disponível — não há re-medição).
    await tester.pump();
    expect(find.text('CorpoSheet'), findsOneWidget);

    await tester.pumpAndSettle();
    // O corpo rolável da sheet (o conteúdo pode rolar DENTRO dele; o rect de
    // um filho alto se estende clipado abaixo — por isso não se mede o texto).
    final double screenBottom = tester.getRect(find.byType(Navigator)).bottom;
    expect(
      tester.getRect(find.byType(CustomScrollView)).bottom,
      lessThanOrEqualTo(screenBottom - 300),
    );
  });

  testWidgets('teclado: a page também sobe pelo viewInsets', (tester) async {
    Widget build(EdgeInsets insets) => _appInsets(
      insets,
      (BuildContext context) => Center(
        child: GestureDetector(
          onTap: () => showAppBottomSheetPage<void>(
            context: context,
            title: 'Título',
            child: const SizedBox(height: 200, child: Text('CorpoPage')),
          ),
          child: const Text('Abrir'),
        ),
      ),
    );

    await tester.pumpWidget(build(EdgeInsets.zero));
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    await tester.pumpWidget(build(const EdgeInsets.only(bottom: 300)));
    await tester.pumpAndSettle();
    final double screenBottom = tester.getRect(find.byType(Navigator)).bottom;
    expect(
      tester.getRect(find.byType(CustomScrollView)).bottom,
      lessThanOrEqualTo(screenBottom - 300),
    );
  });

  testWidgets('teclado depois de um arraste NÃO fecha a sheet (re-assento)', (
    tester,
  ) async {
    Widget build(EdgeInsets insets) => _appInsets(
      insets,
      (BuildContext context) => Center(
        child: GestureDetector(
          onTap: () => showAppBottomSheet<void>(
            context: context,
            draggable: true,
            title: 'Título',
            child: const SizedBox(height: 200, child: Text('CorpoSheet')),
          ),
          child: const Text('Abrir'),
        ),
      ),
    );

    await tester.pumpWidget(build(EdgeInsets.zero));
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    // Qualquer arraste liga o hasDragged do DSS — que nunca desliga sozinho.
    await tester.drag(find.text('Título'), const Offset(0, -30));
    await tester.pumpAndSettle();
    expect(find.text('CorpoSheet'), findsOneWidget);

    // Teclado: a fração preservada cairia perto do snap 0 e a balística
    // FECHARIA a sheet sem gesto (o defeito). O re-assento segura no repouso.
    final double restHeight = tester
        .getSize(find.byType(CustomScrollView))
        .height;
    await tester.pumpWidget(build(const EdgeInsets.only(bottom: 300)));
    await tester.pumpAndSettle();
    expect(find.text('CorpoSheet'), findsOneWidget);
    final double screenBottom = tester.getRect(find.byType(Navigator)).bottom;
    expect(
      tester.getRect(find.byType(CustomScrollView)).bottom,
      lessThanOrEqualTo(screenBottom - 300),
    );

    // Teclado FECHA: a sheet volta ao content-fit — não fica presa numa
    // fração inflada (o jumpTo do re-assento apagou o hasDragged que o snap
    // do DSS exigiria para corrigir sozinho).
    await tester.pumpWidget(build(EdgeInsets.zero));
    await tester.pumpAndSettle();
    expect(
      tester.getSize(find.byType(CustomScrollView)).height,
      moreOrLessEquals(restHeight, epsilon: 1),
    );
  });

  testWidgets('arraste de fechar vence a animação do inset (não é roubado)', (
    tester,
  ) async {
    Widget build(EdgeInsets insets) => _appInsets(
      insets,
      animations: true,
      (BuildContext context) => Center(
        child: GestureDetector(
          onTap: () => showAppBottomSheet<void>(
            context: context,
            draggable: true,
            title: 'Título',
            child: const SizedBox(height: 200, child: Text('CorpoSheet')),
          ),
          child: const Text('Abrir'),
        ),
      ),
    );

    await tester.pumpWidget(build(const EdgeInsets.only(bottom: 300)));
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.text('CorpoSheet'), findsOneWidget);

    // O usuário arrasta para fechar e, com o dedo abaixo do repouso, o
    // teclado dispensa: o AnimatedPadding anima o avail por ~200ms. O
    // re-assento NÃO pode roubar o gesto (censo de ponteiros).
    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.text('Título')),
    );
    await gesture.moveBy(const Offset(0, 120));
    await tester.pump(const Duration(milliseconds: 32));
    await tester.pumpWidget(build(EdgeInsets.zero)); // teclado fecha
    for (int i = 0; i < 10; i++) {
      await gesture.moveBy(const Offset(0, 40));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await gesture.up();
    await tester.pumpAndSettle();
    expect(find.text('CorpoSheet'), findsNothing);
  });

  testWidgets('medição com teclado aberto não trava repouso subdimensionado', (
    tester,
  ) async {
    Widget build(EdgeInsets insets) => _appInsets(
      insets,
      (BuildContext context) => Center(
        child: GestureDetector(
          onTap: () => showAppBottomSheet<void>(
            context: context,
            draggable: true,
            title: 'Título',
            child: const SizedBox(height: 500, child: Text('CorpoSheet')),
          ),
          child: const Text('Abrir'),
        ),
      ),
    );

    // A sheet abre COM o teclado já aberto: a medição roda sob a altura
    // reduzida — mas mede a altura NATURAL (OverflowBox), não a capada.
    await tester.pumpWidget(build(const EdgeInsets.only(bottom: 300)));
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    // Teclado fecha: o repouso deve voltar ao contrato (teto de 0.65 da
    // altura cheia), não ficar preso na medição capada (0.5). O corpo rolável
    // é a sheet menos a margem inferior do card destacado (12).
    await tester.pumpWidget(build(EdgeInsets.zero));
    await tester.pumpAndSettle();
    final double avail = tester.getSize(find.byType(Navigator)).height;
    expect(
      tester.getSize(find.byType(CustomScrollView)).height,
      moreOrLessEquals(0.65 * avail - 12, epsilon: 1),
    );
  });

  testWidgets('fling de fechar em voo não é cancelado pelo teclado', (
    tester,
  ) async {
    Widget build(EdgeInsets insets) => _appInsets(
      insets,
      (BuildContext context) => Center(
        child: GestureDetector(
          onTap: () => showAppBottomSheet<void>(
            context: context,
            draggable: true,
            title: 'Título',
            child: const SizedBox(height: 200, child: Text('CorpoSheet')),
          ),
          child: const Text('Abrir'),
        ),
      ),
    );
    await tester.pumpWidget(build(const EdgeInsets.only(bottom: 300)));
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.text('CorpoSheet'), findsOneWidget);

    // Fling para baixo e, com a balística EM VOO (dedo já solto), o teclado
    // dispensa. A sheet estava FORA dos snaps antigos → o re-assento não age
    // e o fechamento termina.
    await tester.fling(find.text('Título'), const Offset(0, 400), 1200);
    await tester.pump();
    await tester.pumpWidget(build(EdgeInsets.zero));
    await tester.pumpAndSettle();
    expect(find.text('CorpoSheet'), findsNothing);
  });

  testWidgets('toque PARADO no ciclo do teclado não engole o re-assento', (
    tester,
  ) async {
    Widget build(EdgeInsets insets) => _appInsets(
      insets,
      (BuildContext context) => Center(
        child: GestureDetector(
          onTap: () => showAppBottomSheet<void>(
            context: context,
            draggable: true,
            title: 'Título',
            child: const SizedBox(height: 200, child: Text('CorpoSheet')),
          ),
          child: const Text('Abrir'),
        ),
      ),
    );
    await tester.pumpWidget(build(EdgeInsets.zero));
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.drag(find.text('Título'), const Offset(0, -30));
    await tester.pumpAndSettle();
    final double restHeight = tester
        .getSize(find.byType(CustomScrollView))
        .height;

    await tester.pumpWidget(build(const EdgeInsets.only(bottom: 300)));
    await tester.pumpAndSettle();

    // Dedo POUSADO (sem mover) enquanto o teclado fecha: o veto do censo não
    // pode DESCARTAR o re-assento — só adiá-lo para a soltura.
    final TestGesture press = await tester.startGesture(
      tester.getCenter(find.text('Título')),
    );
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pumpWidget(build(EdgeInsets.zero));
    await tester.pump(const Duration(milliseconds: 16));
    await press.up();
    await tester.pumpAndSettle();
    expect(
      tester.getSize(find.byType(CustomScrollView)).height,
      moreOrLessEquals(restHeight, epsilon: 1),
    );
  });

  testWidgets('pan de trackpad não é roubado pela mudança do teclado', (
    tester,
  ) async {
    Widget build(EdgeInsets insets) => _appInsets(
      insets,
      (BuildContext context) => Center(
        child: GestureDetector(
          onTap: () => showAppBottomSheet<void>(
            context: context,
            draggable: true,
            title: 'Título',
            child: const SizedBox(height: 200, child: Text('CorpoSheet')),
          ),
          child: const Text('Abrir'),
        ),
      ),
    );
    await tester.pumpWidget(build(EdgeInsets.zero));
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    // Trackpad arrasta por eventos de pan-zoom (não onPointerDown): o censo
    // precisa vê-los, senão o re-assento mata o gesto no meio.
    final Offset start = tester.getCenter(find.text('Título'));
    final TestGesture pan = await tester.createGesture(
      kind: PointerDeviceKind.trackpad,
    );
    await pan.panZoomStart(start);
    await pan.panZoomUpdate(start, pan: const Offset(0, 80));
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pumpWidget(build(const EdgeInsets.only(bottom: 300)));
    await tester.pump(const Duration(milliseconds: 16));
    for (int k = 2; k <= 8; k++) {
      await pan.panZoomUpdate(start, pan: Offset(0, 80.0 * k));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await pan.panZoomEnd();
    await tester.pumpAndSettle();
    expect(find.text('CorpoSheet'), findsNothing);
  });

  testWidgets('resize só de largura preserva o DSS (sem crash, sem reset)', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      _app(
        (BuildContext context) => Center(
          child: GestureDetector(
            onTap: () => showAppBottomSheet<void>(
              context: context,
              draggable: true,
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

    // Largura muda (rotação/resize de janela): a forma da árvore não pode
    // alternar — senão o State do DSS é descartado e o controller anexa em
    // dobro (assert em debug, corrupção em release).
    tester.view.physicalSize = const Size(2100, 1800); // 700×600 lógicos
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('CorpoSheet'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('CorpoSheet'), findsOneWidget);
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
