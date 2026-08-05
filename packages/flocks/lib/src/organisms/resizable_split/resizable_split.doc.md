# AppResizableSplit

Two panels (`first`/`second`) with a **draggable divider**, horizontal or
vertical. The split is a **fraction** (0..1) that scales with the window.

## When to use

- Sidebar + content (a list + a map, say) with a width the user adjusts.

## When NOT to use

- A fixed division with no adjustment → a `Row`/`Column` with `Expanded`.
- **One** panel alone, with no sibling to divide with (`AppShell`'s `aside`, say)
  → `AppResizablePanel`, which measures in px and shares the same gutter.

## Persistence (the caller's job)

The design system **does not depend on storage**. To persist the fraction across
sessions:

- restore the saved value and pass it in `initialFirstFraction`;
- save new values in the `onFractionChanged` callback.

```dart
AppResizableSplit(
  initialFirstFraction: restoredFraction ?? 0.22, // read from your storage
  onFractionChanged: (f) => storage.write('tracking_map.split', f),
  minFirstSize: 260,
  minSecondSize: 320,
  first: sidebar,
  second: map,
);
```

## Anatomy

- A draggable **divider** with a handle (hover animates through motion tokens,
  honoring reduce-motion); a **double tap** resets it to `initialFirstFraction`.
- A `RepaintBoundary` isolates each panel (critical when one side is an expensive
  platform view, such as a map).
- A **tooltip** (`AppTooltip`) on the divider.

## Accessibility

The divider has a tooltip and its own drag target; the handle's colors come from
the theme (AA in light and dark).
