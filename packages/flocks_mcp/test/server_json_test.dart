// O `server.json` do MCP Registry é gerado NO JOB DE RELEASE, não commitado —
// o `identifier` carrega a tag e o `fileSha256` só existe depois do build, e
// um arquivo commitado antes do release mentiria um dos dois (a justificativa
// inteira está no cabeçalho do gerador). O que fica no repositório é a
// função, e este gate segura a forma dela: se o registry mudar de schema ou
// alguém trocar o namespace sem querer, é aqui que fica vermelho, não na
// máquina de quem instalou um hash errado.
import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import '../tool/generate_mcpb_manifest.dart' show kPubspecPath, pubspecField;
import '../tool/generate_server_json.dart';

void main() {
  final String version = pubspecField(
    File(kPubspecPath).readAsStringSync(),
    'version',
  );
  // Um hash sintático: o real só existe no job, depois do zip. O gate valida
  // a FORMA do arquivo; a verdade do hash é responsabilidade do job, que o
  // calcula do mesmo arquivo que anexa, no mesmo passo.
  final String dummySha = 'a' * 64;
  final Map<String, Object?> server =
      jsonDecode(serverJsonSource(version: version, fileSha256: dummySha))
          as Map<String, Object?>;

  test('nome, schema e transporte são os decididos', () {
    expect(server['name'], kRegistryName);
    expect(
      server[r'$schema'],
      'https://static.modelcontextprotocol.io/schemas/2025-12-11/server.schema.json',
    );
    final List<Object?> packages = server['packages']! as List<Object?>;
    expect(packages, hasLength(1));
    final Map<String, Object?> package =
        packages.single! as Map<String, Object?>;
    expect(package['registryType'], 'mcpb');
    expect(package['transport'], <String, Object?>{'type': 'stdio'});
    expect(package['fileSha256'], dummySha);
  });

  test('o identifier aponta para o Release da versão do pubspec', () {
    final Map<String, Object?> package =
        (server['packages']! as List<Object?>).single! as Map<String, Object?>;
    final String identifier = package['identifier']! as String;
    expect(
      identifier,
      'https://github.com/jotapeconsultoria/flocks/releases/download/'
      'v$version/$kBundleFileName',
      reason:
          'A URL do artefato é derivada da versão do pubspec — divergir aqui '
          'é publicar no registry um link para um release que não existe.',
    );
    // Regra do registry para `registryType: mcpb`: a URL PRECISA conter a
    // string "mcp". O nome `flocks-mcp.mcpb` a satisfaz; se o artefato for
    // renomeado, esta é a linha que impede a surpresa na hora de publicar.
    expect(identifier, contains('mcp'));
  });

  test('a versão do server.json é a do pubspec', () {
    expect(server['version'], version);
  });

  test('um sha fora do pattern do schema é recusado na geração', () {
    // O schema exige `^[a-f0-9]{64}$` — hex minúsculo. O registry não valida
    // o hash, os clientes validam: deixar um valor torto passar aqui é
    // instalação quebrada na máquina alheia.
    expect(
      () => serverJsonSource(version: version, fileSha256: 'não-é-um-sha'),
      throwsArgumentError,
    );
    expect(
      () => serverJsonSource(version: version, fileSha256: 'A' * 64),
      throwsArgumentError,
      reason: 'Hex maiúsculo também viola o pattern do schema.',
    );
  });
}
