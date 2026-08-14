// O teste que prova que o BINÁRIO funciona, não só as funções.
//
// `tools_contract_test.dart` chama `runTool` e confere a resposta — tudo o que
// ele prova é que o cálculo está certo. Nada ali toca o handshake, o registro
// de tools no `initialize`, o enquadramento de JSON por linha, nem o fato de
// que um único `print` perdido no stdout quebraria o parse do cliente com uma
// mensagem sem relação aparente. Este sobe o executável como processo e fala
// com ele por stdin/stdout, que é exatamente o que Claude Code, Claude Desktop
// e Cursor fazem.
//
// É também o canário do pin `dart_mcp: ^0.5.2`. O package se declara
// experimental e o 0.6.0-wip já troca o tipo do canal; quem for subir o pin
// descobre aqui, e não num cliente de alguém.
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flocks_mcp/src/server.dart' show kServerVersion;
import 'package:test/test.dart';

/// Quanto esperar por uma resposta antes de considerar o servidor pendurado.
///
/// Servidor que não responde tem que ficar VERMELHO, não travar a CI até o
/// timeout global do runner — que chegaria sem dizer qual passo travou.
const Duration kReplyTimeout = Duration(seconds: 30);

/// Um cliente MCP mínimo, falando com o processo por linha.
class ServerProcess {
  ServerProcess._(this._process, this._lines);

  final Process _process;
  final StreamQueue<String> _lines;
  int _nextId = 0;

  /// Sobe `bin/flocks_mcp.dart` e prepara a leitura do stdout.
  static Future<ServerProcess> start() async {
    final Process process = await Process.start(
      Platform.resolvedExecutable,
      <String>['run', 'bin/flocks_mcp.dart'],
    );
    // O stderr do servidor é diagnóstico; encaminhado para o do teste, ele vira
    // a primeira pista quando algo aqui falhar.
    process.stderr.transform(utf8.decoder).listen(stderr.write);
    return ServerProcess._(
      process,
      StreamQueue<String>(
        process.stdout.transform(utf8.decoder).transform(const LineSplitter()),
      ),
    );
  }

  /// Envia uma requisição e devolve a resposta correspondente.
  Future<Map<String, Object?>> request(
    String method, [
    Map<String, Object?>? params,
  ]) async {
    final int id = ++_nextId;
    _send(<String, Object?>{
      'jsonrpc': '2.0',
      'id': id,
      'method': method,
      'params': ?params,
    });
    // Notificações do servidor (`notifications/tools/list_changed`, por
    // exemplo) podem chegar entre a pergunta e a resposta: a resposta é a
    // primeira linha que traz o `id` que enviamos.
    while (true) {
      final Map<String, Object?> message = await _receive();
      if (message['id'] == id) {
        return message;
      }
    }
  }

  /// Envia uma notificação (sem `id`, sem resposta).
  void notify(String method, [Map<String, Object?>? params]) => _send(
    <String, Object?>{'jsonrpc': '2.0', 'method': method, 'params': ?params},
  );

  /// Encerra o processo.
  Future<void> shutdown() async {
    await _lines.cancel(immediate: true);
    _process.kill();
    await _process.exitCode;
  }

  void _send(Map<String, Object?> message) =>
      _process.stdin.writeln(jsonEncode(message));

  Future<Map<String, Object?>> _receive() async {
    final String line = await _lines.next.timeout(
      kReplyTimeout,
      onTimeout: () => throw StateError(
        'O servidor não respondeu em ${kReplyTimeout.inSeconds}s. Ele subiu e '
        'ficou mudo, ou escreveu algo que não é uma linha de JSON-RPC no '
        'stdout.',
      ),
    );
    return jsonDecode(line) as Map<String, Object?>;
  }
}

/// O `result` de uma resposta, falhando com o `error` quando veio erro.
Map<String, Object?> resultOf(Map<String, Object?> reply) {
  expect(
    reply['error'],
    isNull,
    reason: 'O servidor devolveu erro de JSON-RPC: ${reply['error']}',
  );
  return reply['result']! as Map<String, Object?>;
}

/// O texto do primeiro conteúdo de um `tools/call`.
String contentText(Map<String, Object?> callResult) =>
    ((callResult['content']! as List<Object?>).first
            as Map<String, Object?>)['text']!
        as String;

