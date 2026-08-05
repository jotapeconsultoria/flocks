import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Regra 9 — o eixo `AppStyle` (`filled`/`outlined`/`elevated`) alcança todo
/// componente que desenha a PRÓPRIA caixa.
///
/// A unidade de medida aqui é a **pasta do componente**, não o arquivo. Medir
/// por arquivo dá falso positivo em toda família que separa o painter do
/// widget público: `button_core.dart` monta `BoxDecoration` e nunca escreve
/// `AppStyle`, mas o `AppButton` da mesma pasta lê `theme.styleTheme.style` e
/// traduz para `ButtonVariant` antes de chamá-lo. O eixo chega — por
/// composição, que é justamente o que um grep por arquivo não enxerga.

/// Pastas que pintam algo que **não é a caixa de um componente**. O eixo não
/// se aplica: não há fill/borda/sombra de container para tratar.
const Map<String, String> kStyleAxisNotAContainer = <String, String>{
  'atoms/divider': 'uma régua, não uma caixa',
  // `atoms/icons` saiu daqui: o placeholder de erro foi para
  // `foundation/icons/`, junto com o carregamento, quando o ícone virou eixo.
  // O `AppIcon` não pinta mais caixa nenhuma — só delega ao provider.
  'atoms/illustrations': 'placeholder de asset que falhou ao carregar',
  'atoms/loadings': 'barrier do overlay e faixa do shimmer',
  'atoms/swatch': 'amostra de cor — a cor É o conteúdo, não um tratamento',
  'molecules/breadcrumb': 'véu de hover e anel de foco (estado, não container)',
  'molecules/date_picker': 'realce da célula e anel de foco',
  'molecules/interactive': 'véu de hover',
  'molecules/pagination': 'realce da página ativa e hover',
  'molecules/time_picker': 'faixa que marca a seleção no trilho',
  'organisms/navigation_rail': 'pílula de hover e recorte do avatar',
  'organisms/resizable_panel': 'cor da alça de arraste',
  'organisms/scaffolds': 'fundo da página, degradê de borda e sombra da barra',
  'organisms/tab_view': 'pílula de hover, indicador e divisória',
  'organisms/workspace_tabs': 'silhueta bespoke da aba e divisória',

  // Os dois já estão em `kGlassExempt` pela cláusula 2 — "é uma MARCA presa ao
  // alvo (mensagem fixa, IgnorePointer), não um contêiner". A mesma cláusula
  // vale aqui: não dá para classificar como container num eixo e não-container
  // no outro. O fill escuro do balão, aliás, é escolhido para garantir
  // contraste num rótulo transitório — não é um tratamento de superfície.
  'molecules/tooltip': 'marca presa ao alvo (ver kGlassExempt)',
  // `molecules/charts` saiu desta lista: o balão do gráfico continua sendo
  // rótulo, mas a pasta ganhou o `AppChartShell` — um cartão de verdade, que
  // entrou no eixo. Uma pasta com pelo menos um container no eixo não precisa
  // de classificação.
};

/// Containers **deliberadamente fora** do eixo. Entrar aqui é uma decisão de
/// design registrada, não um TODO — o mesmo estatuto de `kGlassExempt`.
///
/// Diferente de [kStyleAxisNotAContainer]: ali o eixo não se aplica (não há
/// caixa de container); aqui ele se aplicaria, e a escolha foi não aplicar.
const Map<String, String> kStyleAxisByDecision = <String, String>{
  // A linha avulsa é fill + `Border.all(outline)` — ou seja, ela JÁ é
  // `outlined`, só que fixo. Entrar no eixo faria o `filled` (o default do DS)
  // TIRAR essa borda, e a linha avulsa perderia o que a separa do fundo.
  // Decisão do dono (2026-07-30): a borda é identidade da linha avulsa, não um
  // tratamento de superfície — fica como está.
  'molecules/list_tile': 'a borda é identidade da linha avulsa, não tratamento',

  // A tabela não é uma caixa: é header + linhas + rodapé, cada um com seu
  // `DecoratedBox`, compostos em métodos diferentes. Aplicar o eixo por caixa
  // poria borda em volta do header E do rodapé no `outlined`; fazê-lo direito
  // exige um wrapper de envelope — refatoração estrutural do organismo mais
  // complexo do pacote, com a rolagem horizontal e as alças de redimensionar
  // como superfície de regressão. Decisão do dono (2026-07-30): não vale o
  // risco pelo ganho.
  'organisms/data_table': 'envelope em 3 caixas; refatoração não vale o risco',
};

/// Dívida de verdade: pinta caixa de container, o eixo se aplica, e ninguém
/// decidiu nada ainda. **Deve ficar vazio** — uma entrada aqui é trabalho
/// pendente, não um estado de repouso. Quem migrar, apaga a linha; quem
/// decidir manter, move para [kStyleAxisByDecision] com o motivo.
const Map<String, String> kStyleAxisPending = <String, String>{};

