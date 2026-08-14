# AppImage

Flocks' raster image (network, asset or in-memory bytes), with standardized
loading and fallback. It complements **AppIllustration** (SVG) and
**AppAvatar** (circular).

## When to use

- A raster photo, thumbnail or banner: a camera event, an icon preview, a portrait.
- Bytes that are already in memory: an API payload, a decoded base64 QR code.

## When NOT to use

- A vector icon or illustration → **AppIcon** / **AppIllustration**.
- A circular profile photo → **AppAvatar**.

## Anatomy

- Constructors: `AppImage.network(url)`, `AppImage.asset(path)` and
  `AppImage.memory(bytes)`.
- It clips to `radius` (default: the global radius, round mode) through `ClipRRect`.
- `fit` (default `BoxFit.cover`), with optional `width`/`height`.
- **Network**: it cross-fades from the placeholder (`loading`: `spinner` or
  `skeleton`) to the image when it finishes; on error it falls back to `fallback`.
- **Memory**: same cross-fade and fallback contract as network, decoding a
  `Uint8List` with `gaplessPlayback` (swapping `bytes` keeps the old frame until
  the new one decodes — pass a **new** list when the content changes). Empty or
  corrupt bytes land on `fallback`, never on a broken frame. Pair it with the
  static `AppImage.decodeBase64` helper, which tolerates whitespace, a
  `data:image/png;base64,` prefix and missing padding, and returns `null` for
  invalid input — decode **once**, outside `build`. Meant for small API
  payloads (a QR, a thumbnail); large files belong to `.network`, since the
  bytes stay retained in the `ImageCache`.
- `fallback` defaults to a `surfaceContainer` box (a neutral theme-aware
  placeholder); pass a widget of your own (an icon, say) for something richer.

## Accessibility (Rule 8)

- `semanticLabel == null` (the default) → decorative (excluded from the semantics).
- `semanticLabel != null` → `Semantics(image: true, label: …)`.
- The `.memory` variant almost always carries meaning (a QR code, a chart):
  label it. And a screen reader cannot read any QR, labeled or not — the label
  says what the image is; what completes the flow is the copyable code as text
  next to it.

## Testing note

Same as **AppIcon**: the `.network` variant loads off the network, which is
blocked in `flutter_test` → the widget falls back to `fallback`. That is why the
golden captures the **fallback** state (deterministic, theme-aware); checking
the real image happens in the Widgetbook or the app. The widget tests cover
fit, radius, fallback and semantics.

The `.memory` variant *does* decode in tests, but only inside
`tester.runAsync` — without it the test binding never completes
`instantiateImageCodec` and the tree freezes on the placeholder. The memory
golden decodes an 8×8 opaque PNG sample inside `runAsync`; a test written with
a dry `pumpAndSettle` would pass by accident today and flake tomorrow.

## Do / Don't

- ✅ Give it `width`/`height` (most uses have a fixed box).
- ✅ Pass `semanticLabel` when the image carries meaning.
- ✅ Decode base64 once (`AppImage.decodeBase64`), outside `build`.
- ❌ Do not use it for vectors (SVG) — that is `AppIllustration`.
- ❌ Do not feed `.memory` multi-megabyte files — the bytes stay in the
  `ImageCache`; that is `.network` territory.

## Examples

```dart
AppImage.network(event.thumbnailUrl, width: 96, height: 64)

AppImage.asset(
  'assets/banner.png',
  height: 120,
  radius: theme.radiusTheme.resolve(),
  semanticLabel: 'Promotional banner',
)

final Uint8List? qr = AppImage.decodeBase64(res.pixQrBase64);
// ...
if (qr != null)
  AppImage.memory(qr, width: 200, height: 200,
      semanticLabel: 'QR Code do PIX')
```
