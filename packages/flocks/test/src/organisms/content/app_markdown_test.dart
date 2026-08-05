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

/// Texto simples de tudo que foi renderizado.
///
/// Os blocos viram `Text.rich`, cujo `data` é nulo — `find.text` não os acha.
/// Achatar os spans é o jeito honesto de afirmar sobre o conteúdo visível.
String _rendered(WidgetTester tester) => tester
    .widgetList<Text>(find.byType(Text))
    .map((Text t) => t.data ?? t.textSpan?.toPlainText() ?? '')
    .join('\n');

void main() {
  group('AppMarkdown · blocos', () {
    testWidgets('renderiza headings e parágrafos', (WidgetTester tester) async {
      await tester.pumpWidget(
        _host(
          const AppMarkdown(
            data: '# Relatório\n\nVelocidade média do período.',
          ),
        ),
      );

      final String text = _rendered(tester);
      expect(text, contains('Relatório'));
      expect(text, contains('Velocidade média do período.'));
      // O `#` é sintaxe, não conteúdo.
      expect(text, isNot(contains('# Relatório')));
    });

    testWidgets('aplica a escala tipográfica nos headings', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(const AppMarkdown(data: '# H1\n\n###### H6')),
      );

      final List<Text> texts = tester
          .widgetList<Text>(find.byType(Text))
          .toList();
      final Text h1 = texts.firstWhere(
        (Text t) => (t.textSpan?.toPlainText() ?? '') == 'H1',
      );
      final Text h6 = texts.firstWhere(
        (Text t) => (t.textSpan?.toPlainText() ?? '') == 'H6',
      );

      expect(h1.style!.fontSize, greaterThan(h6.style!.fontSize!));
    });

    testWidgets('formatação inline não vaza sintaxe', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppMarkdown(
            data: 'Isto é **negrito**, _itálico_, ~~riscado~~ e `código`.',
          ),
        ),
      );

      final String text = _rendered(tester);
      expect(text, contains('negrito'));
      expect(text, contains('itálico'));
      expect(text, contains('riscado'));
      expect(text, contains('código'));
      expect(text, isNot(contains('**')));
      expect(text, isNot(contains('~~')));
    });

    testWidgets('negrito vira peso maior no span', (WidgetTester tester) async {
      await tester.pumpWidget(_host(const AppMarkdown(data: 'a **b** c')));

      final Text paragraph = tester.widget<Text>(find.byType(Text).first);
      final List<InlineSpan> spans =
          (paragraph.textSpan! as TextSpan).children!;
      final TextSpan bold = spans.whereType<TextSpan>().firstWhere(
        (TextSpan s) => s.toPlainText().trim() == 'b',
      );

      expect(bold.style!.fontWeight, FontWeight.w600);
    });

    testWidgets('bloco de código preserva quebras e indentação', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppMarkdown(
            data: '```dart\nvoid main() {\n  print("oi");\n}\n```',
          ),
        ),
      );

      final String text = _rendered(tester);
      expect(text, contains('void main() {\n  print("oi");\n}'));
      // A cerca não é conteúdo.
      expect(text, isNot(contains('```')));
    });

    testWidgets('citação é renderizada', (WidgetTester tester) async {
      await tester.pumpWidget(
        _host(const AppMarkdown(data: '> Atenção ao limite.')),
      );
      expect(_rendered(tester), contains('Atenção ao limite.'));
    });

    testWidgets('régua horizontal vira AppDivider', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_host(const AppMarkdown(data: 'a\n\n---\n\nb')));
      expect(find.byType(AppDivider), findsOneWidget);
    });
  });

  group('AppMarkdown · listas', () {
    testWidgets('lista não-ordenada usa marcador', (WidgetTester tester) async {
      await tester.pumpWidget(_host(const AppMarkdown(data: '- alfa\n- beta')));

      final String text = _rendered(tester);
      expect(text, contains('•'));
      expect(text, contains('alfa'));
      expect(text, contains('beta'));
    });

    testWidgets('lista ordenada numera respeitando o início', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(const AppMarkdown(data: '3. três\n4. quatro')),
      );

      final String text = _rendered(tester);
      expect(text, contains('3.'));
      expect(text, contains('4.'));
    });

    testWidgets('lista aninhada troca o marcador por profundidade', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(const AppMarkdown(data: '- pai\n    - filho')),
      );

      final String text = _rendered(tester);
      expect(text, contains('•'));
      // Nível 2 usa '–' (e não '◦'): Poppins não desenha U+25E6 e o marcador
      // saía como tofu. Ver _bulletFor em content_block_builder.dart.
      expect(text, contains('–'));
      expect(text, contains('pai'));
      expect(text, contains('filho'));
    });
  });

  group('AppMarkdown · tabelas', () {
    testWidgets('tabela GFM vira AppSimpleDataTable', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppMarkdown(
            data: '| Placa | Modelo |\n| --- | --- |\n| ABC-1234 | GV75 |',
          ),
        ),
      );

      expect(find.byType(AppSimpleDataTable), findsOneWidget);
      final String text = _rendered(tester);
      expect(text, contains('Placa'));
      expect(text, contains('ABC-1234'));
      expect(text, contains('GV75'));
    });
  });

  group('AppMarkdown · links', () {
    testWidgets('toque no link chama onTapLink com o href', (
      WidgetTester tester,
    ) async {
      String? tapped;
      await tester.pumpWidget(
        _host(
          AppMarkdown(
            data: 'Veja a [rota completa](https://exemplo.com/rota) agora.',
            onTapLink: (String href) => tapped = href,
          ),
        ),
      );

      await tester.tapOnText(find.textRange.ofSubstring('rota completa'));
      await tester.pump();

      expect(tapped, 'https://exemplo.com/rota');
    });

    testWidgets('link é sublinhado e usa a cor de acento', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(const AppMarkdown(data: '[site](https://exemplo.com)')),
      );

      final Text paragraph = tester.widget<Text>(find.byType(Text).first);
      final TextSpan link = (paragraph.textSpan! as TextSpan).children!
          .whereType<TextSpan>()
          .firstWhere((TextSpan s) => s.recognizer != null);

      expect(link.text, 'site');
      expect(link.style!.decoration, TextDecoration.underline);
    });

    testWidgets('rebuild com novo conteúdo mantém os links funcionando', (
      WidgetTester tester,
    ) async {
      String? tapped;
      void onTap(String href) => tapped = href;

      await tester.pumpWidget(
        _host(AppMarkdown(data: '[um](https://um.com)', onTapLink: onTap)),
      );
      await tester.pumpWidget(
        _host(AppMarkdown(data: '[dois](https://dois.com)', onTapLink: onTap)),
      );

      await tester.tapOnText(find.textRange.ofSubstring('dois'));
      await tester.pump();

      expect(tapped, 'https://dois.com');
    });

    testWidgets('desmontar após rebuilds não lança', (
      WidgetTester tester,
    ) async {
      for (int i = 0; i < 5; i++) {
        await tester.pumpWidget(
          _host(AppMarkdown(data: '[link $i](https://exemplo.com/$i)')),
        );
      }
      await tester.pumpWidget(_host(const SizedBox.shrink()));

      expect(tester.takeException(), isNull);
    });
  });

  group('AppMarkdown · robustez', () {
    testWidgets('entrada vazia não ocupa espaço', (WidgetTester tester) async {
      await tester.pumpWidget(_host(const AppMarkdown(data: '')));
      expect(tester.takeException(), isNull);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('markdown parcial (streaming) não lança', (
      WidgetTester tester,
    ) async {
      // Cerca e tabela ainda não fechadas — o estado normal a cada frame
      // enquanto a resposta da IA chega.
      const List<String> chunks = <String>[
        '# Rel',
        '# Relatório\n\n| Placa |',
        '# Relatório\n\n| Placa |\n| --- |',
        '# Relatório\n\n| Placa |\n| --- |\n| ABC |\n\n```da',
        '# Relatório\n\n| Placa |\n| --- |\n| ABC |\n\n```dart\nvoid main(',
      ];

      for (final String chunk in chunks) {
        await tester.pumpWidget(_host(AppMarkdown(data: chunk)));
        expect(tester.takeException(), isNull, reason: 'falhou em: $chunk');
      }
    });

    testWidgets('HTML cru embutido não é interpretado', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppMarkdown(data: 'antes <script>alert(1)</script> depois'),
        ),
      );

      // O conteúdo aparece como texto literal; nada é executado nem some.
      final String text = _rendered(tester);
      expect(text, contains('antes'));
      expect(text, contains('depois'));
    });

    testWidgets('entidades HTML são decodificadas', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(const AppMarkdown(data: 'Tucker &amp; Cia &mdash; 10&deg;')),
      );

      final String text = _rendered(tester);
      expect(text, contains('Tucker & Cia'));
      expect(text, contains('—'));
      expect(text, contains('10°'));
      expect(text, isNot(contains('&amp;')));
    });
  });

  group('AppMarkdown · estilo', () {
    testWidgets('textColor pinta o corpo do documento', (
      WidgetTester tester,
    ) async {
      const Color red = Color(0xFFFF0000);
      await tester.pumpWidget(
        _host(const AppMarkdown(data: 'texto', textColor: red)),
      );

      final Text paragraph = tester.widget<Text>(find.byType(Text).first);
      expect(paragraph.style!.color, red);
    });

    testWidgets('styleSheet vence style e textColor', (
      WidgetTester tester,
    ) async {
      const Color green = Color(0xFF00FF00);
      late AppContentStyle sheet;

      await tester.pumpWidget(
        _host(
          Builder(
            builder: (BuildContext context) {
              sheet = AppContentStyle.resolve(
                context,
              ).copyWith(base: const TextStyle(fontSize: 33, color: green));
              return AppMarkdown(
                data: 'texto',
                textColor: const Color(0xFFFF0000),
                styleSheet: sheet,
              );
            },
          ),
        ),
      );

      final Text paragraph = tester.widget<Text>(find.byType(Text).first);
      expect(paragraph.style!.color, green);
      expect(paragraph.style!.fontSize, 33);
    });
  });
}
