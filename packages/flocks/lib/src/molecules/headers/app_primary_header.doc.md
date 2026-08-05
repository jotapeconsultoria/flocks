# AppPrimaryHeader

**Primary** header: a centered `child` + optional `leading` and `trailing`
slots, over `surface`.

## When to use

- The top of a page with a centered title and actions at the sides (back, menu).

## When NOT to use

- Just a `child`, with no slots → `AppSimpleHeader`.

## Anatomy

- **Row**: `leading` (a back `AppIconButton`, say) · `child` (`Expanded`,
  centered through `centerChild`) · `trailing` (an action).
- **Background**: `surface` (or the `decoration`'s color); the top **safe area**
  is added.
- **Padding**: defaults to `EdgeInsets.all(AppSpacings.s16)`.

## Migration

- The legacy `style` (`AppPrimaryHeaderStyle`) was **dead code** (the border and
  radius were commented out; 0 call sites) — **removed**.

## Accessibility (Rule 8)

- Marked as a header through `AppSemantics.header`.

## Example

```dart
AppPrimaryHeader(
  leading: AppIconButton(icon: AppIcon(AppIconToken.chevronLeft), onPressed: back),
  child: AppText('Details'),
)
```