void main() {
  late ServerProcess server;

  setUpAll(() async {
    server = await ServerProcess.start();
  });

  tearDownAll(() async {
    await server.shutdown();
  });

  // Um `group` só, e os testes em ordem: são as etapas de UMA conversa com um
  // servidor com estado. Rodá-las isoladas exigiria subir o processo cinco
  // vezes, e a etapa que mais importa — o `initialize` acontecer ANTES de
  // qualquer `tools/call` — deixaria de ser exercitada.
  group('a conversa MCP com o binário', () {
    test(
      'initialize devolve serverInfo, versão e a capability de tools',
      () async {
        final Map<String, Object?> result = resultOf(
          await server.request('initialize', <String, Object?>{
            'protocolVersion': '2025-06-18',
            'capabilities': <String, Object?>{},
            'clientInfo': <String, Object?>{
              'name': 'flocks_mcp protocol test',
              'version': '0.1.0',
            },
          }),
        );

        final Map<String, Object?> info =
            result['serverInfo']! as Map<String, Object?>;
        expect(info['name'], 'flocks_mcp');
        // Contra a constante, e não contra um literal: o que este teste tem a
        // provar é que o BINÁRIO anuncia o que o código declara. Quem amarra a
        // constante ao `version:` do pubspec são o `install_docs_test` e o
        // `mcpb_manifest_test` — o triângulo continua fechado, e um literal a
        // menos envelhece a cada bump.
        expect(info['version'], kServerVersion);
        expect(result['protocolVersion'], isA<String>());
        expect(
          (result['capabilities']! as Map<String, Object?>)['tools'],
          isNotNull,
          reason:
              'Sem a capability `tools`, nenhum cliente chama tool nenhuma.',
        );
        expect(
          result['instructions'],
          contains('no Material'),
          reason:
              'As instructions entram no system prompt do cliente, e é ali que a '
              'premissa do pacote precisa chegar antes da primeira chamada.',
        );

        server.notify('notifications/initialized');
      },
    );

    test('tools/list traz as três do contrato, com schema', () async {
      final List<Object?> tools =
          resultOf(await server.request('tools/list'))['tools']!
              as List<Object?>;
      final Map<String, Map<String, Object?>> byName =
          <String, Map<String, Object?>>{
            for (final Object? t in tools)
              (t! as Map<String, Object?>)['name']! as String:
                  t as Map<String, Object?>,
          };

      expect(byName.keys, <String>[
        'list_components',
        'get_component',
        'search_components',
      ]);
      for (final Map<String, Object?> tool in byName.values) {
        expect(tool['description'], isNotEmpty);
        final Map<String, Object?> schema =
            tool['inputSchema']! as Map<String, Object?>;
        expect(schema['type'], 'object');
        expect(
          (schema['properties']! as Map<String, Object?>).keys,
          contains('lang'),
        );
      }
      expect(
        byName['get_component']!['inputSchema'],
        containsPair('required', <String>['id']),
      );
      expect(
        byName['search_components']!['inputSchema'],
        containsPair('required', <String>['query']),
      );
    });

    test('tools/call list_components devolve os 135', () async {
      final Map<String, Object?> result = resultOf(
        await server.request('tools/call', <String, Object?>{
          'name': 'list_components',
          'arguments': <String, Object?>{},
        }),
      );
      final Map<String, Object?> payload =
          jsonDecode(contentText(result)) as Map<String, Object?>;
      expect(payload['count'], 135);
      expect(payload['lang'], 'en');
    });

    test('tools/call get_component atravessa o lang até a prosa', () async {
      final Map<String, Object?> result = resultOf(
        await server.request('tools/call', <String, Object?>{
          'name': 'get_component',
          'arguments': <String, Object?>{'id': 'app_badge', 'lang': 'pt'},
        }),
      );
      expect(result['isError'], isNot(true));
      final Map<String, Object?> component =
          (jsonDecode(contentText(result))
                  as Map<String, Object?>)['component']!
              as Map<String, Object?>;
      expect(component['name'], 'AppBadge');
      expect(
        component['summary'],
        'Pill compacta de status, tingida por papel de cor semântico.',
      );
      expect(
        (component['props']! as List<Object?>).first,
        containsPair('name', 'label'),
      );
    });

    test(
      'id inexistente chega ao cliente como isError, com a sugestão',
      () async {
        // A parte do contrato que mais depende do transporte: se a recusa
        // virasse erro de JSON-RPC em algum ponto do caminho, o modelo do outro
        // lado nunca leria a sugestão — veria a chamada falhar e pronto.
        final Map<String, Object?> result = resultOf(
          await server.request('tools/call', <String, Object?>{
            'name': 'get_component',
            'arguments': <String, Object?>{'id': 'appbadge'},
          }),
        );
        expect(result['isError'], isTrue);
        expect(contentText(result), contains('"app_badge"'));
        expect(contentText(result), contains('list_components'));
      },
    );
  });
}
