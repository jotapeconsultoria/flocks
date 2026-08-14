# Flocks

A Flutter design system built on `widgets.dart` — no Material, no Cupertino.
133 components that restyle themselves along three global axes and wear an entire
brand from a single configuration.

[flocks.live](https://flocks.live)

```yaml
dependencies:
  flocks: ^0.1.0
```

```dart
import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';

final myBrand = AppBrandConfig(
  clientSlug: 'acme',
  primaryColor: swatchFromSeed(const Color(0xFF4F46E5)),
);

void main() => runApp(
  AppTheme(
    data: AppThemeData.forBrand(myBrand, dark: false),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(
            builder: (BuildContext context) => const MyApp(),
          ),
        ],
      ),
    ),
  ),
);
```

That is the whole setup — one seed, no network. The icons, the illustrations and
the fonts ship inside the package, so this runs on the first `flutter run`.
`flocksBrand` also exists, but it is the brand of *this site*, not a starting
point: adopting it would put our identity in your product instead of yours.

**The `Overlay` is not decoration.** This package mounts none for you — the host
decides where the floating layer lives — and three kinds of component need one
above them:

- **The ones that insert into it themselves:** the dropdowns (`AppDropdown`,
  `AppMultiSelect`, `AppSearchableDropdown`, `AppSearchableMultiSelect`),
  `AppTooltip`, `AppPopover`, `AppMenu`, `AppOmniSearch`, `AppPickerAnchor` and
  the inputs built on it (`AppDatePickerInput`, `AppTimePickerInput`,
  `AppDateTimePickerInput`, `AppColorPickerInput`), plus `showAppOverlay` and
  `showAppSnackbar`.
- **Every text field, by Flutter's rule rather than ours:** an `AppInput` builds a
  `TextSelectionOverlay` when it takes focus — a tap, keyboard traversal and a
  `requestFocus()` on the `focusNode` you passed all do it — and the constructor of
  the `SelectionOverlay` underneath is what demands the ancestor:
  `assert(debugCheckHasOverlay(context))`, in its initializer list
  (`packages/flutter/lib/src/widgets/text_selection.dart`). Drawing a field is
  fine, because until it is focused the selection overlay does not exist yet.
- **The ones that build one of the above inside themselves:** `AppInput(info:)`
  (an `AppPopover`), `AppPagination(perPage:)` (an `AppDropdown<int>`),
  `AppSplitButton` (an `AppMenu`), and anything carrying a `tooltip` —
  `AppCheckbox`, `AppSwitch`, a collapsed `AppNavigationRail`.

Static text is the exception, and only static: the `AppSelectionRegion` that wraps
every `AppText` asks with `Overlay.maybeOf` and returns the child when there is
none, so the text still draws — it just is not selectable. A text *field* is not
covered by that; it is in the list above.

Without an ancestor, opening any of them throws, and the message is the
framework's rather than ours. This is a debug build, measured with an
`AppDropdown` under the root above minus its `Overlay`
(`packages/flutter/lib/src/widgets/overlay.dart`, Flutter 3.44.9):

```
No Overlay widget found.
Some widgets require an Overlay widget ancestor for correct operation.
The most common way to add an Overlay to an application is to include a MaterialApp, CupertinoApp or Navigator widget in the runApp() call.
The context from which that widget was searching for an overlay was:
  AppDropdown<String>
```

The hint offers the three widgets this package exists to do without. The second
line is an `ErrorDescription`, and it stays generic — "Some widgets" — because no
call site here passes `debugRequiredFor`; the `ErrorSummary` above it never names
anything, and the component that failed appears only at the bottom, in the context
line. The text-field path is a different assert with a different message, and that
one does name the widget: `debugCheckHasOverlay` interpolates
`context.widget.runtimeType`, and the context handed to it is the field's own
`EditableText` — so it reads "EditableText widgets require an Overlay widget
ancestor". In a release or profile build the asserts are compiled out; `Overlay.of`
then ends at its `!` and throws `Null check operator used on a null value`.

The `Directionality` above the `Overlay` is required for the same reason the
overlay is: the overlay resolves its entries' direction-sensitive coordinates
through it.

After that, every component reads the theme by itself:

```dart
AppButton(
  icon: AppIconToken.add,
  label: 'New vehicle',
  onPressed: _create,
)
```

---

## Zero Material — and it is verified

`lib/src` imports neither `material.dart` nor `cupertino.dart`. That is not an
intention in a README: it is 25 suites in `test/architecture/` that sweep the
code on every `flutter test`, and the allow-list has **one** entry —
`TextSelectionControls`, which has no equivalent in the `widgets` layer.

This matters because a design system that reuses `Card`, `InkWell` or `Scaffold`
inherits Material's visual decisions along with them. Here the box, the ripple
and the scaffold belong to the system.

Those same suites police the rest: no component invents a `bool _isHovered`
instead of using the shared interaction state; no animation uses a raw
`Curves.*`; no tappable target is mute to a screen reader. And every axis has a
pair of tests — a **census** (nobody is outside) and a **reach** (changing the
global changes the pixel). The absence of an offender is not the presence of an
effect.

## Three global axes

One value in the theme restyles all 133 components at once.

| Axis | Values | What it changes |
|---|---|---|
| `AppStyle` | `filled` · `outlined` · `elevated` | The fill, border and shadow of every box |
| `AppRadiusMode` | `reto` · `redondo` · `circular` · `padrao` | The corner of every surface |
| `AppGlassTheme` | on · off | Glass on floating surfaces |

```dart
AppThemeData.forBrand(brand, dark: false).copyWith(
  styleTheme: const AppStyleTheme(style: AppStyle.outlined),
  radiusTheme: const AppRadiusTheme(mode: AppRadiusMode.reto),
);
```

Alongside them come the motion axis (which honors the OS's "reduce motion"), the
transparency axis (an accessibility gate) and the icon axis.

## White-label from one hex

A brand is an object. The whole palette — 11 stops per role, light and dark —
comes out of a seed, derived by **HCT tone** (perceptually uniform), which
preserves hue and chroma and gives consistent contrast between stops.

```dart
final myFullBrand = AppBrandConfig(
  clientSlug: 'acme',
  primaryColor: swatchFromSeed(const Color(0xFF4F46E5)),
  neutralLightColor: neutralSwatchFromSeed(const Color(0xFF6B7280)),
  typography: const AppBrandTypography(displayFamily: 'SpaceGrotesk'),
);
```

A brand is **only** what the system needs to draw itself: the palette, the global
axes, the typography. It carries no app name, no site, no asset base URL, no
store link. Those describe *your product*, not its styling — and a design system
that held them would be asserting that your app has a splash screen, an OTP flow,
a nav rail and a Play Store listing. That is the same coupling Flocks refuses
when it declines to reuse `Card` and `Scaffold`. Where that identity lives is
your call; the components take it as parameters.

The consequence is that nothing here reaches for a network you did not ask for.
`AppIcon`, `AppIllustration` and `AppAuthSplitLayout` all accept `null` where a
remote asset would go, and simply draw nothing.

`lib/src/brand/brands/flocks_brand.dart` is the complete example — and every
registered brand's contrast is verified against WCAG AA, brand × brightness, in
`test/src/theme/contrast_test.dart`. The rules are in
[`doc/COLOR_ACCESSIBILITY_RULES.md`](doc/COLOR_ACCESSIBILITY_RULES.md).

## Pluggable icons

`AppIconToken` is the 55 names the components use — the contract a provider has
to satisfy. The default one serves SVGs from inside the package: 25 KB, it works
offline, on the first `flutter run`, with no CDN.

Swapping the set is swapping the provider, and there are three ready paths:

| | |
|---|---|
| **A whole library** | [`flocks_phosphor`](../flocks_phosphor) — 1,512 icons × 6 weights, font-based and tree-shakeable, with weight as a brand axis |
| **Material, Font Awesome…** | [`flocks_material`](../flocks_material) is the reference implementation: one table and one `build` |
| **Your own CDN** | `AppNetworkIconProvider(baseUrl: …)`, already in the core |

```dart
AppThemeScope(
  iconProvider: const PhosphorIconProvider(weight: PhosphorWeight.bold),
  builder: (context, theme) => MyApp(theme: theme),
)
```

The core embeds only the contract because Flutter **does not tree-shake assets**:
everything in the `pubspec` is paid for by every adopter. A Material adapter has
to be a separate package for the same reason the core does not import
`material.dart` — and the architecture test bars whoever tries.

## Documentation in two languages

Every component's catalog entry (`lib/src/**/*.meta.dart`, served as
`doc/mcp/catalog.json`) carries its prose in English **and** in Brazilian
Portuguese. Both are required by the type: `LocalizedText` and `LocalizedList`
have no single-language constructor, so a component cannot enter the catalog
half-translated.

```dart
summary: LocalizedText(
  en: 'Compact status pill, tinted by a semantic color role.',
  pt: 'Pill compacta de status, tingida por papel de cor semântico.',
),
```

That is what lets flocks.live publish one route per component in each language
without either side going missing. `states` and `variants` stay outside it on
purpose: they name API surface (an enum's value, an interaction state), and that
vocabulary is English throughout the package — it is checked against the
allow-list in `test/architecture/catalog_vocabulary.dart`.

## Structure

```
lib/src/
  tokens/       color, spacing, radius, typography, icon
  theme/        AppThemeData and the axes
  brand/        white-label
  foundation/   interaction, focus, semantics, icon providers
  motion/       micro-interactions
  atoms/ molecules/ organisms/    the components
```

Every component carries a `.doc.md`, a `.preview.dart`, a Widgetbook case and a
test — required by `dart run tool/validate_components.dart`.

## Development

```bash
flutter test --exclude-tags golden
```

```bash
flutter test --tags golden
```

```bash
dart run tool/validate_components.dart
```

The goldens compare pixels and are sensitive to the rasterizer: run them on
macOS, and never `--update-goldens` in bulk without looking at what changed.
`tool/golden_triage.py` builds contact sheets per family for the review.

## License

MIT — see [LICENSE](LICENSE). The fonts (`assets/fonts/`) are OFL 1.1 and the
icons (`assets/icons/`) are from [Phosphor Icons](https://phosphoricons.com)
under MIT; the license texts ship beside the files.

`lib/src/foundation/pointer/pointer_interceptor_web.dart` is adapted from
[`pointer_interceptor_web`](https://pub.dev/packages/pointer_interceptor_web)
(flutter/packages) under BSD-3-Clause — Copyright 2013 The Flutter Authors. All
rights reserved. The notice also sits at the top of that file, as BSD-3
requires.
