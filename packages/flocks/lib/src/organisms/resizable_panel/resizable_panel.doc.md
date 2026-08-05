# AppResizablePanel

A panel whose **width is dragged** from one of its edges, in **px**.

## When to use

- A side panel whose width belongs to the user and has no sibling to divide with
  — the `aside` slot of `AppShell` (the assistant), say, which takes the full
  height beside the header.
- When the right measure is absolute ("a floor of 380px"), not proportional.

## When NOT to use

- Two sibling panels sharing the space → `AppResizableSplit` (a fraction, scaling
  with the window).
- A fixed width with no adjustment → a `SizedBox`.

## `maxWidth` belongs to the caller (it cannot be inferred)

As a non-flexible child of a `Row`, the panel receives an **unbounded** main-axis
constraint — an internal `LayoutBuilder` would read `infinity`. Compute the
ceiling at the source and pass it in:

```dart
AppResizablePanel(
  initialWidth: restored ?? 380,          // read from your storage
  minWidth: 380,                          // the floor
  maxWidth: MediaQuery.sizeOf(context).width / 2,
  onWidthChanged: (w) => storage.write('shell.assistant.width', w),
  child: assistantPanel,
);
```

The width is **re-clamped on every build**: a restored width larger than the
current ceiling (a window smaller than in the session it was saved in)
accommodates itself instead of overflowing. The clamp is display-only — the
chosen width is still stored, so widening the window again returns the panel to
the size the user asked for.

## Persistence (the caller's job)

The design system does not depend on storage: restore the saved value into
`initialWidth` and write new ones from `onWidthChanged` — just like
`AppResizableSplit`.

## Anatomy

- A draggable **gutter** (the same one as `AppResizableSplit`) on the `edge` edge
  (`start` = left in LTR, for panels anchored to the right); the handle is hidden
  at rest, revealed on hover and lit during the drag, with motion through tokens
  (honoring reduce-motion); a **double tap** returns to `initialWidth`.
- A `RepaintBoundary` isolates the content — hovering or dragging the gutter does
  not repaint the panel.
- A **tooltip** (`AppTooltip`) on the gutter.

## Caveats

- It needs a **bounded height** (the content is stretched on the cross axis).
- The drag's sign honors `Directionality` and `edge`: dragging away from the
  panel always grows it.

## Accessibility

The gutter has a tooltip, a `resizeColumn` cursor and its own drag target; the
handle's color comes from the theme (AA contrast in light and dark).
