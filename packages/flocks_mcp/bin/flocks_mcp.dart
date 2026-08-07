// O executável: o servidor MCP do Flocks falando por stdin/stdout.
//
// É o que `dart pub global activate flocks_mcp` põe no PATH, e o que um
// cliente (Claude Code, Claude Desktop, Cursor) sobe como subprocesso. Curto
// porque tem que ser: o catálogo viaja embarcado, então não há arquivo a
// localizar, credencial a ler nem rede a alcançar — subir e falar.
//
// A regra que rege este arquivo: NADA vai para o stdout além de JSON-RPC. O
// stdout É o canal, e um `print` de diagnóstico no meio dele quebra o parse do
// cliente com uma mensagem que não parece ter nada a ver. Diagnóstico vai para
// o stderr, que os clientes mostram no log do servidor.
import 'dart:io';

import 'package:dart_mcp/stdio.dart';
import 'package:flocks_mcp/flocks_mcp.dart';

void main(List<String> arguments) {
  if (arguments.contains('--help') || arguments.contains('-h')) {
    stderr.writeln(
      'flocks_mcp — the Flocks design system catalog, as an MCP server.\n'
      '\n'
      'Takes no arguments: it speaks MCP over stdin/stdout and is meant to be\n'
      'launched by an MCP client, not by hand. Register it with:\n'
      '\n'
      '  claude mcp add flocks -- flocks_mcp\n'
      '\n'
      'Tools: list_components · get_component · search_components.\n'
      'See https://github.com/jotapeconsultoria/flocks for the full contract.',
    );
    return;
  }

  FlocksMcpServer(stdioChannel(input: stdin, output: stdout));
}
