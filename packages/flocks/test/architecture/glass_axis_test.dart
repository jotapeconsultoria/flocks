import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'glass_allowlist.dart';

/// Censo do eixo glass — a rede que impede um overlay novo de nascer opaco.
///
/// Varre `lib/src` como o `architecture_test.dart` (fonte pura, sem golden e sem
/// pump), e cobra que toda superfície flutuante esteja classificada — em
/// `kGlassSurfaces` (pinta e aplica glass), `kGlassDelegated` (monta o overlay
/// mas quem pinta é outro) ou `kGlassExempt` (fora do eixo, com o motivo).
void main() {
  final List<File> dartFiles = Directory('lib/src')
      .listSync(recursive: true)
      .whereType<File>()
      .where((FileSystemEntity f) => f.path.endsWith('.dart'))
      // Artefatos do componente (catálogo/widgetbook) carregam exemplos em
      // string que casariam com as marcas abaixo. Só código de runtime conta.
      .where(
        (FileSystemEntity f) =>
            !f.path.endsWith('.meta.dart') && !f.path.endsWith('.preview.dart'),
      )
      .toList();

  /// Path relativo a `lib/src`, com barras normalizadas.
  String rel(File f) {
    final String p = f.path.replaceAll(r'\', '/');
    final int i = p.indexOf('lib/src/');
    return i == -1 ? p : p.substring(i + 'lib/src/'.length);
  }

  /// Marcas de que o arquivo **cria** uma superfície flutuante. Não conta
  /// `Overlay.of(context)` sozinho (consumir o overlay ≠ pintar um painel).
  bool declaresOverlay(String src) =>
      src.contains('OverlayEntry(') ||
      src.contains('extends PopupRoute') ||
      src.contains('extends ModalRoute') ||
      src.contains('extends PageRoute') ||
      src.contains('showAppOverlay(');

  /// Marcas de que o arquivo participa do eixo glass.
  bool participatesInGlass(String src) =>
      src.contains('AppOverlayPanel') ||
      src.contains('AppGlassSurface') ||
      src.contains('AppProgressiveBlur') ||
      src.contains('appResolveGlassOn') ||
      src.contains('resolveGlassOn') ||
      src.contains('glassTheme.enabled');

  test('as três listas são disjuntas', () {
    final List<(String, String, Set<String>)>
    pairs = <(String, String, Set<String>)>[
      (
        'kGlassSurfaces',
        'kGlassExempt',
        kGlassSurfaces.keys.toSet().intersection(kGlassExempt.keys.toSet()),
      ),
      (
        'kGlassSurfaces',
        'kGlassDelegated',
        kGlassSurfaces.keys.toSet().intersection(kGlassDelegated.keys.toSet()),
      ),
      (
        'kGlassExempt',
        'kGlassDelegated',
        kGlassExempt.keys.toSet().intersection(kGlassDelegated.keys.toSet()),
      ),
    ];
    for (final (String a, String b, Set<String> both) in pairs) {
      expect(both, isEmpty, reason: 'Path em $a e $b ao mesmo tempo: $both');
    }
  });

  test('toda entrada das listas existe em disco', () {
    final Set<String> onDisk = dartFiles.map(rel).toSet();
    final List<String> missing = <String>[
      for (final String p in <String>[
        ...kGlassSurfaces.keys,
        ...kGlassExempt.keys,
        ...kGlassDelegated.keys,
      ])
        if (!onDisk.contains(p)) p,
    ];
    expect(
      missing,
      isEmpty,
      reason:
          'Entradas obsoletas (arquivo renomeado/removido?). Atualize '
          'glass_allowlist.dart: $missing',
    );
  });

  test('toda superfície de kGlassSurfaces referencia o eixo glass', () {
    final List<String> offenders = <String>[];
    for (final File f in dartFiles) {
      final String path = rel(f);
      if (!kGlassSurfaces.containsKey(path)) continue;
      if (!participatesInGlass(f.readAsStringSync())) {
        offenders.add('$path (${kGlassSurfaces[path]})');
      }
    }
    expect(
      offenders,
      isEmpty,
      reason:
          'Estas superfícies deveriam aplicar glass e não referenciam mais o '
          'eixo — alguém removeu o caminho? $offenders',
    );
  });

  // O assert que impede a recaída: um overlay novo não passa despercebido.
  test('todo overlay em lib/src está classificado contra o eixo glass', () {
    final List<String> unclassified = <String>[];
    for (final File f in dartFiles) {
      final String path = rel(f);
      if (kGlassSurfaces.containsKey(path) ||
          kGlassExempt.containsKey(path) ||
          kGlassDelegated.containsKey(path)) {
        continue;
      }
      if (declaresOverlay(f.readAsStringSync())) unclassified.add(path);
    }
    expect(
      unclassified,
      isEmpty,
      reason:
          'Superfície flutuante nova sem classificação. Decida contra as três '
          'cláusulas em lib/src/theme/app_glass_axis.dart e adicione a '
          'kGlassSurfaces (pinta e aplica glass), kGlassDelegated (só monta, '
          'quem pinta é outro) ou kGlassExempt (com o motivo): $unclassified',
    );
  });
}
