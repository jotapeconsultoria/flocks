# AppDropdown

**Single-selection** dropdown: a trigger field that opens an options overlay.

## When to use

- Choosing one option among a few or a moderate number (up to ~15).

## When NOT to use

- Many options → `AppSearchableDropdown`.
- Several selections → `AppMultiSelect`.

## Anatomy and states

- **Trigger**: a label + a bordered field (`outline` / `primary` when open /
  `danger` on error) + the value or hint + an **animated chevron**
  (`AppAnimatedRotation` through `AppMotion`). Tab-focusable
  (`FlocksInteraction`); Enter/Space opens it.
- **Overlay**: an `AppOverlayPanel` with the options (it follows the global glass
  axis); a neutral hover, a ✓ on the selected one (the accent in a legible stop).
  Choosing closes the overlay.
- **Radius**: the global radius (round mode).

## Accessibility (Rule 8)

- The accents (border/icon/✓) resolve to a legible stop ≥ 3:1; the error in a
  legible `danger`; the hint in a neutral. Colors validated across 2 brands × 2
  brightnesses.

## Tests

- No pixel golden (the chevron is a network `AppIcon`); contrast by assertion.

## Example

```dart
AppDropdown<String>(
  label: 'Fruit',
  options: <AppDropdownOption<String>>[AppDropdownOption(value: 'b', label: 'Banana')],
  selectedValue: v, onChanged: (nv) => setState(() => v = nv),
)
```
