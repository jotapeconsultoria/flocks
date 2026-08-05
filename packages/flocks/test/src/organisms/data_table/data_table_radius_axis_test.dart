import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Regra 9 — o eixo de forma alcança os cantos das tabelas.
///
/// Era a queixa concreta: as tabelas traziam o raio numa const (`AppRadius.l`),
/// então uma marca configurada em `reto` continuava com os cantos curvos e uma
/// em `circular` não mudava nada. O teste de arquitetura
/// (`radius_axis_test.dart`) garante que a const não volta; este garante que a
/// leitura do eixo produz o efeito.
Widget _host(Widget child, {required AppRadiusMode mode}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(size: Size(1024, 768)),
    child: AppTheme(
      data: AppThemeData.light.copyWith(
        radiusTheme: AppRadiusTheme(mode: mode),
      ),
      child: Center(child: SizedBox(width: 600, child: child)),
    ),
  ),
);

/// Todos os raios de canto encontrados nas decorações das linhas da tabela.
Set<double> _cornerRadii(WidgetTester tester) {
  final Set<double> out = <double>{};
  for (final Table table in tester.widgetList<Table>(find.byType(Table))) {
    for (final TableRow row in table.children) {
      final Decoration? d = row.decoration;
      if (d is! BoxDecoration) continue;
      final BorderRadiusGeometry? r = d.borderRadius;
      if (r is! BorderRadius) continue;
      out.addAll(<double>[
        r.topLeft.x,
        r.topRight.x,
        r.bottomLeft.x,
        r.bottomRight.x,
      ]);
    }
  }
  return out;
}

Widget _table() => const AppSimpleDataTable(
  columnLabels: <String>['Placa', 'Motorista'],
  rows: <List<Widget>>[
    <Widget>[AppText('ABC1D23'), AppText('Ana')],
    <Widget>[AppText('XYZ9W87'), AppText('Bruno')],
  ],
);

void main() {
  testWidgets('marca `reto` esquadreja os cantos da tabela', (tester) async {
    await tester.pumpWidget(_host(_table(), mode: AppRadiusMode.reto));
    // Só zeros: nem o topo do cabeçalho nem a base da última linha sobram
    // curvos enquanto o resto da tela é reto.
    expect(_cornerRadii(tester), <double>{0});
  });

  testWidgets('marca `redondo` arredonda no raio do design system', (
    tester,
  ) async {
    await tester.pumpWidget(_host(_table(), mode: AppRadiusMode.redondo));
    // Sem tamanho conhecido o container pousa no teto — o mesmo número em que
    // pousam os demais containers do DS (AppCard, shell, bloco de código).
    expect(_cornerRadii(tester), contains(kRedondoCap));
  });

  testWidgets('os dois modos produzem cantos diferentes', (tester) async {
    // A trava contra o remédio virar decoração: se `reto` e `redondo` derem o
    // mesmo raio, alguém religou a const sem o teste de arquitetura notar
    // (ex.: `resolve(override: ...)` fixo).
    await tester.pumpWidget(_host(_table(), mode: AppRadiusMode.reto));
    final Set<double> reto = _cornerRadii(tester);

    await tester.pumpWidget(_host(_table(), mode: AppRadiusMode.redondo));
    final Set<double> redondo = _cornerRadii(tester);

    expect(reto, isNot(equals(redondo)));
  });
}
