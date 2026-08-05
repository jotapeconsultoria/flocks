# AppSearchableDropdown

Like `AppDropdown`, with a **search field** at the top of the overlay that
filters the options by text (focused automatically when it opens).

## When to use

- Choosing one option among **many** (a long list).

## When NOT to use

- Few options → `AppDropdown`.
- Several selections → `AppSearchableMultiSelect`.

## Anatomy

- The same trigger as `AppDropdown` + a **search field** (`EditableText`) at the
  top of the overlay; options filtered by `contains`; a "No results" empty state.

## Note

- The search field is a **simple filter** (`EditableText`), not a full form field
  — Rule 7's selection recipe is left to `AppInput`.

## Accessibility (Rule 8)

- Search takes focus when it opens; options at AA contrast; a legible accent.

## Example

```dart
AppSearchableDropdown<String>(
  options: opts, searchHintText: 'Search…', onChanged: set,
)
```
