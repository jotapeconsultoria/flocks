import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Arquivos que, DURANTE a migração, ainda podem importar Material/Cupertino.
/// Adicione com comentário justificando + plano de remoção (Gate 7/decoupling).
/// Deve tender a zero. (vazio por ora — o `flocks` nasce limpo.)
const Set<String> _materialCupertinoAllowlist = <String>{
  // ÚNICO ponto do Flocks que toca Cupertino: as instâncias de
  // `TextSelectionControls` (handles + toolbar de copiar/colar), que não têm
  // equivalente na camada `widgets`. O mesmo bloco já esteve copiado em 4
  // arquivos (AppSelectionRegion, AppInput e os dois do color picker) com só um
  // deles na allow-list — os outros três violavam a regra em silêncio. Agora
  // todos consomem `appTextSelectionControls`.
  // Resíduo Gate 7: trocar por controls próprios (contextMenuButtonItems) exige
  // validação de UX web/desktop. Esta allow-list é o próprio rastro da dívida —
  // enquanto a entrada estiver aqui, ela existe; feita a troca, a linha sai e o
  // gate volta a valer para o arquivo.
  'foundation/selection/app_text_selection_controls.dart',
};

/// A CHAMADA do registry global (não a menção ao nome).
const String _setBrandCall = 'AppBrand.setBrand(';

void main() {
  final List<File> dartFiles = Directory('lib/src')
      .listSync(recursive: true)
      .whereType<File>()
      .where((FileSystemEntity f) => f.path.endsWith('.dart'))
      .cast<File>()
      .toList();

  String rel(File f) => f.path.replaceAll(r'\', '/');

  test('nenhum arquivo importa Material/Cupertino (design-agnostic)', () {
    final List<String> offenders = <String>[];
    for (final File f in dartFiles) {
      final String path = rel(f);
      if (_materialCupertinoAllowlist.any((String a) => path.endsWith(a))) {
        continue;
      }
      final String content = f.readAsStringSync();
      if (content.contains('package:flutter/material.dart') ||
          content.contains('package:flutter/cupertino.dart')) {
        offenders.add(path);
      }
    }
    expect(
      offenders,
      isEmpty,
      reason: 'Flocks deve ficar só sobre widgets.dart. Offenders: $offenders',
    );
  });

  test('nenhuma aresta flocks → tracked_shared_pkg', () {
    final List<String> offenders = <String>[
      for (final File f in dartFiles)
        if (f.readAsStringSync().contains('package:tracked_shared_pkg')) rel(f),
    ];
    expect(
      offenders,
      isEmpty,
      reason: 'Flocks não pode depender do shared. Offenders: $offenders',
    );
  });

  test(
    'componentes não hardcodam AppColors.* (fora de tokens/theme/brand)',
    () {
      final RegExp appColors = RegExp(r'\bAppColors\.');
      final List<String> offenders = <String>[];
      for (final File f in dartFiles) {
        final String path = rel(f);
        if (path.contains('/tokens/') ||
            path.contains('/theme/') ||
            path.contains('/brand/')) {
          continue;
        }
        // Ignora comentários (dartdoc/linha) — só cor usada em runtime conta.
        final bool usesInCode = f
            .readAsLinesSync()
            .where((String l) => !l.trimLeft().startsWith('//'))
            .any(appColors.hasMatch);
        if (usesInCode) {
          offenders.add(path);
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'Componentes devem ler cor de AppTheme.of(context), não '
            'AppColors.*. Offenders: $offenders',
      );
    },
  );

  test('nenhum teste troca a marca pelo singleton AppBrand.setBrand', () {
    // `AppBrand.current` é estado de PROCESSO: um teste que o altera contamina
    // os seguintes, e a suíte só é determinística enquanto ninguém a roda em
    // paralelo (o `-j 1` vira requisito escondido). Pior, o vazamento é
    // silencioso — no teste do acento do dialog o tema era resolvido ANTES do
    // setBrand e media a marca anterior sem ninguém perceber.
    //
    // `AppThemeData.forBrand(brand, dark:)` faz o tema virar função pura da
    // marca; nenhum teste precisa mais do registry global.
    final List<String> offenders = Directory('test')
        .listSync(recursive: true)
        .whereType<File>()
        .where((File f) => f.path.endsWith('.dart'))
        // Este arquivo cita o nome três vezes (título, matcher, mensagem) —
        // não pode se auto-acusar. O helper cita em comentário, e comentário
        // não roda.
        .where((File f) => !f.path.endsWith('architecture_test.dart'))
        .where(
          (File f) => f
              .readAsLinesSync()
              .where((String l) => !l.trimLeft().startsWith('//'))
              .any((String l) => l.contains(_setBrandCall)),
        )
        .map((File f) => f.path)
        .toList();

    expect(
      offenders,
      isEmpty,
      reason:
          'Use AppThemeData.forBrand(brand, dark: …) em vez de '
          'AppBrand.setBrand. Offenders: $offenders',
    );
  });
}
