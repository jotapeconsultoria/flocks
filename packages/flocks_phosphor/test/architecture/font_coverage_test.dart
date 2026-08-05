// Todo codepoint que o Dart escreve tem glifo na TTF que vai junto.
//
// O catálogo de nomes e codepoints vem de `phosphor-icons/core`; as fontes vêm
// de `phosphor-icons/web`. São dois repositórios com numeração própria, e o
// único vínculo entre eles é o submódulo que uma tag do `web` fixa. Se esse
// vínculo se romper — alguém sobe só um dos dois pins —, o código continua
// compilando e os ícones ficam em branco, porque um codepoint sem glifo não é
// erro, é espaço vazio.
//
// Este gate pergunta à fonte, não ao catálogo. Conferir o gerado contra o
// catálogo que o gerou provaria só que o gerador é determinístico.
import 'dart:io';

import 'package:flocks_phosphor/flocks_phosphor.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../tool/phosphor_catalog.dart';
import '../support/ttf_cmap.dart';

void main() {
  final PhosphorCatalog catalog = readVendoredCatalog();
  final Map<PhosphorWeight, Set<int>> glyphs = <PhosphorWeight, Set<int>>{
    for (final PhosphorWeight w in PhosphorWeight.values)
      w: readCmapCodepoints(File('$kFontsDirectory/${w.fileName}')),
  };

  group('a fonte desenha o que o catálogo promete', () {
    for (final PhosphorWeight weight in PhosphorWeight.values) {
      test('${weight.name}: os ${catalog.icons.length} ícones têm glifo', () {
        final List<String> missing = <String>[
          for (final PhosphorIconEntry i in catalog.icons)
            if (!glyphs[weight]!.contains(i.codepoint)) i.name,
        ];
        expect(
          missing,
          isEmpty,
          reason:
              '${missing.length} codepoints do catálogo não existem em '
              '${weight.fileName}. As duas metades do upstream saíram de '
              'sincronia — rode `$kVendorCommand`.',
        );
      });
    }

    test('a cmap foi lida de verdade — nenhuma fonte veio vazia', () {
      // Um leitor de cmap que devolvesse `{}` faria todos os testes acima
      // passarem por vacuidade... se a asserção fosse "nada falta". Ela é o
      // contrário, então um conjunto vazio os reprovaria. Isto aqui é o
      // canário do canário: garante que o leitor funciona antes de confiar
      // nele para dizer que uma fonte está incompleta.
      for (final PhosphorWeight w in PhosphorWeight.values) {
        expect(
          glyphs[w]!.length,
          greaterThanOrEqualTo(catalog.icons.length),
          reason: '${w.fileName}: cmap com ${glyphs[w]!.length} codepoints.',
        );
      }
    });
  });

  group('o duotone tem as DUAS camadas de cada ícone', () {
    // A armadilha inteira deste peso. Se só a mancha existisse, o pacote
    // desenharia meio ícone, e nada avisaria.
    test('a segunda camada está na fonte', () {
      final Set<int> duotone = glyphs[PhosphorWeight.duotone]!;
      final List<String> halved = <String>[
        for (final PhosphorIconEntry i in catalog.icons)
          if (i.duotoneFigure case final int figure)
            if (!duotone.contains(figure)) i.name,
      ];
      expect(
        halved,
        isEmpty,
        reason:
            '${halved.length} ícones duotone não têm a camada de cima na '
            'fonte. O desenho sairia pela metade.',
      );
    });

    test('o par do contrato aponta para dois glifos que existem', () {
      final Set<int> duotone = glyphs[PhosphorWeight.duotone]!;
      for (final MapEntry<String, IconData> e
          in kPhosphorContractDuotoneFigure.entries) {
        expect(
          duotone,
          contains(e.value.codePoint),
          reason: '${e.key}: a camada de cima não tem glifo.',
        );
        if (kPhosphorContractDuotoneGround[e.key] case final IconData ground) {
          expect(
            duotone,
            contains(ground.codePoint),
            reason: '${e.key}: a mancha não tem glifo.',
          );
          expect(
            ground.codePoint,
            isNot(e.value.codePoint),
            reason: '${e.key}: as duas camadas são o mesmo glifo.',
          );
        }
      }
    });

    test('os mapas de contrato só guardam IconData — nunca aninhado', () {
      // O invariante que custou uma medição para aparecer. Um mapa de
      // `PhosphorDuotoneIconData` compila, passa em todo teste de unidade, e
      // embarca a fonte SEM os glifos do contrato: o `--tree-shake-icons` não
      // enxerga `IconData` aninhado dentro de outro objeto constante dentro de
      // um mapa constante. O tipo estático é o que registra a lição, porque o
      // defeito só apareceria num `flutter build --release`.
      expect(kPhosphorContractDuotoneFigure, isA<Map<String, IconData>>());
      expect(kPhosphorContractDuotoneGround, isA<Map<String, IconData>>());
      expect(kPhosphorContractRegular, isA<Map<String, IconData>>());
    });

    test('a distância entre as camadas NÃO é constante', () {
      // Canário do modelo, e não do código: registra que `codepoint + 1` é
      // falso neste upstream. Se um dia passar a ser verdade para todos, isto
      // reprova e alguém revisita a decisão de ler o par do CSS — em vez de a
      // suposição errada voltar por descuido.
      final Set<int> deltas = <int>{
        for (final PhosphorIconEntry i in catalog.icons)
          if (i.duotoneFigure case final int figure) figure - i.codepoint,
      };
      expect(
        deltas,
        isNot(<int>{1}),
        reason:
            'Se a distância virou sempre 1, o par pode voltar a ser '
            'calculado. Hoje ela varia de 1 a 33, e por isso é lida.',
      );
    });
  });

  group('os pesos são fontes diferentes, e não a mesma seis vezes', () {
    test('cada peso tem família própria', () {
      expect(<String>{
        for (final PhosphorWeight w in PhosphorWeight.values) w.fontFamily,
      }, hasLength(PhosphorWeight.values.length));
    });

    test('os arquivos têm conteúdo distinto', () {
      // Um `cp` errado no passo de vendorização deixaria seis cópias do
      // `regular` com nomes diferentes, e o eixo de peso viraria decoração.
      final Set<int> sizes = <int>{
        for (final PhosphorWeight w in PhosphorWeight.values)
          File('$kFontsDirectory/${w.fileName}').lengthSync(),
      };
      expect(
        sizes,
        hasLength(PhosphorWeight.values.length),
        reason: 'Dois pesos com o mesmo tamanho em bytes — provável cópia.',
      );
    });
  });
}
