# flocks_lucide

The [Lucide](https://lucide.dev) icons as an `AppIconProvider` for
[Flocks](../flocks) — **shipped as a font, and tree-shakeable**.

```yaml
dependencies:
  flocks_lucide: ^0.1.0
```

> **Heads up:** this package is **not yet published** on pub.dev, so the
> dependency above does not resolve yet. Until it ships, depend on it through
> the repository:
>
> ```yaml
> dependencies:
>   flocks_lucide:
>     git:
>       url: https://github.com/jotapeconsultoria/flocks.git
>       path: packages/flocks_lucide
> ```

```dart
AppThemeScope(
  iconProvider: const LucideIconProvider(),
  builder: (context, theme) => MyApp(theme: theme),
)
```

## Why a font, and not SVG

Flutter **does not tree-shake assets**: whatever the `pubspec` declares goes
into the bundle whole, whether the app uses ten icons or two thousand. Shipping
Lucide's ~1,600 SVGs would put megabytes into every adopter's bundle to draw
twenty glyphs.

Fonts, Flutter does know how to prune. `--tree-shake-icons` reads the constant
`IconData` of the app and rebuilds the TTF with only the glyphs it finds
written down. This is the same reason `flocks_material` never had the problem —
Material icons are a font, and one that ships inside Flutter.

Measured on the example app with ~20 icons ([`example/`](example)), running
`flutter build web --release`:

| | `lucide.ttf` in the bundle |
|---|---|
| `--no-tree-shake-icons` | 834 KB |
| default | **19 KB** (−97.7%) |

For scale, [`flocks_phosphor`](../flocks_phosphor) ships six weights and lands
at 91 KB under the same measurement. One weight, one font, one fifth of that.

## Two doors, and the difference between them is the gain

`LucideIconProvider` serves the 55 `AppIconToken` of the contract — and nothing
else. That is not a limitation, it is the mechanism: everything the provider
can reach counts as *written* for the tree-shaker, so a map of all 2,025 names
would drag the whole font back in.

For any other icon, write the constant directly. The cost is then paid by
whoever uses it, and it is only the glyph named:

```dart
const LucideIcon(FlocksLucide.store)
```

When an icon really must arrive by *slug* — because the caller is a component
that takes a `String` — declare it in `extraIcons`. The map is yours, it is
`const`, and it carries into the bundle exactly the glyphs you list:

```dart
const LucideIconProvider(
  extraIcons: <String, IconData>{'storefront': FlocksLucide.store},
)
```

## One weight

Lucide is drawn in stroke, and the thickness is a property of the SVG rather
than a separate family — there is no six-weight matrix here like
[`flocks_phosphor`](../flocks_phosphor) has, because upstream does not publish
one. One TTF, one family.

## Where the codepoints come from

From `font/lucide.css`, which upstream ships **next to the font itself** — not
from `font/codepoints.json`, which is the file the name suggests. That was
measured, not assumed: in `lucide-static 1.31.0` the JSON lists 2,045 names and
the CSS lists 2,025, and the 20 extra ones — `chrome`, `github`, `facebook`,
`twitter` and the other retired brand icons, plus `circle-euro-sign` and
`rail-symbol` — **have no glyph in the font**. Their codepoints are kept so the
rest is not renumbered. Generating from the JSON would have produced 20
constants that draw nothing, and nothing would have gone red.

## Updating Lucide

```bash
# 1. raise the pin in tool/lucide_catalog.dart, then:
dart run tool/vendor_lucide.dart    # downloads the TTF + catalog (the only networked step)
dart run tool/generate_icons.dart   # regenerates the classes
flutter test
```

`test/architecture/` fails if the generated code drifts from the catalog, if the
catalog drifts from the pin, if a vendored file's sha256 stops matching, if a
codepoint has no glyph in the TTF, or if any `IconData` stops being constant —
which would make `flutter build --release` **abort** in every app depending on
this package.

## License

MIT, like Flocks. The font in `assets/fonts/` is Lucide's, under **ISC**, and
its license text ships beside it in `assets/fonts/LICENSE-lucide` — including
the portion derived from [Feather](https://feathericons.com), which is MIT and
belongs to another holder.
