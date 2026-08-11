# Changelog

Every relevant change to this package. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the numbering
follows [SemVer](https://semver.org/).

> **On the numbering.** This package moves in lockstep with `flocks`: the
> contract (`AppIconProvider`) lives there, and an adapter on a version line of
> its own would only create a compatibility matrix to maintain. Its own public
> line starts at `0.1.0` because nothing here was ever published — the core is
> already at `0.1.2`. The `flocks` CHANGELOG explains why `0.x`.

## [0.1.0] - 2026-08-11

### Added

- `LucideIconProvider` — the [Lucide](https://lucide.dev) icons as a Flocks
  `AppIconProvider`, covering the 55 `AppIconToken` of the contract. It serves
  those 55 and nothing else, deliberately: everything the provider can reach
  counts as *written* for `--tree-shake-icons`, so a map of every name would
  drag the whole font into every adopter's bundle. `extraIcons` is the escape
  hatch, and it costs exactly what it lists.
- `FlocksLucide` — the 2,025 names as `const IconData`, reachable one constant
  at a time through `LucideIcon`. One weight: Lucide is drawn in stroke, and
  upstream publishes no weight matrix, so there is nothing here like the six
  families of `flocks_phosphor`.
- **Lucide 1.31.0 vendored as a font**, pinned by version *and* by sha256 of
  every vendored artifact. `tool/vendor_lucide.dart` is the only networked step;
  `tool/generate_icons.dart` reads only what is on disk, which is what lets the
  freshness gate call the very same function and diff the result.
- Architecture gates ported from `flocks_phosphor`: `const_icon_data` (a
  non-constant `IconData` makes `flutter build --release` *abort* in every
  dependent app), `font_coverage` (every catalog codepoint, and all 55 of the
  contract, have a real glyph in the shipped TTF), and `generated_freshness`
  (generated code, catalog, pin and on-disk digests all agree).

### Measured

- **834 KB → 19 KB (−97.7%)** for `lucide.ttf` in the example app's web release
  bundle, with `--tree-shake-icons` on versus off. `flocks_phosphor` lands at
  91 KB under the same measurement, for six weights.
- **The codepoints come from `font/lucide.css`, not `font/codepoints.json`** —
  the opposite of what the filenames suggest, and measured rather than assumed.
  In `lucide-static 1.31.0` the JSON lists 2,045 names and the CSS 2,025; the 20
  extra ones (`chrome`, `github`, `facebook`, `twitter` and the other retired
  brand icons, plus `circle-euro-sign` and `rail-symbol`) **have no glyph in the
  font**. Generating from the JSON would have emitted 20 constants that draw
  nothing, with nothing going red.
- Four pairs of names collapse to one Dart identifier (`arrow-down-0-1` and
  `arrow-down-01`, and three analogues). They are two spellings of the same
  drawing, so one field serves both — and the generator throws if two *different*
  codepoints ever collide, rather than silently picking one.
