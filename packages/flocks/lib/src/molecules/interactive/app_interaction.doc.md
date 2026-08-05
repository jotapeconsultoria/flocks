# AppInteraction

Flocks' interaction wrapper — like Material's `InkWell`, but over the `widgets`
layer and driven by tokens. It wraps **any** widget (an icon, some text, a card)
and applies the standard click/hover/focus behavior. It is the replacement for
the old `AppTextButton`/`AppIconButton`.

## When to use

- Making an icon, text or card clickable with standard hover/press/tooltip (the
  behavior of bar icons: hover shows a highlight + tooltip, a click animates).
- "Clickable text" / "clickable icon" — the color and the size come from the
  `child` itself (an `AppText`/`AppIcon` in the role's color).

## When NOT to use

- A primary action with a background and a label (Save, Send) → use
  **`AppButton`**.
- Only a micro-animation, with no click → use
  `AppInteractiveMotion`/`AppScaleOnTap`.

## Anatomy

- **Gestures**: `onTap`, `onDoubleTap`, `onLongPress` (through
  `FlocksInteraction`).
- **States**: hover, focus (Tab → a focus ring), press, disabled + keyboard
  activation (Enter/Space) and a click cursor.
- **Highlight** (`highlight`): a translucent `onSurface` overlay on hover (8%) /
  press (12%), with `radius`'s radius (defaulting to the **global radius**, round
  mode).
- **Motion** (`motion`, `AppMotionPreset`): `none` / `scale` (it shrinks on
  press) / `lift` (it grows on hover). It runs through `AppMotion` → honoring the
  **global animation toggle** and the OS's reduce-motion.
- **Loading** (`loading`): it blocks interaction and overlays a spinner on the
  `child` (rendered invisible → no layout jump).
- **Disabled** (`enabled: false`): it dims the `child`.
- **Tooltip** (`tooltip`): optional; it shows an `AppTooltip` on hover/focus.
- **`padding`**: give it room for the feel of an icon button.

## Accessibility (Rule 8)

- It applies a button role (`AppSemantics.button`) with a `semanticLabel` (and
  the `loading` state).
- Enter/Space fire `onTap` when focused; the focus ring appears on the highlight
  (desktop/keyboard) and disappears on touch.

## Do / Don't

- ✅ Give icons and text a standard click, hover and tooltip.
- ✅ Add `padding` so the highlight can breathe around icons.
- ❌ Do not use it as a primary action button with a background and a label (use
  `AppButton`).

## Examples

```dart
// A bar icon, as in the chat: hover shows a highlight + tooltip; a click animates.
AppInteraction(
  tooltip: 'Add',
  onTap: add,
  padding: const EdgeInsets.all(AppSpacings.s8),
  child: AppIcon(AppIconToken.plus),
)

// Clickable text with a double click, no highlight, growing on hover.
AppInteraction(
  onTap: open,
  onDoubleTap: edit,
  highlight: false,
  motion: AppMotionPreset.lift,
  child: AppText('Open'),
)
```
