// Regras do catálogo Widgetbook (`widgetbook/CONVENTIONS.md`), aplicadas por
// leitura de texto — mesmo molde de `component_conformance.dart`.
//
// Existe porque as convenções eram só um documento: quem escrevia a use-case
// nova não tinha como saber que esqueceu o `States`, deixou um rótulo em
// português ou trocou um token por um slider livre.
import 'dart:io';

/// Nomes de caso canônicos (CONVENTIONS §"Canonical case names").
const Set<String> kCanonicalCaseNames = <String>{
  'Playground',
  'Catalog',
  'States',
  'Sizes',
  'Type scale',
  // Cena realista de um componente que vive em grupo (list tiles). Entrou
  // quando as cinco cenas `Scenario · X` viraram uma.
  'Scenario',
  // Família do eixo glass: o vidro só se avalia sobre um fundo que rola, então
  // esses casos usam `wbGlassStage` em vez do painel.
  'Glass over backdrop',
};

/// Casos que valem como "visão de conjunto" para a regra do `States`.
const Set<String> kWholeSetCaseNames = <String>{
  'States',
  'Sizes',
  'Type scale',
  'Catalog',
  'Scenario',
};

/// Tipos dispensados do `States`: primitivos de MOTION não têm grade estática
/// — o que eles mostram é a transição, e uma grade congelada some com ela.
const Set<String> kNoWholeSetView = <String>{
  'AppFade',
  'AppPop',
  'AppSlide',
  'AppExpand',
  'AppCrossFade',
  'AppValueBuilder',
  'AppTypewriter',
  'AppAppear',
  'AppAnimatedRotation',
  'AppSpin',
  'AppInteractiveMotion',
  'AppScaleOnTap',
  // Marcadores de página de tokens/cores: o caso É a grade.
  'ColorFoundations',
  'DesignTokens',
};

/// Arquivo → motivo, para o único import de Material tolerado no catálogo.
///
/// A camada `widgets` não tem lista reordenável, e `AppListTile.reorderIndex`
/// existe justamente para viver dentro de uma. Sem a exceção, a alça apareceria
/// sem arrastar nada — pior que a exceção.
const Map<String, String> kMaterialImportAllowlist = <String, String>{
  'list_tile_use_cases.dart':
      'ReorderableListView (não há equivalente em widgets)',
};

/// Sliders permitidos: valores genuinamente contínuos, sem token que os cubra.
final RegExp _sliderAllowedLabel = RegExp(
  r'^(scale|fromScale|opacity|turns|progress|value|dx|dy|'
  r'maxWidth|minWidth|initialWidth|panelMaxHeight|customSize.*|box|'
  r'initialFirstFraction|maxWidth \(0 = no limit\))$',
);

/// Rótulo de slider que cheira a token (o valor mora numa escala do DS).
final RegExp _tokenishLabel = RegExp(
  r'\b(size|spacing|gap|padding|radius|stroke|thickness|duration|height)\b',
  caseSensitive: false,
);

/// Uma use-case declarada no catálogo.
class WbUseCase {
  /// Cria uma [WbUseCase].
  const WbUseCase({
    required this.name,
    required this.type,
    required this.file,
    required this.line,
  });

  /// Nome do caso (`Playground`, `States`…).
  final String name;

  /// Classe registrada em `type:`.
  final String type;

  /// Arquivo do catálogo.
  final String file;

  /// Linha da anotação (1-based).
  final int line;
}

final RegExp _useCaseAnnotation = RegExp(
  r"@widgetbook\.UseCase\(\s*name:\s*'((?:[^'\\]|\\.)*)'\s*,\s*type:\s*([A-Za-z_]\w*)",
);

/// Lê todas as use-cases de `widgetbook/use_cases`.
List<WbUseCase> discoverUseCases(String root) {
  final Directory dir = Directory('$root/widgetbook/use_cases');
  if (!dir.existsSync()) return const <WbUseCase>[];
  final List<WbUseCase> cases = <WbUseCase>[];
  final List<File> files =
      dir
          .listSync()
          .whereType<File>()
          .where((File f) => f.path.endsWith('.dart'))
          .toList()
        ..sort((File a, File b) => a.path.compareTo(b.path));
  for (final File f in files) {
    final String src = f.readAsStringSync();
    for (final RegExpMatch m in _useCaseAnnotation.allMatches(src)) {
      cases.add(
        WbUseCase(
          name: m.group(1)!,
          type: m.group(2)!,
          file: f.uri.pathSegments.last,
          line: src.substring(0, m.start).split('\n').length,
        ),
      );
    }
  }
  return cases;
}

