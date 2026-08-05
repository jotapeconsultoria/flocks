import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Regra 1 — o estado de interação (hover/pressed/focused) vem de
/// `FlocksInteraction`, não de `bool` no `State` de cada componente.
///
/// Um `bool _isHovered` isolado não é só duplicação: ele nunca ganha o resto
/// do pacote do primitivo — foco por Tab, Enter/Space, `pressed`, cursor de
/// desabilitado. Era o caso do header do calendário, que tinha três hovers
/// paralelos e **nenhum** foco por teclado.

/// Casos em que o campo de estado é a resposta CERTA — o primitivo não cobre
/// a forma do problema. Cada entrada diz por quê.
const Map<String, String> kInteractionStateExempt = <String, String>{
  // Hover de "qual dos N", e o N mora num `OverlayEntry` — uma árvore de
  // elementos à parte, que o pai repinta por `markNeedsBuild()`. O realce não
  // é estado de UM alvo: é o índice do alvo sob o ponteiro. As linhas em si
  // já usam FlocksInteraction (foco e ativação vêm dele).
  'molecules/dropdown/app_dropdown.dart': 'índice da opção sob o ponteiro',
  'molecules/dropdown/app_multi_select.dart': 'índice da opção sob o ponteiro',
  'molecules/dropdown/app_searchable_dropdown.dart':
      'índice da opção sob o ponteiro',
  'molecules/dropdown/app_searchable_multi_select.dart':
      'índice da opção sob o ponteiro',

  // Mesma forma, numa grade: `_hoveredDay/_hoveredMonth/_hoveredYear` é a
  // célula sob o ponteiro, não o estado de um botão.
  'molecules/date_picker/app_date_picker.dart': 'célula do grid sob o ponteiro',
  'molecules/date_picker/app_date_range_picker.dart':
      'célula do grid sob o ponteiro',

  // A linha inteira acende quando o ponteiro entra em QUALQUER célula — e um
  // `Table` é um único render object. Nenhuma célula pode ser dona do estado
  // da linha; o pai tem de ser.
  'organisms/data_table/app_data_table.dart': 'linha inteira de um Table',

  // `AppHoverHighlight` é o primitivo do DS para o caso simétrico: realce de
  // hover em coisa NÃO interativa. FlocksInteraction não serve — sem handler
  // ele entra em `disabled` e não reporta hover nenhum.
  'molecules/interactive/app_hover_highlight.dart':
      'primitivo de hover em conteúdo não interativo',

  // Alça de arraste: o estado que importa é `_dragging`, que não é um
  // WidgetState. FlocksInteraction não modela pan.
  'organisms/resizable_panel/resize_gutter.dart': 'alça de arraste, não de tap',

  // Campo de texto. O primitivo da Regra 7 para editável é
  // `AppTextSelectionGestures` sobre `EditableText` — o `GestureDetector` do
  // FlocksInteraction disputaria a arena com os gestos de seleção (o mesmo
  // conflito que já quebrou o arraste das sheets).
  'molecules/input/app_input.dart': 'foco de EditableText (Regra 7)',
  'molecules/color_picker/app_color_picker_input.dart':
      'foco de EditableText (Regra 7)',
};

/// Dívida: aqui o primitivo SERVE, e a migração só não foi feita ainda. Não
/// confundir com [kInteractionStateExempt] — estes devem esvaziar.
const Map<String, String> kInteractionStateDebt = <String, String>{
  // O realce é pintado FORA do detector (o `AnimatedContainer` embrulha o
  // `MouseRegion`), então migrar exige inverter a estrutura, e a área de toque
  // hoje é `translucent`. Mudança de geometria de alvo — merece rodada própria.
  'organisms/navigation_rail/app_navigation_rail.dart':
      'realce pintado fora do detector; inverter mexe na área de toque',
  'organisms/tab_view/app_tab_view.dart':
      'realce pintado fora do detector; inverter mexe na área de toque',

  // Satélite do list_tile: o dono decidiu que estes ficam documentados como
  // sucedidos até o `AppListTile` do tracked_shared_pkg virar shim. Migrar
  // agora é investir numa peça em fila de remoção.
  'molecules/list_tile/app_list_tile_draggable_checkbox.dart':
      'satélite em fila de cutover do list_tile',

  // A ABA (o `X` de fechar do mesmo arquivo já migrou). `foreground` e
  // `backgroundColor` são derivados por contraste ANTES da árvore e usados em
  // pontos espalhados dela, então o builder do primitivo exige reestruturar um
  // `build` cuja geometria de asas está calibrada comentário a comentário.
  'organisms/workspace_tabs/app_workspace_tabs.dart':
      'cores derivadas acima da árvore; migrar reestrutura o build',
};

