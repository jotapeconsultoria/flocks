# AppRadio

Circular single-selection radio button (the generic `AppRadio<T>`). Rebuilt on
`FlocksInteraction` — Tab focus, Enter/Space activation, hover and a focus ring.

## When to use

- Choosing **one** option among several mutually exclusive ones.

## When NOT to use

- Multiple selections → use **AppCheckbox**.
- Turning a single option on or off → use **AppSwitch**.

## Anatomy / states

The **semantic fill** (independent of style): selected (`value == groupValue`) =
`primary` with the dot in `onPrimary`; unselected = no fill of its own
(surface/ghost, resolved by the style); disabled = a neutral dimmed by tone.
Focus (keyboard) = an outer ring in `primary`.

## Style (AppStyle)

It follows the global container axis (`theme.styleTheme.style`, overridable
through `style:`), like `AppAvatar`/`AppBadge` — **additive** over the state's
semantic fill:

- `filled` (the design system's default): selected = a `primary` circle with no
  border; **empty = a neutral well (`neutralPrimary.s200`) with no border** —
  distinct from `surface`/`surfaceContainer` so it does not disappear over a card
  or a panel.
- `outlined`: selected = `primary` + a `primary` border; empty = transparent + an
  `outline` border — the classic bordered radio look.
- `elevated`: like `filled` + a symmetric shadow (`AppElevation`).

## Accessibility (Rule 8)

- `AppSemantics.toggle(mutuallyExclusive: true)` → exposes `checked` and the
  mutually exclusive group. `semanticLabel` is optional.
- Tab-navigable, activatable with Enter/Space (through `FlocksInteraction`).

## Example

```dart
AppRadio<Plan>(
  value: Plan.basic,
  groupValue: selected,
  onChanged: (v) => setState(() => selected = v),
)
```