void main() {
  final List<Directory> componentDirs = <Directory>[
    for (final String layer in <String>['atoms', 'molecules', 'organisms'])
      ...Directory(
        'lib/src/$layer',
      ).listSync().whereType<Directory>().cast<Directory>(),
  ];

  String rel(Directory d) {
    final String p = d.path.replaceAll(r'\', '/');
    final int i = p.indexOf('lib/src/');
    return i == -1 ? p : p.substring(i + 'lib/src/'.length);
  }

  /// Arquivos de runtime da pasta (sem descer em subpastas: cada componente é
  /// um nível).
  List<File> runtimeFiles(Directory d) => d
      .listSync()
      .whereType<File>()
      .where((File f) => f.path.endsWith('.dart'))
      .where(
        (File f) =>
            !f.path.endsWith('.meta.dart') && !f.path.endsWith('.preview.dart'),
      )
      .toList();

  String codeOf(File f) => f
      .readAsLinesSync()
      .where((String l) {
        final String t = l.trimLeft();
        return !t.startsWith('///') &&
            !t.startsWith('//') &&
            !t.startsWith('*');
      })
      .join('\n');

  bool paintsBox(Directory d) =>
      runtimeFiles(d).any((File f) => codeOf(f).contains('BoxDecoration('));

  /// Marcas de que a pasta CONSOME o eixo. Não basta procurar a palavra
  /// `AppStyle`: quem lê o global e resolve escreve `theme.styleTheme.style` e
  /// `styleBoxDecoration(...)` sem nunca nomear o enum — e o censo acusaria de
  /// ofensor justamente quem acabou de migrar.
  final RegExp axisMark = RegExp(
    r'(\bAppStyle\b|styleTheme\.style|styleBoxDecoration|resolveStyleDecoration)',
  );

  bool onAxis(Directory d) =>
      runtimeFiles(d).any((File f) => axisMark.hasMatch(codeOf(f)));

  test('as três listas são disjuntas', () {
    final Set<String> classified = <String>{};
    final List<String> dupes = <String>[];
    for (final Map<String, String> list in <Map<String, String>>[
      kStyleAxisNotAContainer,
      kStyleAxisByDecision,
      kStyleAxisPending,
    ]) {
      for (final String p in list.keys) {
        if (!classified.add(p)) dupes.add(p);
      }
    }
    expect(
      dupes,
      isEmpty,
      reason:
          'Uma pasta ou não tem caixa de container, ou tem e ficou de fora por '
          'decisão, ou tem e falta decidir. Só uma das três: $dupes',
    );
  });

  test('todo componente que pinta caixa está classificado contra o eixo', () {
    final List<String> unclassified = <String>[
      for (final Directory d in componentDirs)
        if (paintsBox(d) &&
            !onAxis(d) &&
            !kStyleAxisNotAContainer.containsKey(rel(d)) &&
            !kStyleAxisByDecision.containsKey(rel(d)) &&
            !kStyleAxisPending.containsKey(rel(d)))
          rel(d),
    ];
    expect(
      unclassified,
      isEmpty,
      reason:
          'Componente novo pintando BoxDecoration sem passar pelo eixo. Leia '
          'theme.styleTheme.style e resolva por styleBoxDecoration — ou, se o '
          'que ele pinta não é a caixa de um container (régua, véu de hover, '
          'barrier, silhueta bespoke), classifique em kStyleAxisNotAContainer '
          'com o motivo: $unclassified',
    );
  });

  test('nenhuma entrada das listas envelheceu', () {
    final Set<String> onDisk = componentDirs.map(rel).toSet();
    final List<String> stale = <String>[
      for (final String p in <String>[
        ...kStyleAxisNotAContainer.keys,
        ...kStyleAxisByDecision.keys,
        ...kStyleAxisPending.keys,
      ])
        if (!onDisk.contains(p) ||
            !paintsBox(Directory('lib/src/$p')) ||
            onAxis(Directory('lib/src/$p')))
          p,
    ];
    expect(
      stale,
      isEmpty,
      reason:
          'Pasta renomeada, que parou de pintar caixa, ou que JÁ entrou no '
          'eixo (neste caso é vitória: apague a linha). Remova: $stale',
    );
  });

  // O que torna "Fase 7 fechada" um fato verificável, e não uma frase.
  test('não há container esperando decisão', () {
    expect(
      kStyleAxisPending,
      isEmpty,
      reason:
          'Todo container do pacote ou está no eixo, ou ficou de fora por '
          'decisão registrada. Uma entrada em kStyleAxisPending é trabalho em '
          'curso, não um estado de repouso: migre (e apague a linha) ou decida '
          '(e mova para kStyleAxisByDecision com o motivo). '
          'Pendentes: ${kStyleAxisPending.keys.toList()}',
    );
  });

  // A trava do achado desta rodada: se alguém "consertar" o `button_core`
  // medindo por arquivo, esta lista voltaria a crescer com um falso positivo.
  test('o eixo pode chegar por composição, e a medida respeita isso', () {
    final Directory buttons = Directory('lib/src/molecules/buttons');
    expect(
      paintsBox(buttons),
      isTrue,
      reason: 'button_core continua montando o BoxDecoration do botão',
    );
    expect(
      onAxis(buttons),
      isTrue,
      reason:
          'o AppStyle chega ao botão pelo AppButton, que lê '
          'theme.styleTheme.style e traduz para ButtonVariant — o painter '
          'interno não precisa (nem deve) reler o eixo',
    );
  });
}
