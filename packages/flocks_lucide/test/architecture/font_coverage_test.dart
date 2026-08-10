// Todo codepoint que o Dart escreve tem glifo na TTF que vai junto.
//
// Um codepoint sem glifo não é erro: é espaço vazio. O código compila, o app
// roda, e o ícone simplesmente não aparece — o tipo de defeito que só a revisão
// visual pega, e só se a tela em que ele mora for aberta.
//
// Este gate pergunta à FONTE, não ao catálogo. Conferir o gerado contra o
// catálogo que o gerou provaria só que o gerador é determinístico. Foi
// perguntando à fonte que se descobriu que 20 nomes do `codepoints.json` do
// Lucide não têm desenho nenhum — ver `tool/vendor_lucide.dart`.
import 'dart:io';

import 'package:flocks/flocks.dart';
import 'package:flocks_lucide/flocks_lucide.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../tool/lucide_catalog.dart';
import '../support/ttf_cmap.dart';

void main() {
  final LucideCatalog catalog = readVendoredCatalog();
  final Set<int> glyphs = readCmapCodepoints(
    File('$kFontsDirectory/$kFontFileName'),
  );

  group('a fonte desenha o que o catálogo promete', () {
    test('os ${catalog.icons.length} ícones do catálogo têm glifo', () {
      final List<String> missing = <String>[
        for (final LucideIconEntry i in catalog.icons)
          if (!glyphs.contains(i.codepoint)) i.name,
      ];
      expect(
        missing,
        isEmpty,
        reason:
            '${missing.length} codepoints do catálogo não existem em '
            '$kFontFileName. O catálogo e a fonte saíram de sincronia — rode '
            '`$kVendorCommand`.',
      );
    });

    test('a cmap foi lida de verdade — a fonte não veio vazia', () {
      // Um leitor de cmap que devolvesse `{}` faria o teste acima passar por
      // vacuidade... se a asserção fosse "nada falta". Ela é o contrário, então
      // um conjunto vazio o reprovaria. Isto aqui é o canário do canário:
      // garante que o leitor funciona antes de confiar nele.
      expect(
        glyphs.length,
        greaterThan(1500),
        reason: '$kFontFileName: cmap com ${glyphs.length} codepoints.',
      );
    });
  });

  group('o contrato inteiro tem desenho', () {
    // 55/55. É a promessa que o pacote faz ao design system, e a que um
    // adaptador quebra sem que nada mais reclame.
    test('todo AppIconToken está no mapa de contrato', () {
      final List<String> missing = <String>[
        for (final AppIconToken token in AppIconToken.values)
          if (!kLucideContract.containsKey(token.slug)) token.slug,
      ];
      expect(
        missing,
        isEmpty,
        reason:
            'Um adaptador que não cobre os 55 deixa buracos no design system. '
            'Acrescente a tradução em `kFlocksToLucide` e regenere com '
            '`$kGenerateCommand`.',
      );
      expect(kLucideContract, hasLength(AppIconToken.values.length));
    });

    test('todo glifo do contrato existe na fonte', () {
      final List<String> blank = <String>[
        for (final MapEntry<String, IconData> e in kLucideContract.entries)
          if (!glyphs.contains(e.value.codePoint)) e.key,
      ];
      expect(
        blank,
        isEmpty,
        reason:
            'Estes tokens apontam para um codepoint sem desenho na fonte: '
            'compilam, e desenham vazio.',
      );
    });

    test('o mapa do contrato só guarda IconData — nunca aninhado', () {
      // Trava de tipo herdada do phosphor, onde um mapa de objetos compostos
      // fez o tree-shaker embarcar a fonte com ZERO glifos do contrato: o app
      // desenhava tudo em branco, só no build de release.
      expect(kLucideContract, isA<Map<String, IconData>>());
    });

    test('todo glifo do contrato vem da fonte deste pacote', () {
      final Set<String?> families = kLucideContract.values
          .map((IconData g) => '${g.fontPackage}/${g.fontFamily}')
          .toSet();
      expect(families, <String>['$kFontPackage/$kFontFamily']);
    });
  });
}
