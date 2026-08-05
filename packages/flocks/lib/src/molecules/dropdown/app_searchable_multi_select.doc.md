# AppSearchableMultiSelect

Like `AppMultiSelect`, with a **search field** at the top of the overlay;
selecting **does not close** it.

## When to use

- Selecting several options among **many** (a long list).

## When NOT to use

- Few options → `AppMultiSelect`.
- Single selection → `AppSearchableDropdown`.

## Anatomy

- A trigger with chips (a ✕ to remove) + a **search field** (`EditableText`) at
  the top of the overlay; filtered options with a ✓ on the selected ones; it
  stays open.

## Accessibility (Rule 8)

- Search takes focus when it opens; chips and options at AA contrast.

## Example

```dart
AppSearchableMultiSelect<String>(
  options: opts, selectedValues: vs, onChanged: set,
)
```
