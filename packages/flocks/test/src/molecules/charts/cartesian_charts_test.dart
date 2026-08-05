import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flocks/flocks.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Os cartesianos, o medidor e a moldura, recém-chegados do
/// `tracked_shared_pkg`. Além de provar que renderizam, os testes travam as
/// três coisas que a migração CONSERTOU — a moldura branca no tema escuro, o
/// canto preso a uma const e a legenda alcançável só por mouse.

const List<AppCartesianChartPoint> _points = <AppCartesianChartPoint>[
  AppCartesianChartPoint(x: 0, y: 12),
  AppCartesianChartPoint(x: 1, y: 18),
  AppCartesianChartPoint(x: 2, y: 9),
];

const List<AppCartesianChartSeries> _series = <AppCartesianChartSeries>[
  AppCartesianChartSeries(id: 'a', label: 'Frota A', points: _points),
];

const List<String> _labels = <String>['Jan', 'Fev', 'Mar'];

const List<AppBarChartSeries> _bars = <AppBarChartSeries>[
  AppBarChartSeries(id: 'a', label: 'Frota A', values: <double>[10, 14, 12]),
];

const List<AppBubbleChartNode> _nodes = <AppBubbleChartNode>[
  AppBubbleChartNode(label: 'Norte', value: 40),
  AppBubbleChartNode(label: 'Sul', value: 25),
];

const List<AppGaugeChartSegment> _gauge = <AppGaugeChartSegment>[
  AppGaugeChartSegment(label: 'Usado', value: 72),
  AppGaugeChartSegment(label: 'Livre', value: 28),
];

Widget _host(
  Widget child, {
  bool dark = false,
  AppRadiusMode radiusMode = AppRadiusMode.padrao,
  AppStyle style = AppStyle.filled,
}) {
  final AppThemeData base = dark ? AppThemeData.dark : AppThemeData.light;
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(size: Size(800, 600)),
      child: AppTheme(
        data: base.copyWith(
          radiusTheme: AppRadiusTheme(mode: radiusMode),
          styleTheme: AppStyleTheme(style: style),
        ),
        child: Center(child: SizedBox(width: 360, height: 420, child: child)),
      ),
    ),
  );
}

