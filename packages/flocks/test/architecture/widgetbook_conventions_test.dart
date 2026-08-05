// As convenções do catálogo (`widgetbook/CONVENTIONS.md`) dentro do
// `flutter test`.
//
// Antes eram só um documento: quem escrevia a use-case nova não tinha como
// saber que esqueceu o `States`, deixou um rótulo em português ou trocou um
// token por um slider livre — e nada quebrava.
import 'package:flutter_test/flutter_test.dart';

import '../../tool/widgetbook_conventions.dart';

void main() {
  test('o catálogo Widgetbook cumpre o CONVENTIONS.md', () {
    final List<String> errors = widgetbookConventionErrors('.');
    expect(
      errors,
      isEmpty,
      reason:
          'Convenções do catálogo (widgetbook/CONVENTIONS.md):\n'
          '${errors.map((String e) => '  - $e').join('\n')}',
    );
  });
}
