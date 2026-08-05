import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(data: AppThemeData.light, child: child),
  ),
);

void main() {
  testWidgets('AppScaffold posiciona header, conteúdo e footer', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppScaffold(
          header: Text('Cabeçalho'),
          footer: Text('Rodapé'),
          child: Text('Corpo'),
        ),
      ),
    );
    expect(find.text('Cabeçalho'), findsOneWidget);
    expect(find.text('Corpo'), findsOneWidget);
    expect(find.text('Rodapé'), findsOneWidget);

    // Header acima do conteúdo, footer abaixo.
    final double headerY = tester.getTopLeft(find.text('Cabeçalho')).dy;
    final double bodyY = tester.getTopLeft(find.text('Corpo')).dy;
    final double footerY = tester.getTopLeft(find.text('Rodapé')).dy;
    expect(headerY, lessThan(bodyY));
    expect(bodyY, lessThan(footerY));
  });

  testWidgets('AppScaffold pinta o fundo com surface do tema', (tester) async {
    await tester.pumpWidget(_host(const AppScaffold(child: SizedBox())));
    final BoxDecoration d =
        tester
                .widget<DecoratedBox>(
                  find
                      .descendant(
                        of: find.byType(AppScaffold),
                        matching: find.byType(DecoratedBox),
                      )
                      .first,
                )
                .decoration
            as BoxDecoration;
    expect(d.color, AppThemeData.light.colorTheme.surface);
  });

  testWidgets('AppScaffold funciona sem header e sem footer', (tester) async {
    await tester.pumpWidget(_host(const AppScaffold(child: Text('Só corpo'))));
    expect(find.text('Só corpo'), findsOneWidget);
  });

  testWidgets('AppScaffold suaviza as bordas do conteúdo quando solicitado', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppScaffold(
          fadeFooter: true,
          fadeHeader: true,
          footer: Text('Rodapé'),
          header: Text('Cabeçalho'),
          child: Text('Corpo rolável'),
        ),
      ),
    );

    final gradients = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((box) => box.decoration)
        .whereType<BoxDecoration>()
        .where((decoration) => decoration.gradient is LinearGradient);
    expect(gradients, hasLength(2));
    final surfaceRgb =
        AppThemeData.light.colorTheme.surface.toARGB32() & 0x00FFFFFF;
    for (final decoration in gradients) {
      final gradient = decoration.gradient! as LinearGradient;
      for (final color in gradient.colors) {
        expect(color.toARGB32() & 0x00FFFFFF, surfaceRgb);
      }
    }
  });

  testWidgets('AppScaffold não cria fade para slots ausentes', (tester) async {
    await tester.pumpWidget(
      _host(
        const AppScaffold(
          fadeFooter: true,
          fadeHeader: true,
          child: Text('Corpo sem slots'),
        ),
      ),
    );

    final gradients = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((box) => box.decoration)
        .whereType<BoxDecoration>()
        .where((decoration) => decoration.gradient is LinearGradient);
    expect(gradients, isEmpty);
  });

  testWidgets('AppScaffold renderiza o floatingAction no canto inferior', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppScaffold(floatingAction: Text('FAB'), child: Text('Corpo')),
      ),
    );
    expect(find.text('FAB'), findsOneWidget);

    // Alinhado ao canto inferior-direito (bottomEnd, LTR): abaixo e à direita
    // do centro da área de conteúdo.
    final Rect scaffold = tester.getRect(find.byType(AppScaffold));
    final Offset fab = tester.getCenter(find.text('FAB'));
    expect(fab.dy, greaterThan(scaffold.center.dy));
    expect(fab.dx, greaterThan(scaffold.center.dx));
  });

  testWidgets('AppScaffold sem floatingAction não cria o slot', (tester) async {
    await tester.pumpWidget(_host(const AppScaffold(child: Text('Corpo'))));
    expect(find.text('FAB'), findsNothing);
  });

  // Contrato do eixo glass: a barra sobrepõe o conteúdo e a reserva vai por
  // MediaQuery.padding, NÃO por um Padding externo. Um Padding encolheria o
  // viewport e o conteúdo nunca passaria por baixo da barra — sem isso o vidro
  // desfoca só o fundo chapado da página e a barra lê como um véu opaco.
  group('barra glass sobreposta', () {
    const double kTopInset = 44;

    Widget hostWithHeader(ScrollController controller) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(
          padding: EdgeInsets.only(top: kTopInset),
          viewPadding: EdgeInsets.only(top: kTopInset),
        ),
        child: AppTheme(
          data: AppThemeData.light,
          child: AppScaffold(
            contentUnderBars: true,
            header: const AppPrimaryHeader(glass: true, child: Text('Título')),
            child: ListView(
              controller: controller,
              children: <Widget>[
                for (int i = 0; i < 20; i++)
                  SizedBox(key: ValueKey<int>(i), height: 60),
              ],
            ),
          ),
        ),
      ),
    );

    testWidgets('o viewport rolável cobre a barra (não é recortado nela)', (
      tester,
    ) async {
      await tester.pumpWidget(hostWithHeader(ScrollController()));
      final Rect header = tester.getRect(find.byType(AppPrimaryHeader));
      final Rect viewport = tester.getRect(find.byType(Viewport).first);
      expect(viewport.top, lessThanOrEqualTo(header.top));
      expect(viewport.height, greaterThan(header.height));
    });

    testWidgets('em repouso o 1º item nasce ABAIXO da barra (reserva)', (
      tester,
    ) async {
      await tester.pumpWidget(hostWithHeader(ScrollController()));
      final Rect header = tester.getRect(find.byType(AppPrimaryHeader));
      final Rect first = tester.getRect(find.byKey(const ValueKey<int>(0)));
      expect(first.top, header.bottom);
    });

    testWidgets('ao rolar, o conteúdo passa POR BAIXO da barra', (
      tester,
    ) async {
      final ScrollController controller = ScrollController();
      await tester.pumpWidget(hostWithHeader(controller));
      final Rect header = tester.getRect(find.byType(AppPrimaryHeader));
      controller.jumpTo(200);
      await tester.pump();
      // Um item que estaria fora de vista agora está sob a barra — é o que o
      // BackdropFilter precisa ter para desfocar.
      final Rect item = tester.getRect(find.byKey(const ValueKey<int>(3)));
      expect(item.top, lessThan(header.bottom));
    });

    testWidgets('default (contentUnderBars: false) recua o viewport', (
      tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(
              padding: EdgeInsets.only(top: kTopInset),
              viewPadding: EdgeInsets.only(top: kTopInset),
            ),
            child: AppTheme(
              data: AppThemeData.light,
              child: AppScaffold(
                header: const AppPrimaryHeader(
                  glass: true,
                  child: Text('Título'),
                ),
                child: ListView(
                  children: <Widget>[
                    for (int i = 0; i < 20; i++)
                      SizedBox(key: ValueKey<int>(i), height: 60),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      // Sem opt-in, o conteúdo continua recortado na aresta da barra — é o
      // comportamento que as páginas ainda não migradas dependem.
      final Rect header = tester.getRect(find.byType(AppPrimaryHeader));
      final Rect viewport = tester.getRect(find.byType(Viewport).first);
      expect(viewport.top, header.bottom);
    });

    testWidgets('barra NÃO-glass segue no fluxo em coluna (sem sobreposição)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppScaffold(
            header: AppPrimaryHeader(glass: false, child: Text('Título')),
            child: Text('Corpo'),
          ),
        ),
      );
      final Rect header = tester.getRect(find.byType(AppPrimaryHeader));
      expect(
        tester.getTopLeft(find.text('Corpo')).dy,
        greaterThanOrEqualTo(header.bottom),
      );
    });
  });

  test('AppScaffold está no catálogo como migrated', () {
    expect(
      flocksCatalog.any(
        (AppComponentMeta m) =>
            m.id == 'app_scaffold' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
