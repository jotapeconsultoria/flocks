# flocks_mcp

The [Flocks](../flocks) component catalog, served to agents over MCP. 131
components with their props, usage rules, accessibility notes and runnable
examples — in English and Portuguese, from a catalog that is bilingual at the
source rather than translated.

```bash
dart pub global activate flocks_mcp
```

> The package is **not yet published** on pub.dev — that is the decided
> destination, and it goes out after `flocks` itself, because the core's
> `0.1.0` is what settles the catalog schema this server embeds. Until then the
> line above does not resolve, and the way in is a git activation:
>
> ```bash
> dart pub global activate --source git https://github.com/jotapeconsultoria/flocks.git --git-path packages/flocks_mcp
> ```
>
> `test/install_docs_test.dart` requires this notice to leave on the same day
> `publish_to: none` does.

Then register it with your client — see [Installation](#installation).

## Why it exists

Flocks is built directly on `widgets.dart`: no Material, no Cupertino. That is
the point of the package, and it is also what makes an agent guess wrong. A
model asked to write a screen will reach for Material's parameter names,
because that is what Flutter code looks like everywhere else, and the result
does not compile. `get_component` is the fix: the real prop list, with types,
defaults and what is required, from the same `*.meta.dart` sources the site and
the Widgetbook are generated from.

## Tools

| Tool | Input | Returns |
| --- | --- | --- |
| `list_components` | `category?` (`atom`·`molecule`·`organism`), `lang?` | `id`, `name` and `summary` of every component |
| `get_component` | `id` (required), `lang?` | the full record: props, whenToUse/whenNotToUse, do/don't, a11y, examples, related |
| `search_components` | `query` (required), `lang?` | the same digest as `list_components`, for every match |

`lang` is `"en"` or `"pt"` and defaults to `"en"`. The catalog carries both
languages field by field, written by hand — neither is a translation of the
other, and neither is more complete, so there is no fallback to reason about.

Search is case- and accent-insensitive, treats `_` and `-` as word boundaries,
and requires every term of the query to be present. So `"data table"` finds
`app_data_table`, and `"selecao"` finds prose that says *seleção*.

### `list_components`

```json
{ "category": "atom", "lang": "en" }
```

```json
{
  "lang": "en",
  "category": "atom",
  "count": 24,
  "components": [
    {
      "id": "app_text",
      "name": "AppText",
      "summary": "Design system text, theme-adapted and selectable."
    },
    {
      "id": "app_badge",
      "name": "AppBadge",
      "summary": "Compact status pill, tinted by a semantic color role."
    }
  ]
}
```

### `get_component`

```json
{ "id": "app_badge", "lang": "pt" }
```

```json
{
  "lang": "pt",
  "component": {
    "id": "app_badge",
    "name": "AppBadge",
    "category": "atom",
    "summary": "Pill compacta de status, tingida por papel de cor semântico.",
    "whenToUse": [
      "Rótulo de estado/categoria: status de alerta, severidade, tag curta."
    ],
    "whenNotToUse": [
      "Ação primária/CTA → use um botão (o badge é uma pill de rótulo)."
    ],
    "props": [
      {
        "name": "label",
        "type": "String",
        "required": true,
        "description": "Texto curto exibido na pill."
      },
      {
        "name": "color",
        "type": "AppBadgeColor",
        "required": false,
        "default": "AppBadgeColor.neutral",
        "enumValues": ["neutral", "primary", "info", "success", "warning", "danger"]
      }
    ],
    "examples": [{ "title": "Status", "code": "AppBadge(label: 'Ativo')" }],
    "a11y": "…",
    "related": ["app_chip", "app_status_dot"]
  }
}
```

### `search_components`

```json
{ "query": "empty state" }
```

```json
{
  "lang": "en",
  "query": "empty state",
  "count": 2,
  "components": [
    {
      "id": "app_list_empty",
      "name": "AppListEmpty",
      "summary": "List empty state: illustration + message + optional action."
    }
  ]
}
```

### Errors

A refusal comes back as a normal tool result with `isError: true`, never as a
JSON-RPC error. The difference decides who reads it: a protocol error is a
broken connection to the client and the model never sees it, while an error in
the result is text the model reads — and corrects itself from. So no message
here only refuses; every one names the way out.

```
Unknown component id "appbadge". Did you mean: "app_badge"? Call list_components to see all 131 ids.
Unknown lang "fr". Valid values: "en", "pt". …
Unknown category "widget". Valid values: "atom", "molecule", "organism". Omit the parameter to list every component.
```

## Installation

The server speaks MCP over stdio and takes no arguments, no configuration and
no network. Replace `flocks_mcp` below with `dart pub global run flocks_mcp` if
you would rather not put the pub cache's `bin` on your `PATH`.

**Claude Code**

```bash
claude mcp add flocks -- flocks_mcp
```

**Claude Desktop** — `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "flocks": {
      "command": "flocks_mcp"
    }
  }
}
```

**Cursor** — `.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "flocks": {
      "command": "flocks_mcp"
    }
  }
}
```

Before publication, point `command` at the checkout instead:

```json
{
  "mcpServers": {
    "flocks": {
      "command": "dart",
      "args": ["run", "/path/to/flocks/packages/flocks_mcp/bin/flocks_mcp.dart"]
    }
  }
}
```

## How it is built

**Pure Dart, on purpose.** The audience is Flutter developers, who already have
the SDK, and `dart pub global activate` is the idiomatic way to hand them a
command. That is also why the `environment:` block carries no `flutter:`
constraint even though its two sibling packages do: declaring one would make
`pub` demand the Flutter SDK to resolve this package, closing the very door it
exists to fit through.

**The catalog travels embedded.** `dart pub global activate` installs one
package — the `flocks` `doc/` does not come with it, and no relative path
reaches it on the installing machine. So `tool/embed_catalog.dart` turns
`../flocks/doc/mcp/catalog.json` into `lib/src/catalog_data.g.dart`, and
`test/catalog_embed_freshness_test.dart` compares the two byte for byte on
every `dart test`. Without that gate the failure mode is the worst kind: the
server hands a *model* props that no longer exist, with all the confidence of a
source of truth, and nothing goes red. This repository has lost twice to that
shape of bug — a stale `catalog.json`, and a use-case count that circulated as
three different numbers — and the remedy is the same each time: generate the
artifact, and let a test hold it to the source.

**Transport: [`dart_mcp`](https://pub.dev/packages/dart_mcp), pinned at
`^0.5.2`.** Hand-rolling MCP over stdio is not much code — newline-delimited
JSON-RPC 2.0, an `initialize` handshake, `tools/list` and `tools/call` — and it
was the alternative considered. Two things decided it the other way. The
package's dependencies are light and pure Dart (`async`, `collection`,
`json_rpc_2`, `meta`, `stream_channel`, `stream_transform`), so none of them
compromises the activation story above. And the handshake negotiates a protocol
*revision*: written by hand it would pin one, and age silently as clients moved
on. The cost is a `0.x` dependency that calls itself experimental — answered
with a caret, which in `0.x` resolves to `>=0.5.2 <0.6.0` and keeps the
breaking changes already sitting in `0.6.0-wip` from arriving on their own, and
with `test/protocol_e2e_test.dart`, which talks to the built binary over a real
pipe and is what turns red if a future bump breaks the wire.

## License

MIT, like the rest of Flocks.
