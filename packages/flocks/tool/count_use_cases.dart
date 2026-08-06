// Serializa a contagem de use cases do catálogo Widgetbook para JSON,
// consumível por quem publica o número (site, ROADMAP, release notes).
// Uso: `dart run tool/count_use_cases.dart`.
//
// "295 use cases" já circulou como 293 e 297 porque cada citação media na mão,
// num momento diferente — o mesmo modo de falha que o `catalog.json` tinha
// antes do `catalog_freshness_test`. Mesmo remédio: a geração vive aqui e a
// CONFERÊNCIA vive em `test/architecture/use_case_count_test.dart`, que roda no
// `flutter test` de todo PR. Quem cita, deriva daqui.
//
// Por isso a montagem do JSON é uma função pública, e não corpo do `main`: o
// teste chama a mesma, e as duas não têm como divergir.
import 'dart:convert';
import 'dart:io';

import 'widgetbook_conventions.dart';

/// Onde a contagem serializada vive, relativo à raiz do pacote.
const String kUseCaseCountPath = 'doc/widgetbook_use_cases.json';

/// O comando que regenera o arquivo — citado na mensagem de falha do teste.
const String kCountCommand = 'dart run tool/count_use_cases.dart';

/// O conteúdo exato que [kUseCaseCountPath] deve ter, incluindo a quebra
/// final. A contagem deriva das anotações `@widgetbook.UseCase` reais, via
/// [discoverUseCases] — a mesma leitura que o gate de convenções usa.
String serializedUseCaseCount() {
  final int count = discoverUseCases('.').length;
  return '${const JsonEncoder.withIndent('  ').convert(<String, Object?>{'useCases': count})}\n';
}

void main() {
  final File output = File(kUseCaseCountPath);
  output.parent.createSync(recursive: true);
  output.writeAsStringSync(serializedUseCaseCount());
  stdout.writeln(
    'Escrito ${discoverUseCases('.').length} use case(s) em ${output.path}',
  );
}
