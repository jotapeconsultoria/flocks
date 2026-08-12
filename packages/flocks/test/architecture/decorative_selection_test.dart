import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Texto decorativo sobre alvo de ponteiro precisa desligar a seleção, e
/// `IgnorePointer` não faz isso na web.
///
/// `AppText` embrulha todo texto num `AppSelectionRegion`, que cria um
/// `SelectableRegion` quando existe `Overlay` ancestral. Na web o
/// `SelectableRegion` monta um platform view DOM (`Positioned.fill` com um
/// `HtmlElementView`) cujo listener chama `preventDefault()` no `mousedown` de
/// QUALQUER botão — não só o direito. Um elemento do DOM não participa do
/// hit-test do Flutter: o `IgnorePointer` que envolve o texto some para o
/// framework e continua de pé para o browser, que entrega o evento ao div.
///
/// O que isso custou, medido em https://flocks.live/demo/?screen=crud em
/// 2026-08-11: a busca do CRUD não filtrava. A dica do campo era um `AppText`,
/// logo um `SelectableRegion`, logo um div por cima da área editável;
/// `elementsFromPoint` no centro do campo devolvia
/// `div.web-selectable-region-context-menu` no topo, o `mousedown` cancelado
/// matava a transferência de foco do browser, e as teclas mutavam
/// `input.flt-text-editing.value` sem nada chegar ao Dart. No `AppBarChart`, 48
/// pontos da área do gráfico tinham um desses divs no topo, e o `pointerdown`
/// sobre uma barra coberta por rótulo de eixo nunca chegava ao gráfico.
///
/// Nenhum teste de widget pega isto: na VM o SDK usa o ramo `_io`, que é
/// passa-direto e não monta platform view nenhum. Por isso o gate é de FONTE.
///
/// A regra: se um `IgnorePointer` contém `AppText`/`ChartTooltip`, ele precisa
/// de um `SelectionContainer.disabled` imediatamente acima — que zera o
/// registrar e cai no guard que `AppSelectionRegion` já tem.
void main() {
  final List<File> dartFiles = Directory('lib/src')
      .listSync(recursive: true)
      .whereType<File>()
      .where((FileSystemEntity f) => f.path.endsWith('.dart'))
      // `.meta.dart` é catálogo (String), não árvore de widgets.
      .where((FileSystemEntity f) => !f.path.endsWith('.meta.dart'))
      .toList();

  String rel(File f) {
    final String p = f.path.replaceAll(r'\', '/');
    final int i = p.indexOf('lib/src/');
    return i == -1 ? p : p.substring(i + 'lib/src/'.length);
  }

  int indentOf(String line) => line.length - line.trimLeft().length;

  bool isComment(String line) {
    final String t = line.trimLeft();
    return t.startsWith('//') || t.startsWith('*');
  }

  /// Linhas do bloco aberto em [start], por indentação. `dart format` roda sob
  /// gate no CI, então a indentação é confiável como delimitador.
  List<String> blockAfter(List<String> lines, int start) {
    final int base = indentOf(lines[start]);
    final List<String> block = <String>[];
    for (int i = start + 1; i < lines.length; i++) {
      final String line = lines[i];
      if (line.trim().isEmpty) continue;
      if (indentOf(line) <= base) break;
      block.add(line);
    }
    return block;
  }

  /// As linhas de código (sem comentário) imediatamente acima de [start].
  List<String> codeAbove(List<String> lines, int start, int howMany) {
    final List<String> out = <String>[];
    for (int i = start - 1; i >= 0 && out.length < howMany; i--) {
      if (lines[i].trim().isEmpty || isComment(lines[i])) continue;
      out.add(lines[i]);
    }
    return out;
  }

  test('texto decorativo sob IgnorePointer desliga a seleção', () {
    final List<String> offenders = <String>[];

    for (final File f in dartFiles) {
      final List<String> lines = f.readAsLinesSync();
      for (int i = 0; i < lines.length; i++) {
        if (isComment(lines[i]) || !lines[i].contains('IgnorePointer(')) {
          continue;
        }

        final String block = blockAfter(
          lines,
          i,
        ).where((String l) => !isComment(l)).join('\n');
        final bool hasText =
            block.contains('AppText(') || block.contains('ChartTooltip(');
        if (!hasText) continue;

        final bool disabled = codeAbove(
          lines,
          i,
          4,
        ).any((String l) => l.contains('SelectionContainer.disabled'));
        if (!disabled) {
          offenders.add('${rel(f)}:${i + 1}');
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'Estes IgnorePointer envolvem texto e não desligam a seleção. Na web '
          'cada AppText aí dentro monta um platform view DOM que cancela o '
          'mousedown por cima do alvo, e o IgnorePointer não o alcança — foi o '
          'que quebrou a busca da demo. Envolva em SelectionContainer.disabled '
          '(ver molecules/input/app_input.dart):\n  ${offenders.join('\n  ')}',
    );
  });
}
