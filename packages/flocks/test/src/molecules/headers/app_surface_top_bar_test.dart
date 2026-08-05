import 'package:flocks/flocks.dart';
// Peça interna (não exportada no baril): a barra de topo compartilhada pelas
// três superfícies flutuantes — dialog, bottom sheet e side sheet.
import 'package:flocks/src/molecules/headers/app_surface_top_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child, {TextDirection dir = TextDirection.ltr}) =>
    Directionality(
      textDirection: dir,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: AppTheme(
          data: AppThemeData.light,
          child: Center(child: SizedBox(width: 400, child: child)),
        ),
      ),
    );

void main() {
  test('altura da barra é o token', () {
    expect(kAppSurfaceTopBarHeight, 64.0);
  });

  testWidgets('altura fixa, com ou sem título', (tester) async {
    for (final String? title in <String?>[null, 'T']) {
      await tester.pumpWidget(_host(AppSurfaceTopBar(title: title)));
      expect(
        tester.getSize(find.byType(AppSurfaceTopBar)).height,
        kAppSurfaceTopBarHeight,
      );
    }
  });

  // O contrato das sheets: a reserva de 44px dos DOIS lados existe justamente
  // para o título não se deslocar quando o "X" troca de canto. Se alguém trocar
  // a reserva simétrica por uma condicional, os goldens das sheets mudam — e
  // este teste acusa antes disso.
  testWidgets('centralizado: o título não se mexe quando o "X" troca de lado', (
    tester,
  ) async {
    final List<double> centros = <double>[];
    for (final AppSheetCloseSide side in AppSheetCloseSide.values) {
      await tester.pumpWidget(
        _host(AppSurfaceTopBar(title: 'Título', closeSide: side)),
      );
      centros.add(tester.getCenter(find.text('Título')).dx);
    }
    expect(centros.first, centros.last);
  });

  testWidgets('alinhado ao início: o título encosta no inset da barra', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppSurfaceTopBar(
          title: 'Título',
          titleAlign: AppSurfaceTopBarTitleAlign.start,
        ),
      ),
    );
    final double barLeft = tester.getTopLeft(find.byType(AppSurfaceTopBar)).dx;
    expect(
      tester.getTopLeft(find.text('Título')).dx - barLeft,
      kAppSurfaceTopBarCloseInset,
    );
  });

  // A handle some por opacidade, não por remoção: mostrar/esconder não pode
  // deslocar nem o título nem o botão.
  testWidgets('a handle não desloca título nem botão', (tester) async {
    final List<Offset> titulos = <Offset>[];
    final List<Offset> botoes = <Offset>[];
    for (final bool handle in <bool>[false, true]) {
      await tester.pumpWidget(
        _host(AppSurfaceTopBar(title: 'T', showHandle: handle)),
      );
      titulos.add(tester.getCenter(find.text('T')));
      botoes.add(tester.getCenter(find.bySemanticsLabel('Fechar')));
    }
    expect(titulos.first, titulos.last);
    expect(botoes.first, botoes.last);
  });

  testWidgets('o título é anunciado como cabeçalho', (tester) async {
    await tester.pumpWidget(_host(const AppSurfaceTopBar(title: 'T')));
    expect(
      tester.getSemantics(find.text('T')).flagsCollection.isHeader,
      isTrue,
    );
  });

  testWidgets('closeClearance afasta só o "X", não a barra', (tester) async {
    final List<double> xs = <double>[];
    for (final double clearance in <double>[0, 24]) {
      await tester.pumpWidget(
        _host(AppSurfaceTopBar(closeClearance: clearance)),
      );
      xs.add(tester.getCenter(find.bySemanticsLabel('Fechar')).dx);
    }
    expect(xs.first - xs.last, 24);
  });
}
