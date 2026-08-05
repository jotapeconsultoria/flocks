# Flocks

A Flutter design system built on `widgets.dart` — no Material, no Cupertino.

[flocks.live](https://flocks.live)

| Package | What it is |
|---|---|
| [`flocks`](packages/flocks) | The design system: tokens, theme, white-label brand, and the components. |
| [`flocks_phosphor`](packages/flocks_phosphor) | [Phosphor Icons](https://phosphoricons.com) as an `AppIconProvider` — six weights, shipped as fonts so the tree-shaker can prune them. |
| [`flocks_material`](packages/flocks_material) | Material Design icons as an `AppIconProvider`. The reference implementation of the axis. |

Start at [`packages/flocks/README.md`](packages/flocks/README.md).

> **Not yet published on pub.dev.** That is the decided destination; until then
> the way in is a git dependency, and the snippet is in the package README.

## Working on it

This repo is a [pub workspace](https://dart.dev/go/pub-workspaces). Resolve from
the root, always:

```bash
flutter pub get
```

That is what makes the two adapters resolve `flocks` against the local package
instead of going to pub.dev, where it does not exist yet. `pub get` run *inside*
one of the packages will fail for that reason — it is not a broken checkout.

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
licenses, noted in each package's `LICENSE`.
