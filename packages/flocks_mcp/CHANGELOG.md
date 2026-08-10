# Changelog

Every relevant change to this package. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the numbering
follows [SemVer](https://semver.org/).

> **On the numbering.** This package moves in lockstep with `flocks`: what it
> serves *is* the `flocks` component catalog, and a version line of its own
> would only create a compatibility matrix between server and catalog. The
> public line starts at `0.1.0`, next to the core; the `flocks` CHANGELOG
> explains why `0.x`. It published *after* `flocks`, because the core's `0.1.0`
> is what settles the catalog schema this package embeds.

## [0.1.1] - 2026-08-10

### Fixed

- **O `LICENSE` volta a ser reconhecível como MIT.** Ele trazia o texto SPDX
  seguido de uma nota sobre o catálogo embarcado, e qualquer texto apensado
  derruba a confiança do `license_detector`. Este pacote não está no pub.dev —
  a nota vale para quem recebe o `.mcpb`, que leva o `LICENSE` dentro. A
  explicação do catálogo está no README.

### Changed

- Versão em lockstep com o `flocks` 0.1.1, para o Release do bundle sair com a
  licença corrigida.

## [0.1.0] - 2026-08-10

### Added

- An MCP server over stdio, exposing the `flocks` component catalog to agents
  through three tools: `list_components`, `get_component` and
  `search_components`. Every one of them takes `lang` (`en` or `pt`, defaulting
  to `en`) — the catalog is bilingual at the source, per field, so there is no
  fallback to invent.
- The catalog travels embedded, as generated Dart
  (`lib/src/catalog_data.g.dart`, written by `tool/embed_catalog.dart`). A
  package installed by `dart pub global activate` cannot see a sibling
  package's `doc/`, so reading `flocks`' JSON at runtime was never an option.
  `test/catalog_embed_freshness_test.dart` compares the embedded copy with the
  source byte for byte, so a stale catalog fails a test instead of being served
  in silence.
- Errors that teach rather than merely reject: an unknown `id` answers with the
  nearest ids it does know, and an invalid `lang` or `category` answers with the
  valid values. The consumer is a model, and a model corrects itself from a
  good error.
- An MCP Bundle (`flocks-mcp.mcpb`), built by CI on every `v*` tag and attached
  to the GitHub Release with its SHA-256: one archive with native executables
  for macOS (arm64/x64), Linux (x64) and Windows (x64), installable into Claude
  Desktop with two clicks and no Dart SDK. The manifest is generated from the
  pubspec (`tool/generate_mcpb_manifest.dart`, gated by
  `test/mcpb_manifest_test.dart`), and the release also attaches a generated
  `server.json`, ready for a deliberate MCP Registry publication under
  `io.github.jotapeconsultoria/flocks-mcp`.
