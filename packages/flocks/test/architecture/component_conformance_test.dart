// A "Definition of Migrated" dentro do `flutter test`.
//
// O gate já existia em `tool/validate_components.dart`, mas só a CI o rodava —
// e quem trabalha no pacote roda `flutter test`. O resultado era um validador
// vermelho por semanas sem ninguém ver. Aqui as MESMAS regras falham na suíte.
import 'package:flutter_test/flutter_test.dart';

import '../../tool/component_conformance.dart';

void main() {
  test('todo componente cumpre a Definition of Migrated', () {
    final List<String> errors = conformanceErrors('.');
    expect(
      errors,
      isEmpty,
      reason:
          'Conformidade de componentes ("Definition of Migrated", as regras '
          'em tool/component_conformance.dart):\n'
          '${errors.map((String e) => '  - $e').join('\n')}',
    );
  });
}
