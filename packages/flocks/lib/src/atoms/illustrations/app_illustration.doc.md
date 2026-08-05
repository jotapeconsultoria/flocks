# AppIllustration

Vector illustration (SVG) loaded off the network with a local cache. While it
downloads, it shows a shimmer at the final size; on error, a circle in the
`danger` color. The SVG's colors (base and accent) are resolved theme-aware.

## When to use

- Empty states, onboarding, success/error screens with vector art.

## When NOT to use

- Small UI icons → **AppIcon**.

## Colors (Rule 9)

The SVG exposes two color groups by `id` (`baseColor*`, `accentColor*`),
substituted by `AppIllustrationColorMapper`. When `baseColor`/`accentColor` are
not given, `AppIllustration` resolves the defaults from the theme:

- `baseColor` → `theme.colorTheme.neutralPrimary.s900`
- `accentColor` → `theme.colorTheme.secondary` (the brand accent)

So the illustration adapts to light/dark and to the brand with no configuration.

## Sizes

`AppIllustrationSize`: `s` (128), `m` (192), `l` (256, the default), `xl` (384).

## Accessibility (Rule 8)

- `semanticLabel` → labelled image semantics. `null` (the default) → decorative
  (the SVG already uses `excludeFromSemantics`).

## Motion (Rule 10)

- The loading placeholder is an `AppShimmerLoading`, which honors reduce-motion
  (it renders the base box with no sheen).

## Testing note

The final look depends on the network, so **there is no pixel golden** (the same
criterion as AppIcon). The coverage lives in the widget tests: the mapper's
logic, the shimmer placeholder, the error state and the semantics.

## Example

```dart
AppIllustration(
  AppIllustrations.empty,
  size: AppIllustrationSize.xl,
  semanticLabel: 'No results',
)
```
