import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Usos da escala CONST `AppRadius.*` que **não** são canto de superfície — e
/// por isso não passam pelo eixo global de forma (`theme.radiusTheme`).
///
/// A régua para entrar aqui: o valor é um canto que o usuário lê como a forma
/// do componente? Se sim, é do eixo. Se é um comprimento, uma geometria
/// bespoke ou algo que não é o Flocks desenhando uma superfície, entra aqui
/// com o motivo.
const Map<String, String> kRadiusAxisExempt = <String, String>{
  // O caret do texto. Não é a forma de uma superfície: é a espessura de um
  // cursor de 1px. Uma marca `reto` não deveria esquadrejar o cursor — e uma
  // marca `circular` viraria o caret numa cápsula.
  'molecules/input/app_input.dart': 'cursorRadius do caret',
  'molecules/color_picker/app_color_picker_panel.dart': 'cursorRadius do caret',
  'molecules/color_picker/app_color_picker_input.dart': 'cursorRadius do caret',

  // Moldura de DISPOSITIVO simulada (insets de notch/home indicator), usada só
  // pelos `.preview.dart` de headers/footers. É o raio do aparelho de mentira,
  // não de um componente do design system.
  'atoms/bars/bar_preview_scene.dart': 'canto do aparelho simulado na preview',

  // Raio usado como COMPRIMENTO: o respiro horizontal que mantém o rótulo fora
  // da curva da asa. Anda junto do `_activeWingRadius` das workspace tabs (a
  // barra que convive com esta na mesma tela) — theme-lo aqui sozinho
  // desalinharia as duas.
  'organisms/tab_view/app_tab_view.dart': 'raio como padding, não como canto',

  // Geometria da silhueta bespoke (`WorkspaceTabShape`): a asa CÔNCAVA que
  // liga a aba ativa à barra, no formato de aba de navegador. Não é um canto
  // arredondado — é um arco invertido, e o raio dos cantos de cima da mesma
  // silhueta (`_activeTopRadius`) já é um literal calibrado à mão.
  'organisms/workspace_tabs/app_workspace_tabs.dart':
      'arco côncavo da silhueta de aba',
};

void main() {
  final List<File> dartFiles = Directory('lib/src')
      .listSync(recursive: true)
      .whereType<File>()
      .where((FileSystemEntity f) => f.path.endsWith('.dart'))
      // `tokens/` define a escala; `theme/` é o resolver que a consome.
      .where(
        (FileSystemEntity f) =>
            !f.path.contains('lib/src/tokens/') &&
            !f.path.contains('lib/src/theme/'),
      )
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

  /// Sem comentário: dartdoc cita `[AppRadius.xl]` ao documentar o default, e
  /// o `app_icon` guarda um trecho comentado.
  String codeOf(File f) => f
      .readAsLinesSync()
      .where((String l) {
        final String t = l.trimLeft();
        return !t.startsWith('///') &&
            !t.startsWith('//') &&
            !t.startsWith('*');
      })
      .join('\n');

  final RegExp constRadius = RegExp(r'\bAppRadius\.');

  test('cantos de superfície vêm do eixo, não da escala const', () {
    final List<String> offenders = <String>[
      for (final File f in dartFiles)
        if (!kRadiusAxisExempt.containsKey(rel(f)) &&
            constRadius.hasMatch(codeOf(f)))
          rel(f),
    ];
    expect(
      offenders,
      isEmpty,
      reason:
          'Canto de superfície é temável: leia de theme.radiusTheme '
          '(resolve/resolveRadius para containers, tileRadius para linhas, '
          'surfaceCornerRadius para sheets/dialogs, containedMode para painéis '
          'largos). Uma marca em `reto`/`circular` precisa alcançar este canto. '
          'Se o valor NÃO é um canto, adicione a kRadiusAxisExempt com o '
          'motivo: $offenders',
    );
  });

  test('kRadiusAxisExempt não tem entrada obsoleta', () {
    final Set<String> onDisk = dartFiles.map(rel).toSet();
    final List<String> stale = <String>[
      for (final String p in kRadiusAxisExempt.keys)
        if (!onDisk.contains(p) ||
            !constRadius.hasMatch(codeOf(File('lib/src/$p'))))
          p,
    ];
    expect(
      stale,
      isEmpty,
      reason:
          'Entrada da lista que não corresponde mais a um uso em disco '
          '(arquivo renomeado, ou o raio já entrou no eixo). Remova: $stale',
    );
  });
}