/// Caracteres que só existem em português — heurística barata e suficiente
/// para pegar rótulo/descrição que escapou da tradução.
final RegExp _portuguese = RegExp('[ãáâàéêíóôõúçÃÁÂÉÊÍÓÔÕÚÇ]');

/// Roda todas as checagens do catálogo e devolve os erros.
List<String> widgetbookConventionErrors(String root) {
  final List<String> errors = <String>[];
  final Directory dir = Directory('$root/widgetbook/use_cases');
  if (!dir.existsSync()) return <String>['widgetbook/use_cases não existe'];

  final List<WbUseCase> cases = discoverUseCases(root);

  // R-naming — nome do caso na lista canônica. As PÁGINAS de cor e de token
  // ficam de fora: elas não são componentes, e o nome descritivo ("Semantic
  // colors", "Radius") é o índice do catálogo — a spec já as excetua.
  for (final WbUseCase c in cases) {
    if (kNoWholeSetView.contains(c.type)) continue;
    if (!kCanonicalCaseNames.contains(c.name)) {
      errors.add(
        '${c.file}:${c.line} — caso "${c.name}" (${c.type}) fora dos nomes '
        'canônicos ${kCanonicalCaseNames.toList()..sort()}.',
      );
    }
  }

  // R5 — exatamente um Playground por tipo.
  final Map<String, List<WbUseCase>> byType = <String, List<WbUseCase>>{};
  for (final WbUseCase c in cases) {
    byType.putIfAbsent(c.type, () => <WbUseCase>[]).add(c);
  }
  for (final MapEntry<String, List<WbUseCase>> e in byType.entries) {
    final int playgrounds = e.value
        .where((WbUseCase c) => c.name == 'Playground')
        .length;
    final bool marker =
        kNoWholeSetView.contains(e.key) &&
        e.value.every((WbUseCase c) => c.name != 'Playground');
    if (playgrounds == 0 && !marker) {
      errors.add('${e.key}: sem Playground (Regra 5).');
    } else if (playgrounds > 1) {
      errors.add(
        '${e.key}: $playgrounds Playgrounds — deve haver 1 (Regra 5).',
      );
    }

    // R8 — visão de conjunto.
    if (kNoWholeSetView.contains(e.key)) continue;
    final bool hasWholeSet = e.value.any(
      (WbUseCase c) => kWholeSetCaseNames.contains(c.name),
    );
    if (!hasWholeSet) {
      errors.add(
        '${e.key} (${e.value.first.file}): sem visão de conjunto — falta '
        'States/Sizes/Type scale/Catalog/Scenario (Regra 8).',
      );
    }
  }

  // Checagens por arquivo.
  for (final FileSystemEntity entity in dir.listSync()) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final String file = entity.uri.pathSegments.last;
    final List<String> lines = entity.readAsLinesSync();

    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i];
      final int no = i + 1;

      // R-imports.
      if (line.contains('package:flutter/material.dart') ||
          line.contains('package:flutter/cupertino.dart')) {
        if (!kMaterialImportAllowlist.containsKey(file)) {
          errors.add(
            '$file:$no — importa Material/Cupertino. O catálogo é construído '
            'sobre widgets.dart; se for inevitável, registre a exceção com o '
            'motivo em kMaterialImportAllowlist.',
          );
        }
      }

      // R1 — português na cromo do catálogo (rótulo de knob, nome de estado).
      final RegExpMatch? knob = RegExp(
        r"(context\.knobs\.[\w.]+\(\s*)?label:\s*'((?:[^'\\]|\\.)*)'",
      ).firstMatch(line);
      if (knob != null &&
          knob.group(1) != null &&
          _portuguese.hasMatch(knob.group(2)!)) {
        errors.add(
          '$file:$no — rótulo de knob em português: "${knob.group(2)}".',
        );
      }

      // R-knobs — token em slider livre.
      if (line.contains('knobs.double.slider')) {
        // O rótulo pode estar na linha seguinte.
        final String window = lines
            .sublist(i, (i + 3).clamp(0, lines.length))
            .join(' ');
        final RegExpMatch? lbl = RegExp(
          r"label:\s*'((?:[^'\\]|\\.)*)'",
        ).firstMatch(window);
        final String label = lbl?.group(1) ?? '';
        if (!_sliderAllowedLabel.hasMatch(label) &&
            _tokenishLabel.hasMatch(label)) {
          errors.add(
            '$file:$no — "$label" num slider livre: valores de token usam '
            'wbSize/Spacing/Stroke/Radius/DurationKnob (Regra de knobs).',
          );
        }
      }
    }
  }

  return errors;
}
