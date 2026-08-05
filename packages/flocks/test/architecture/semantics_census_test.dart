import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Regra 8 — todo alvo tocável do design system chega nomeado ao leitor de
/// tela.
///
/// Os dois bugs de acessibilidade desta campanha (header do calendário mudo,
/// `AppTooltip` cuja mensagem nunca saía do pixel) foram achados por LEITURA,
/// não por gate — porque não havia gate. Este é o gate.

/// Arquivos que não precisam de semântica própria: não desenham alvo, ou o
/// alvo é de quem os usa.
const Map<String, String> kSemanticsNotATarget = <String, String>{
  // Primitivos: recebem a aparência e o gesto de fora. Quem embrulha é que
  // sabe se aquilo é botão, toggle ou campo — e é quem chama `AppSemantics`.
  'foundation/flocks_interaction.dart': 'primitivo; o papel é do chamador',
  'foundation/selection/app_text_selection_gestures.dart':
      'mixin de gestos de seleção de texto',
  'motion/widgets/app_interactive_motion.dart': 'envelope de animação',
  'motion/widgets/app_scale_on_tap.dart': 'envelope de animação',
};

/// Arquivos cujo alvo é nomeado por OUTRO arquivo, que o teste cobra que
/// carregue semântica. Espelha `kMotionDelegates`: a corrente tem de terminar
/// em alguém que fala com o leitor de tela.
const Map<String, String> kSemanticsDelegates = <String, String>{
  // Os dois botões públicos montam a árvore no ButtonCore, que embrulha em
  // `AppSemantics.button` — inclusive a regra de não anunciar o rótulo duas
  // vezes quando há um AppText filho.
  'molecules/buttons/app_button.dart': 'molecules/buttons/button_core.dart',
  'molecules/buttons/app_floating_button.dart':
      'molecules/buttons/button_core.dart',

  // Gatilho e linhas de opção saem de `dropdown_internals`, que usa
  // `AppSemantics.expandable` (o combobox anuncia se está aberto).
  'molecules/dropdown/app_dropdown.dart':
      'molecules/dropdown/dropdown_internals.dart',
  'molecules/dropdown/app_multi_select.dart':
      'molecules/dropdown/dropdown_internals.dart',
  'molecules/dropdown/app_searchable_dropdown.dart':
      'molecules/dropdown/dropdown_internals.dart',
  'molecules/dropdown/app_searchable_multi_select.dart':
      'molecules/dropdown/dropdown_internals.dart',

  // O gatilho destes é um `AppInput`, que agora é um textField nomeado.
  'molecules/input/app_date_picker_input.dart':
      'molecules/input/app_input.dart',
  'molecules/input/app_date_time_picker_input.dart':
      'molecules/input/app_input.dart',
  'molecules/input/app_time_picker_input.dart':
      'molecules/input/app_input.dart',
  'molecules/footers/app_search_footer.dart': 'molecules/input/app_input.dart',
  'molecules/color_picker/app_color_picker_input.dart':
      'molecules/input/app_input.dart',

  // A alça de redimensionar não tem texto nenhum: o nome dela É a dica
  // ('Redimensionar'), que o AppTooltip passou a publicar em `Semantics.tooltip`.
  'organisms/resizable_panel/resize_gutter.dart':
      'molecules/tooltip/app_tooltip.dart',

  // Só encaminha o `onTap` para o tile, que é quem monta a linha.
  'organisms/api_docs/app_api_flow.dart':
      'organisms/api_docs/app_api_endpoint_tile.dart',

  // O motor de arraste da superfície. Quem declara a fronteira de rota é a
  // ROTA (`AppSemantics.modalRoute`), não o widget que a preenche.
  'organisms/side_sheets/side_sheet_engine.dart':
      'organisms/side_sheets/side_sheet_route.dart',
};

void main() {
  final List<File> dartFiles = Directory('lib/src')
      .listSync(recursive: true)
      .whereType<File>()
      .where((FileSystemEntity f) => f.path.endsWith('.dart'))
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

  String codeOf(File f) => f
      .readAsLinesSync()
      .where((String l) {
        final String t = l.trimLeft();
        return !t.startsWith('///') &&
            !t.startsWith('//') &&
            !t.startsWith('*');
      })
      .join('\n');

  /// O arquivo desenha um alvo que responde a toque?
  final RegExp target = RegExp(
    r'(onTap:|onPressed:|GestureDetector\(|FlocksInteraction\(|AppInteraction\()',
  );

  /// O arquivo fala com a camada de acessibilidade?
  final RegExp speaks = RegExp(
    r'(AppSemantics\.|Semantics\(|semanticLabel|semanticsLabel'
    r'|ExcludeSemantics|MergeSemantics)',
  );

  test('as duas listas são disjuntas', () {
    final Set<String> both = kSemanticsNotATarget.keys.toSet().intersection(
      kSemanticsDelegates.keys.toSet(),
    );
    expect(both, isEmpty, reason: 'Path nas duas listas: $both');
  });

  test('todo alvo tocável fala com o leitor de tela', () {
    final List<String> mute = <String>[
      for (final File f in dartFiles)
        if (target.hasMatch(codeOf(f)) &&
            !speaks.hasMatch(codeOf(f)) &&
            !kSemanticsNotATarget.containsKey(rel(f)) &&
            !kSemanticsDelegates.containsKey(rel(f)))
          rel(f),
    ];
    expect(
      mute,
      isEmpty,
      reason:
          'Alvo tocável sem nome: o leitor de tela anuncia um controle e não '
          'diz o que ele faz. Embrulhe com a fábrica do papel certo '
          '(AppSemantics.button/toggle/textField/expandable/gridCell) — ou, se '
          'quem nomeia é outro arquivo, registre em kSemanticsDelegates: $mute',
    );
  });

  test('a delegação de semântica termina em alguém que fala', () {
    final List<String> broken = <String>[];
    kSemanticsDelegates.forEach((String path, String owner) {
      final File f = File('lib/src/$owner');
      if (!f.existsSync() || !speaks.hasMatch(codeOf(f))) {
        broken.add('$path → $owner');
      }
    });
    expect(
      broken,
      isEmpty,
      reason:
          'O arquivo apontado como dono do nome não fala mais com o leitor — '
          'a delegação virou um buraco silencioso: $broken',
    );
  });

  test('nenhuma entrada das listas envelheceu', () {
    final Set<String> onDisk = dartFiles.map(rel).toSet();
    final List<String> stale = <String>[
      for (final String p in <String>[
        ...kSemanticsNotATarget.keys,
        ...kSemanticsDelegates.keys,
      ])
        if (!onDisk.contains(p) || !target.hasMatch(codeOf(File('lib/src/$p'))))
          p,
    ];
    expect(
      stale,
      isEmpty,
      reason:
          'Entrada sem alvo correspondente em disco — arquivo renomeado, ou o '
          'alvo saiu. Remova: $stale',
    );
  });
}
