# AppSimpleFooter

**Simple** footer: a band over `surface` wrapping one `child`.

## When to use

- A free-form footer: copyright, a note, a total.

## When NOT to use

- Actions → `AppButtonsFooter`. Navigation → `AppNavigationFooter`.

## Anatomy

- **Background**: `surface` (or the `decoration`'s color).
- **Safe area**: the bottom inset is added to the height and padding.

## Example

```dart
AppSimpleFooter(child: AppText('© 2026'))
```
