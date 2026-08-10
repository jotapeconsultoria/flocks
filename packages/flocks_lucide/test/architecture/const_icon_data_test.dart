// Nenhum `IconData` deste pacote pode ser construído em tempo de execução.
//
// Não é preferência de estilo, é a diferença entre o build do adotante passar
// ou não. O `--tree-shake-icons` roda o `const_finder` sobre o kernel do app; se
// ele encontrar UMA instância não-constante de `IconData` em qualquer biblioteca
// alcançável, o `flutter build` **aborta**:
//
//     This application cannot tree shake icons fonts. It has non-constant
//     instances of IconData at the following locations: ...
//     Avoid non-constant invocations of IconData or try to build again with
//     --no-tree-shake-icons.
//
// (`flutter_tools/lib/src/build_system/targets/icon_tree_shaker.dart`, que
// chama `throwToolExit`.) Quem paga não é este pacote: é todo app que dependa
// dele, e o erro aponta para um arquivo que a pessoa não escreveu.
//
// Portado do `flocks_phosphor`, onde o gate nasceu.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// O que caracteriza uma construção de `IconData` em contexto constante.
///
/// Aqui são três formas, todas emitidas pelo gerador ou escritas à mão na
/// superfície pública:
///
/// - `static const IconData x = IconData(...)`, na classe completa;
/// - `'slug': IconData(...)`, num mapa de contrato, que é `const Map`;
/// - qualquer linha com um `const` explícito antes.
///
/// A varredura é textual e deliberadamente conservadora: uma linha que
/// construa `IconData` sem uma dessas âncoras é reprovada, e o jeito de
/// satisfazê-la é escrever `const`. Reconhecer forma a mais é o risco a
/// evitar; reconhecer de menos só custa uma linha aqui.
///
/// Mora aqui em cima, e não dentro de cada teste, porque o canário lá embaixo
/// precisa exercitar ESTA regex. Uma cópia dela provaria só que a cópia
/// funciona — que é a forma de vacuidade que este arquivo existe para evitar.
final RegExp kConstContext = RegExp(
  r'(const .*IconData\(|'
  r'static const IconData \w+ =|'
  r"^\s*'[a-z0-9-]+': IconData\()",
);

/// O que conta como construção de `IconData`.
///
/// O limite à esquerda vem do molde: sem ele, um tipo terminado em `IconData(`
/// casa por sufixo e o gate reprova declarações perfeitamente constantes. Foi o
/// primeiro resultado do gate no `flocks_phosphor`, onde
/// `PhosphorDuotoneIconData` disparava exatamente isso.
final RegExp kIconDataCall = RegExp(r'(?<![A-Za-z0-9_$])IconData\(');

/// Toda ocorrência de `IconData(` em `lib/`, com arquivo e linha.
Iterable<(File, int, String)> _iconDataSites() sync* {
  for (final FileSystemEntity entity in Directory(
    'lib',
  ).listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) {
      continue;
    }
    final List<String> lines = entity.readAsLinesSync();
    for (int i = 0; i < lines.length; i++) {
      if (kIconDataCall.hasMatch(lines[i])) {
        yield (entity, i + 1, lines[i]);
      }
    }
  }
}

void main() {
  group('todo IconData do pacote é constante', () {
    test('nenhuma construção fora de um contexto const', () {
      final List<String> offenders = <String>[
        for (final (File file, int line, String source) in _iconDataSites())
          if (!kConstContext.hasMatch(source) &&
              !source.trimLeft().startsWith('///') &&
              !source.trimLeft().startsWith('//'))
            '${file.path}:$line — ${source.trim()}',
      ];
      expect(
        offenders,
        isEmpty,
        reason:
            'Instância não-constante de IconData. Isto não degrada nada: faz '
            '`flutter build --release` ABORTAR em todo app que dependa deste '
            'pacote, com um erro apontando para um arquivo que a pessoa não '
            'escreveu. Escreva o codepoint como constante.',
      );
    });

    test('o gate não é vácuo — ele de fato vê os IconData do pacote', () {
      // Canário: se a varredura parasse de achar arquivo (um `lib/` movido, um
      // filtro de extensão errado), a lista de ofensores ficaria vazia e o
      // teste acima passaria sem ter olhado nada. Já aconteceu de um gate por
      // texto medir o próprio silêncio.
      expect(
        _iconDataSites().length,
        greaterThan(2000),
        reason:
            'A varredura achou pouca coisa. São 2.021 campos na classe mais os '
            '55 do contrato — se caiu, ela deixou de enxergar os arquivos '
            'gerados, e o gate acima virou vácuo.',
      );
    });

    test('o detector não casa por sufixo de outro tipo', () {
      expect(
        kIconDataCall.hasMatch('  ) = LucideDuotoneIconData('),
        isFalse,
        reason:
            'Sem o limite à esquerda, o sufixo casa e o gate reprovaria '
            'declarações corretas — o primeiro resultado do gate no phosphor.',
      );
      expect(kIconDataCall.hasMatch("  'check': IconData(0xe000,"), isTrue);
    });

    test('o gate reprova uma linha não-constante de verdade', () {
      // O canário do canário: adulterar a PRODUÇÃO e ver reprovar. Sem isto,
      // "nenhum ofensor" pode significar "a regex não casa com nada".
      expect(
        kConstContext.hasMatch('  final IconData bad = IconData(base + 1);'),
        isFalse,
        reason: 'A regex aceitaria uma construção em execução.',
      );
      expect(
        kConstContext.hasMatch(
          '  static const IconData accessibility = IconData(0xe297,',
        ),
        isTrue,
        reason: 'A regex rejeitaria a declaração legítima que o gerador emite.',
      );
    });
  });
}
