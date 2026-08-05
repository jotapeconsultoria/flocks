# AppMultiSelect

**Multi-selection** dropdown: chips for the selected items in the trigger; the
overlay marks them with a ✓ and **does not close** on selection.

## When to use

- Selecting several options among a few or a moderate number.

## When NOT to use

- Many options → `AppSearchableMultiSelect`.
- Single selection → `AppDropdown`.

## Anatomy

- **Trigger**: chips (a label + a ✕ to remove) or a hint + the animated chevron.
- **Overlay**: options with a ✓ on the selected ones; selecting keeps it open.
- It reuses the dropdown core (the same trigger, overlay and colors).

## Accessibility (Rule 8)

- Chips and options at AA contrast; accents in a legible stop. Validated across
  2 brands × 2 brightnesses.

## Example

```dart
AppMultiSelect<String>(options: opts, selectedValues: vs, onChanged: set)
```
