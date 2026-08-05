# Changelog

Every relevant change to this package. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the numbering
follows [SemVer](https://semver.org/).

> **On the numbering.** Nothing here has ever been published. The versions below
> `[1.0.0]`, and the `since: 'flocks@x.y.z'` markers in the component catalog,
> are *internal* migration milestones from the monorepo — they ran from `0.1.0`
> to `1.5.0` while the pubspec still said `1.0.0`, so they never agreed with it
> in the first place.
>
> The **public** line starts at `0.1.0`, on purpose. `1.0.0` on pub.dev is a
> promise about the future, and this package has not yet met an external
> consumer. In `0.x`, SemVer makes the minor the breaking slot, so `^0.1.0`
> pins adopters to `>=0.1.0 <0.2.0` and the churn cannot reach them by
> surprise. It graduates to `1.0.0` once the API holds still through a few
> outside adopters.

## [Unreleased]

### Added

- `AppBrandTypography` — a brand now picks its display and body families. It
  closes the last white-label gap: color, radius, motion, style, glass and icon
  already belonged to the brand; typography was pinned in the package.
- `AppIconToken` — the contract of 55 icons the components use, and that every
  provider has to know how to serve. It is an `extension type` over `String`, so
  it is accepted anywhere a `String` already is.
- `AppIconProvider` as a theme axis, with two implementations:
  `AppAssetIconProvider` (the default, bundled SVGs, no network) and
  `AppNetworkIconProvider` (a CDN, with the base URL injected).
- `AppIllustrationToken`, `AppIllustrationProvider` and the
  `AppIllustrationTheme` axis — the last corner where the package took a
  third-party licensed asset. The bundled `empty` comes from
  [Open Peeps](https://www.openpeeps.com) under **CC0**, which (unlike
  unDraw/ManyPixels/Storyset) does not forbid redistributing it in a package.
- `AppThemeScope(iconProvider:, illustrationProvider:)` — the seam through which
  the APP picks the icon set. The brand cannot declare it: a large set lives in a
  sibling package, and the core does not depend on those.
- Sibling packages `flocks_phosphor` (1,512 icons × 6 weights, with
  `PhosphorWeight` as an axis) and `flocks_material` (the reference
  implementation, which proves the zero-Material thesis from outside).
- The `flocks` brand — the whole palette derived from a seed through
  `swatchFromSeed`, with Space Grotesk on display. It is the living proof of the
  white-label. (It used to be the only brand that worked with no network at all;
  since `cdnBaseUrl` left `AppBrandConfig`, every brand does.)
- `neutralSwatchFromSeed` — the neutral ramp needs a tone ladder of its own: the
  theme uses stop 300 as `surface` and 600 as `outline`, and on the chromatic
  ladder those two sit 30 tones apart (a ratio of 2.79, below the 3.0 floor).
  Without it, **every** seed-generated brand would fail the contrast gate, in the
  same place.
- `AppTextTheme.copyWith` and `AppBrandConfig.copyWith`, which did not exist.
- `LICENSE` (MIT), this `CHANGELOG` and a real `README`.
- `tool/golden_triage.py` — it builds contact sheets per family for reviewing
  golden failures.
- The catalog freshness gate (`test/architecture/catalog_freshness_test.dart`).
  `doc/mcp/catalog.json` drifted twice in three days because regenerating it was
  a manual step, and the site reads that file to publish the component count —
  each drift became a false number in the wild. The test runs in every PR's
  `flutter test` and also requires that the hand-written numbers in the README
  match the code.

### Changed

- **The catalog's prose is bilingual.** `summary`, `description`, `whenToUse`,
  `whenNotToUse`, `props[].description`, `examples[].title/description`, `do`,
  `dont` and `a11y` now carry `LocalizedText`/`LocalizedList` (`en` + `pt`), and
  `doc/mcp/catalog.json` emits `{"en": …, "pt": …}` for each of them. Both
  languages are required by the constructor, so no component can ship
  half-translated; `test/architecture/catalog_language_test.dart` also fails when
  an `en` field is left carrying Portuguese. **Breaking** for anyone reading
  `AppComponentMeta` or the JSON.
- **`states` and `variants` are a closed English vocabulary.** They name API
  surface (an enum's value, an interaction state), so they are not localized;
  they are checked against the allow-list in
  `test/architecture/catalog_vocabulary.dart`.
- **The `.doc.md` files and this README are in English.** The package is
  international from publication onward. The Portuguese lives on in the catalog's
  `pt` side, which is what the site publishes on its PT routes.
- **`Poppins-SemiBold` enters, and the `title*` styles now render at the weight
  they ask for.** They had declared `w600` all along and fell back to 500 because
  there was no 600 file on disk — the design system's "semibold" never existed.
  161 goldens rebaselined.
- **The whole type scale is Poppins.** The `display*` and `label*` styles were
  Neutrek. The `label*` ones move up to weight 500: Neutrek's regular read much
  heavier than Poppins', and keeping them at 400 erased the separation between
  label and body.
- **`AppIcons` stores slugs, not URLs.** Translating a name into an address is
  the brand's provider's job. The `jotape` and `zxtrack` brands point at the CDN;
  the package's default resolves from the bundled assets.
- **The illustration's default accent became neutral** (it was `secondary`). An
  illustration's fill is the AREA — skin, clothing, surface — not a detail:
  painting it with the brand color left the whole figure monochrome in that
  color. It changes how the illustrations look in all 4 apps.
- `AppIllustrations` stores slugs, not URLs, and `AppIllustration` lost its own
  loading — the provider is what loads.
- `AppIcon` became a `StatelessWidget`. The loading moved inside the provider,
  which also resolved a trap: the download was born in `initState`, where reading
  the theme is unsafe — and the provider comes from the theme.
- `swatchFromSeed` now generates 11 stops (50–950), like the hand-written brands.
- `AppBrand` builds the registry as `final`, not `const`, because the `flocks`
  brand derives its palette at runtime.
- **`AppAuthSplitLayout` takes `websiteUrl` as a parameter.** It used to read
  `AppBrand.current.websiteUrl` — the one place in `lib/src` that reached for the
  global brand singleton, for a string that already had sibling parameters
  (`brandTitle`, `brandSubtitle`, `logoUrl`) right next to it. A component that
  reads a static registry cannot be tested without it, cannot render two brands
  on one screen, and forces the package to have an opinion about where the data
  lives. `null` keeps the logo and drops only the link. **Breaking** only in the
  sense that the link now needs to be asked for.

### Removed

- **`AppBrandConfig` is theme configuration, and nothing else.** Gone:
  `appName`, `brandSubtitle`, `websiteUrl`, `cdnBaseUrl` (with its seven derived
  asset getters and `precacheUrls`), `videoBasePath`, `playStoreUrl` and
  `poweredByLabel`. What stays is `clientSlug`, the palette, the six theme axes
  and `typography`.

  None of the removed fields were read by `lib/src` — the package carried them
  only so the app could read them back. The cost was never their weight: the
  derived getters (`splashLogoUrl`, `otpLogoUrl`, `railExpandedUrl` and company)
  **asserted an app architecture** — that there is a splash screen, an OTP flow,
  a profile page, a nav rail, an auth background, and a Play Store listing. A
  design system that asserts that has an opinion about someone else's product,
  which is the same coupling this package refuses when it declines to reuse
  `Card` and `Scaffold`.

  `clientSlug` stayed: with the asset path gone it is pure identity — the
  registry key, and the label that names the goldens and scopes the contrast
  reports. **Breaking** for anyone constructing an `AppBrandConfig`; the fix is
  to delete the arguments and keep that identity wherever your app already keeps
  its own.


- **The Neutrek font.** It is licensed "Personal Use Only"; in an MIT repository,
  using it would amount to redistribution. It was what blocked publishing the
  package.

### Fixed

- The OFL fonts were being redistributed **without the license text**, which the
  SIL Open Font License requires. There is now an `OFL.txt` beside each family.
- `AppIcons.mail`, `.plus` and `.refresh` were cited in dartdoc but did not
  exist. They exist now, as part of the contract.

### Security

- The package's default path no longer depends on a private CDN or on a licensed
  icon set (Streamline Ultimate). The default is offline and MIT.
- **A brand can no longer point anywhere.** `cdnBaseUrl` was first made optional,
  so that an adopter with nowhere to host was not pushed into copying
  `flocksBrand`'s value — which pointed at the site's own CDN, putting our infra
  and our logo inside their product. Removing the field settles it by absence:
  there is no URL to copy and no network for the package to reach.

### Pending

## [1.0.0]

The first consolidated version of the design system inside the monorepo: tokens,
theme, per-brand white-label, the global axes (`AppStyle`, `AppRadiusMode`,
glass, motion, transparency) and 129 components across atoms/molecules/organisms,
each with a `.doc.md`, a preview, a Widgetbook case and a test.
