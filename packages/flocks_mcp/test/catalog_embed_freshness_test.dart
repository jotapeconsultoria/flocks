// Catálogo embarcado não pode envelhecer em silêncio.
//
// Este pacote serve o `doc/mcp/catalog.json` do `flocks` a partir de uma cópia
// em Dart (`lib/src/catalog_data.g.dart`), porque um binário instalado por
// `dart pub global activate` não enxerga o `doc/` do pacote irmão. Cópia é
// número derivado do código, e este repositório já perdeu duas vezes para esse
// modo de falha: o `catalog.json` derivou 123 contra 129 reais em três dias, e
// "295 use cases" circulou como 293 e 297.
//
// Sem este gate, o modo de falha seria pior que os dois anteriores: o servidor
// entregaria a um MODELO props que não existem mais, com toda a confiança de
// uma fonte de verdade, e nada ficaria vermelho. O remédio é o mesmo das
// outras duas vezes — a geração vive em `tool/embed_catalog.dart`, a
// conferência vive aqui, e as duas chamam a MESMA função.
import 'dart:convert';
import 'dart:io';

import 'package:flocks_mcp/src/catalog_data.g.dart';
import 'package:test/test.dart';

import '../tool/embed_catalog.dart';

/// Confere a igualdade sem entregar as strings ao matcher.
///
/// `expect(a, b)` com 490 KB de cada lado despeja os dois inteiros no
/// terminal, e a falha vira um enigma rolando por milhares de linhas. Passando
/// o booleano, o matcher só tem `false` para imprimir, e a mensagem útil é a
/// de [describeDivergence].
void expectSameText(String actual, String expected, {required String reason}) =>
    expect(
      actual == expected,
      isTrue,
      reason: '$reason\n${describeDivergence(actual, expected)}',
    );

/// Descreve onde [embedded] e [source] divergem, sem despejar 490 KB.
///
/// O que a pessoa precisa saber é o tamanho dos dois lados e a vizinhança do
/// primeiro caractere diferente.
String describeDivergence(String embedded, String source) {
  final int shared = embedded.length < source.length
      ? embedded.length
      : source.length;
  int at = 0;
  while (at < shared && embedded.codeUnitAt(at) == source.codeUnitAt(at)) {
    at++;
  }
  String window(String s) {
    final int start = at - 60 < 0 ? 0 : at - 60;
    final int end = at + 60 > s.length ? s.length : at + 60;
    return s.substring(start, end).replaceAll('\n', '⏎');
  }

  return 'Primeira divergência no caractere $at '
      '(embarcado: ${embedded.length} · fonte: ${source.length}).\n'
      '  embarcado: …${window(embedded)}…\n'
      '  fonte:     …${window(source)}…';
}

void main() {
  group('catálogo embarcado', () {
    test('$kEmbeddedPath está em dia com o gerador', () {
      final File file = File(kEmbeddedPath);
      expect(
        file.existsSync(),
        isTrue,
        reason: '$kEmbeddedPath não existe. Rode `$kEmbedCommand`.',
      );
      expectSameText(
        file.readAsStringSync(),
        embeddedCatalogSource(),
        reason:
            'O arquivo gerado divergiu do que o gerador produz agora. Rode '
            '`$kEmbedCommand` e commite o resultado.',
      );
    });

    test('a string embarcada é o $kCatalogSourcePath byte a byte', () {
      // A comparação que interessa de verdade: não é o arquivo .dart contra o
      // gerador (isso o caso acima já cobre), é o CONTEÚDO que o servidor vai
      // entregar contra o catálogo real. As duas comparações só coincidem
      // enquanto a geração não transformar nada — e é para o dia em que
      // alguém achar que dá para "só compactar um pouquinho" que esta existe.
      expectSameText(
        kCatalogJson,
        File(kCatalogSourcePath).readAsStringSync(),
        reason:
            'O catálogo embarcado divergiu da fonte. O servidor MCP serviria '
            'a versão velha para um modelo, com cara de fonte de verdade. '
            'Rode `$kEmbedCommand` e commite o resultado.',
      );
    });

    test('a contagem de componentes bate com a da fonte', () {
      // Redundante com a comparação acima quando ela passa — e é exatamente
      // esse o ponto: é esta que diz "128 contra 131" na falha, em vez de um
      // ponteiro para o caractere 47.312.
      final int embedded = (jsonDecode(kCatalogJson) as List<Object?>).length;
      final int real =
          (jsonDecode(File(kCatalogSourcePath).readAsStringSync())
                  as List<Object?>)
              .length;
      expect(
        embedded,
        real,
        reason:
            'Embarcados: $embedded · na fonte: $real. Rode `$kEmbedCommand`.',
      );
    });
  });
}
