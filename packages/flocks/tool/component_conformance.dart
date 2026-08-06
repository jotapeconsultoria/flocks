// Regras de conformidade dos componentes do Flocks: este arquivo É a
// "Definition of Migrated". A lista nasceu em prosa, num documento interno de
// migração; aqui ela é executável, e é a única versão que sobrou — as regras
// numeradas citadas pelos dartdocs do pacote são as que `conformanceErrors`
// cobra abaixo. Biblioteca pura: só descobre e reporta, não imprime nem sai do
// processo.
//
// Vive aqui, e não em `lib/`, por dois motivos: usa `dart:io` (que quebraria um
// build web se alguém a importasse por engano) e é ferramenta, não produto.
// Dois consumidores:
//  - `tool/validate_components.dart` — o gate da CI;
//  - `test/architecture/component_conformance_test.dart` — o mesmo gate dentro
//    do `flutter test`, para quem roda a suíte ver a falha sem lembrar do tool.
import 'dart:io';

import 'package:flocks/meta.dart';

/// Diretórios de componentes, relativos à raiz do pacote.
const List<String> kComponentDirs = <String>[
  'lib/src/atoms',
  'lib/src/molecules',
  'lib/src/organisms',
];

/// Casa `class AppX extends StatelessWidget|StatefulWidget`, tolerando
/// modificadores (final/base/sealed/abstract) e genéricos (`AppRadio<T>`).
final RegExp _widgetClass = RegExp(
  r'(?:abstract\s+|final\s+|base\s+|sealed\s+|interface\s+)*class\s+'
  r'(App\w+)(?:<[^>]*>)?\s+extends\s+(?:StatelessWidget|StatefulWidget)',
  multiLine: true,
);

/// Casa o `type:` de um `@UseCase` do widgetbook — identificador INTEIRO.
///
/// O check antigo era `wb.contains('type: $name')`, prefixo-inseguro: um
/// `type: AppListTileGroup` dava passe livre a `AppListTile`, e um futuro
/// `type: AppShellHeader` daria a `AppShell`. Casar o identificador fecha isso.
final RegExp _useCaseType = RegExp(r'type:\s*([A-Za-z_]\w*)');

/// Um widget declarado no código.
class DiscoveredWidget {
  /// Cria um [DiscoveredWidget].
  const DiscoveredWidget({
    required this.name,
    required this.file,
    required this.isInternal,
    required this.hasDartdoc,
  });

  /// Nome da classe (ex.: `AppBadge`).
  final String name;

  /// Arquivo onde vive.
  final File file;

  /// Anotado com `@internal` (peça de outro componente, não API pública).
  final bool isInternal;

  /// Tem `///` imediatamente antes da declaração (Regra 2).
  final bool hasDartdoc;

  /// Camada derivada do caminho (`atoms` → [ComponentCategory.atom]…).
  ComponentCategory? get layer {
    final String p = file.path;
    if (p.contains('/atoms/')) return ComponentCategory.atom;
    if (p.contains('/molecules/')) return ComponentCategory.molecule;
    if (p.contains('/organisms/')) return ComponentCategory.organism;
    return null;
  }
}

/// O que precede uma declaração: as anotações e se há dartdoc.
///
/// Anda para TRÁS a partir da declaração, pulando linhas em branco, anotações e
/// comentários — o dartdoc é a primeira linha `///` que sobra.
({bool internal, bool dartdoc}) _preamble(String src, int declStart) {
  final List<String> before = src.substring(0, declStart).split('\n');
  bool internal = false;
  bool dartdoc = false;
  for (int i = before.length - 1; i >= 0; i--) {
    final String line = before[i].trim();
    if (line.isEmpty) continue;
    if (line.startsWith('@')) {
      // `@internal`, `@immutable`, `@widgetbook.UseCase`…
      if (RegExp(r'@internal\b').hasMatch(line)) internal = true;
      continue;
    }
    if (line.startsWith('///')) {
      dartdoc = true;
      continue;
    }
    // Qualquer outra coisa (`}`, `import`, código) encerra o preâmbulo.
    break;
  }
  return (internal: internal, dartdoc: dartdoc);
}

/// Descobre todo widget público `App*` sob os diretórios de componentes.
List<DiscoveredWidget> discoverWidgets(String root) {
  final List<DiscoveredWidget> found = <DiscoveredWidget>[];
  for (final String dirPath in kComponentDirs) {
    final Directory dir = Directory('$root/$dirPath');
    if (!dir.existsSync()) continue;
    for (final FileSystemEntity e in dir.listSync(recursive: true)) {
      if (e is! File || !e.path.endsWith('.dart')) continue;
      final String src = e.readAsStringSync();
      for (final RegExpMatch m in _widgetClass.allMatches(src)) {
        final ({bool internal, bool dartdoc}) pre = _preamble(src, m.start);
        found.add(
          DiscoveredWidget(
            name: m.group(1)!,
            file: e,
            isInternal: pre.internal,
            hasDartdoc: pre.dartdoc,
          ),
        );
      }
    }
  }
  found.sort((DiscoveredWidget a, DiscoveredWidget b) {
    final int byPath = a.file.path.compareTo(b.file.path);
    return byPath != 0 ? byPath : a.name.compareTo(b.name);
  });
  return found;
}

String _dirOf(File f) => f.parent.path;

String _baseOf(File f) {
  final String name = f.uri.pathSegments.last;
  return name.substring(0, name.length - '.dart'.length);
}

String _folderName(File f) {
  final List<String> parts = f.parent.uri.pathSegments
      .where((String s) => s.isNotEmpty)
      .toList();
  return parts.isEmpty ? '' : parts.last;
}

