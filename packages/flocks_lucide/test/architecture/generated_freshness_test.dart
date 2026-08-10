// O que está commitado em `lib/src/generated/` é o que o gerador produz hoje.
//
// Sem este gate, a deriva é silenciosa: alguém sobe o pin, esquece de rodar o
// gerador, e o pacote passa a declarar codepoints de uma versão com a fonte de
// outra. Compila, roda, e desenha o ícone errado.
//
// A conferência chama a MESMA função que a geração (`formattedSources`), e não
// uma reimplementação dela — duas implementações da mesma regra divergem.
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flocks/flocks.dart';
import 'package:flocks_lucide/flocks_lucide.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_icons.dart';
import '../../tool/lucide_catalog.dart';

void main() {
  final LucideCatalog catalog = readVendoredCatalog();

  group('o código gerado está em dia com o catálogo', () {
    final Map<String, String> expected = formattedSources(catalog);
    for (final MapEntry<String, String> e in expected.entries) {
      test(e.key, () {
        final File file = File(e.key);
        expect(
          file.existsSync(),
          isTrue,
          reason: '${e.key} não existe. Rode `$kGenerateCommand`.',
        );
        expect(
          file.readAsStringSync(),
          e.value,
          reason:
              'O arquivo gerado divergiu do catálogo em $kCatalogPath. Rode '
              '`$kGenerateCommand` e commite o resultado.',
        );
      });
    }
  });

  group('o vendorizado é o que o pin diz que é', () {
    test('a versão do catálogo bate com a constante do código', () {
      expect(
        catalog.version,
        kLucideVersion,
        reason:
            'Alguém subiu o pin em `lucide_catalog.dart` sem rebaixar a '
            'matéria-prima. Rode `$kVendorCommand` — senão a fonte de uma '
            'versão convive com os codepoints de outra.',
      );
    });

    test('os digests do catálogo batem com as constantes do código', () {
      expect(
        (catalog.fontSha256, catalog.licenseSha256),
        (kLucideFontSha256, kLucideLicenseSha256),
        reason:
            'O catálogo foi gerado a partir de artefatos com outro digest. '
            'Rode `$kVendorCommand`.',
      );
    });

    // O digest é conferido de novo AQUI, contra o byte que está em disco — e
    // não só no download. É a diferença entre "o que baixamos era o certo" e "o
    // que está commitado continua sendo o certo": um arquivo trocado depois do
    // vendor, por merge torto ou por mão errada, passaria pelo tool sem nunca
    // ser rodado de novo.
    for (final (String label, String path, String expected)
        in <(String, String, String)>[
          (kFontFileName, '$kFontsDirectory/$kFontFileName', kLucideFontSha256),
          (
            kLicenseFileName,
            '$kFontsDirectory/$kLicenseFileName',
            kLucideLicenseSha256,
          ),
        ]) {
      test('$label em disco tem o sha256 do pin', () {
        final File file = File(path);
        expect(
          file.existsSync(),
          isTrue,
          reason: '$path não existe. Rode `$kVendorCommand`.',
        );
        expect(
          sha256.convert(file.readAsBytesSync()).toString(),
          expected,
          reason:
              'O conteúdo de $path não é o do pin de `lucide_catalog.dart`. '
              'Rode `$kVendorCommand` — ou entenda por que ele mudou antes de '
              'subir a constante.',
        );
      });
    }

    test('a TTF do pin está em disco e não veio truncada', () {
      final File font = File('$kFontsDirectory/$kFontFileName');
      expect(font.existsSync(), isTrue);
      expect(
        font.lengthSync(),
        greaterThan(100 * 1024),
        reason: 'Um download truncado passaria despercebido.',
      );
    });

    test('a licença de origem viaja junto do asset que ela cobre', () {
      // A ISC exige o aviso em toda cópia, e o arquivo do Lucide traz também a
      // parte derivada do Feather, que é MIT de outro titular. Publicar a fonte
      // sem ele seria redistribuir sem atribuição.
      final String license = File(
        '$kFontsDirectory/$kLicenseFileName',
      ).readAsStringSync();
      expect(license, contains('ISC License'));
      expect(license, contains('Lucide Icons and Contributors'));
      expect(
        license,
        contains('Feather'),
        reason:
            'O arquivo do upstream credita a parte derivada do Feather (MIT, '
            'de outro titular). Se ela sumiu, a atribuição ficou incompleta.',
      );
    });
  });

  group('o catálogo produz Dart legal', () {
    test('todo nome vira identificador legal', () {
      final RegExp identifier = RegExp(r'^[a-z][a-zA-Z0-9]*$');
      final List<String> bad = <String>[
        for (final LucideIconEntry i in catalog.icons)
          if (!identifier.hasMatch(dartIdentifier(i.name))) i.name,
      ];
      expect(
        bad,
        isEmpty,
        reason:
            'Estes nomes do upstream não viram identificador Dart válido. O '
            'gerador precisa desambiguá-los antes de emitir.',
      );
    });

    test('nomes que colidem no camelCase apontam para o mesmo desenho', () {
      // Quatro pares colidem em 1.31.0 (`arrow-down-0-1` e `arrow-down-01`, e
      // os três análogos). Colapsar é seguro exatamente enquanto o codepoint
      // for o mesmo; se um dia dois desenhos distintos colidirem, um campo só
      // passaria a desenhar o errado para uma das grafias, em silêncio.
      // `fieldsOf` lança nesse caso — este teste é o que o exercita.
      final List<Field> fields = fieldsOf(catalog);
      expect(fields, hasLength(lessThanOrEqualTo(catalog.icons.length)));
      expect(
        fields.map((Field f) => f.identifier).toSet(),
        hasLength(fields.length),
        reason: 'Dois campos com o mesmo identificador não compilariam.',
      );
    });
  });

  group('a tabela de tradução é honesta', () {
    final Set<String> names = <String>{
      for (final LucideIconEntry i in catalog.icons) i.name,
    };

    test('não traduz para nome que o catálogo não tem', () {
      final List<String> dangling = <String>[
        for (final MapEntry<String, String> e in kFlocksToLucide.entries)
          if (!names.contains(e.value)) '${e.key} → ${e.value}',
      ];
      expect(
        dangling,
        isEmpty,
        reason:
            'A tradução aponta para um nome que não existe no Lucide '
            '${catalog.version}. Um upstream que renomeia ícone deixa a tabela '
            'assim, e o gerador quebraria só na hora de emitir.',
      );
    });

    test('só lista o que de fato diverge', () {
      final List<String> redundant = <String>[
        for (final MapEntry<String, String> e in kFlocksToLucide.entries)
          if (e.key == e.value) e.key,
      ];
      expect(
        redundant,
        isEmpty,
        reason:
            'Entrada com chave igual ao valor é ruído: slug ausente da tabela '
            'já é usado como está.',
      );
    });

    test('só traduz slug que existe no contrato', () {
      final Set<String> contract = AppIconToken.values
          .map((AppIconToken t) => t.slug)
          .toSet();
      expect(
        kFlocksToLucide.keys.where((String k) => !contract.contains(k)),
        isEmpty,
        reason: 'Entrada fora do contrato é ruído: o Flocks nunca vai pedi-la.',
      );
    });
  });
}
