# AppCheckbox

Multi-selection checkbox (check/uncheck). Rebuilt on `FlocksInteraction` — Tab
focus, Enter/Space activation, hover and a focus ring. The checkmark is drawn
by `CustomPaint`.

## When to use

- **Independent** options, where zero or more can be checked.

## When NOT to use

- A mutually exclusive single choice → use **AppRadio**.
- Immediately turning a setting on or off → use **AppSwitch**.

## Anatomy / states

The **semantic fill** (independent of style): checked = `primary` with the
checkmark in `onPrimary`; unchecked = no fill of its own (surface/ghost,
resolved by the style); disabled = a neutral dimmed by tone. Focus (keyboard) =
an outer ring in `primary`.

## Style (AppStyle)

It follows the global container axis (`theme.styleTheme.style`, overridable
through `style:`), like `AppAvatar`/`AppBadge` — **additive** over the state's
semantic fill:

- `filled` (the design system's default): checked = a `primary` box with no
  border; **empty = a neutral well (`neutralPrimary.s200`) with no border** —
  distinct from `surface`/`surfaceContainer` so it does not disappear over a
  card or a panel.
- `outlined`: checked = `primary` + a `primary` border; empty = transparent + an
  `outline` border — the classic bordered checkbox look.
- `elevated`: like `filled` + a symmetric shadow (`AppElevation`).

## Accessibility (Rule 8)

- `AppSemantics.toggle` exposes `checked`/`enabled`. `semanticLabel` is optional,
  for when there is no visible label beside it.
- Tab-navigable, activatable with Enter/Space (through `FlocksInteraction`).

## Example

```dart
AppCheckbox(
  checked: acceptedTerms,
  onChanged: (v) => setState(() => acceptedTerms = v),
  semanticLabel: 'Accept the terms',
)
```
