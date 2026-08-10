# Changelog

Every relevant change to this package. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the numbering
follows [SemVer](https://semver.org/).

> **On the numbering.** Nothing before `0.1.0` was ever published, and this
> package moves in lockstep with `flocks`. An earlier `2.0.0` counted the
> internal rewrite from SVG to font — a milestone no external consumer ever saw,
> because nothing was released. The public line starts at `0.1.0`, next to the
> core; the `flocks` CHANGELOG explains why `0.x`.

## [0.1.1] - 2026-08-10

### Fixed

- **A licença volta a ser reconhecida.** O `LICENSE` trazia o MIT verbatim
  seguido de um bloco de notas sobre os assets do Phosphor, e o
  `license_detector` casa o arquivo INTEIRO contra o corpus SPDX — o texto
  apensado derrubava a confiança e o pub.dev reportava "No license was
  recognized". O arquivo passa a ser exatamente o texto SPDX; as notas de
  origem estão no README, e as licenças dos dois repositórios continuam
  viajando em `assets/fonts/`, onde sempre estiveram.
- **Suporte de plataforma (2 → 6) e compatibilidade com wasm**, herdados do
  `flocks` 0.1.1: este pacote nunca teve nada de web em `lib/`, mas carregava
  os dois defeitos do core pela dependência. Ver o CHANGELOG do `flocks`.

## [0.1.0] - 2026-08-05

### Added

- `PhosphorIconProvider` — the 55 `AppIconToken` of the Flocks contract, served
  from the Phosphor fonts. `extraIcons` lets an app declare slugs of its own,
  as a `const` map carrying exactly the glyphs it lists.
- `PhosphorWeight` as an axis (`thin` · `light` · `regular` · `bold` · `fill` ·
  `duotone`). One value restyles every icon in the app, the way `AppStyle`
  restyles the boxes.
- Generated classes for all 1,512 icons in each of the 6 weights. The 1,457
  outside the contract are reached by identifier, so the tree-shaker keeps only
  the glyphs a build actually cites.
- `PhosphorDuotoneIconData` and `PhosphorDuotoneIcon`. Duotone is the one weight
  that is not 1:1 with a codepoint — each icon stacks a 20% patch under an
  opaque outline — so it needs a type of its own; with a plain `IconData` half
  the drawing would go missing and nothing would fail to compile.
- Architecture gates that fail when the generated code drifts from the catalog,
  when the catalog drifts from the pinned tag, when a codepoint has no glyph in
  the TTF, or when an `IconData` stops being constant — the last one would make
  `flutter build --release` fail in every app depending on this package.

### Changed

- **The icons ship as fonts, not SVG.** Flutter does not tree-shake assets: the
  9,072 SVGs this package used to declare went into the bundle whole — 35 MB,
  whether an app used twenty icons or a thousand. A font it knows how to prune:
  `--tree-shake-icons` reads the constant `IconData` and rebuilds each TTF with
  only the glyphs cited. Measured on a ~20-icon example app,
  `flutter build web --release` went from 35.4 MB to 91 KB. The package itself
  went from 35 MB across 9,073 asset files to 3.0 MB across 8. (This is why
  `flocks_material` never had the problem: Material icons are a font, and one
  Flutter already bundles.)
- Codepoints now come from the `style.css` that `phosphor-icons/web` publishes
  next to each font, at the tag pinned in `tool/phosphor_catalog.dart` — not
  from the `codepoint` field of `phosphor-icons/core`, which diverges from the
  fonts on 9 names and would have drawn the wrong icon in all six weights with
  nothing turning red.

### Removed

- `const AppIcon('airplane-tilt')` no longer draws. A name outside the contract
  falls back to `question`; use the weight class, or declare the slug in
  `extraIcons`. Resolving arbitrary slugs at runtime would make all 1,512 names
  reachable at once and undo the tree-shaking that motivated the font.
