# Examples

The product of this package is a command, not a library call: `flocks_mcp`
speaks MCP over stdio, takes no arguments and no configuration. So the first
example is a client registration, the second is the same conversation without a
client, and the third is the catalog used directly from Dart.

## Register it with an agent

```bash
dart pub global activate flocks_mcp
claude mcp add flocks -- flocks_mcp
```

Then ask for a component by name and the agent answers from the real prop list
instead of guessing Material's. `.cursor/mcp.json` and
`claude_desktop_config.json` take the same command — see the package README.

## Talk to it by hand

Useful when a client is misbehaving and you need to know which side is wrong.
MCP over stdio is newline-delimited JSON-RPC 2.0, so a pipe is enough:

```bash
printf '%s\n' \
  '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"demo","version":"1.0.0"}}}' \
  '{"jsonrpc":"2.0","method":"notifications/initialized"}' \
  '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"search_components","arguments":{"query":"empty state"}}}' \
  | flocks_mcp
```

The handshake answers with the negotiated revision and the server version:

```json
{"jsonrpc":"2.0","result":{"protocolVersion":"2024-11-05","capabilities":{"tools":{"listChanged":true}},"serverInfo":{"name":"flocks_mcp","version":"0.1.0"}}}
```

and the call answers with the digest of every match:

```json
{
  "lang": "en",
  "query": "empty state",
  "count": 3,
  "components": [
    { "id": "app_list_empty", "name": "AppListEmpty", "summary": "List empty state: illustration + message + optional action." }
  ]
}
```

A refusal arrives as a normal result with `isError: true`, never as a JSON-RPC
error — an unknown `id` comes back with the nearest ids it does know, because
the consumer is a model and a model corrects itself from a good error.

## Read the catalog from Dart

The server is one layer over `FlocksCatalog`, which knows nothing about MCP and
is usable on its own — for a generator, a lint, or a test that has to agree
with the design system.

```dart
import 'package:flocks_mcp/flocks_mcp.dart';

void main() {
  final FlocksCatalog catalog = FlocksCatalog.embedded;

  // {id, name, summary} of one category.
  final List<Map<String, Object?>> atoms = catalog.list(
    lang: CatalogLang.en,
    category: ComponentCategory.atom,
  );
  print('${atoms.length} atoms; first is ${atoms.first['name']}');

  // The full record, in either language — the catalog is bilingual per field.
  final Map<String, Object?> badge = catalog.get(
    'app_badge',
    lang: CatalogLang.pt,
  );
  print('app_badge (pt): ${badge['summary']}');

  // Search folds case and accents, and requires every term.
  for (final Map<String, Object?> hit
      in catalog.search('empty state', lang: CatalogLang.en)) {
    print('match: ${hit['id']}');
  }
}
```

which prints:

```
24 atoms; first is AppText
app_badge (pt): Pill compacta de status, tingida por papel de cor semântico.
match: app_list_empty
match: app_chart_shell
match: app_navigation_rail_filter
```

`FlocksCatalog.embedded` is `static final`, so the 490 KB of catalog are
decoded on first use and only once — an `initialize` that calls no tool never
pays the parse.
