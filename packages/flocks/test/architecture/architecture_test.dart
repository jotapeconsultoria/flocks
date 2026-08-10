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

  // Os dois gates abaixo guardam a mesma coisa por dois lados: a nota de
  // plataforma e de wasm do pacote no pub.dev, que na 0.1.0 estavam em 10/20 e
  // "not compatible". Nenhum teste deste repositório roda num browser, então
  // sem eles as duas regressões voltariam em silêncio absoluto.

  test('nenhum import condicional decide por `dart.library.html`', () {
    // `dart:html` NÃO existe no dart2wasm — a `libraries.json` do SDK só a
    // declara no alvo dart2js. Um `if (dart.library.html)` é portanto FALSO em
    // todo `flutter build web --wasm`, e o compilador cai no ramo default sem
    // avisar ninguém. Foi exatamente assim que o `app_network_icon_provider`
    // arrastou `dart:io` (via flutter_cache_manager) para dentro do grafo do
    // wasm e deixou o pacote inteiro "not compatible with runtime wasm".
    //
    // Os predicados corretos são `dart.library.io` (verdadeiro na VM, falso nos
    // DOIS backends web) e `dart.library.js_interop` (verdadeiro nos dois
    // backends web, falso na VM). Escolha pelo que o ramo precisa.
    // Comentário não compila, e este repositório explica as decisões na prosa —
    // o comentário que conta POR QUE o predicado saiu cita o nome dele, e não
    // pode se auto-acusar. Mesmo filtro do gate do `AppBrand.setBrand`.
    final List<String> offenders = <String>[
      for (final File f in dartFiles)
        if (f
            .readAsLinesSync()
            .where((String l) => !l.trimLeft().startsWith('//'))
            .any((String l) => l.contains('dart.library.html')))
          rel(f),
    ];
    expect(
      offenders,
      isEmpty,
      reason:
          'Troque por `dart.library.io` ou `dart.library.js_interop` — '
          '`dart.library.html` é falso no dart2wasm e escolhe o ramo errado '
          'em silêncio. Offenders: $offenders',
    );
  });

  test('o pubspec não depende de `pointer_interceptor`', () {
    // Ele saiu na 0.1.1, e não pode voltar por conveniência. É plugin federado
    // que endossa só `web` e `ios`; o pana INTERSECTA as plataformas de todo o
    // fecho de dependências, então esta única linha rebaixava o `flocks` — e
    // por herança o `flocks_phosphor` e o `flocks_material` — para "Supports 2
    // of 6 platforms" na página do pub.dev, num design system que roda em toda
    // parte. Import condicional não salva: o pana lê o pubspec, não os imports.
    //
    // O que ele fazia no browser vive agora em `src/foundation/pointer/`, em
    // ~20 linhas de `dart:js_interop` + `package:web`. Se precisar da
    // interceptação no iOS (que exige UIView nativo, logo um plugin), o caminho
    // é o app consumidor declarar o pacote, não o Flocks.
    // Só as linhas de DECLARAÇÃO: o comentário do `web:` logo acima conta esta
    // história inteira e cita o nome, como a prosa deste repositório faz.
    final List<String> declarations = File('pubspec.yaml')
        .readAsLinesSync()
        .where((String l) => !l.trimLeft().startsWith('#'))
        .toList();
    expect(
      declarations.where((String l) => l.contains('pointer_interceptor')),
      isEmpty,
      reason:
          'Voltar a depender de `pointer_interceptor` derruba a nota de '
          'plataforma do flocks e dos dois adaptadores para 2 de 6.',
    );
  });
}
