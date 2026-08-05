# AppDialog & AppDialogContent

The design system's central modal surface. **`AppDialog`** is the floating card
(scrollable content + an optional footer); **`AppDialogContent`** is the standard
body (title, message, illustration). To show it as a modal use the
**`showAppDialog`** helper.

## When to use

- Confirming an action that blocks the flow (delete, leave without saving).
- Showing a result or notice that requires acknowledgement before continuing.

## When NOT to use

- Transient, non-blocking feedback → `AppAlert` through `showAppOverlay`.
- A choice anchored to a trigger (a short list) → `AppMenu`/`AppPopover`.
- A long form on mobile rising from the bottom → `AppBottomSheet`.

## Anatomy

- **Surface** (`AppDialog`): a `surfaceContainer` card that follows the
  `AppStyle` axis (its own default **`elevated`** — a symmetric shadow;
  `outlined` swaps the shadow for an `outline` border; `filled` leaves it flat).
  Radius from the global axis.
- **Top bar**: the same one the sheets use — 64px, an optional `title`
  (`titleMedium`/`onSurface`) and a close button in a circular chip. It sits
  **outside the scroll**, like the footer.
- **Content**: a free `child`, scrollable (`SingleChildScrollView`) when it
  exceeds the height.
- **Footer**: an optional `footer` (an `AppButtonsFooter` with a primary +
  secondary action, say).
- **Standard body** (`AppDialogContent`): an optional title
  (`titleLarge`/`onSurface`), a message (`bodyLarge`/`neutralPrimary.s700`) and a
  central illustration (the accent color defaults to the theme's `secondary`).

## Top bar

- `title` — aligned to the **start**, not centered as in the sheets: here it is a
  form's heading, not a panel's label. The style comes through a
  `DefaultTextStyle`, so an already-styled `AppText` wins the merge.
- `showCloseButton` — **`true`** by default; `closeSide` — **`end`** (right in
  LTR) by default. `onCloseButton` replaces the pop.
- With no `title` **and** no button the bar is not mounted: the card returns to
  its historical shape, with no leftover 64px gap.
- With the bar, the card takes the constraints' **maximum width** (640 by
  default) — the bar runs edge to edge. Without it, the card still hugs its
  content (a floor of 448).
- ⚠️ In a `barrierDismissible: false` dialog, the "X" becomes the **only** way
  out. If you switch it off, make sure the footer offers an exit.

## Modal (`showAppDialog`)

- It uses the app's `Navigator` (a custom `PopupRoute`, **with no Material**).
- **Barrier**: the theme's `neutralPrimary.barrier()`, dismissible by default
  (`barrierDismissible`), labelled "Close".
- **Transition**: a fade with `AppDurations.normal` and the `AppCurves.standard`
  curve; it collapses under reduce-motion (`AppMotion`).
- **Constraints**: `minWidth 448 / maxWidth 640` by default (overridable).

## Global axes

- **Style**: `style` (default `elevated`).
- **Radius**: `radiusMode`/`radius` (defaulting to the global one).
- **Motion**: an enter/exit fade through tokens; it honors reduce-motion.

## Accessibility

- The focus scope and its return are managed by the `Navigator`'s route.
- The close button is the dialog's **first focusable node** (labelled "Close",
  the same as the barrier) — the keyboard now has a way out that is not the
  barrier.
- The bar's title is announced as a **heading**.
- The theme's colors (`surfaceContainer`/`outline`, the title in `onSurface`, the
  message in `neutralPrimary.s700`) pass WCAG AA in light and dark across both
  brands.

## Example

```dart
showAppDialog(
  context: context,
  title: const AppText('Delete vehicle?'),
  child: const AppDialogContent(
    message: 'This action cannot be undone.',
    illustration: 'assets/delete.svg',
  ),
  footer: AppButtonsFooter(primary: confirm, secondary: cancel),
);
```
