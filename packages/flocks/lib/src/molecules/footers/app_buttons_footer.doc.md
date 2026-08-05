# AppButtonsFooter

**Action** footer: a primary button and an optional secondary one.

## When to use

- The footer of a form, dialog or bottom sheet with 1–2 actions.

## When NOT to use

- A bottom navigation bar → `AppNavigationFooter`.
- A footer with no actions → `AppSimpleFooter`.

## Anatomy

- **Layout**: a `Row` (default) or a `Column` (`axis: Axis.vertical`);
  `alignment` controls the alignment (default `end`).
- **Surface** (`platform`): `desktop` = `surfaceContainer` (an elevated card),
  `mobile` = `surface`.
- **Rounding** (`style`): `card`/`dialog`/`sheet` round the bottom corners with
  the **global radius** (round mode); `page` does not round.
- **Safe area**: the bottom inset is added to the padding and the height.

## Accessibility (Rule 8)

- The semantics come from the child buttons (`AppButton`).

## Example

```dart
AppButtonsFooter(
  primary: AppButton(label: 'Save', onPressed: save),
  secondary: AppButton(style: AppStyle.outlined, label: 'Cancel', onPressed: cancel),
)
```
