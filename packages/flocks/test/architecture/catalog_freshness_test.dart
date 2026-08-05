// Número publicado não pode derivar do código.
//
// `doc/mcp/catalog.json` derivou duas vezes em três dias — 123 serializados
// contra 129 reais — porque regenerar era um passo manual. O site lê esse
// arquivo para compor a contagem, então cada deriva vira um número falso
// publicado, e ninguém percebe porque nada fica vermelho.
//
// O remédio não é lembrar de rodar o comando: é o comando deixar de ser
// necessário lembrar. Este teste roda no `flutter test` de todo PR (fora da
// partição golden, portanto no job Linux) e falha dizendo exatamente o que
// rodar.
//
// Os números do README caem na mesma armadilha por outro caminho: são string
// escrita à mão. Não dá para gerá-los num arquivo de prosa, mas dá para cobrar
// que batam — que é o que impede a mesma classe de defeito de reaparecer ali.
import 'dart:convert';
import 'dart:io';

import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../tool/serialize_meta.dart';

/// Lê o número que antecede [noun] no README (ex.: `129 components` → 129).
///
/// Devolve todas as ocorrências: o mesmo número aparece mais de uma vez no
/// texto, e uma delas envelhecer sozinha é justo o caso a pegar.
///
/// Os substantivos são ingleses porque o README é inglês. Se o texto mudar de
/// idioma outra vez, eles mudam junto — senão a regex para de casar, o
/// `isNotEmpty` abaixo reprova, e é ele que impede este gate de virar vácuo.
List<int> _numbersBefore(String readme, String noun) => RegExp(
  r'(\d+)\s+' + RegExp.escape(noun),
).allMatches(readme).map((RegExpMatch m) => int.parse(m.group(1)!)).toList();

void main() {
  group('catálogo serializado', () {
    test('doc/mcp/catalog.json está em dia com o flocksCatalog', () {
      final File file = File(kCatalogPath);
      expect(
        file.existsSync(),
        isTrue,
        reason: '$kCatalogPath não existe. Rode `$kSerializeCommand`.',
      );
      expect(
        file.readAsStringSync(),
        serializedCatalog(),
        reason:
            'O catálogo serializado divergiu do código. O site lê este arquivo '
            'para publicar a contagem de componentes, então a deriva vira um '
            'número falso no ar. Rode `$kSerializeCommand` e commite o '
            'resultado.',
      );
    });

    test('todo componente do catálogo chegou ao JSON', () {
      // Redundante com a comparação de string acima quando ela passa — e é
      // exatamente esse o ponto: é esta que diz "123 contra 129" na falha, em
      // vez de um diff de milhares de linhas de JSON.
      final int serialized =
          (jsonDecode(File(kCatalogPath).readAsStringSync()) as List<Object?>)
              .length;
      expect(
        serialized,
        flocksCatalog.length,
        reason:
            'Serializados: $serialized · no código: ${flocksCatalog.length}. '
            'Rode `$kSerializeCommand`.',
      );
    });
  });

  group('os números do README batem com o código', () {
    final String readme = File('README.md').readAsStringSync();

    test('a contagem de componentes', () {
      final List<int> claimed = _numbersBefore(readme, 'components');
      expect(
        claimed,
        isNotEmpty,
        reason: 'O README parou de citar a contagem.',
      );
      for (final int n in claimed) {
        expect(
          n,
          flocksCatalog.length,
          reason:
              'O README diz $n componentes; o catálogo tem '
              '${flocksCatalog.length}.',
        );
      }
    });

    test('a contagem de tokens de ícone', () {
      final List<int> claimed = _numbersBefore(readme, 'names');
      expect(
        claimed,
        isNotEmpty,
        reason: 'O README parou de citar a contagem.',
      );
      for (final int n in claimed) {
        expect(
          n,
          AppIconToken.values.length,
          reason:
              'O README diz $n tokens de ícone; AppIconToken tem '
              '${AppIconToken.values.length}.',
        );
      }
    });

    test('a contagem de suítes de arquitetura', () {
      final int suites = Directory('test/architecture')
          .listSync()
          .whereType<File>()
          .where((File f) => f.path.endsWith('_test.dart'))
          .length;
      final List<int> claimed = _numbersBefore(readme, 'suites');
      expect(
        claimed,
        isNotEmpty,
        reason: 'O README parou de citar a contagem.',
      );
      for (final int n in claimed) {
        expect(
          n,
          suites,
          reason:
              'O README diz $n suítes de arquitetura; existem $suites em '
              'test/architecture/.',
        );
      }
    });
  });
}
