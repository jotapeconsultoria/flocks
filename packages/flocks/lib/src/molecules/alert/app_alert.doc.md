# AppAlert

Alert **card** with a title, a description and an icon in the semantic color —
plus optional slots: an action inside the card, a named dismiss control and
free content. It is only the card — to show it somewhere on screen, use the
**`showAppOverlay`** helper.

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
- **Description** (`bodyMedium`, `neutralPrimary.s700`): up to `maxLines`
  lines (3 by default), `ellipsis`. `maxLines: null` removes the cap — for the
  policy text a user must actually read whole.

## Action & dismiss

- **`action`** (`Widget?`): an action INSIDE the card. `footer` placement
  (default) gives it its own row aligned to the end — the only placement that
  never fights the 1-line title for width. `trailing` puts it at the end of
  the title row, for the compact strip whose whole message fits the title.
- **`onDismiss`** (`VoidCallback?`): draws a named "×" at the end of the title
  row, as its own tap target (the `AppFilterChip` precedent — dismissing and
  acting are different gestures). It is a pure callback: **the caller owns
  visibility**; the card never hides itself.
- **`child`** (`Widget?`): free content between the description and the action
  footer, inheriting the tinted background and padding — a highlighted value,
  a selector, a row of fields.
- The card's `style`/`radiusMode`/`radius` apply to the card's box and are NOT
  forwarded into the slots: a button inside follows the global axis on its own.
- **`liveRegion`** (default `true`): the announcement wrapper. Set it to
  `false` when the alert is page furniture (a permanent settings box): a live
  region re-announces the whole card whenever an inner control changes — a
  button entering `loading` would make the reader repeat title and
  description.

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
  readers when it appears (`liveRegion: false` opts out without silencing the
  text).
- The "×" is a named tap target (`dismissSemanticLabel`, default
  `'Dispensar'`) and adds a Tab stop, as does the `action` — reading order
  follows the visual order: title → icon → action → ×.
- Contrast validated across 2 brands × 2 brightnesses: title and description over
  the tinted background ≥ AA; border and icon (semantic color) ≥ 3:1 against the
  surface — see `alert_test.dart`.

## Do / Don't

- ✅ Match the semantic color to the message (danger = error, success = success).
- ✅ A short title (1 line); the detail goes in the description.
- ✅ Choose `position`/`animation` by urgency (an error at the top; a discreet
  success in the bottom corner).
- ✅ Small buttons in the `trailing` placement — a large one stretches the
  title row and misaligns the semantic icon.
- ✅ `liveRegion: false` when the alert is furniture, not news.
- ❌ Do not stack several overlays in the same corner at once.
- ❌ Do not put two buttons in `trailing` — that is what `footer` is for.
- ❌ Do not expect the card to hide itself on dismiss — wrap it in
  `if (visible)` or dismiss the overlay.

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
