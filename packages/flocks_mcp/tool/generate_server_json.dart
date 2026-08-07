// Gera o `server.json` do MCP Registry — no JOB DE RELEASE, não no repo.
// Uso: `dart run tool/generate_server_json.dart <sha256-do-.mcpb>` (escreve no
// stdout; o job redireciona para o arquivo que anexa ao Release).
//
// Por que gerado no release em vez de commitado. Dos campos do arquivo, dois
// mudam a cada versão: o `identifier` (a URL do artefato no Release, que
// carrega a tag) e o `fileSha256` (o hash do zip, que só existe DEPOIS do
// build). Um server.json commitado antes do primeiro release carregaria um
// hash de um artefato que não existe — mentira com cara de fonte de verdade —
// ou um placeholder que viola o pattern do schema. Gerado no job, nenhum hash
// escrito à mão existe no repositório, e o que fica commitado é esta função,
// com gate em `test/server_json_test.dart` para a forma e o lockstep de
// versão.
//
// O namespace é `io.github.jotapeconsultoria` — autenticado por device flow
// do GitHub, sem segredo permanente. A alternativa por DNS com `flocks.live`
// daria o reverse-DNS desajeitado `live.flocks/…` e exigiria guardar uma
// chave Ed25519 para sempre; pesado e descartado (ver o README).
//
// O registry NÃO valida o hash — os CLIENTES validam antes de instalar. Um
// sha errado aqui é instalação quebrada na máquina alheia, por isso o job o
// calcula do mesmo arquivo que anexa, no mesmo passo.
import 'dart:convert';
import 'dart:io';

import 'generate_mcpb_manifest.dart' show kPubspecPath, pubspecField;

/// O nome no registry. A URL do artefato PRECISA conter "mcp" (regra do
/// registry para `registryType: mcpb`) — o arquivo `flocks-mcp.mcpb` satisfaz.
const String kRegistryName = 'io.github.jotapeconsultoria/flocks-mcp';

/// O nome do artefato anexado ao Release, estável entre versões: é o que
/// permite ao site apontar para `releases/latest/download/`.
const String kBundleFileName = 'flocks-mcp.mcpb';

/// O formato que o schema exige de `fileSha256`.
final RegExp kSha256Pattern = RegExp(r'^[a-f0-9]{64}$');

/// O conteúdo do server.json para [version] com o hash [fileSha256],
/// incluindo a quebra final.
String serverJsonSource({required String version, required String fileSha256}) {
  if (!kSha256Pattern.hasMatch(fileSha256)) {
    throw ArgumentError.value(
      fileSha256,
      'fileSha256',
      'não é um SHA-256 em hex minúsculo (64 caracteres)',
    );
  }
  final Map<String, Object?> server = <String, Object?>{
    r'$schema':
        'https://static.modelcontextprotocol.io/schemas/2025-12-11/server.schema.json',
    'name': kRegistryName,
    'title': 'Flocks MCP',
    'description': pubspecField(
      File(kPubspecPath).readAsStringSync(),
      'description',
    ),
    'repository': <String, Object?>{
      'url': 'https://github.com/jotapeconsultoria/flocks',
      'source': 'github',
    },
    'version': version,
    'websiteUrl': 'https://flocks.live/mcp/',
    'packages': <Object?>[
      <String, Object?>{
        'registryType': 'mcpb',
        'identifier':
            'https://github.com/jotapeconsultoria/flocks/releases/download/'
            'v$version/$kBundleFileName',
        'fileSha256': fileSha256,
        'transport': <String, Object?>{'type': 'stdio'},
      },
    ],
  };
  return '${const JsonEncoder.withIndent('  ').convert(server)}\n';
}

void main(List<String> arguments) {
  if (arguments.length != 1) {
    stderr.writeln(
      'Uso: dart run tool/generate_server_json.dart <sha256-do-.mcpb>',
    );
    exitCode = 64;
    return;
  }
  final String version = pubspecField(
    File(kPubspecPath).readAsStringSync(),
    'version',
  );
  stdout.write(serverJsonSource(version: version, fileSha256: arguments[0]));
}
