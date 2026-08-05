# AppSideSheet & AppSideSheetPage

**Floating** side panel — `AppBottomSheet`'s horizontal sibling. A detached card
(margin + rounded corners) that slides in from the `side` edge (`start`/`end`,
default `end` = right) and grows toward the center. Show it through
**`showAppSideSheet`**.

**`AppSideSheetPage`** is **visually identical** — the same surface, the same
snaps, the same chrome. What changes is the **route's class**:
`SideSheetPageRoute` (a persistent `PageRoute`) instead of the ephemeral
`SideSheetRoute`.

The difference matters when the panel is a first-class "page": heavy, with state
of its own, that has to survive and still be able to host an ephemeral sheet **on
top** (the Vehicle Record is the case that motivated it). An ephemeral route does
not stack that way — the second sheet would close the first.

Choose by the nature of the content, not by the look: an aside that closes right
away → `AppSideSheet`; a destination with state → `AppSideSheetPage`.

## When to use

- A detail or an edit beside the main content (desktop/tablet: a map + a panel).
- A contextual form or list that benefits from resizing (40/70/full).

## When NOT to use

- A panel that rises from the bottom on mobile → `AppBottomSheet`.
- A blocking central confirmation → `AppDialog`.

## Snaps (responsive by width, breakpoint 1024)

- **Wide** (`> AppDevice.tablet.breakpoint`): `40% → 70% → full`.
- **Narrow** (`<= 1024`): `70% → full`.
- **full** = edge-to-edge, leaving a **peek** on the opposite edge (a tappable
  barrier), mirroring the peek at the top of `AppBottomSheetPage`.
- Non-draggable = pinned to the 1st snap (40% wide / 70% narrow).

## Dragging (`draggable: true`)

An `AnimationController` + a gutter `GestureDetector` on the **inner** edge
(there is no horizontal `DraggableScrollableSheet`). The resize is horizontal;
the `child`'s scroll is vertical → no axis conflict. Dragging the inner edge:
- **outward** (away from the anchored edge): it grows → the next snap → full (a
  morph);
- **toward the anchored edge** past the smallest snap: it **closes**;
- from **full**, it returns to the smaller snap — unless `alwaysClose` (then it
  closes).
- It works with **mouse/trackpad** on desktop (a bare GestureDetector).
- `onClose` fires when it closes by any means.

## Chrome

- **Handle** (`showHandle`): a **vertical** grabber on the inner edge (it changes
  sides according to `side`).
- **Close button**: a chip (a circular icon-only `AppButton`); `closeSide`
  defaults to the **inner corner** according to `side` (`end`→start,
  `start`→end).
- An optional **title**, centered in the top bar.

## Global axes

- **Style**: `style` — an overlay does not follow the global one; its own default
  is `elevated`.
- **Radius**: `radiusMode` (the inner corners stay rounded; the outer ones
  flatten at full).
- **Motion**: a lateral slide + snap through tokens; it honors reduce-motion.

## Accessibility

Focus and its return are handled by the `Navigator`'s route; the barrier and the
close button are labelled "Close". The theme's colors pass WCAG AA in light and
dark across both brands.

## Example

```dart
showAppSideSheet<void>(
  context: context,
  side: AppSheetSide.end,
  draggable: true,
  showHandle: true,
  title: const Text('Vehicle'),
  child: vehicleDetails, // it scrolls vertically on its own
);
```

## Opening snap (`initialSnap`)

By default the sheet opens at the **smallest** snap (`rest`: 40% on wide screens,
70% on narrow ones) — the right behavior for a side panel that accompanies the
screen underneath (configuring columns, preferences).

For content that **needs** the whole width — two columns side by side, a wide
table — pass `initialSnap: AppSideSheetSnap.full`. Without that, the user would
open into a narrow panel and have to drag before being able to read, which turns
the first interaction into an obstacle.

The choice is by **position on the scale**, not by fraction: the snaps only exist
after layout (they depend on the available width and on `edgePeek`), so `full` is
resolved as "the last snap" in the `LayoutBuilder`, not as a fixed number.

```dart
showAppSideSheet<void>(
  context: context,
  draggable: true,
  initialSnap: AppSideSheetSnap.full,
  child: const AppDocsWorkspace(...),
);
```
