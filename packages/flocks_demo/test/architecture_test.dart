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

/// Onde um literal de cor é legítimo, por sufixo de caminho.
///
/// Uma entrada só: `demo_config.dart` é a fronteira por onde a cor ENTRA na
/// demo — a semente padrão e o desempacotamento do hex que vem da URL. Cor
/// escolhida pelo visitante não tem como não ser literal em algum ponto, e este
/// é o ponto, concentrado num arquivo em vez de espalhado.
///
/// A lista deve tender a zero pelo lado de baixo: entrada nova aqui é dívida, e
/// precisa vir com a razão escrita, como a de cima.
const Set<String> _colorLiteralAllowlist = <String>{'state/demo_config.dart'};

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
      // `fetch(` com o parêntese, e não `fetch` solto: a palavra aparece em
      // prosa de UI ("Nothing here is fetched.") e um gate que proíbe descrever
      // a própria regra ensina a apagar a descrição — a mesma razão do filtro de
      // comentários lá em cima. O `window.fetch` acima cobre só a forma
      // qualificada; esta cobre a importada por `@JS()` ou por extension type.
      'fetch(',
      // As três vias de saída que não são `fetch` e que o gate anterior deixava
      // passar inteiras. `sendBeacon` é a pior das três para esta demo: foi
      // desenhada exatamente para vazar dados na descarga da página, é
      // fire-and-forget, aceita um Blob — o logo caberia nela — e não devolve
      // nada que um teste de retorno pudesse observar.
      'sendBeacon',
      'WebSocket',
      'EventSource',
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
            'Sem esta flag a demo baixa o `canvaskit.js` e o `canvaskit.wasm` de '
            'www.gstatic.com a cada carregamento; com ela, o `canvaskit/` que já '
            'vai no build é servido por nós. O que esta flag NÃO alcança é a '
            'Roboto que o engine busca em fonts.gstatic.com como fallback '
            'registrado — uma requisição, medida, e o TODO.md explica por que '
            'ela é mais cara de consertar. "Não contacta host nenhum" seria '
            'falso com flag ou sem ela, e por isso não está escrito em lugar '
            'nenhum.',
      );
    }
  });

  test('nenhuma cor nem sombra escrita à mão fora da fronteira', () {
    // O `main.dart` da demo abre dizendo "nenhum `Color` literal fora do que o
    // visitante escolheu, nenhum `BoxShadow`" — e até agora nada fiscalizava a
    // frase. Numa demo cuja tese é que o tema resolve tudo, um `Colors.red` de
    // depuração esquecido é a tese desmentida no pixel: ele não reage à marca, e
    // seria a única coisa na tela a não reagir.
    //
    // `BoxShadow` entra na mesma lista porque a elevação é eixo do tema
    // (`AppElevations`), não decoração local. Uma sombra à mão não acompanha o
    // `AppStyle` que o visitante trocar.
    const List<String> forbidden = <String>['Colors.', 'BoxShadow', 'Color(0x'];
    final List<String> offenders = <String>[];
    for (final File f in files) {
      final String path = f.path.replaceAll(r'\', '/');
      if (_colorLiteralAllowlist.any(path.endsWith)) continue;
      final String content = code(f);
      for (final String needle in forbidden) {
        if (content.contains(needle)) offenders.add('${f.path}: $needle');
      }
    }
    expect(
      offenders,
      isEmpty,
      reason:
          'Cor e sombra saem do tema, que é o que a marca do visitante '
          'reconfigura. Se o literal for a fronteira de entrada da cor, ele '
          'mora em `state/demo_config.dart`. Offenders: $offenders',
    );
  });

  test('a allow-list de cor não guarda entrada morta', () {
    // Uma allow-list que sobrevive ao arquivo que a justificava passa a mentir:
    // parece dívida ativa e é entulho. Este gate é o que a mantém honesta.
    for (final String suffix in _colorLiteralAllowlist) {
      expect(
        files.any((File f) => f.path.replaceAll(r'\', '/').endsWith(suffix)),
        isTrue,
        reason:
            '`$suffix` está na allow-list e não existe mais — tire a linha.',
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
