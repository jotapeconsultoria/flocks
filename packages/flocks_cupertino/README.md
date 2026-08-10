# flocks_cupertino

The `cupertino_icons` glyphs as an `AppIconProvider` for
[Flocks](../flocks) — the iOS visual vocabulary, under MIT.

```yaml
dependencies:
  flocks_cupertino: ^0.1.0
```

> **Heads up:** this package is **not yet published** on pub.dev, so the
> dependency above does not resolve yet. Until it ships, depend on it through
> the repository:
>
> ```yaml
> dependencies:
>   flocks_cupertino:
>     git:
>       url: https://github.com/jotapeconsultoria/flocks.git
>       path: packages/flocks_cupertino
> ```

```dart
AppThemeScope(
  iconProvider: const CupertinoIconProvider(),
  builder: (context, theme) => MyApp(theme: theme),
)
```

## These are not SF Symbols

The glyphs come from the font shipped by the
[`cupertino_icons`](https://pub.dev/packages/cupertino_icons) package, which is
**MIT-licensed**. They are original drawings in the visual vocabulary of iOS.

They are **not Apple's SF Symbols**. SF Symbols are licensed by Apple and
cannot be redistributed inside a package; this adapter does not bundle them,
does not download them, and does not depend on them. The distinction is not
pedantry — it is the difference between a package that can be published and one
that cannot.

The `IconData` constants themselves live in `package:flutter/cupertino.dart`:
the framework carries the constants, the `cupertino_icons` package carries the
font they point at. That is why the dependency is declared — without it, the
constants resolve to a font family that is not in the bundle.

## One table and one `build`

This is the same shape as [`flocks_material`](../flocks_material), the
reference implementation of the axis: a `const` table of 55 entries and a
`build`. It covers the 55 `AppIconToken` of the contract, and a test keeps it
covering them. A name outside the contract falls back to a question mark —
`CupertinoIcons` names are Dart identifiers, not strings, so an arbitrary slug
cannot be resolved.

Some tokens share a glyph, and that is deliberate: the iOS set draws no
difference between a PDF and a rich document, or between a CSV and a
spreadsheet. Inventing a distinction the set does not have would produce a
*wrong* icon, not a specific one.

## License

MIT, like Flocks. The glyphs come from the `cupertino_icons` font, also MIT —
this package bundles no font of its own, it declares the dependency that
carries one.
