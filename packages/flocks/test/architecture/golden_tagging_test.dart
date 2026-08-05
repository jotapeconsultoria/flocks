import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// A CI roda os testes em DOIS jobs, partidos por tag: tudo menos golden em
/// Linux, e só os golden em macOS — porque é lá que as baselines são geradas e
/// a rasterização de texto não é idêntica entre plataformas.
///
/// A partição só funciona enquanto todo golden carrega a tag. Um arquivo novo
/// sem ela cai no job errado: comparado contra uma baseline de macOS num
/// runner Linux, falha por motivo que não é regressão — e a leitura natural do
/// vermelho vira "golden é instável", que é como um gate morre.
///
/// Comparar golden tem duas formas no pacote: `matchesGoldenFile` direto (51
/// suítes) e o helper `goldenMatrixTest` de `test/support/golden_matrix.dart`,
/// que embrulha a matriz {claro,escuro}×{jotape,zxtrack}. Procurar só a
/// primeira acusaria de mal-etiquetada justamente a suíte que usa o helper —
/// e o próprio helper não é suíte (é biblioteca; tag em biblioteca não tem
/// efeito).
void main() {
  final List<File> testFiles = Directory('test')
      .listSync(recursive: true)
      .whereType<File>()
      .where((File f) => f.path.endsWith('_test.dart'))
      .toList();

  String rel(File f) {
    final String p = f.path.replaceAll(r'\', '/');
    final int i = p.indexOf('test/');
    return i == -1 ? p : p.substring(i);
  }

  /// A suíte compara imagem — direto ou pelo helper da matriz.
  bool comparesGolden(File f) {
    final String src = f.readAsStringSync();
    return src.contains('matchesGoldenFile') ||
        src.contains('goldenMatrixTest');
  }

  bool tagged(File f) =>
      f.readAsStringSync().contains("@Tags(<String>['golden'])");

  test('toda suíte que compara golden declara @Tags(golden)', () {
    final List<String> untagged = <String>[
      for (final File f in testFiles)
        if (comparesGolden(f) && !tagged(f)) rel(f),
    ];
    expect(
      untagged,
      isEmpty,
      reason:
          "Comece o arquivo com `@Tags(<String>['golden'])` + `library;`. Sem "
          'a tag o golden roda no job Linux, contra baseline de macOS, e o '
          'vermelho não vai significar regressão: $untagged',
    );
  });

  test('a tag golden não é usada por quem não compara imagem', () {
    // O inverso importa igual: uma suíte marcada por engano some do job que
    // roda em todo PR e passa a rodar só no de macOS — some do caminho quente
    // sem ninguém notar.
    final List<String> mistagged = <String>[
      for (final File f in testFiles)
        if (tagged(f) && !comparesGolden(f)) rel(f),
    ];
    expect(
      mistagged,
      isEmpty,
      reason:
          'Tag `golden` em suíte que não compara imagem — ela sairia do job '
          'que roda em todo PR: $mistagged',
    );
  });
}
