# flocks_mcp

The [Flocks](../flocks) component catalog, served to agents over MCP. 135
components with their props, usage rules, accessibility notes and runnable
examples — in English and Portuguese, from a catalog that is bilingual at the
source rather than translated.

```bash
dart pub global activate flocks_mcp
```

Then register it with your client — see [Installation](#installation). Or skip
the Dart SDK entirely: the [`.mcpb` bundle](#installation) installs into Claude
Desktop with two clicks, and needs neither the Dart toolchain nor pub.dev.

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
Unknown component id "appbadge". Did you mean: "app_badge"? Call list_components to see all 135 ids.
Unknown lang "fr". Valid values: "en", "pt". …
Unknown category "widget". Valid values: "atom", "molecule", "organism". Omit the parameter to list every component.
```

## Installation

The server speaks MCP over stdio and takes no arguments, no configuration and
no network. Replace `flocks_mcp` below with `dart pub global run flocks_mcp` if
you would rather not put the pub cache's `bin` on your `PATH`.

**Claude Desktop — MCP Bundle (no Dart SDK required)**

Download
[`flocks-mcp.mcpb`](https://github.com/jotapeconsultoria/flocks/releases/latest/download/flocks-mcp.mcpb)
from the latest release and open it with Claude Desktop — double-click, or
Settings → Extensions → Advanced settings → Install Extension… The bundle
carries native executables for macOS (arm64 and x64), Linux (x64) and Windows
(x64) and selects the right one at launch; no Dart SDK is involved, and no
pub.dev either, so this is the install path for a machine without the Dart
toolchain. Every release publishes the bundle's SHA-256 next to the file —
`shasum -a 256 -c flocks-mcp.mcpb.sha256` verifies the download.

On macOS the executable inside the bundle is ad-hoc signed, not notarized. The
launcher clears the quarantine flag before the first run; if Gatekeeper still
objects, System Settings → Privacy & Security → "Allow Anyway" is the manual
override.

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

To run a change that is not released yet, point `command` at a checkout
instead:

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

**The `.mcpb` bundle.** `dart compile exe` does not cross-compile, so a `v*`
tag has CI build the server on four runners and zip the four executables into
one bundle, `manifest.json` at the root. Two quirks of the format shaped the
layout. There is no per-architecture selection — `platform_overrides` knows
`darwin`, `win32` and `linux`, nothing finer — so on macOS and Linux the entry
point is a launcher script that picks the binary by `uname -m`. And Claude
Desktop extracts the archive without Unix modes
([mcpb#294](https://github.com/modelcontextprotocol/mcpb/issues/294)): every
file lands as `0600`, so a manifest that pointed at the binary would fail with
`EACCES` on every install. Instead the manifest launches `/bin/sh` — which only
needs read access — and `mcpb/run.sh` hands the executable bit back before the
`exec`. The manifest itself is generated from the pubspec by
`tool/generate_mcpb_manifest.dart`: the version already lives in two gated
places, and a hand-written third one is exactly how versions drift. Packing is
a plain `zip` in CI, no npm CLI in the pipeline; the validation `mcpb pack`
would do lives in `test/mcpb_manifest_test.dart`, and
`npx @anthropic-ai/mcpb validate` remains a useful manual cross-check during
development.

## MCP Registry

The server is listed on the [MCP
Registry](https://registry.modelcontextprotocol.io) as
`io.github.jotapeconsultoria/flocks-mcp`. Like pub.dev, publishing there is
irreversible, so it goes out deliberately, not as a side effect of CI. How it
is set up:

- **Namespace**: `io.github.jotapeconsultoria/flocks-mcp`, which mirrors the
  organization that owns the repository. The DNS alternative on `flocks.live`
  was weighed and dropped: reverse-DNS would read `live.flocks/…` (the TLD
  comes first), and the method requires keeping an Ed25519 private key as a
  standing secret — and the artifact already lives on GitHub Releases.
- **`server.json`**: generated by the release job and attached to every GitHub
  Release, carrying that release's `identifier` URL and the real `fileSha256`
  of its bundle. Those two fields change every version, which is why the file
  is generated rather than committed: `tool/generate_server_json.dart` holds
  the shape, `test/server_json_test.dart` gates it, and no hand-written hash
  exists anywhere in the repository. The registry does not verify the hash —
  MCP clients do, before installing — so it is computed by the same job that
  attaches the bundle it hashes.

Publishing a version is:

```bash
brew install mcp-publisher
rm -f server.json
mcp-publisher login github -token "$GITHUB_PAT"
curl -LO https://github.com/jotapeconsultoria/flocks/releases/download/vX.Y.Z/server.json
mcp-publisher publish
```

Two things in that snippet are scar tissue. The `rm -f` is there because
`curl -LO` **refuses to overwrite**: with a stale `server.json` in the
directory, the download is silently skipped and the previous version is
republished. And the URL names the tag instead of `latest`, because the release
is built by CI *after* the tag is pushed — reaching for `latest` in that window
downloads the previous release, which is how a 100-character `description`
already fixed in this version can still come back as a `422`.

**Use `-token`, not the interactive flow, for an organization namespace.** Bare
`mcp-publisher login github` authenticates through *MCP Registry Login (Prod)*,
a private GitHub App. The registry resolves org permissions with `GET
/user/memberships/orgs`, and a private App's user token cannot see an
organization it is not installed on — so the login succeeds and hands back a
token scoped to `io.github.<your-user>/*` only, and `publish` fails with a 403
naming the namespace it will not grant. A classic Personal Access Token with
the `read:org` scope has that visibility; the publisher must also be an Owner
of the organization, which is what the registry requires. The 403 suggests
making organization membership public — that is a dead end here, because the
endpoint the registry calls reads *private* memberships, and public ones are a
different list (`GET /users/{user}/orgs`).

The 403 names its own cause: *"You have permission to publish:
`io.github.<your-personal-account>/*`"* is what a token without `read:org`
looks like from the registry's side — the login worked, the org was invisible.
An empty `$GITHUB_PAT` produces it too, since `-token ""` falls back to the
interactive flow. Before blaming permissions, check the variable is set and
that the token is *classic*: a fine-grained token returns no `x-oauth-scopes`
header from `https://api.github.com/user`, and that empty header is the
verdict. Ownership itself is verifiable without the publisher —
`gh api user/memberships/orgs` must list the organization with
`role: admin` and `state: active`.

Two limits worth knowing before a release, both learned the expensive way:
`description` must be **at most 100 characters** (`test/server_json_test.dart`
gates it, along with pub.dev's 60-character floor), and the registry JWT lives
about **five minutes** — chain `login` and `publish` so it cannot expire in
between.

## License

MIT, like the rest of Flocks.
