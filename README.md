# Flocks

A Flutter design system built on `widgets.dart` — no Material, no Cupertino.

[flocks.live](https://flocks.live)

Four of the seven packages are published on pub.dev under the
[jotapeconsultoria.com.br](https://pub.dev/publishers/jotapeconsultoria.com.br)
verified publisher. The two newest icon adapters are not yet published —
publishing them is a move of its own.

| Package | What it is |
|---|---|
| [`flocks`](packages/flocks) · [pub.dev](https://pub.dev/packages/flocks) | The design system: tokens, theme, white-label brand, and the components. |
| [`flocks_phosphor`](packages/flocks_phosphor) · [pub.dev](https://pub.dev/packages/flocks_phosphor) | [Phosphor Icons](https://phosphoricons.com) as an `AppIconProvider` — six weights, shipped as fonts so the tree-shaker can prune them. |
| [`flocks_material`](packages/flocks_material) · [pub.dev](https://pub.dev/packages/flocks_material) | Material Design icons as an `AppIconProvider`. The reference implementation of the axis. |
| [`flocks_cupertino`](packages/flocks_cupertino) · *not yet published* | The [`cupertino_icons`](https://pub.dev/packages/cupertino_icons) glyphs as an `AppIconProvider` — the iOS visual vocabulary, under MIT. Not Apple's SF Symbols. |
| [`flocks_lucide`](packages/flocks_lucide) · *not yet published* | [Lucide](https://lucide.dev) as an `AppIconProvider` — one stroke weight, shipped as a font so the tree-shaker can prune it. |
| [`flocks_mcp`](packages/flocks_mcp) · [pub.dev](https://pub.dev/packages/flocks_mcp) | The component catalog served to agents over MCP. Also on the [MCP Registry](https://registry.modelcontextprotocol.io) and as an `.mcpb` bundle in each [release](https://github.com/jotapeconsultoria/flocks/releases/latest). |
| [`flocks_demo`](packages/flocks_demo) · [flocks.live/demo](https://flocks.live/demo/) · *not published, by design* | The white-label demo: your brand colour on a full dashboard and CRUD, and the configuration exported as Dart you can paste. It is a showcase, not a library. |

No version numbers in that table on purpose: nothing here gates a hand-written
one, and pub.dev already shows the current version of each.

Start at [`packages/flocks/README.md`](packages/flocks/README.md). The
components are browsable at [widgetbook.flocks.live](https://widgetbook.flocks.live).

## Working on it

This repo is a [pub workspace](https://dart.dev/go/pub-workspaces). Resolve from
the root, always:

```bash
flutter pub get
```

That is what makes the adapters and the MCP server resolve `flocks` against the
local package instead of the published one, so a change to the core is felt by
them in the same checkout. Each package carries `resolution: workspace`, so `pub get`
run *inside* one of them will fail — it is not a broken checkout.

```bash
dart format --output=none --set-exit-if-changed .   # formatação
dart analyze                                        # os três pacotes
cd packages/flocks && flutter test --exclude-tags golden
cd packages/flocks && dart run tool/validate_components.dart
```

Goldens compare pixels and their baselines were generated on macOS arm64, so
they run apart, and only there:

```bash
cd packages/flocks && flutter test --tags golden
```

## License

MIT — see [LICENSE](LICENSE). Bundled third-party assets keep their own
licenses: the fonts are SIL Open Font License 1.1, [Phosphor
Icons](https://phosphoricons.com) is MIT, [Lucide](https://lucide.dev) is ISC
(with the part derived from Feather under its own MIT), and
[`cupertino_icons`](https://pub.dev/packages/cupertino_icons) — a dependency,
not a vendored asset — is MIT. Each license text ships beside the files it
covers (`OFL.txt`, `assets/icons/LICENSE`, `assets/fonts/LICENSE-phosphor-*`,
`packages/flocks_lucide/assets/fonts/LICENSE-lucide`), and each package's
README says which apply to it.
