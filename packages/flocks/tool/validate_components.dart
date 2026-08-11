// Valida o catálogo de componentes do Flocks. Roda no CI; sai com código != 0
// se algo falhar. Uso: `dart run tool/validate_components.dart`, e o cwd tem de
// ser a raiz do pacote — de fora dela ele NÃO RODA e diz qual comando rodar, em
// vez de descobrir zero widget e aprovar.
//
// As regras vivem em `component_conformance.dart` — compartilhadas com
// `test/architecture/component_conformance_test.dart`, para o mesmo gate valer
// no `flutter test`.
import 'dart:io';

import 'package:flocks/meta.dart';

import 'component_conformance.dart';

void main() {
  final List<String> errors;
  try {
    errors = conformanceErrors('.');
  } on StateError catch (e) {
    // A mensagem sai verbatim, sem glosa: assim um `StateError` futuro de outra
    // origem não sai diagnosticado como cwd errado. `exit` é `Never`, então o
    // `errors` de cima dispensa `late`.
    stderr.writeln('Validação de componentes NÃO RODOU: ${e.message}');
    exit(1);
  }

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
