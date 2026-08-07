// Embarca o `doc/mcp/catalog.json` do `flocks` como Dart gerado, consumível
// por um binário instalado avulso. Uso: `dart run tool/embed_catalog.dart`.
//
// Por que embarcar em vez de ler o arquivo. `dart pub global activate
// flocks_mcp` instala UM pacote: o `doc/` do `flocks` não vem junto, e não há
// caminho relativo que o alcance na máquina de quem instalou. Ou o catálogo
// viaja dentro do código, ou o servidor sobe sem dado.
//
// Por que com gate. Catálogo embarcado é número derivado do código, e este
// repositório já perdeu duas vezes para esse modo de falha: o `catalog.json`
// derivou 123 contra 129 reais em três dias, e "295 use cases" circulou como
// 293 e 297. Sem gate, o MCP serviria props que não existem mais — em
// silêncio, que é o pior jeito. A CONFERÊNCIA vive em
// `test/catalog_embed_freshness_test.dart`, que roda no `dart test` de todo PR.
//
// Por isso a montagem é uma função pública, e não corpo do `main`: o teste
// chama a mesma, e as duas não têm como divergir. É o mesmo desenho do
// `tool/serialize_meta.dart` e do `tool/count_use_cases.dart` do `flocks`.
import 'dart:convert';
import 'dart:io';

/// A fonte, relativa à raiz DESTE pacote — que é o cwd tanto do `dart run`
/// quanto do `dart test`. O arquivo é gerado lá por
/// `dart run tool/serialize_meta.dart` e fiscalizado lá pelo
/// `catalog_freshness_test`; aqui ele é só a entrada.
const String kCatalogSourcePath = '../flocks/doc/mcp/catalog.json';

/// Onde o catálogo embarcado vive, relativo à raiz do pacote.
const String kEmbeddedPath = 'lib/src/catalog_data.g.dart';

/// O comando que regenera o arquivo — citado na mensagem de falha do teste.
const String kEmbedCommand = 'dart run tool/embed_catalog.dart';

/// Escapa [raw] como literal Dart de aspas duplas.
///
/// `jsonEncode` já trata aspas, barras invertidas e caracteres de controle, e
/// a gramática de string JSON é subconjunto da de Dart — menos por um detalhe:
/// o `$` inicia interpolação em Dart e passa intacto pelo `jsonEncode`. Daí o
/// segundo passo.
///
/// Nem raw string (`r'''…'''`, que não pode conter `'''` nem terminar em `'`)
/// nem concatenação de pedaços: as duas dependem de o conteúdo continuar se
/// comportando. Hoje o catálogo não tem `$` nem `'''`; esta função é a que não
/// precisa que isso continue verdade.
String dartStringLiteral(String raw) => jsonEncode(raw).replaceAll(r'$', r'\$');

/// O conteúdo exato que [kEmbeddedPath] deve ter, incluindo a quebra final.
///
/// Sai já no formato que o `dart format` produz — o
/// `dart format --set-exit-if-changed .` da raiz varre o workspace inteiro, e
/// um gerado que o formatter quisesse reescrever reprovaria a CI a cada
/// regeneração.
String embeddedCatalogSource() {
  final String raw = File(kCatalogSourcePath).readAsStringSync();
  return '''
// GERADO por `$kEmbedCommand`. NÃO EDITE À MÃO.
//
// A fonte é `$kCatalogSourcePath`, e
// `test/catalog_embed_freshness_test.dart` compara os dois byte a byte a cada
// `dart test`. Editar aqui não sobrevive à próxima regeneração — e, antes
// disso, fica vermelho.

/// O catálogo de componentes do `flocks`, byte a byte como serializado lá.
///
/// String, e não estrutura Dart: o que o gate compara é o texto contra o
/// arquivo-fonte, e qualquer transformação na geração abriria espaço para a
/// cópia embarcada divergir sem nada acusar. O parse acontece uma vez, em
/// `lib/src/catalog.dart`.
const String kCatalogJson =
    ${dartStringLiteral(raw)};
''';
}

void main() {
  final File source = File(kCatalogSourcePath);
  if (!source.existsSync()) {
    stderr.writeln(
      'Fonte não encontrada: $kCatalogSourcePath. Este gerador roda a partir '
      'de packages/flocks_mcp, num checkout do repositório do Flocks — o '
      'catálogo mora no pacote irmão.',
    );
    exitCode = 1;
    return;
  }

  final File output = File(kEmbeddedPath);
  output.parent.createSync(recursive: true);
  output.writeAsStringSync(embeddedCatalogSource());

  final int components =
      (jsonDecode(source.readAsStringSync()) as List<Object?>).length;
  stdout.writeln('Embarcados $components componente(s) em ${output.path}');
}