void main() {
  group('renderiza', () {
    testWidgets('AppLineChart', (tester) async {
      await tester.pumpWidget(_host(const AppLineChart(series: _series)));
      expect(find.byType(AppLineChart), findsOneWidget);
    });

    testWidgets('AppAreaChart', (tester) async {
      await tester.pumpWidget(_host(const AppAreaChart(series: _series)));
      expect(find.byType(AppAreaChart), findsOneWidget);
    });

    testWidgets('AppBarChart', (tester) async {
      await tester.pumpWidget(
        _host(AppBarChart(labels: _labels, series: _bars)),
      );
      expect(find.byType(AppBarChart), findsOneWidget);
    });

    testWidgets('AppBubbleChart', (tester) async {
      await tester.pumpWidget(_host(AppBubbleChart(nodes: _nodes)));
      expect(find.byType(AppBubbleChart), findsOneWidget);
    });

    testWidgets('AppGaugeChart', (tester) async {
      await tester.pumpWidget(_host(AppGaugeChart(segments: _gauge)));
      expect(find.byType(AppGaugeChart), findsOneWidget);
    });
  });

  group('AppChartShell · a moldura', () {
    /// A decoração da caixa externa do shell.
    BoxDecoration deco(WidgetTester tester) => tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((DecoratedBox d) => d.decoration)
        .whereType<BoxDecoration>()
        .first;

    testWidgets('no tema escuro a superfície NÃO é branca', (tester) async {
      // O bug que veio junto na bagagem: a moldura pintava `neutralWhite`, que
      // é branco puro nos DOIS brilhos — um cartão branco no meio da tela
      // escura. Este é o teste que não existia no shared.
      await tester.pumpWidget(
        _host(
          const AppChartShell(
            chartConstraints: BoxConstraints.tightFor(height: 80),
            title: 'Consumo',
            child: SizedBox(),
          ),
          dark: true,
        ),
      );
      final Color? fill = deco(tester).color;
      expect(fill, isNotNull);
      expect(
        fill,
        AppThemeData.dark.colorTheme.surfaceContainer,
        reason: 'a moldura segue a superfície do tema, não o papel "branco"',
      );
      expect(fill, isNot(const Color(0xFFFFFFFF)));
    });

    testWidgets('a marca em `reto` esquadreja a moldura', (tester) async {
      await tester.pumpWidget(
        _host(
          const AppChartShell(
            chartConstraints: BoxConstraints.tightFor(height: 80),
            child: SizedBox(),
          ),
          radiusMode: AppRadiusMode.reto,
        ),
      );
      final BorderRadius r = deco(tester).borderRadius! as BorderRadius;
      expect(r.topLeft.x, 0);
    });

    testWidgets('a marca em `outlined` dá borda à moldura', (tester) async {
      await tester.pumpWidget(
        _host(
          const AppChartShell(
            chartConstraints: BoxConstraints.tightFor(height: 80),
            child: SizedBox(),
          ),
          style: AppStyle.outlined,
        ),
      );
      expect(deco(tester).border, isNotNull);
      expect(deco(tester).boxShadow, isNull);
    });

    testWidgets('mostra o vazio em português', (tester) async {
      await tester.pumpWidget(
        _host(
          const AppChartShell(
            chartConstraints: BoxConstraints.tightFor(height: 80),
            isEmpty: true,
            child: SizedBox(),
          ),
        ),
      );
      expect(find.text('Sem dados'), findsOneWidget);
    });

    testWidgets('o item de legenda é um toggle alcançável por teclado', (
      tester,
    ) async {
      // Era `GestureDetector` cru com `Semantics` à mão: alternava a série só
      // por mouse e chegava ao leitor sem estado.
      final SemanticsHandle handle = tester.ensureSemantics();
      final List<String> tapped = <String>[];
      await tester.pumpWidget(
        _host(
          AppChartShell(
            chartConstraints: const BoxConstraints.tightFor(height: 80),
            legendItems: const <AppChartLegendItem>[
              AppChartLegendItem(color: Color(0xFF00FF00), label: 'Frota A'),
            ],
            onLegendTap: (AppChartLegendItem item) => tapped.add(item.label),
            child: const SizedBox(),
          ),
        ),
      );

      expect(find.byType(FlocksInteraction), findsOneWidget);
      expect(find.bySemanticsLabel('Frota A'), findsWidgets);

      await tester.tap(find.byType(FlocksInteraction));
      expect(tapped, <String>['Frota A']);

      handle.dispose();
    });
  });

  group('AppBarChart · o canto obedece à marca', () {
    /// Renderiza e devolve os bytes crus da cena.
    Future<Uint8List> pixels(WidgetTester tester, Widget scene) async {
      await tester.pumpWidget(scene);
      await tester.pumpAndSettle();
      final RenderRepaintBoundary boundary =
          tester.renderObject(find.byKey(const Key('cena')))
              as RenderRepaintBoundary;
      late Uint8List bytes;
      await tester.runAsync(() async {
        final ui.Image image = await boundary.toImage();
        final ByteData? data = await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        );
        bytes = data!.buffer.asUint8List();
        image.dispose();
      });
      return bytes;
    }

    testWidgets('`reto` e `redondo` desenham barras diferentes', (
      tester,
    ) async {
      // A barra é pintada em Canvas, não é um DecoratedBox: o raio não existe
      // na árvore de widgets. A única prova de que o eixo chega até a ponta da
      // barra é o pixel. Antes o canto vinha de `AppRadius.l` fixo e uma marca
      // `reto` não o alcançava — as duas cenas sairiam idênticas.
      Widget scene(AppRadiusMode mode) => _host(
        RepaintBoundary(
          key: const Key('cena'),
          child: AppBarChart(labels: _labels, series: _bars, showGrid: false),
        ),
        radiusMode: mode,
      );

      final Uint8List reto = await pixels(tester, scene(AppRadiusMode.reto));
      final Uint8List redondo = await pixels(
        tester,
        scene(AppRadiusMode.redondo),
      );

      expect(reto.length, redondo.length);
      expect(
        reto,
        isNot(equals(redondo)),
        reason: 'a marca `reto` tem de esquadrejar a ponta da barra',
      );
    });
  });
}
