import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(size: Size(800, 600)),
    child: AppTheme(
      data: AppThemeData.light,
      child: Align(alignment: Alignment.topLeft, child: child),
    ),
  ),
);

String _rendered(WidgetTester tester) => tester
    .widgetList<Text>(find.byType(Text))
    .map((Text t) => t.data ?? t.textSpan?.toPlainText() ?? '')
    .join('\n');

/// Spans com recognizer (ou seja, links realmente clicáveis) da árvore.
Iterable<TextSpan> _linkSpans(WidgetTester tester) sync* {
  for (final Text text in tester.widgetList<Text>(find.byType(Text))) {
    final InlineSpan? span = text.textSpan;
    if (span == null) {
      continue;
    }
    final List<TextSpan> found = <TextSpan>[];
    span.visitChildren((InlineSpan child) {
      if (child is TextSpan && child.recognizer != null) {
        found.add(child);
      }
      return true;
    });
    yield* found;
  }
}

void main() {
  group('AppHtml · estrutura', () {
    testWidgets('renderiza headings, parágrafos e ênfase', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppHtml(
            data: '<h1>Termos</h1><p>Leia com <strong>atenção</strong>.</p>',
          ),
        ),
      );

      final String text = _rendered(tester);
      expect(text, contains('Termos'));
      expect(text, contains('Leia com'));
      expect(text, contains('atenção'));
    });

    testWidgets('aceita documento completo, não só fragmento', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppHtml(
            data:
                '<!DOCTYPE html><html><head><title>x</title></head>'
                '<body><p>Conteúdo legal</p></body></html>',
          ),
        ),
      );

      final String text = _rendered(tester);
      expect(text, contains('Conteúdo legal'));
      // O <title> vive no <head> e não é conteúdo visível.
      expect(text, isNot(contains('x')));
    });

    testWidgets('containers aninhados não alteram o resultado', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppHtml(
            data:
                '<div><section><article><div>'
                '<p>Texto profundo</p>'
                '</div></article></section></div>',
          ),
        ),
      );

      expect(_rendered(tester), contains('Texto profundo'));
    });

    testWidgets('listas e citações são renderizadas', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppHtml(
            data:
                '<ul><li>Um</li><li>Dois</li></ul>'
                '<blockquote>Aviso importante</blockquote>',
          ),
        ),
      );

      final String text = _rendered(tester);
      expect(text, contains('Um'));
      expect(text, contains('Dois'));
      expect(text, contains('•'));
      expect(text, contains('Aviso importante'));
    });

    testWidgets('entidades HTML são decodificadas', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(const AppHtml(data: '<p>Tucker &amp; Cia &mdash; 10&deg;</p>')),
      );

      final String text = _rendered(tester);
      expect(text, contains('Tucker & Cia'));
      expect(text, contains('—'));
      expect(text, isNot(contains('&amp;')));
    });
  });

  group('AppHtml · tabelas', () {
    testWidgets('tabela com thead usa o cabeçalho declarado', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppHtml(
            data:
                '<table><thead><tr><th>Placa</th><th>Modelo</th></tr></thead>'
                '<tbody><tr><td>ABC-1234</td><td>GV75</td></tr></tbody></table>',
          ),
        ),
      );

      expect(find.byType(AppSimpleDataTable), findsOneWidget);
      final String text = _rendered(tester);
      expect(text, contains('Placa'));
      expect(text, contains('ABC-1234'));
    });

    testWidgets('tabela sem <th> promove a primeira linha, sem perder dados', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppHtml(
            data:
                '<table><tr><td>Coluna</td></tr>'
                '<tr><td>Valor</td></tr></table>',
          ),
        ),
      );

      final String text = _rendered(tester);
      expect(text, contains('Coluna'));
      expect(text, contains('Valor'));
    });
  });

  group('AppHtml · sanitização', () {
    testWidgets('script é descartado com o conteúdo', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppHtml(
            data: '<p>antes</p><script>alert("xss")</script><p>depois</p>',
          ),
        ),
      );

      final String text = _rendered(tester);
      expect(text, contains('antes'));
      expect(text, contains('depois'));
      // O corpo do script não pode virar texto visível.
      expect(text, isNot(contains('alert')));
      expect(text, isNot(contains('xss')));
    });

    testWidgets('style, iframe e form são descartados', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppHtml(
            data:
                '<style>body{display:none}</style>'
                '<iframe src="https://malicioso.com"></iframe>'
                '<form><input value="segredo"></form>'
                '<p>sobrevivente</p>',
          ),
        ),
      );

      final String text = _rendered(tester);
      expect(text, contains('sobrevivente'));
      expect(text, isNot(contains('display')));
      expect(text, isNot(contains('segredo')));
    });

    testWidgets('href javascript: não vira link clicável', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppHtml(
            data: '<p><a href="javascript:alert(1)">clique aqui</a></p>',
          ),
        ),
      );

      // O texto permanece — só o gatilho é removido.
      expect(_rendered(tester), contains('clique aqui'));
      expect(_linkSpans(tester), isEmpty);
    });

    testWidgets('href data: não vira link clicável', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppHtml(
            data: '<p><a href="data:text/html;base64,PHNjcmlwdD4=">x</a></p>',
          ),
        ),
      );

      expect(_linkSpans(tester), isEmpty);
    });

    testWidgets('href http continua clicável', (WidgetTester tester) async {
      String? tapped;
      await tester.pumpWidget(
        _host(
          AppHtml(
            data:
                '<p>Veja o <a href="https://exemplo.com">site oficial</a>.</p>',
            onTapLink: (String href) => tapped = href,
          ),
        ),
      );

      expect(_linkSpans(tester), hasLength(1));
      await tester.tapOnText(find.textRange.ofSubstring('site oficial'));
      await tester.pump();
      expect(tapped, 'https://exemplo.com');
    });

    testWidgets('link relativo é preservado', (WidgetTester tester) async {
      String? tapped;
      await tester.pumpWidget(
        _host(
          AppHtml(
            data: '<p><a href="/termos">termos</a></p>',
            onTapLink: (String href) => tapped = href,
          ),
        ),
      );

      await tester.tapOnText(find.textRange.ofSubstring('termos'));
      await tester.pump();
      expect(tapped, '/termos');
    });
  });

  group('AppHtml · degradação', () {
    testWidgets('tag desconhecida preserva o texto', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppHtml(
            data: '<custom-widget><p>não me perca</p></custom-widget>',
          ),
        ),
      );

      expect(_rendered(tester), contains('não me perca'));
    });

    testWidgets('tag inline desconhecida preserva o texto na frase', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(const AppHtml(data: '<p>antes <weird>meio</weird> depois</p>')),
      );

      final String text = _rendered(tester);
      expect(text, contains('antes'));
      expect(text, contains('meio'));
      expect(text, contains('depois'));
    });

    testWidgets('HTML malformado não lança', (WidgetTester tester) async {
      const List<String> broken = <String>[
        '<p>sem fechar',
        '<div><p>aninhado errado</div></p>',
        '<table><tr><td>solto',
        '<<>>',
        '<p>&naoexiste;</p>',
      ];

      for (final String data in broken) {
        await tester.pumpWidget(_host(AppHtml(data: data)));
        expect(tester.takeException(), isNull, reason: 'falhou em: $data');
      }
    });

    testWidgets('entrada vazia não ocupa espaço', (WidgetTester tester) async {
      await tester.pumpWidget(_host(const AppHtml(data: '')));
      expect(tester.takeException(), isNull);
      expect(find.byType(Text), findsNothing);
    });
  });
}
