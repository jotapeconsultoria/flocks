// Valida o catálogo de componentes do Flocks. Roda no CI; sai com código != 0
// se algo falhar. Uso: `dart run tool/validate_components.dart`.
//
// As regras vivem em `component_conformance.dart` — compartilhadas com
// `test/architecture/component_conformance_test.dart`, para o mesmo gate valer
// no `flutter test`.
import 'dart:io';

import 'package:flocks/meta.dart';

import 'component_conformance.dart';

void main() {
  final List<String> errors = conformanceErrors('.');

  if (errors.isNotEmpty) {
    stderr.writeln('Validação de componentes FALHOU (${errors.length}):');
    for (final String e in errors) {
      stderr.writeln('  - $e');
    }
    exit(1);
  }

  final int migrated = flocksCatalog
      .where((AppComponentMeta m) => m.status == ComponentStatus.migrated)
      .length;
  final int internal = discoverWidgets(
    '.',
  ).where((DiscoveredWidget w) => w.isInternal).length;
  stdout.writeln(
    'OK: $migrated componente(s) migrado(s) + $internal interno(s); '
    'catálogo, artefatos e testes completos.',
  );
}
