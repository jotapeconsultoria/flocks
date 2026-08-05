# AppBottomSheet, AppBottomSheetPage & AppBottomSheetContent

Panels anchored to the **bottom** of the screen.

- **`AppBottomSheet`** — a **detached floating card** (margins on L/R/bottom,
  rounded corners) that rises until the content fits (a `maxHeightFraction`
  ceiling, with internal scrolling above that). Show it through
  **`showAppBottomSheet`**; with `draggable: true` it gains two states (rest ⇄
  **page**) with a fluid **morph**.
- **`AppBottomSheetPage`** — an iOS-style **page**: it rises to just below the top
  safe area, leaving a gap (peek) that shows the screen underneath;
  edge-to-edge, with a **downward swipe** to close. Show it through
  **`showAppBottomSheetPage`**.
- **`AppBottomSheetContent`** — the standard body (title, message, illustration),
  **scrollable** — for **non-draggable** sheets.

## When to use

- `AppBottomSheet`: a form, detail or action that rises from the bottom on mobile.
- `AppBottomSheet(draggable)`: a long list or form that benefits from being
  dragged up into a page.
- `AppBottomSheetPage`: content that needs almost the whole screen (with a peek at
  the top).

## When NOT to use

- A blocking central confirmation on desktop → `AppDialog`.
- A short menu anchored to a trigger → `AppMenu`.

## Top bar (chrome)

- A centered **handle** (grabber) — only when `showHandle` (draggable).
- An optional, centered **title**.
- A **close button** — an icon-only `AppButton` in a circular chip, on by default
  (`showCloseButton`, default `true`); side through `closeSide` (`start`/`end`,
  default `end` = right in LTR); action through `onCloseButton` (`null` = pop).

## Dragging (`AppBottomSheet(draggable: true)`)

Built on `DraggableScrollableSheet` (which coordinates gesture ↔ scroll in a
single gesture): it always drags from the handle or the header, and from the body
when the scroll is at the top.

- **rest** = the content's height (a `maxHeightFraction` ceiling, default 0.65);
  **page** = the top safe area + the peek.
- dragging **up**: rest → page (a morph: margins → 0, bottom corners → 0, width →
  100%).
- dragging **down**: at rest it **closes**; at page it returns to rest — unless
  `alwaysClose: true` (then page closes too).
- `onClose` fires when it closes by **any** means (drag/barrier/button).

### Scrolling (the contract)

- **Non-draggable / page** through `AppBottomSheetContent`: the **body** handles
  its own scrolling.
- **Draggable**: the `child` must be **non-scrollable** (the sheet owns the
  scrolling and coordinates it with the drag). Pass the content directly (with no
  `SingleChildScrollView`); a scrollable of the caller's own must use
  `PrimaryScrollController.of(context)`.

## Modal (the route)

- A custom `PopupRoute`, **with no Material**. A slide-up with `AppDurations.slow`
  and the `AppCurves.emphasized`/`accelerate` curves; it collapses under
  reduce-motion.
- **Barrier**: the theme's `neutralPrimary.barrier()`, dismissible by default.
- **Root navigator**: `useRootNavigator: true` covers the bottom navigation. The
  design system does **not** depend on a router.

## Global axes

- **Style**: `style` — an overlay does not follow the global one; its own default
  is `elevated` (a shadow); `outlined` swaps that for a border.
- **Radius**: `radiusMode` (the top corners; the bottom ones animate in the
  morph).
- **Motion**: slide-up + snap through tokens; it honors reduce-motion.

## Accessibility

Focus and its return are managed by the `Navigator`'s route; the barrier and the
close button are labelled "Close". The theme's colors pass WCAG AA in light and
dark across both brands.

## Examples

```dart
// A simple floating card (the X dismisses it by default).
showAppBottomSheet<void>(
  context: context,
  useRootNavigator: true,
  title: const Text('Filters'),
  footer: AppButtonsFooter(primary: apply),
  child: const AppBottomSheetContent(
    title: 'Filters',
    message: 'Refine the search.',
    illustration: 'assets/filter.svg',
  ),
);

// Draggable (rest ⇄ page) — a non-scrollable child.
showAppBottomSheet<void>(
  context: context,
  draggable: true,
  showHandle: true,
  title: const Text('Vehicles'),
  child: vehiclesColumn, // with no SingleChildScrollView of its own
);

// An iOS-style page.
showAppBottomSheetPage<void>(
  context: context,
  title: const Text('Settings'),
  child: settingsBody,
);
```
