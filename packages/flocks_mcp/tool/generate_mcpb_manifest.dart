// Gera o `mcpb/manifest.json` — o manifesto do MCP Bundle (`.mcpb`) — a
// partir do `pubspec.yaml` e do contrato de tools em código. Uso:
// `dart run tool/generate_mcpb_manifest.dart`.
//
// Por que gerado. `name`, `version` e `description` já vivem no pubspec, e a
// versão já vive TAMBÉM em `kServerVersion` (com gate no
// `test/install_docs_test.dart`). Um manifesto escrito à mão seria o TERCEIRO
// lugar para a mesma versão envelhecer sozinha — a armadilha que este
// repositório já pagou duas vezes para aprender. Quarta aplicação do padrão
// gerador+gate (`catalog.json`, `widgetbook_use_cases.json`,
// `catalog_data.g.dart`): a montagem é função pública, o
// `test/mcpb_manifest_test.dart` chama a mesma, e os dois não têm como
// divergir. As tools vêm de `flocksTools` pela mesma razão — o manifesto
// anuncia exatamente o que o servidor registra.
//
// Por que `/bin/sh` + `run.sh` em vez do binário direto. O Claude Desktop
// extrai o zip descartando os modos Unix (mcpb#294): todo arquivo chega como
// 0600, sem bit de execução, e um `command` apontando para o binário falha
// com EACCES em toda instalação. O `sh` só precisa de LEITURA no script, e o
// `run.sh` devolve o `+x` ao binário antes do `exec`. O mesmo script faz a
// seleção de arquitetura via `uname -m`, porque o formato não tem nenhuma —
// `platform_overrides` seleciona só por OS (`darwin`/`win32`/`linux`).
// Windows não tem bit de execução, então lá o `.exe` entra direto.
import 'dart:convert';
import 'dart:io';

import 'package:dart_mcp/server.dart';
import 'package:flocks_mcp/flocks_mcp.dart';

/// A fonte dos campos `name`, `version` e `description`.
const String kPubspecPath = 'pubspec.yaml';

/// Onde o manifesto vive, relativo à raiz do pacote.
const String kManifestPath = 'mcpb/manifest.json';

/// O launcher que o manifesto declara como entry point (ver o cabeçalho).
const String kLauncherPath = 'mcpb/run.sh';

/// O comando que regenera o arquivo — citado na mensagem de falha do teste.
const String kManifestCommand = 'dart run tool/generate_mcpb_manifest.dart';

/// Os binários que o job de release compila e o bundle carrega, por
/// OS-arquitetura. O `run.sh` monta este nome com `uname`; o `ci.yml` o usa
/// como saída do `dart compile exe` — e o gate confere as três pontas.
const List<String> kBundleBinaries = <String>[
  'flocks_mcp-darwin-arm64',
  'flocks_mcp-darwin-x64',
  'flocks_mcp-linux-x64',
  'flocks_mcp-windows-x64.exe',
];

/// Extrai um campo escalar do pubspec, sem parser de YAML: os três campos que
/// interessam são linhas `chave: valor` no topo do arquivo, e uma dependência
/// de YAML aqui viraria dependência do PACOTE (o gerador e o gate compilam
/// junto com ele).
String pubspecField(String pubspec, String field) {
  final RegExpMatch? match = RegExp(
    '^$field:\\s*(.+?)\\s*\$',
    multiLine: true,
  ).firstMatch(pubspec);
  if (match == null) {
    throw StateError('O pubspec perdeu o campo `$field:`.');
  }
  final String raw = match.group(1)!;
  // O `description:` vem entre aspas duplas no pubspec; `name:` e `version:`
  // vêm nus. O manifesto quer o valor, não a sintaxe de YAML.
  if (raw.length >= 2 && raw.startsWith('"') && raw.endsWith('"')) {
    return raw.substring(1, raw.length - 1);
  }
  return raw;
}

/// O conteúdo exato que [kManifestPath] deve ter, incluindo a quebra final.
String mcpbManifestSource() {
  final String pubspec = File(kPubspecPath).readAsStringSync();
  final Map<String, Object?> manifest = <String, Object?>{
    'manifest_version': '0.3',
    'name': pubspecField(pubspec, 'name'),
    'display_name': 'Flocks MCP',
    'version': pubspecField(pubspec, 'version'),
    'description': pubspecField(pubspec, 'description'),
    'author': <String, Object?>{
      'name': 'JotaPe Tecnologia',
      'url': 'https://flocks.live',
    },
    'license': 'MIT',
    'homepage': 'https://flocks.live/mcp/',
    'documentation':
        'https://github.com/jotapeconsultoria/flocks/tree/main/packages/flocks_mcp',
    'support': 'https://github.com/jotapeconsultoria/flocks/issues',
    'repository': <String, Object?>{
      'type': 'git',
      'url': 'https://github.com/jotapeconsultoria/flocks',
    },
    'server': <String, Object?>{
      'type': 'binary',
      'entry_point': 'server/run.sh',
      'mcp_config': <String, Object?>{
        'command': '/bin/sh',
        'args': <String>[r'${__dirname}/server/run.sh'],
        'platform_overrides': <String, Object?>{
          'win32': <String, Object?>{
            'command': r'${__dirname}/server/flocks_mcp-windows-x64.exe',
            'args': <String>[],
          },
        },
      },
    },
    'tools': <Object?>[
      for (final Tool tool in flocksTools)
        <String, Object?>{'name': tool.name, 'description': tool.description},
    ],
    'compatibility': <String, Object?>{
      'platforms': <String>['darwin', 'win32', 'linux'],
    },
  };
  return '${const JsonEncoder.withIndent('  ').convert(manifest)}\n';
}

void main() {
  final File output = File(kManifestPath);
  output.parent.createSync(recursive: true);
  output.writeAsStringSync(mcpbManifestSource());
  stdout.writeln('Manifesto do bundle gerado em ${output.path}');
}
