// Contagem citada não pode ser medição manual.
//
// "295 use cases" já circulou como 293 e 297: cada citação contava na mão, num
// momento diferente, e nada ficava vermelho quando o catálogo crescia. É o
// mesmo modo de falha que o `doc/mcp/catalog.json` tinha antes do
// `catalog_freshness_test` — número publicado derivando do código em silêncio.
//
// Mesmo remédio: a contagem vira artefato gerado (`doc/widgetbook_use_cases
// .json`, via `tool/count_use_cases.dart`) e este teste cobra que o artefato
// esteja em dia. Roda no `flutter test` de todo PR (fora da partição golden,
// portanto no job Linux) e falha dizendo exatamente o que rodar.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/count_use_cases.dart';
import '../../tool/widgetbook_conventions.dart';

void main() {
  group('contagem de use cases serializada', () {
    test('doc/widgetbook_use_cases.json está em dia com as anotações', () {
      final File file = File(kUseCaseCountPath);
      expect(
        file.existsSync(),
        isTrue,
        reason: '$kUseCaseCountPath não existe. Rode `$kCountCommand`.',
      );
      expect(
        file.readAsStringSync(),
        serializedUseCaseCount(),
        reason:
            'A contagem serializada divergiu das anotações @widgetbook.UseCase. '
            'Quem cita o número lê este arquivo, então a deriva vira um número '
            'falso em circulação. Rode `$kCountCommand` e commite o resultado.',
      );
    });

    test('o número do artefato bate com as anotações', () {
      // Redundante com a comparação de string acima quando ela passa — e é
      // exatamente esse o ponto: é esta que diz "293 contra 295" na falha,
      // com os dois números lado a lado.
      final int serialized =
          (jsonDecode(File(kUseCaseCountPath).readAsStringSync())
                  as Map<String, Object?>)['useCases']!
              as int;
      final int real = discoverUseCases('.').length;
      expect(
        serialized,
        real,
        reason:
            'Serializados: $serialized · anotados: $real. '
            'Rode `$kCountCommand`.',
      );
    });
  });
}