void main() {
  final List<File> dartFiles = Directory('lib/src')
      .listSync(recursive: true)
      .whereType<File>()
      .where((FileSystemEntity f) => f.path.endsWith('.dart'))
      // `foundation/` é quem IMPLEMENTA o primitivo.
      .where((FileSystemEntity f) => !f.path.contains('lib/src/foundation/'))
      .where(
        (FileSystemEntity f) =>
            !f.path.endsWith('.meta.dart') && !f.path.endsWith('.preview.dart'),
      )
      .toList();

  String rel(File f) {
    final String p = f.path.replaceAll(r'\', '/');
    final int i = p.indexOf('lib/src/');
    return i == -1 ? p : p.substring(i + 'lib/src/'.length);
  }

  /// Declaração de campo de estado de interação: `bool _isHovered = false;`,
  /// `int? _hoveredIndex;`, `bool _pressed = false;`… O filtro de tipo evita
  /// casar `FocusNode _focusNode` (que é o nó, não o estado).
  final RegExp stateField = RegExp(
    r'^\s*(?:late\s+)?(?:bool|int)\??\s+_\w*(?:[Hh]over|[Pp]ress|[Ff]ocus)\w*\s*[=;]',
    multiLine: true,
  );

  String codeOf(File f) => f
      .readAsLinesSync()
      .where((String l) {
        final String t = l.trimLeft();
        return !t.startsWith('///') &&
            !t.startsWith('//') &&
            !t.startsWith('*');
      })
      .join('\n');

  test('as duas listas são disjuntas', () {
    final Set<String> both = kInteractionStateExempt.keys.toSet().intersection(
      kInteractionStateDebt.keys.toSet(),
    );
    expect(
      both,
      isEmpty,
      reason:
          'Um path é isenção (o primitivo não serve) OU dívida (serve e falta '
          'fazer). Nunca os dois: $both',
    );
  });

  test('nenhum componente novo inventa estado de interação', () {
    final List<String> offenders = <String>[
      for (final File f in dartFiles)
        if (!kInteractionStateExempt.containsKey(rel(f)) &&
            !kInteractionStateDebt.containsKey(rel(f)) &&
            stateField.hasMatch(codeOf(f)))
          rel(f),
    ];
    expect(
      offenders,
      isEmpty,
      reason:
          'Hover/pressed/focus saem de FlocksInteraction — que já traz Tab, '
          'Enter/Space e cursor de desabilitado junto. Se a forma do problema '
          'não couber no primitivo (índice de uma lista, alça de arraste, '
          'campo de texto), classifique em kInteractionStateExempt com o '
          'motivo: $offenders',
    );
  });

  test('nenhuma entrada das listas envelheceu', () {
    final Set<String> onDisk = dartFiles.map(rel).toSet();
    final List<String> stale = <String>[
      for (final String p in <String>[
        ...kInteractionStateExempt.keys,
        ...kInteractionStateDebt.keys,
      ])
        if (!onDisk.contains(p) ||
            !stateField.hasMatch(codeOf(File('lib/src/$p'))))
          p,
    ];
    expect(
      stale,
      isEmpty,
      reason:
          'Entrada sem campo correspondente em disco — o arquivo foi renomeado, '
          'ou a migração já aconteceu e a linha ficou para trás. Remova: $stale',
    );
  });
}
