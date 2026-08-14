# AppDialog & AppDialogContent

The design system's central modal surface. **`AppDialog`** is the floating card
(scrollable content + an optional footer); **`AppDialogContent`** is the standard
body (title, message, optional illustration). To show it as a modal use the
**`showAppDialog`** helper — or **`showAppConfirm`** for the yes/no case.

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
  (`titleLarge`/`onSurface`), a message (`bodyLarge`/`neutralPrimary.s700`) and an
  **optional** central illustration (the accent color defaults to the theme's
  `secondary`). With `illustration: null` the whole art block — the art and its
  two 64px breathers — leaves the layout and the body closes 32px below the
  message: that is the plain confirmation body.

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

## Confirmation (`showAppConfirm`)

The convenience pair of `showAppDialog` for the single most repeated dialog:
title, one sentence, Confirm/Cancel.

- Returns **`Future<bool>` — never null**. The confirm button resolves `true`;
  the cancel button, the barrier, the "X" and Esc all resolve **`false`**. The
  caller writes `if (await showAppConfirm(...))` with no `== true` and no
  `?? false` — that normalization is the reason the function exists.
- **`destructive: true`** is a reading key, not a color: it turns the confirm
  button `danger` AND tints the illustration with the SAME accent (the
  `AppDialogContent.accentRole` contract). `confirmColor` overrides the role
  without dropping the semantics. The cancel button is always
  `outlined`/`neutral`.
- **Body**: pass `message` (the standard `AppDialogContent`, with an optional
  `illustration`) OR `content` (your own body — a list of items about to be
  deleted, a type-to-confirm input). Passing both, or neither, is a programming
  error (assert).
- **Width**: defaults to `maxWidth: 480` with **no floor** — unlike the 448/640
  of `showAppDialog`, whose 448 floor is meant for forms and overflows a 375px
  phone once the route's 64px side paddings are paid. A confirm is a sentence;
  the card hugs it.
- A double tap on either button produces a **single pop** (an
  `appRouteIsTopmost` guard) — the screen underneath never gets dismissed by the
  second tap.
- Everything else — motion (fade + reduce-motion), route focus, barrier,
  glass/style/radius — is inherited from `showAppDialog` untouched.

```dart
if (await showAppConfirm(
  context: context,
  title: 'Excluir empresa',
  message: 'Os usuários dela perdem o acesso. Não dá para desfazer.',
  confirmLabel: 'Excluir',
  destructive: true,
)) {
  await controller.remove(account.id);
}
```

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
