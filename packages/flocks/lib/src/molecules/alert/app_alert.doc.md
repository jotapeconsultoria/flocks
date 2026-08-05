# AppAlert

Alert **card** with a title, a description and an icon in the semantic color. It
is only the card — to show it somewhere on screen, use the **`showAppOverlay`**
helper.

## When to use

- Contextual feedback (notice, error, success, info) — **inline** on the page.
- **Transient** feedback (it disappears on its own in a corner) — through
  `showAppOverlay` with a `duration`. `AppAlert` covers the role that used to
  belong to the snackbar.

## When NOT to use

- A short status pill, with no title or description → `AppBadge`.
- A generic floating surface (free content) → `AppCard`.

## Anatomy (the card)

- **Card**: a `surfaceContainer` background tinted by a whisper (8%) of the
  semantic color + a border in the semantic color (`AppStrokes.m`). **No literal
  shadow** — elevation comes from tone + border (the design system's philosophy,
  same as `AppTooltip`).
- **Radius**: the global radius (round mode).
- **Title** (`titleMedium`, `onSurface`): 1 line, `ellipsis`.
- **Icon** (`AppIconSize.m`, semantic color) to the right of the title.
- **Description** (`bodyMedium`, `neutralPrimary.s700`): up to 3 lines, `ellipsis`.

## Colors (`AppAlertColor`)

`info` (blue) · `success` (green) · `warning` (amber) · `danger` (red). Each one
resolves to the theme's token (`info`/`success`/`warning`/`danger`).

## `showAppOverlay` (the positioning helper)

It shows **any** widget at a point on screen through the `Overlay` (no Material):

- **`position`** (`AppOverlayPosition`): the **3×3 grid without the center** — 4
  corners + 4 edge midpoints
  (`topLeft`/`topCenter`/`topRight`/`centerLeft`/`centerRight`/`bottomLeft`/`bottomCenter`/`bottomRight`).
  It honors `SafeArea` + `margin`.
- **`maxWidth`**: the content's maximum width.
- **`animation`** (`AppOverlayAnimation`): `fade` / `scale` / `slide` (sliding
  from the edge nearest the position) — it applies to the entrance **and** the
  exit, through `AppMotion` (honoring reduce-motion → no animation).
- **`duration`**: auto-dismiss (`null` = it stays until dismissed). The return
  value is a callback that **dismisses** with the exit animation. It does not
  block the pointer outside the card.

## Accessibility (Rule 8)

- Wrapped in `AppSemantics.liveRegion` → the alert is **announced** by screen
  readers when it appears.
- Contrast validated across 2 brands × 2 brightnesses: title and description over
  the tinted background ≥ AA; border and icon (semantic color) ≥ 3:1 against the
  surface — see `alert_test.dart`.

## Do / Don't

- ✅ Match the semantic color to the message (danger = error, success = success).
- ✅ A short title (1 line); the detail goes in the description.
- ✅ Choose `position`/`animation` by urgency (an error at the top; a discreet
  success in the bottom corner).
- ❌ Do not stack several overlays in the same corner at once.

## Tests

- No **pixel golden** (`AppIcon` loads a network SVG through `cache_manager`,
  which is unavailable in `flutter_test`); contrast is validated by assertion.
  The overlay is tested by behavior (it shows, it auto-dismisses, `dismiss()`
  removes it).

## Examples

```dart
// Inline
AppAlert(
  title: 'No connection',
  description: 'Check your internet and try again.',
  color: AppAlertColor.danger,
)

// Positioned on screen
final dismiss = showAppOverlay(
  context: context,
  position: AppOverlayPosition.topRight,
  animation: AppOverlayAnimation.slide,
  maxWidth: 360,
  child: AppAlert(title: 'Saved', description: 'Changes applied.'),
);
```
