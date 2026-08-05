import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: AppThemeData.light,
      child: Center(child: child),
    ),
  ),
);

void main() {
  testWidgets('mostra campo e valor', (WidgetTester tester) async {
    await tester.pumpWidget(
      _host(const AppFilterChip(field: 'Tipo', value: 'client.created')),
    );
    expect(find.text('Tipo: '), findsOneWidget);
    expect(find.text('client.created'), findsOneWidget);
  });

  testWidgets('sem campo mostra só o valor', (WidgetTester tester) async {
    await tester.pumpWidget(_host(const AppFilterChip(value: 'só o valor')));
    expect(find.text('só o valor'), findsOneWidget);
    expect(find.textContaining(': '), findsNothing);
  });

  // Os dois alvos são o ponto do componente: remover e editar são ações
  // diferentes, e um alvo só faria uma delas acontecer por engano toda vez.
  testWidgets('remover e abrir são alvos SEPARADOS', (
    WidgetTester tester,
  ) async {
    int removeu = 0;
    int abriu = 0;
    await tester.pumpWidget(
      _host(
        AppFilterChip(
          field: 'Tipo',
          value: 'client.created',
          onRemove: () => removeu++,
          onTap: () => abriu++,
        ),
      ),
    );

    await tester.tap(
      find.bySemanticsLabel('Remover filtro Tipo: client.created'),
    );
    await tester.pump();
    expect(removeu, 1, reason: 'o "×" não removeu');
    expect(abriu, 0, reason: 'remover disparou também a abertura do filtro');

    await tester.tap(find.bySemanticsLabel('Tipo: client.created'));
    await tester.pump();
    expect(abriu, 1);
    expect(removeu, 1, reason: 'abrir o filtro removeu-o');
  });

  testWidgets('sem onRemove não existe o "×"', (WidgetTester tester) async {
    await tester.pumpWidget(
      _host(const AppFilterChip(field: 'Tipo', value: 'client.created')),
    );
    expect(
      find.bySemanticsLabel('Remover filtro Tipo: client.created'),
      findsNothing,
      reason:
          'um "×" sem callback é um botão que não faz nada — pior que a '
          'ausência dele',
    );
  });
}
