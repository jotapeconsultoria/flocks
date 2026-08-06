# Changelog

Every relevant change to this package. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the numbering
follows [SemVer](https://semver.org/).

> **On the numbering.** Nothing before `0.1.0` was ever published, and this
> package moves in lockstep with `flocks`: the contract (`AppIconProvider`)
> lives there, and an adapter on a version line of its own would only create a
> compatibility matrix to maintain. The public line starts at `0.1.0`, next to
> the core; the `flocks` CHANGELOG explains why `0.x`.

## [0.1.0] - 2026-08-05

### Added

- `MaterialIconProvider` — Material Design icons as a Flocks `AppIconProvider`.
  It covers the 55 `AppIconToken` of the contract, and a test keeps it covering
  them. A name outside the contract falls back to a question mark: Material
  names are Dart identifiers, not strings, so an arbitrary slug cannot be
  resolved.
- The package doubles as the reference implementation of the axis — a table and
  a `build`, around 120 lines, which is the shape a `flocks_fontawesome` or an
  in-house provider would take. Living outside the core is the point: an adapter
  inside `flocks` would have cost every consumer the Material dependency and
  broken the zero-Material thesis the architecture test enforces.
