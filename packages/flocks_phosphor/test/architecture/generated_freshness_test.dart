// Número gerado não pode derivar do que foi commitado.
//
// O core já viveu isto: `doc/mcp/catalog.json` derivou duas vezes em três dias
// — 123 serializados contra 129 reais — porque regenerar era um passo manual
// que ninguém lembrava, e nada ficava vermelho. Aqui a superfície é maior: são
// 9.072 constantes em seis arquivos, e um codepoint errado não quebra a
// compilação, desenha o ícone errado.
//
// O remédio é o mesmo: geração e conferência partem da MESMA função
// (`formattedSources`), e a conferência roda no `flutter test` de todo PR.
import 'dart:io';

import 'package:flocks/flocks.dart';
import 'package:flocks_phosphor/flocks_phosphor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_icons.dart';
import '../../tool/phosphor_catalog.dart';

void main() {
  final PhosphorCatalog catalog = readVendoredCatalog();

  group('o gerado está em dia com o catálogo fixado', () {
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
              'O arquivo gerado divergiu do catálogo em $kCatalogPath. '
              'Rode `$kGenerateCommand` e commite o resultado.',
        );
      });
    }
  });

  group('o catálogo vendorizado é o que o pin diz', () {
    test('a versão do arquivo bate com as constantes do código', () {
      expect(
        (catalog.coreCommit, catalog.webTag),
        (kPhosphorCoreCommit, kPhosphorWebTag),
        reason:
            'Alguém subiu o pin em `phosphor_catalog.dart` sem rebaixar a '
            'matéria-prima. Rode `$kVendorCommand` — senão as fontes de uma '
            'versão convivem com os codepoints de outra.',
      );
    });

    test('as seis TTFs do pin estão em disco', () {
      for (final PhosphorWeight w in PhosphorWeight.values) {
        final File font = File('$kFontsDirectory/${w.fileName}');
        expect(font.existsSync(), isTrue, reason: 'falta ${w.fileName}');
        expect(
          font.lengthSync(),
          greaterThan(100 * 1024),
          reason:
              '${w.fileName} tem ${font.lengthSync()} bytes — não é uma TTF '
              'inteira. Um download truncado passaria despercebido até um '
              'ícone sumir em produção.',
        );
      }
    });

    test('a segunda camada do duotone nunca é o desenho de outro ícone', () {
      // O invariante que substitui o `codepoint + 1` que a gente achava que
      // valia. Como o par vem lido e não calculado, o que importa não é a
      // distância: é que nenhum contorno caia em cima do codepoint que outro
      // ícone usa como desenho principal. Se caísse, `wifi-high` desenharia o
      // contorno de `wifi-medium` sobre a própria mancha, e o defeito seria
      // visual, não de compilação.
      final Set<int> bases = <int>{
        for (final PhosphorIconEntry i in catalog.icons) i.codepoint,
      };
      final Map<int, String> figures = <int, String>{
        for (final PhosphorIconEntry i in catalog.icons)
          if (i.duotoneFigure case final int figure) figure: i.name,
      };
      expect(<String>[
        for (final MapEntry<int, String> f in figures.entries)
          if (bases.contains(f.key)) f.value,
      ], isEmpty);
    });

    test('a segunda camada é sempre diferente da primeira', () {
      expect(
        <String>[
          for (final PhosphorIconEntry i in catalog.icons)
            if (i.duotoneFigure == i.codepoint) i.name,
        ],
        isEmpty,
        reason: 'Empilhar o mesmo glifo duas vezes só engrossa o traço.',
      );
    });

    test('só os dois ícones conhecidos têm camada única', () {
      // Fixado por nome de propósito. Se o upstream passar a publicar um
      // terceiro, isto reprova e alguém decide conscientemente — em vez de o
      // ícone aparecer apagado e ninguém ligar as duas coisas.
      expect(
        <String>[
          for (final PhosphorIconEntry i in catalog.icons)
            if (i.duotoneFigure == null) i.name,
        ],
        <String>['cell-signal-none', 'wifi-none'],
      );
    });
  });

  group('os identificadores gerados são Dart válido', () {
    // O compilador já pegaria um identificador inválido — mas só depois de
    // alguém regenerar e tentar compilar 9.072 constantes. Esta é a mensagem
    // que diz QUAL nome do upstream causou.
    final RegExp valid = RegExp(r'^[a-z][a-zA-Z0-9]*$');

    test('todo nome do catálogo vira identificador legal', () {
      final List<String> invalid = <String>[
        for (final PhosphorIconEntry i in catalog.icons) ...<String>[
          if (!valid.hasMatch(dartIdentifier(i.name))) i.name,
          for (final String alias in i.aliases)
            if (!valid.hasMatch(dartIdentifier(alias))) alias,
        ],
      ];
      expect(invalid, isEmpty);
    });

    test('nome e apelido não colidem depois de virar camelCase', () {
      final Map<String, List<String>> byIdentifier = <String, List<String>>{};
      for (final PhosphorIconEntry i in catalog.icons) {
        for (final String name in <String>[i.name, ...i.aliases]) {
          byIdentifier
              .putIfAbsent(dartIdentifier(name), () => <String>[])
              .add(name);
        }
      }
      expect(
        <String, List<String>>{
          for (final MapEntry<String, List<String>> e in byIdentifier.entries)
            if (e.value.length > 1) e.key: e.value,
        },
        isEmpty,
        reason:
            'Dois nomes do upstream viraram o mesmo campo. O segundo '
            'sobrescreveria o primeiro em silêncio.',
      );
    });
  });

  group('o contrato do Flocks e a tabela de tradução se sustentam', () {
    test('a tabela não traduz para nome que o catálogo não tem', () {
      final Set<String> known = <String>{
        for (final PhosphorIconEntry i in catalog.icons) ...<String>[
          i.name,
          ...i.aliases,
        ],
      };
      final List<String> broken = <String>[
        for (final MapEntry<String, String> e in kFlocksToPhosphor.entries)
          if (!known.contains(e.value)) '${e.key} -> ${e.value}',
      ];
      expect(
        broken,
        isEmpty,
        reason:
            'A tradução aponta para um ícone que não existe na versão fixada. '
            'O upstream renomeou algo.',
      );
    });

    test('a tabela só lista o que de fato diverge', () {
      expect(
        <String>[
          for (final MapEntry<String, String> e in kFlocksToPhosphor.entries)
            if (e.key == e.value) e.key,
        ],
        isEmpty,
        reason: 'Entrada que traduz para si mesma é ruído.',
      );
    });

    test('todo AppIconToken está nos seis mapas de contrato', () {
      // O teste de contrato cruzado que só roda porque os três pacotes moram
      // no mesmo repositório. Separados, ele dependeria de publicar primeiro.
      for (final PhosphorWeight w in PhosphorWeight.values) {
        expect(
          _contractKeys(w),
          AppIconToken.values.map((AppIconToken t) => t.slug).toSet(),
          reason:
              'O mapa de ${w.name} não é exatamente o contrato. Ou entrou '
              'token novo em `AppIconToken` e ninguém regenerou, ou sobrou '
              'chave de um token que saiu.',
        );
      }
    });
  });
}

/// As chaves do mapa de contrato de [weight].
Set<String> _contractKeys(PhosphorWeight weight) => switch (weight) {
  PhosphorWeight.thin => kPhosphorContractThin.keys.toSet(),
  PhosphorWeight.light => kPhosphorContractLight.keys.toSet(),
  PhosphorWeight.regular => kPhosphorContractRegular.keys.toSet(),
  PhosphorWeight.bold => kPhosphorContractBold.keys.toSet(),
  PhosphorWeight.fill => kPhosphorContractFill.keys.toSet(),
  PhosphorWeight.duotone => kPhosphorContractDuotoneFigure.keys.toSet(),
};
