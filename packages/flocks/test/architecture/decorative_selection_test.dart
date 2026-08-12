import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Texto decorativo sob `IgnorePointer` precisa desligar a seleção, porque na
/// web o `IgnorePointer` não alcança o que o `SelectableRegion` monta.
///
/// `AppText` embrulha todo texto num `AppSelectionRegion`, que cria um
/// `SelectableRegion` quando existe `Overlay` ancestral. Na web o
/// `SelectableRegion` monta um `PlatformSelectableRegionContextMenu`: um
/// `Positioned.fill` com `HtmlElementView`, ou seja **um elemento real do DOM**
/// cobrindo a região.
///
/// Um elemento do DOM não participa do hit-test do Flutter. O `IgnorePointer`
/// desaparece para o framework e o div continua de pé para o navegador — então
/// texto marcado como decorativo segue oferecendo seleção e menu de contexto
/// sobre área que devia ser só alvo de interação. Medido em
/// https://flocks.live/demo/?screen=crud em 2026-08-11: `elementsFromPoint` no
/// centro do campo de busca devolvia `div.web-selectable-region-context-menu` no
/// topo, e eram 21 desses divs numa tela. No `AppBarChart` do widgetbook, 48
/// pontos da área do gráfico tinham um deles no topo, porque os rótulos do eixo
/// X caem sobre as barras.
///
/// O que este gate **não** afirma: que esses divs sejam a causa da busca do CRUD
/// não filtrar. Essa hipótese foi levantada e **refutada** por medição em
/// 2026-08-12 — com o ponteiro sobre o div o Flutter aplicava
/// `SystemMouseCursors.text` (logo hit-testou por baixo), o
/// `input.flt-text-editing` só nasce depois do clique (logo o clique chegou ao
/// Dart), e o sintoma se repetiu idêntico clicando DENTRO do campo e FORA do rect
/// do div, onde não há listener nenhum. A causa da busca segue desconhecida; o
/// que se conserta aqui é a interceptação de seleção, que é real e é medível.
///
/// Nenhum teste de widget pega isto: na VM o SDK usa o ramo `_io` do platform
/// view, que é passa-direto e não monta elemento nenhum. Por isso o gate é de
/// FONTE.
///
/// A regra: se um `IgnorePointer` contém texto, ele precisa de um
/// `SelectionContainer.disabled` como envelope IMEDIATO — que zera o registrar e
/// cai no guard que `AppSelectionRegion` já tem.
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
    return t.startsWith('//') || t.startsWith('*') || t.startsWith('/*');
  }

  /// O bloco aberto em [start]: o RESTO da própria linha (a forma de uma linha,
  /// `cond ? IgnorePointer(child: box) : box`, vive toda aqui) mais as linhas
  /// seguintes mais indentadas. `dart format` roda sob gate no CI, então a
  /// indentação é confiável como delimitador.
  String subtreeAt(List<String> lines, int start, int fromColumn) {
    final StringBuffer out = StringBuffer(lines[start].substring(fromColumn));
    final int base = indentOf(lines[start]);
    for (int i = start + 1; i < lines.length; i++) {
      final String line = lines[i];
      if (line.trim().isEmpty) continue;
      if (indentOf(line) <= base) break;
      if (isComment(line)) continue;
      out.writeln(line);
    }
    return out.toString();
  }

  /// Nomes de tipo que RENDERIZAM texto, resolvidos transitivamente: `AppText`,
  /// mais toda classe cujo corpo mencione um nome já no conjunto. É o que torna
  /// visível um filho como `_StepLabel(...)` ou `ChartTooltip(...)`, que a busca
  /// literal por `AppText(` não via.
  Set<String> textBearingTypes() {
    final RegExp classDecl = RegExp(
      r'^(?:final |abstract |sealed |base |mixin )*class (\w+)',
    );
    final Map<String, String> bodyOf = <String, String>{};

    for (final File f in dartFiles) {
      final List<String> lines = f.readAsLinesSync();
      for (int i = 0; i < lines.length; i++) {
        final RegExpMatch? m = classDecl.firstMatch(lines[i]);
        if (m == null) continue;
        final StringBuffer body = StringBuffer();
        for (int j = i + 1; j < lines.length; j++) {
          if (lines[j].startsWith('}')) break;
          if (!isComment(lines[j])) body.writeln(lines[j]);
        }
        bodyOf[m.group(1)!] = body.toString();
      }
    }

    final Set<String> bearing = <String>{'AppText'};
    bool changed = true;
    while (changed) {
      changed = false;
      for (final MapEntry<String, String> e in bodyOf.entries) {
        if (bearing.contains(e.key)) continue;
        if (bearing.any((String t) => e.value.contains('$t('))) {
          bearing.add(e.key);
          changed = true;
        }
      }
    }
    return bearing;
  }

  final Set<String> bearing = textBearingTypes();

  /// O valor atribuído ao identificador [name] no mesmo arquivo, se houver — para
  /// enxergar um filho passado por VARIÁVEL (`IgnorePointer(child: labelWidget)`).
  String resolveLocal(List<String> lines, String name) {
    final RegExp decl = RegExp(
      r'(?:final|var|const|Widget)\s+' + RegExp.escape(name) + r'\b\s*=',
    );
    for (int i = 0; i < lines.length; i++) {
      if (isComment(lines[i])) continue;
      final RegExpMatch? m = decl.firstMatch(lines[i]);
      if (m == null) continue;
      return subtreeAt(lines, i, m.end);
    }
    return '';
  }

  bool mentionsText(String source, List<String> lines, {int depth = 1}) {
    if (bearing.any((String t) => source.contains('$t('))) return true;
    if (depth <= 0) return false;
    // Identificadores nus que possam ser o filho, resolvidos um nível.
    for (final RegExpMatch m in RegExp(r'\b([a-z_]\w*)\b').allMatches(source)) {
      final String id = m.group(1)!;
      if (const <String>{
        'child',
        'children',
        'true',
        'false',
        'null',
        'return',
        'const',
        'final',
        'if',
        'else',
        'context',
      }.contains(id)) {
        continue;
      }
      final String resolved = resolveLocal(lines, id);
      if (resolved.isEmpty) continue;
      if (mentionsText(resolved, lines, depth: depth - 1)) return true;
    }
    return false;
  }

  test('texto decorativo sob IgnorePointer desliga a seleção', () {
    final List<String> offenders = <String>[];

    for (final File f in dartFiles) {
      final List<String> lines = f.readAsLinesSync();
      for (int i = 0; i < lines.length; i++) {
        if (isComment(lines[i])) continue;
        final int at = lines[i].indexOf('IgnorePointer(');
        if (at == -1) continue;

        final String subtree = subtreeAt(
          lines,
          i,
          at + 'IgnorePointer('.length,
        );
        if (!mentionsText(subtree, lines)) continue;

        // Precisa ser ANCESTRAL, não irmão. Subindo, só é ancestral a linha com
        // indentação ESTRITAMENTE menor que a última aceita: um
        // `SelectionContainer.disabled` irmão fica na mesma indentação e é
        // descartado, enquanto um envelope legítimo com um `AppSemantics.
        // decorative` no meio (como em `app_input.dart`) continua valendo.
        bool wrapped = lines[i]
            .substring(0, at)
            .contains('SelectionContainer.disabled(');
        int need = indentOf(lines[i]);
        for (int j = i - 1; j >= 0 && !wrapped && need > 2; j--) {
          if (lines[j].trim().isEmpty || isComment(lines[j])) continue;
          final int ind = indentOf(lines[j]);
          if (ind >= need) continue;
          need = ind;
          if (lines[j].contains('SelectionContainer.disabled(')) wrapped = true;
        }

        if (!wrapped) offenders.add('${rel(f)}:${i + 1}');
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'Estes IgnorePointer envolvem texto e não desligam a seleção. Na web '
          'cada AppText aí dentro monta um platform view DOM sobre o alvo, '
          'oferecendo seleção e menu de contexto onde devia haver só interação — '
          'e o IgnorePointer não o alcança, porque elemento do DOM não participa '
          'do hit-test do Flutter. Envolva em SelectionContainer.disabled (ver '
          'molecules/input/app_input.dart):\n  ${offenders.join('\n  ')}',
    );
  });
}
