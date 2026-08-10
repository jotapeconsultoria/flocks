// O teste de arquitetura da demo.
//
// O `architecture_test.dart` do `flocks` varre `lib/src` DO PACOTE DELE — este
// pacote está fora do alcance. Sem um equivalente aqui, a demo poderia importar
// Material, abrir um cliente HTTP ou trocar o provider de ícone pelo de rede sem
// que nada ficasse vermelho, e os dois argumentos que ela existe para sustentar
// ("zero Material" e "funciona offline") cairiam calados.
//
// O mecanismo é o mesmo do original, e a simplicidade é deliberada: lê o arquivo
// como texto e procura substring, sem análise de AST.
//
// A diferença é que aqui os comentários são descartados antes da busca, e não
// por preciosismo: os arquivos que mais precisam ser varridos são justamente os
// que EXPLICAM por que não fazem rede, e a primeira versão deste teste reprovou
// `browser_web.dart` por causa da frase "não há `createObjectURL` aqui". Um gate
// que proíbe documentar a própria regra ensina a apagar a documentação. O
// `architecture_test` do core faz o mesmo filtro, pela mesma razão.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Os arquivos Dart de `lib/`.
List<File> libFiles() => Directory('lib')
    .listSync(recursive: true)
    .whereType<File>()
    .where((File f) => f.path.endsWith('.dart'))
    .toList();

/// O conteúdo de [file] sem as linhas de comentário.
String code(File file) => file
    .readAsLinesSync()
    .where((String line) => !line.trimLeft().startsWith('//'))
    .join('\n');

void main() {
  final List<File> files = libFiles();

  test('há o que varrer', () {
    expect(files, isNotEmpty, reason: 'rode a partir de packages/flocks_demo');
  });

  test('nenhum arquivo importa Material ou Cupertino', () {
    final List<String> offenders = <String>[];
    for (final File f in files) {
      final String content = code(f);
      if (content.contains('package:flutter/material.dart') ||
          content.contains('package:flutter/cupertino.dart')) {
        offenders.add(f.path);
      }
    }
    expect(
      offenders,
      isEmpty,
      reason:
          'A demo é a prova de que dá para montar um app inteiro sobre '
          'widgets.dart. Um import de Material aqui desmente a tela que ela '
          'está mostrando. Offenders: $offenders',
    );
  });

  test('nenhum arquivo abre um caminho de rede', () {
    // A lista é o que sustenta o gate do logo. Se um destes entrar,
    // `no_network_test.dart` provavelmente ainda passaria — ele só vê o que o
    // teste exercita —, e é por isso que a proibição é estática também.
    const List<String> forbidden = <String>[
      'package:http/',
      'package:dio/',
      'dart:io',
      'HttpClient',
      'XMLHttpRequest',
      'HttpRequest',
      'window.fetch',
      'createObjectURL',
      'AppNetworkIconProvider',
      'AppNetworkIllustrationProvider',
    ];
    final List<String> offenders = <String>[];
    for (final File f in files) {
      final String content = code(f);
      for (final String needle in forbidden) {
        if (content.contains(needle)) offenders.add('${f.path}: $needle');
      }
    }
    expect(
      offenders,
      isEmpty,
      reason:
          'A demo não faz rede — é a tese do pacote e é o que garante que o '
          'logo do visitante não sai da aba. Offenders: $offenders',
    );
  });

  test('nenhum import condicional por dart.library.html', () {
    // A mesma proibição do core, pela mesma razão: `dart.library.html` é FALSO
    // no dart2wasm, então a condição escolhe o ramo default em silêncio. O
    // `flocks` levou um bug assim até a 0.1.1.
    final List<String> offenders = <String>[];
    for (final File f in files) {
      if (code(f).contains('dart.library.html')) {
        offenders.add(f.path);
      }
    }
    expect(
      offenders,
      isEmpty,
      reason:
          'Use `dart.library.io` ou `dart.library.js_interop`. Offenders: '
          '$offenders',
    );
  });

  test('o pubspec não declara um cliente HTTP', () {
    final List<String> lines = File('pubspec.yaml')
        .readAsLinesSync()
        .where((String l) => !l.trimLeft().startsWith('#'))
        .toList();
    const List<String> forbidden = <String>['http:', 'dio:', 'chopper:'];
    final List<String> offenders = <String>[];
    for (final String line in lines) {
      for (final String dep in forbidden) {
        if (line.trimLeft().startsWith(dep)) offenders.add(line.trim());
      }
    }
    expect(
      offenders,
      isEmpty,
      reason:
          'Uma dependência de rede nas deps da demo é a porta pela qual o logo '
          'sairia. Offenders: $offenders',
    );
  });

  test('o build da demo não puxa o CanvasKit de um CDN', () {
    // O default do Flutter (`--web-resources-cdn`, ligado) baixa
    // `canvaskit.js` e `canvaskit.wasm` de `www.gstatic.com` a cada
    // carregamento. Numa demo cuja tese é "funciona offline, sem CDN", isso é a
    // tese sendo desmentida na aba de rede do visitante.
    //
    // Este gate é ESTÁTICO — lê o workflow — porque o defeito não é alcançável
    // pelos outros: `no_network_test.dart` roda na VM e não enxerga o bootstrap
    // JS que faz o download, e nenhum arquivo de `lib/` menciona o CDN. Só
    // apareceu ao abrir a demo num navegador e ler as requisições, e sem um
    // gate voltaria no dia em que alguém reescrevesse o passo de build.
    final File workflow = File('../../.github/workflows/ci.yml');
    expect(workflow.existsSync(), isTrue, reason: 'ci.yml não encontrado');

    final List<String> buildLines = workflow
        .readAsLinesSync()
        .where((String l) => l.contains('flutter build web'))
        .where((String l) => l.contains('flocks_demo') || l.contains('/demo/'))
        .toList();

    expect(
      buildLines,
      isNotEmpty,
      reason: 'o passo de build da demo sumiu do ci.yml',
    );
    for (final String line in buildLines) {
      expect(
        line,
        contains('--no-web-resources-cdn'),
        reason:
            'Sem esta flag a demo baixa o CanvasKit de www.gstatic.com, e '
            'deixa de ser verdade que ela não contacta host nenhum.',
      );
    }
  });

  test('o logo não tem como virar URL', () {
    // O ponto exato onde a fronteira se romperia por conveniência: basta uma
    // linha criando uma object URL para os bytes ganharem um endereço.
    final String logo = code(File('lib/src/state/demo_logo.dart'));
    expect(logo, isNot(contains('Uri')));
    expect(logo, isNot(contains('http')));
    expect(logo, contains('Uint8List'));
  });
}
