# AppImage

Flocks' raster image (network or asset), with standardized loading and fallback.
It complements **AppIllustration** (SVG) and **AppAvatar** (circular).

## When to use

- A raster photo, thumbnail or banner: a camera event, an icon preview, a portrait.

## When NOT to use

- A vector icon or illustration → **AppIcon** / **AppIllustration**.
- A circular profile photo → **AppAvatar**.

## Anatomy

- Constructors: `AppImage.network(url)` and `AppImage.asset(path)`.
- It clips to `radius` (default: the global radius, round mode) through `ClipRRect`.
- `fit` (default `BoxFit.cover`), with optional `width`/`height`.
- **Network**: it cross-fades from the placeholder (`loading`: `spinner` or
  `skeleton`) to the image when it finishes; on error it falls back to `fallback`.
- `fallback` defaults to a `surfaceContainer` box (a neutral theme-aware
  placeholder); pass a widget of your own (an icon, say) for something richer.

## Accessibility (Rule 8)

- `semanticLabel == null` (the default) → decorative (excluded from the semantics).
- `semanticLabel != null` → `Semantics(image: true, label: …)`.

## Testing note

Same as **AppIcon**: the `.network` variant loads off the network, which is
blocked in `flutter_test` → the widget falls back to `fallback`. That is why the
golden captures the **fallback** state (deterministic, theme-aware); checking
the real image happens in the Widgetbook or the app. The widget tests cover
fit, radius, fallback and semantics.

## Do / Don't

- ✅ Give it `width`/`height` (most uses have a fixed box).
- ✅ Pass `semanticLabel` when the image carries meaning.
- ❌ Do not use it for vectors (SVG) — that is `AppIllustration`.

## Examples

```dart
AppImage.network(event.thumbnailUrl, width: 96, height: 64)

AppImage.asset(
  'assets/banner.png',
  height: 120,
  radius: theme.radiusTheme.resolve(),
  semanticLabel: 'Promotional banner',
)
```
