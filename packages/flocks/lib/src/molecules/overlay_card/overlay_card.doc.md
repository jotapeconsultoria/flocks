# AppOverlayCard

Floating card that **intercepts the pointer** — it stops clicks from leaking to
a *platform view* underneath (a map on the web, say). It is `AppCard` +
interception.

## When to use

- A card or panel that floats **over a map or a video** (web) where the click
  must not leak to the layer below.

## When NOT to use

- An ordinary card, with no platform view underneath → `AppCard`.

## Anatomy

- A `surfaceContainer` **surface** on the `AppStyle` (default `elevated`) and
  `AppRadiusMode` axes; an optional accent border (`accentColor`, in `outlined`).
- Free **content** (`child`) with `padding` (default `s16`), clipped to the
  radius.
- All of it wrapped in the interception: on the web, an empty `<div>` mounted
  behind the content, so the platform view below never sees the click. Off the
  web there is no DOM to steal it, and the wrapper is a pass-through.

## Accessibility

The theme's colors (`surfaceContainer`/`outline`) pass WCAG AA in light and dark.
The interceptor does not alter the content's semantics.

## Example

```dart
AppOverlayCard(child: filterPanel); // floating over the AppMap
```
