// O gate de frescor do snippet de marca exportado.
//
// É a terceira aplicação de um padrão que o repo já usa no catálogo
// (`catalog_freshness_test.dart`) e no `server.json` do MCP: um ARTEFATO
// versionado mais um teste que o confere em todo PR. Aqui ele rende mais que
// nos outros dois, porque o artefato é um `.dart` de verdade:
//
// - **golden de texto**: o arquivo é, byte a byte, o que `toDartSnippet` emite
//   hoje. Mudou o gerador sem querer? Reprova aqui.
// - **prova de compilação, contra ESTA árvore**: o arquivo está no caminho do
//   `dart analyze` da raiz, e um snippet que não compila reprova a análise antes
//   de qualquer teste rodar — o que um teste de string não alcançaria.
// - **round-trip**: o teste importa a configuração DECLARADA no artefato e
//   compara o tema derivado com o da marca de origem. Serialização que não faz
//   ida e volta é serialização errada.
//
// O QUE ESTE ARQUIVO NÃO PROVA, dito aqui porque a versão anterior deste
// comentário afirmava o contrário. A prova de compilação vale para o `flocks`
// DESTA BRANCH, não para o que está no pub.dev: `packages/flocks` é membro do
// workspace (`resolution: workspace`), o artefato mora dentro dele, e o
// `package:flocks/flocks.dart` que ele importa resolve para
// `packages/flocks/lib/` — onde todo símbolo novo já existe, publicado ou não.
// O `pubspec.lock` não tem entrada `flocks` nenhuma.
//
// Foi essa lacuna que deixou a demo exportar `flippedSwatch(` durante a 0.1.1,
// com este gate verde: a função existia aqui e não lá.
//
// Quem fecha o furo é o job `snippet (hosted)` do `ci.yml`. Ele monta um pacote
// descartável FORA do workspace, declara o `flocks` hospedado pinado na versão
// exata deste pubspec, copia este mesmo artefato para dentro e roda
// `dart analyze` — a situação real de quem cola o snippet num projeto próprio.
// Este teste continua sendo o gate do FORMATO; o de lá é o gate da PROMESSA.
//
// Com uma ressalva que também vale dita, porque é o mesmo tipo de coisa que este
// cabeçalho existe para não deixar passar: entre preparar um release e publicá-lo
// a versão pinada não é resolvível, e nessa janela o job PULA, anotando no log o
// que deixou de conferir. Ele não é uma proteção contínua — é uma proteção que
// vale para toda versão que já esteja no pub.dev, e que fica muda exatamente
// enquanto a próxima não estiver.
//
// O gerador mora aqui, e não em `tool/`, por uma razão de plataforma: o `flocks`
// depende de Flutter, e `dart run` não compila `dart:ui`. Regenerar é
// `flutter test <este arquivo> --update-goldens` — o mesmo mecanismo que o
// Flutter já dá para artefato gerado, sem inventar um segundo.
//
// Sem a tag `golden`: `golden_tagging_test.dart` reserva a tag para quem compara
// PIXEL, e essas suítes rodam em macOS. Esta compara texto e roda em Linux com
// o resto.
import 'dart:io';

import 'package:flocks/flocks.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/exported_brand_snippet.dart' as artifact;

/// Onde o snippet gerado vive, relativo à raiz do pacote.
const String kSnippetPath = 'test/support/exported_brand_snippet.dart';

/// O comando que regenera o arquivo — citado na mensagem de falha.
const String kExportCommand =
    'flutter test $kSnippetPath --update-goldens'
    ' (na verdade: flutter test test/architecture/'
    'brand_snippet_freshness_test.dart --update-goldens)';

/// O slug usado no artefato.
///
/// Não é o `flocks` da marca de origem de propósito: o arquivo declara uma
/// variável de nome derivado do slug, e `flocksBrand` sombrearia o `flocksBrand`
/// que o próprio arquivo importa do pacote. De quebra, exercita o parâmetro
/// `clientSlug` — que é como a demo nomeia a marca do visitante sem tocar na
/// configuração que está na tela.
const String kSnippetSlug = 'acme';

/// O conteúdo exato que [kSnippetPath] deve ter.
///
/// A marca de origem é a [flocksBrand] — uma marca REAL do pacote, não uma
/// fabricada para o teste. Ela exercita de uma vez três das quatro formas de
/// swatch que o gerador sabe encurtar (cromática, neutra e espelhada), um papel
/// opcional, um eixo fora do padrão e a tipografia.
String exportedBrandSnippet() =>
    flocksBrand.toDartSnippet(clientSlug: kSnippetSlug);

void main() {
  test('$kSnippetPath está em dia com o toDartSnippet', () {
    final File file = File(kSnippetPath);
    final String expected = exportedBrandSnippet();

    if (autoUpdateGoldenFiles) {
      file.parent.createSync(recursive: true);
      file.writeAsStringSync(expected);
      return;
    }

    expect(
      file.existsSync(),
      isTrue,
      reason: '$kSnippetPath não existe. Rode `$kExportCommand`.',
    );
    expect(
      file.readAsStringSync(),
      expected,
      reason:
          'O snippet exportado divergiu do gerador. Se a mudança em '
          '`toDartSnippet` é intencional, rode `$kExportCommand` e commite o '
          'resultado — e confira que o arquivo novo continua compilando.',
    );
  });

  // A prova de que a serialização é honesta. Não compara as duas
  // `AppBrandConfig` (a classe não tem `==`), e sim os temas que elas derivam,
  // que é o que de fato chega ao pixel — e `AppThemeData` é `Equatable`, então
  // a comparação cobre cor, radius, estilo e tipografia de uma vez.
  group('a marca reconstruída do snippet é a marca original', () {
    for (final bool dark in <bool>[false, true]) {
      test('tema ${dark ? 'escuro' : 'claro'}', () {
        expect(
          AppThemeData.forBrand(artifact.acmeBrand, dark: dark),
          AppThemeData.forBrand(flocksBrand, dark: dark),
        );
      });
    }
  });

  test('o slug é o único campo que o snippet reescreve', () {
    expect(artifact.acmeBrand.clientSlug, kSnippetSlug);
    expect(flocksBrand.clientSlug, 'flocks');
  });
}
