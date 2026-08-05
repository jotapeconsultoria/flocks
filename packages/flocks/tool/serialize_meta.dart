// Serializa o catálogo de componentes (`flocksCatalog`) para JSON, consumível
// pelo MCP server e pelo site. Uso: `dart run tool/serialize_meta.dart`.
//
// O arquivo gerado é a fonte da contagem que o site publica, e derivou duas
// vezes em três dias (123 serializados contra 129 reais) porque regenerar era
// um passo manual que ninguém lembrava. Agora a geração vive aqui e a
// CONFERÊNCIA vive em `test/architecture/catalog_freshness_test.dart`, que roda
// no `flutter test` de todo PR.
//
// Por isso a montagem do JSON é uma função pública, e não corpo do `main`: o
// teste chama a mesma, e as duas não têm como divergir.
import 'dart:convert';
import 'dart:io';

import 'package:flocks/meta.dart';

/// Onde o catálogo serializado vive, relativo à raiz do pacote.
const String kCatalogPath = 'doc/mcp/catalog.json';

/// O comando que regenera o arquivo — citado na mensagem de falha do teste.
const String kSerializeCommand = 'dart run tool/serialize_meta.dart';

/// O conteúdo exato que [kCatalogPath] deve ter, incluindo a quebra final.
String serializedCatalog() {
  final List<Map<String, Object?>> catalog = flocksCatalog
      .map((AppComponentMeta m) => m.toJson())
      .toList();
  return '${const JsonEncoder.withIndent('  ').convert(catalog)}\n';
}

void main() {
  final File output = File(kCatalogPath);
  output.parent.createSync(recursive: true);
  output.writeAsStringSync(serializedCatalog());
  stdout.writeln(
    'Escrito ${flocksCatalog.length} componente(s) em ${output.path}',
  );
}