/// O artefato `<suffix>` cobre [widget]?
///
/// Aceita por-arquivo (`app_badge.doc.md`) ou agrupado por pasta
/// (`loadings.doc.md`) — mas o agrupado só conta se **citar a classe**. Antes
/// bastava o arquivo existir, e 20 widgets passavam por baixo de um doc/preview
/// agrupado que nunca falava deles.
bool _hasArtifact(DiscoveredWidget widget, String suffix) {
  final String dir = _dirOf(widget.file);
  final File perFile = File('$dir/${_baseOf(widget.file)}$suffix');
  if (perFile.existsSync()) return true;
  final File grouped = File('$dir/${_folderName(widget.file)}$suffix');
  if (!grouped.existsSync()) return false;
  return RegExp(
    '\\b${RegExp.escape(widget.name)}\\b',
  ).hasMatch(grouped.readAsStringSync());
}

/// Todo `type:` registrado nas use-cases do widgetbook.
Set<String> useCaseTypes(String root) {
  final Directory dir = Directory('$root/widgetbook/use_cases');
  if (!dir.existsSync()) return <String>{};
  final Set<String> types = <String>{};
  for (final FileSystemEntity e in dir.listSync()) {
    if (e is! File || !e.path.endsWith('.dart')) continue;
    for (final RegExpMatch m in _useCaseType.allMatches(e.readAsStringSync())) {
      types.add(m.group(1)!);
    }
  }
  return types;
}

/// Todo identificador citado na suíte de testes (para o check da Regra 6).
Set<String> _testedIdentifiers(String root) {
  final Directory dir = Directory('$root/test');
  if (!dir.existsSync()) return <String>{};
  final Set<String> ids = <String>{};
  final RegExp word = RegExp(r'\bApp\w+\b');
  for (final FileSystemEntity e in dir.listSync(recursive: true)) {
    if (e is! File || !e.path.endsWith('.dart')) continue;
    for (final RegExpMatch m in word.allMatches(e.readAsStringSync())) {
      ids.add(m.group(0)!);
    }
  }
  return ids;
}

/// Roda todas as checagens e devolve os erros (vazio = conforme).
List<String> conformanceErrors(String root) {
  final List<String> errors = <String>[];

  // 1. Metadados dos componentes migrados.
  for (final AppComponentMeta m in flocksCatalog) {
    if (m.status != ComponentStatus.migrated) continue;
    void require(bool ok, String what) {
      if (!ok) errors.add('${m.id}: $what');
    }

    // Os campos de prosa são cobrados nos DOIS idiomas: o site publica uma
    // rota por componente em cada um, e um lado vazio é uma página vazia no ar.
    require(m.summary.en.trim().isNotEmpty, 'summary.en vazio');
    require(m.summary.pt.trim().isNotEmpty, 'summary.pt vazio');
    require(m.whenToUse.en.isNotEmpty, 'whenToUse.en vazio');
    require(m.whenToUse.pt.isNotEmpty, 'whenToUse.pt vazio');
    require(m.props.isNotEmpty, 'props vazio (Regra 6 — o MCP serve isto)');
    require(m.examples.isNotEmpty, 'sem exemplos (Regra 2/4)');
    require((m.a11y?.en ?? '').trim().isNotEmpty, 'a11y.en vazio (Regra 8)');
    require((m.a11y?.pt ?? '').trim().isNotEmpty, 'a11y.pt vazio (Regra 8)');
    require(m.themeAware, 'themeAware=false (Regra 9)');
    require(m.reducesMotion, 'reducesMotion=false (Regra 10)');
  }

  // 2 + 3. Cruza o código com catálogo, artefatos e testes.
  final Map<String, AppComponentMeta> byName = <String, AppComponentMeta>{
    for (final AppComponentMeta m in flocksCatalog) m.name: m,
  };
  final Set<String> wbTypes = useCaseTypes(root);
  final Set<String> tested = _testedIdentifiers(root);

  for (final DiscoveredWidget w in discoverWidgets(root)) {
    final String rel = w.file.path.replaceFirst('$root/', '');

    // Regra 2 — dartdoc vale para TODO widget, inclusive o interno.
    if (!w.hasDartdoc) {
      errors.add('${w.name} ($rel): sem dartdoc na classe (Regra 2).');
    }

    // `@internal` = peça de outro componente: não é API pública, então não
    // entra no catálogo nem precisa de doc/preview/use-case/teste próprios.
    if (w.isInternal) continue;

    final AppComponentMeta? meta = byName[w.name];
    if (meta == null) {
      errors.add(
        '${w.name} ($rel): widget público sem entrada em flocksCatalog '
        '(crie o .meta.dart e registre-o, ou marque a classe @internal).',
      );
    } else if (w.layer != null && meta.category != w.layer) {
      errors.add(
        '${w.name} ($rel): meta diz category=${meta.category.name} mas o '
        'arquivo está em ${w.layer!.name}.',
      );
    }

    if (!_hasArtifact(w, '.doc.md')) {
      errors.add('${w.name} ($rel): sem .doc.md que o cubra (Regra 3).');
    }
    if (!_hasArtifact(w, '.preview.dart')) {
      errors.add('${w.name} ($rel): sem .preview.dart que o cubra (Regra 5).');
    }
    if (!wbTypes.contains(w.name)) {
      errors.add('${w.name} ($rel): sem @UseCase no widgetbook (Regra 4).');
    }
    if (!tested.contains(w.name)) {
      errors.add(
        '${w.name} ($rel): nenhum teste em test/ o exercita (Regra 6).',
      );
    }
  }

  return errors;
}
