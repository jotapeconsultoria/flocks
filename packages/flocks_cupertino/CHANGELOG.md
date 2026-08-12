# Changelog

Every relevant change to this package. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the numbering
follows [SemVer](https://semver.org/).

> **On the numbering.** This package moves in lockstep with `flocks`: the
> contract (`AppIconProvider`) lives there, and an adapter on a version line of
> its own would only create a compatibility matrix to maintain. Its own public
> line starts at `0.1.0` because nothing here was ever published — the core is
> already at `0.1.2`. The `flocks` CHANGELOG explains why `0.x`.

## [0.1.0] - 2026-08-12

### Added

- `CupertinoIconProvider` — the `cupertino_icons` glyphs as a Flocks
  `AppIconProvider`. It covers the 55 `AppIconToken` of the contract, and a
  test keeps it covering them. A name outside the contract falls back to a
  question mark: `CupertinoIcons` names are Dart identifiers, not strings, so
  an arbitrary slug cannot be resolved.
- The glyphs come from the MIT-licensed
  [`cupertino_icons`](https://pub.dev/packages/cupertino_icons) font — original
  drawings in the iOS visual vocabulary. **They are not Apple's SF Symbols**,
  which cannot be redistributed and which this package neither bundles nor
  downloads. A test asserts that every glyph of the contract really does come
  from that package's font, so the licensing claim in the prose stays true by
  measurement rather than by assertion.
- **`example/`** — the same ten `AppIconToken` the sibling adapters demonstrate.
  What it shows is the swap, not the drawings: `main.dart` does not know
  Cupertino exists, and replacing the single `iconProvider` line redraws
  everything without touching the tree.
