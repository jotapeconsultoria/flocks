import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: AppThemeData.light,
      child: SizedBox(width: 420, height: 400, child: child),
    ),
  ),
);

void main() {
  testWidgets('renderiza um item por evento', (WidgetTester tester) async {
    await tester.pumpWidget(
      _host(
        AppTimeline(
          itemCount: 3,
          itemBuilder: (BuildContext context, int i) => AppText('evento $i'),
        ),
      ),
    );
    for (int i = 0; i < 3; i++) {
      expect(find.text('evento $i'), findsOneWidget);
    }
  });

  // O rodapé vive DENTRO da rolagem, junto ao último item. Fora dela, um
  // "carregar mais" ficaria visível o tempo todo e seria clicado antes de a
  // pessoa chegar ao fim.
  testWidgets('o rodapé entra como último item da lista', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        AppTimeline(
          itemCount: 2,
          itemBuilder: (BuildContext context, int i) => AppText('evento $i'),
          footer: const AppText('carregar mais'),
        ),
      ),
    );
    expect(find.text('carregar mais'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('sem rodapé a lista tem só os eventos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        AppTimeline(
          itemCount: 2,
          itemBuilder: (BuildContext context, int i) => AppText('evento $i'),
        ),
      ),
    );
    final ListView lista = tester.widget<ListView>(find.byType(ListView));
    expect(lista.semanticChildCount, isNot(3));
  });

  testWidgets('markerBuilder substitui o marcador padrão', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        AppTimeline(
          itemCount: 2,
          itemBuilder: (BuildContext context, int i) => AppText('evento $i'),
          markerBuilder: (BuildContext context, int i) =>
              const SizedBox(width: 8, height: 8, child: AppText('!')),
        ),
      ),
    );
    // O marcador é decoração e sai da SEMÂNTICA, mas continua na árvore de
    // widgets: quem customiza precisa vê-lo renderizado.
    expect(find.text('!'), findsNWidgets(2));
  });
}
