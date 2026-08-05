import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(size: Size(900, 700)),
    child: AppTheme(data: AppThemeData.light, child: child),
  ),
);

const List<String> _cols = <String>['Placa', 'Modelo'];
List<List<Widget>> _rows() => const <List<Widget>>[
  <Widget>[AppText('ABC-1234'), AppText('GV75')],
  <Widget>[AppText('XYZ-9876'), AppText('GV55')],
];

void main() {
  _contrastGroup();
  _explicitWidthGroup();
  testWidgets('AppSimpleDataTable mostra colunas e linhas', (tester) async {
    await tester.pumpWidget(
      _host(AppSimpleDataTable(columnLabels: _cols, rows: _rows())),
    );
    expect(find.text('Placa'), findsOneWidget);
    expect(find.text('ABC-1234'), findsOneWidget);
    expect(find.text('GV55'), findsOneWidget);
  });

  testWidgets('AppDataTable mostra header, linhas e dispara sort', (
    tester,
  ) async {
    int? sortedColumn;
    await tester.pumpWidget(
      _host(
        AppDataTable(
          columnLabels: _cols,
          rows: _rows(),
          page: 1,
          perPage: 16,
          total: 2,
          totalPages: 1,
          columnSortOrders: const <AppDataTableSortOrder>[
            AppDataTableSortOrder.none,
            AppDataTableSortOrder.none,
          ],
          onColumnSortTap: (int i) => sortedColumn = i,
          onPageChange: (_) {},
          onPerPageChange: (_) {},
        ),
      ),
    );
    expect(find.text('Placa'), findsOneWidget);
    expect(find.text('ABC-1234'), findsOneWidget);

    await tester.tap(find.text('Placa'));
    await tester.pump();
    expect(sortedColumn, 0);
  });

  testWidgets('AppDataTable não importa Material (sem MaterialLocalizations)', (
    tester,
  ) async {
    // Renderiza sob WidgetsApp-free host; se dependesse de Material/Tooltip do
    // Material, quebraria por falta de MaterialLocalizations.
    await tester.pumpWidget(
      _host(AppSimpleDataTable(columnLabels: _cols, rows: _rows())),
    );
    expect(tester.takeException(), isNull);
  });

  test('AppDataTable(+Simple) no catálogo como migrated', () {
    for (final String id in <String>[
      'app_data_table',
      'app_simple_data_table',
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

/// Contraste dos elementos que a tabela resolve sozinha, por marca e tema.
///
/// A tabela é a única superfície do app que mistura DUAS bases: header e
/// paginação usam `surface`, as linhas usam `surfaceContainer`. Um stop fixo
/// serve a uma e falha na outra — foi assim que o chevron desabilitado ficou em
/// 1.67 e os totais em 3.74 no escuro.
void _contrastGroup() {
  group('AppDataTable — contraste sobre as duas bases', () {
    for (final brand in const <AppBrandConfig>[jotapeBrand, zxtrackBrand]) {
      for (final dark in [false, true]) {
        test('${brand.clientSlug}/${dark ? "escuro" : "claro"}', () {
          final colors = dark
              ? brand.toDarkColorTheme()
              : brand.toLightColorTheme();
          final bar = colors.surface;
          final rows = colors.surfaceContainer;

          // Texto do header e das linhas, cada um sobre a SUA base.
          expect(
            contrastRatio(colors.onSurface, bar),
            greaterThanOrEqualTo(kAaNormal),
          );
          expect(
            contrastRatio(colors.onSurface, rows),
            greaterThanOrEqualTo(kAaNormal),
          );
          // Divisória entre linhas.
          expect(
            contrastRatio(colors.divider, rows),
            greaterThanOrEqualTo(kUi),
          );

          // Acentos da paginação, sobre a barra.
          final accent = readableStopOn(
            colors.tertiary,
            bar,
            minRatio: kAaNormal,
          );
          expect(contrastRatio(accent, bar), greaterThanOrEqualTo(kAaNormal));

          // Chevron desabilitado: isento da WCAG, mas com piso próprio do DS —
          // tem de ser perceptível E distinguível do habilitado.
          final muted = mutedForDisabled(accent, bar);
          expect(
            contrastRatio(muted, bar),
            greaterThanOrEqualTo(kDisabledMinRatio),
          );
          expect(
            toneDelta(muted, accent),
            greaterThanOrEqualTo(kDisabledDistinctionTone),
          );

          // Tamanho de página escolhido x não escolhido. A cor sozinha não
          // basta: em marcas onde `secondary` e `tertiary` resolvem para o
          // MESMO stop (a zxtrack), os dois ficariam idênticos e não daria
          // para saber qual página está ativa.
          final active = readableStopOn(
            colors.secondary,
            bar,
            minRatio: kAaNormal,
          );
          final idle = readableStopOn(
            colors.neutralPrimary,
            bar,
            minRatio: kAaNormal,
          );
          expect(contrastRatio(idle, bar), greaterThanOrEqualTo(kAaNormal));
          expect(active, isNot(idle));

          // Totais: ficam FORA da barra, sobre o cartão.
          final totals = readableStopOn(
            colors.neutralPrimary,
            rows,
            minRatio: kAaNormal,
          );
          expect(contrastRatio(totals, rows), greaterThanOrEqualTo(kAaNormal));
        });
      }
    }
  });
}

/// Largura explícita: cabeçalho reordenável, corpo alinhado, última coluna
/// absorvendo a sobra.
void _explicitWidthGroup() {
  Widget host(Widget child) => WidgetsApp(
    color: const Color(0xFF000000),
    // `onGenerateRoute` e não `builder`: o ReorderableList precisa do Overlay,
    // e ele só existe com Navigator.
    onGenerateRoute: (RouteSettings settings) => PageRouteBuilder<void>(
      settings: settings,
      pageBuilder: (BuildContext context, _, _) => AppTheme(
        data: AppThemeData.light,
        child: Directionality(textDirection: TextDirection.ltr, child: child),
      ),
    ),
  );

  Widget table({
    required List<double> widths,
    void Function(int, int)? onReorder,
    void Function(int, double)? onResize,
  }) => AppDataTable(
    columnLabels: const ['A', 'B', 'C'],
    columnWidths: widths,
    onColumnReorder: onReorder,
    onColumnResize: onResize,
    rows: const [
      [Text('a1'), Text('b1'), Text('c1')],
    ],
    page: 1,
    perPage: 12,
    total: 1,
    totalPages: 1,
    onPageChange: _noop,
    onPerPageChange: _noop,
  );

  group('AppDataTable — largura explícita', () {
    testWidgets('a última coluna absorve a sobra', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(host(table(widths: const [200, 200, 200])));
      await tester.pumpAndSettle();

      final a = tester.getSize(find.byKey(const ValueKey<String>('A')));
      final c = tester.getSize(find.byKey(const ValueKey<String>('C')));

      // As outras respeitam o que foi pedido; só a última estica — deixar
      // espaço vazio à direita chamaria mais atenção que a coluna larga.
      expect(a.width, 200);
      expect(c.width, greaterThan(200));
    });

    testWidgets('sem sobra, ninguém estica', (tester) async {
      // 800 de viewport para 900 de colunas: há transbordo, não sobra.
      await tester.binding.setSurfaceSize(const Size(800, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(host(table(widths: const [300, 300, 300])));
      await tester.pumpAndSettle();

      final c = tester.getSize(find.byKey(const ValueKey<String>('C')));
      expect(c.width, 300);
    });

    testWidgets('sem onColumnReorder não há arraste no cabeçalho', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1000, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(host(table(widths: const [200, 200, 200])));
      await tester.pumpAndSettle();

      expect(find.byType(ReorderableDragStartListener), findsNothing);
    });

    testWidgets('arrastar a divisória redimensiona a coluna', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final resizes = <(int, double)>[];
      await tester.pumpWidget(
        host(
          table(
            widths: const [200, 200, 200],
            onReorder: (_, _) {},
            onResize: (index, delta) => resizes.add((index, delta)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // A alça vive na borda direita da célula, POR CIMA da área que reordena.
      final header = tester.getRect(find.byKey(const ValueKey<String>('A')));
      final gesture = await tester.startGesture(
        Offset(header.right - 2, header.center.dy),
      );
      await gesture.moveBy(const Offset(40, 0));
      await gesture.up();
      await tester.pumpAndSettle();

      expect(resizes, isNotEmpty);
      expect(resizes.first.$1, 0);
      expect(resizes.map((r) => r.$2).reduce((a, b) => a + b), closeTo(40, 1));
    });

    testWidgets('o cursor de redimensionar sobrevive ao arraste', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1000, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        host(
          table(
            widths: const [200, 200, 200],
            onReorder: (_, _) {},
            onResize: (_, _) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      MouseCursor tableCursor() => tester
          .widgetList<MouseRegion>(
            find.descendant(
              of: find.byType(AppDataTable),
              matching: find.byType(MouseRegion),
            ),
          )
          .first
          .cursor;

      expect(tableCursor(), MouseCursor.defer);

      final header = tester.getRect(find.byKey(const ValueKey<String>('A')));
      final gesture = await tester.startGesture(
        Offset(header.right - 2, header.center.dy),
      );
      // Move MUITO além da alça: é justamente aqui que o cursor voltaria ao
      // normal se dependesse só do MouseRegion de 8px.
      await gesture.moveBy(const Offset(300, 0));
      await tester.pump();

      expect(tableCursor(), SystemMouseCursors.resizeColumn);

      await gesture.up();
      await tester.pumpAndSettle();
      expect(tableCursor(), MouseCursor.defer);
    });

    testWidgets('com onColumnReorder cada coluna vira alça de arraste', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1000, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        host(table(widths: const [200, 200, 200], onReorder: (_, _) {})),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ReorderableDragStartListener), findsNWidgets(3));
    });
  });
}

void _noop(int _) {}
