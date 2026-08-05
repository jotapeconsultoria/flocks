# AppSimpleHeader

**Simple** page header: a band over `surface` wrapping one `child`.

## When to use

- The top of a page with free content (a title, a search field).

## When NOT to use

- You need leading/child/trailing → `AppPrimaryHeader`.

## Anatomy

- **Background**: `surface` (or the `decoration`'s color).
- **Safe area**: the top inset is added to the height and the top padding.
- **Padding**: defaults to `EdgeInsets.all(AppSpacings.s16)`.

## Accessibility (Rule 8)

- Marked as a header through `AppSemantics.header`; the meaning comes from the
  `child`.

## Example

```dart
AppSimpleHeader(child: AppText('Title'))
```
