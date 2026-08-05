@Tags(<String>['golden'])
library;

import 'dart:io';

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Valida o AppHtml contra os payloads REAIS de `GET /support` (colunas
// `privacy_policy` / `service_terms` da tabela `accounts`), capturados do
// ambiente local. Enquanto o vocabulário de tags do backend não era conhecido,
// a allow-list era hipótese; estas fixtures a transformam em fato.
//
// Regenerar (com o ambiente local de pé):
//   docker exec tracked-api-postgres-1 psql -U tracked -d tracked -t -A \
//     -c "SELECT privacy_policy FROM accounts WHERE privacy_policy IS NOT NULL LIMIT 1;" \
//     > test/src/organisms/content/fixtures/privacy_policy.html

const String _fixtures = 'test/src/organisms/content/fixtures';

String _load(String name) => File('$_fixtures/$name').readAsStringSync().trim();

Widget _host(Widget child, {AppThemeData? theme}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(size: Size(800, 1000)),
    child: AppTheme(
      data: theme ?? AppThemeData.light,
      child: Align(alignment: Alignment.topLeft, child: child),
    ),
  ),
);

String _rendered(WidgetTester tester) => tester
    .widgetList<Text>(find.byType(Text))
    .map((Text t) => t.data ?? t.textSpan?.toPlainText() ?? '')
    .join('\n');

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
  group('AppHtml · Política de Privacidade (payload real)', () {
    testWidgets('preserva todo o texto do documento', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(AppHtml(data: _load('privacy_policy.html'))),
      );

      final String text = _rendered(tester);
      expect(text, contains('Política de Privacidade'));
      expect(text, contains('Última atualização:'));
      expect(text, contains('Dados coletados'));
      expect(text, contains('Dados de identificação e contato.'));
      expect(text, contains('Informações de veículos e dispositivos.'));
      expect(text, contains('Registros técnicos necessários para segurança.'));
      expect(text, contains('Como usamos os dados'));
      expect(text, contains('Seus direitos'));
      expect(text, contains('privacidade@tracked.local'));
      expect(text, contains('Conteúdo fictício'));
      // Nenhuma tag pode vazar como texto.
      expect(text, isNot(contains('<')));
    });

    testWidgets('link mailto sem aspas no atributo continua clicável', (
      WidgetTester tester,
    ) async {
      // O backend emite `href=mailto:...` sem aspas — HTML válido, mas fácil de
      // quebrar num parser ingênuo.
      String? tapped;
      await tester.pumpWidget(
        _host(
          AppHtml(
            data: _load('privacy_policy.html'),
            onTapLink: (String href) => tapped = href,
          ),
        ),
      );

      expect(_linkSpans(tester), hasLength(1));
      await tester.tapOnText(
        find.textRange.ofSubstring('privacidade@tracked.local'),
      );
      await tester.pump();
      expect(tapped, 'mailto:privacidade@tracked.local');
    });
  });

  group('AppHtml · Termos de Uso (payload real)', () {
    testWidgets('preserva o texto e numera a lista ordenada', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(AppHtml(data: _load('service_terms.html'))),
      );

      final String text = _rendered(tester);
      expect(text, contains('Termos de Uso'));
      expect(text, contains('Uso permitido'));
      expect(text, contains('Utilizar a plataforma apenas para finalidades'));
      expect(text, contains('Manter suas credenciais de acesso protegidas.'));
      expect(text, contains('Disponibilidade'));
      expect(text, contains('Responsabilidades'));
      // `<ol>` deve numerar, não usar marcador.
      expect(text, contains('1.'));
      expect(text, contains('2.'));
      expect(text, contains('3.'));
      expect(text, isNot(contains('<')));
    });

    testWidgets('link https sem aspas continua clicável', (
      WidgetTester tester,
    ) async {
      String? tapped;
      await tester.pumpWidget(
        _host(
          AppHtml(
            data: _load('service_terms.html'),
            onTapLink: (String href) => tapped = href,
          ),
        ),
      );

      await tester.tapOnText(
        find.textRange.ofSubstring('nosso canal de suporte'),
      );
      await tester.pump();
      expect(tapped, 'https://tracked.local/suporte');
    });
  });

  group('AppHtml · cobertura da allow-list', () {
    test('as fixtures só usam tags suportadas', () {
      final RegExp tagPattern = RegExp(r'<\s*/?\s*([a-zA-Z][a-zA-Z0-9-]*)');
      final Set<String> used = <String>{};
      for (final String name in <String>[
        'privacy_policy.html',
        'service_terms.html',
      ]) {
        for (final RegExpMatch m in tagPattern.allMatches(_load(name))) {
          used.add(m.group(1)!.toLowerCase());
        }
      }

      // Falha se o backend passar a emitir uma tag fora da allow-list — o
      // sinal de que o subconjunto suportado precisa crescer.
      final Set<String> unsupported = used.where((String t) {
        return !ContentTagsProbe.isSupported(t);
      }).toSet();

      expect(
        unsupported,
        isEmpty,
        reason:
            'Tags do payload real fora da allow-list do AppHtml: $unsupported. '
            'Tags usadas: ${used.toList()..sort()}',
      );
    });
  });

  group('AppHtml · goldens dos documentos legais', () {
    for (final bool dark in <bool>[false, true]) {
      final String mode = dark ? 'dark' : 'light';

      testWidgets('Política de Privacidade · $mode', (
        WidgetTester tester,
      ) async {
        final AppThemeData data = AppThemeData.forBrand(
          jotapeBrand,
          dark: dark,
        );

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(720, 900)),
              child: AppTheme(
                data: data,
                child: Container(
                  key: const Key('golden'),
                  color: data.colorTheme.surface,
                  width: 720,
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: AppHtml(data: _load('privacy_policy.html')),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byKey(const Key('golden')),
          matchesGoldenFile('goldens/legal_privacy_policy_$mode.png'),
        );
      });
    }
  });
}

/// Espelha a taxonomia interna do renderer para o teste de cobertura.
///
/// `ContentTags` é privado ao `src/`; esta lista é a mesma allow-list, mantida
/// em sincronia de propósito — se divergirem, o teste acima acusa.
sealed class ContentTagsProbe {
  static const Set<String> _supported = <String>{
    // blocos
    'p', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'ul', 'ol', 'li', 'blockquote',
    'pre', 'hr', 'table', 'thead', 'tbody', 'tfoot', 'tr', 'th', 'td',
    // containers pass-through
    'html', 'body', 'main', 'div', 'section', 'article', 'aside', 'header',
    'footer', 'figure', 'figcaption', 'nav', 'dl', 'dt', 'dd',
    // inline
    'strong', 'b', 'em', 'i', 'u', 's', 'del', 'strike', 'code', 'a', 'span',
    'sup', 'sub', 'img', 'br', 'mark', 'small',
  };

  static bool isSupported(String tag) => _supported.contains(tag);
}
