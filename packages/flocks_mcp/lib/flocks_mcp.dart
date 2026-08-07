/// The Flocks MCP server: the `flocks` component catalog, served to agents
/// over stdio.
///
/// The executable in `bin/` is the product; this library is what it is built
/// from, and what the tests exercise. Three layers, kept apart on purpose:
///
/// - [FlocksCatalog] answers questions about the catalog and knows nothing
///   about MCP;
/// - [runTool] and [flocksTools] are the tool contract — arguments in,
///   `CallToolResult` out — and know nothing about transports;
/// - [FlocksMcpServer] wires that contract onto a JSON-RPC channel.
library;

export 'src/catalog.dart';
export 'src/server.dart';
export 'src/tools.dart';
