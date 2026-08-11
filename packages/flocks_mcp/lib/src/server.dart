// A fiação: o contrato de `tools.dart` sobre um canal JSON-RPC.
//
// Fina de propósito. Tudo que decide o que a resposta É mora em `tools.dart` e
// `catalog.dart`, testável sem processo; aqui só sobra o que só existe quando
// há um cliente do outro lado — o handshake, o registro das tools e a versão
// que o servidor anuncia.
import 'dart:async';

import 'package:dart_mcp/server.dart';

import 'catalog.dart';
import 'tools.dart';

/// A versão que o servidor anuncia no `initialize`.
///
/// Espelha o `version:` do pubspec, e `test/install_docs_test.dart` cobra que
/// os dois não se separem: um servidor que se apresenta com a versão errada
/// mente para o log de quem for depurar a integração.
const String kServerVersion = '0.1.2';

/// O que o cliente lê antes de decidir chamar qualquer coisa.
///
/// Entra no system prompt de quem conecta, então a frase que importa é a
/// segunda: Flocks não é Material, e um modelo que deduzir a API pelo nome do
/// widget escreve código que não compila. É o erro que este servidor existe
/// para evitar, dito antes de a primeira tool ser chamada.
const String kServerInstructions =
    'Flocks is a Flutter design system built directly on widgets.dart — it '
    'uses no Material and no Cupertino. This server serves its component '
    'catalog: 131 components with their props, when to use and when not to '
    'use them, do and don\'t, accessibility behaviour and runnable examples, '
    'in English and Portuguese. Before writing UI for a Flocks codebase, call '
    'get_component for each component you intend to use: the APIs are not '
    "Material's, so parameter names inferred from the widget name will not "
    'compile. Start from list_components or search_components when you do not '
    'know the id yet.';

/// O servidor MCP do Flocks.
base class FlocksMcpServer extends MCPServer with ToolsSupport {
  /// Serve [catalog], ou o catálogo embarcado se nenhum for passado.
  ///
  /// O parâmetro existe para os testes: é o que permite exercitar o handshake
  /// contra um catálogo minúsculo sem tocar no que o binário serve.
  FlocksMcpServer(super.channel, {FlocksCatalog? catalog})
    : catalog = catalog ?? FlocksCatalog.embedded,
      super.fromStreamChannel(
        implementation: Implementation(
          name: 'flocks_mcp',
          version: kServerVersion,
        ),
        instructions: kServerInstructions,
      );

  /// O catálogo que este servidor serve.
  final FlocksCatalog catalog;

  @override
  FutureOr<InitializeResult> initialize(InitializeRequest request) {
    // Registrar aqui, e não no corpo do construtor, é o que o `ToolsSupport`
    // documenta: é neste ponto que a capability `tools` entra no
    // `InitializeResult` que volta para o cliente.
    for (final Tool tool in flocksTools) {
      registerTool(
        tool,
        (CallToolRequest request) => runTool(
          tool.name,
          request.arguments ?? const <String, Object?>{},
          catalog,
        ),
      );
    }
    return super.initialize(request);
  }
}
