# Changelog

Every relevant change to this package. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the numbering
follows [SemVer](https://semver.org/).

> **On the numbering.** Nothing before `0.1.0` was ever published, and this
> package moves in lockstep with `flocks`: the contract (`AppIconProvider`)
> lives there, and an adapter on a version line of its own would only create a
> compatibility matrix to maintain. The public line starts at `0.1.0`, next to
> the core; the `flocks` CHANGELOG explains why `0.x`.

## [0.1.2] - 2026-08-11

**Nada mudou neste pacote.** O número acompanha o `flocks` 0.1.2 pela razão que
o bloco acima dá: o contrato mora no core, e um adaptador numa linha própria só
criaria matriz de compatibilidade para manter. Uma entrada que fingisse conteúdo
seria pior que esta, que declara não ter.

O que mudou no core — `toDartSnippet`, `flippedSwatch` e `kSwatchStops`, e uma
superfície grande em `circular` que parou de cortar o próprio conteúdo — está no
CHANGELOG do `flocks`.

## [0.1.1] - 2026-08-10

### Fixed

- **A licença volta a ser reconhecida.** O `LICENSE` trazia o MIT verbatim
  seguido de uma nota dizendo que o pacote não embute asset de terceiro, e o
  `license_detector` casa o arquivo INTEIRO contra o corpus SPDX — bastavam
  aquelas duas linhas para derrubar a confiança e o pub.dev reportar "No
  license was recognized". O arquivo passa a ser exatamente o texto SPDX; a
  nota está no README, onde já estava.
- **Suporte de plataforma (2 → 6) e compatibilidade com wasm**, herdados do
  `flocks` 0.1.1. Ver o CHANGELOG do core.

### Added

- **`example/`** — os mesmos dez `AppIconToken` do contrato, servidos pelos
  glifos do Material. O que ele demonstra é a troca, não os desenhos: o
  `main.dart` não sabe que existe Material, e trocar a única linha do
  `iconProvider` por `PhosphorIconProvider()` redesenha tudo sem mexer na
  árvore.

## [0.1.0] - 2026-08-10

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
