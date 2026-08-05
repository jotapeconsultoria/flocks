# AppNumberStepper

Numeric **− value +** control with `min`/`max`/`step`. No free text editing (that
would be an organism / `AppInput`): only decrement, display and increment.

## When to use

- Small quantities with discrete steps (items, copies, minutes, zoom).

## When NOT to use

- Wide or free numeric input → a text field (`AppInput`, organism).
- Choosing from fixed options → `AppDropdown` / `AppSegmentedButton`.

## Anatomy / states

- **Container**: an `outline` border, the global radius (round mode), height from
  `size`.
- **− / +**: neutral `AppIconButton`s (dense). The **−** disables at `min`; the
  **+** at `max`. Touches honor `step`; the emitted value already arrives
  **clamped**.
- **Value**: a centered `AppText` (`onSurface`), with a minimum width so it does
  not "jump"; an optional `format` (currency/unit).
- **enabled=false**: it dims the value by tone and disables both buttons.

## Accessibility (Rule 8)

- The buttons are labelled ("Decrease" / "Increase") and disable at the limits.
- The value is a **status region** (`AppSemantics.status`) — screen readers
  announce the change.

## Motion

- No looping animation; the buttons' press-scale honors reduce-motion.

## Example

```dart
AppNumberStepper(
  value: quantity,
  min: 1,
  max: 99,
  onChanged: (v) => setState(() => quantity = v.toInt()),
)
```
