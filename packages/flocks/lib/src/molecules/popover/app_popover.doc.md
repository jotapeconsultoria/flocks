# AppPopover

**Rich-content** overlay anchored to a `trigger`. It opens on click or on hover,
shows an arbitrary `child` (with an optional `title` and `actions`) and draws an
arrow pointing at the target. It renders through the `Overlay`, anchored by a
`LayerLink` (transform-safe), and re-provides the theme inside the entry — so it
works in any host.

## When to use

- Rich details or help shown on demand (more than a text tooltip).
- A small form or light confirmation anchored to a control.

## When NOT to use

- Just a short piece of hover text → use `AppTooltip`.
- Choosing a value from a list → use `AppDropdown`.
- A list of actions (with icons/danger/sections) → use `AppMenu`.

## Anatomy / states

- **Trigger**: passive content (an icon, text, a box) — the popover is what makes
  it actionable (click or hover). Wrapped in a `CompositedTransformTarget` + a
  `TapRegion`.
- **Panel**: an `AppCard` with an optional `title` (a `titleMedium`/`onSurface`
  header), the `child` and an optional row of `actions`.
- **style** (the `AppStyle` axis): `elevated` (its own default, a soft shadow) /
  `outlined` (an `outline` border only) / `filled` (flat) — it does not follow
  the global `styleTheme`. The **shape** follows the global radius
  (`radiusMode`/`radius`).
- **Arrow** (`showArrow`, on by default): a `surfaceContainer` triangle with an
  `outline` border on the slanted edges, aligned by `placement`
  (start/center/end).
- **placement**: `bottomCenter` (default) / `bottomStart` / `bottomEnd` /
  `topStart` / `topCenter` / `topEnd`.
- **triggerMode**: `click` (default) or `hover` (it closes when the pointer
  leaves both the trigger and the panel).
- **maxWidth**: constrains the width; `null` = sized by the content.
- **controller** (`AppPopoverController`): programmatic `open()` / `close()` /
  `toggle()`.
- It closes on an **outside click** or on **Esc**.

## Accessibility (Rule 8)

- The `title`, when present, is marked as a heading (`AppSemantics.header`).
- The trigger must carry its own semantics (an `AppIcon` with a `semanticLabel`,
  say), because the popover only makes it tappable.
- In `hover` mode, do not put essential content only in the popover (touch has no
  hover).

## Motion

- The panel enters with a **fade + pop** (`AppAppear`) and honors reduce-motion
  (when off, it appears instantly).

## Example

```dart
AppPopover(
  trigger: AppIcon(AppIconToken.info, semanticLabel: 'Help'),
  title: 'About the score',
  child: AppText('It combines hard braking, cornering and average speed.'),
  actions: <Widget>[AppTextButton(label: 'Got it', onPressed: dismiss)],
)
```
