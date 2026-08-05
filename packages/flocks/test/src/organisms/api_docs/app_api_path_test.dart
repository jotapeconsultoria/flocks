import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const TextStyle _base = TextStyle(fontSize: 12);
const TextStyle _placeholder = TextStyle(
  fontSize: 12,
  color: Color(0xFFFF5B04),
);

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
  group('splitApiPathSpans', () {
    List<TextSpan> split(String path) =>
        splitApiPathSpans(path, base: _base, placeholder: _placeholder);

    test('path sem placeholder vira um span só', () {
      final List<TextSpan> spans = split('/associations/vehicle-device');
      expect(spans, hasLength(1));
      expect(spans.single.text, '/associations/vehicle-device');
      expect(spans.single.style, _base);
    });

    test('o segmento entre chaves ganha o estilo de placeholder', () {
      final List<TextSpan> spans = split('/devices/{id}/commands');

      expect(spans.map((TextSpan s) => s.text).toList(), <String>[
        '/devices/',
        '{id}',
        '/commands',
      ]);
      expect(spans[0].style, _base);
      // As chaves entram no destaque: é `{id}` inteiro que se substitui, e
      // deixar as chaves em preto sugeriria que elas ficam na URL final.
      expect(spans[1].style, _placeholder);
      expect(spans[2].style, _base);
    });

    test('vários placeholders', () {
      final List<TextSpan> spans = split('/a/{x}/b/{y}');
      expect(
        spans
            .where((TextSpan s) => s.style == _placeholder)
            .map((TextSpan s) => s.text),
        <String>['{x}', '{y}'],
      );
    });

    test('chave sem fechamento não vira placeholder', () {
      // Melhor mostrar literal do que destacar um trecho até o fim do path.
      final List<TextSpan> spans = split('/devices/{id');
      expect(spans.every((TextSpan s) => s.style == _base), isTrue);
      expect(spans.map((TextSpan s) => s.text).join(), '/devices/{id');
    });

    test('placeholder no começo', () {
      final List<TextSpan> spans = split('{base}/devices');
      expect(spans.first.text, '{base}');
      expect(spans.first.style, _placeholder);
    });
  });

  testWidgets('renderiza o path e expõe prefixo + path na semântica', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppApiPath('/devices/{id}', prefix: 'https://api.tracked.local'),
      ),
    );

    // O rótulo semântico junta prefixo e path: quem ouve precisa da URL
    // inteira, não do pedaço que sobrou depois do host.
    expect(
      find.bySemanticsLabel('https://api.tracked.local/devices/{id}'),
      findsOneWidget,
    );
  });

  testWidgets('trunca em uma linha por padrão', (WidgetTester tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 80,
          child: AppApiPath('/um/caminho/bem/longo/{id}/de/verdade'),
        ),
      ),
    );

    final AppRichText text = tester.widget<AppRichText>(
      find.byType(AppRichText),
    );
    expect(text.maxLines, 1);
    expect(text.overflow, TextOverflow.ellipsis);
  });
}
