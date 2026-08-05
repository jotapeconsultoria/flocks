# AppListEmpty

A list or table's empty state: **illustration + message + optional action**.

## When to use

- A list or table with no items: empty, or with no results after a filter.

## When NOT to use

- A load error → a dedicated error state.
- Loading → `AppShimmerLoading` / `AppCircularLoading`.

## Anatomy

- A centered **illustration** (`AppIllustration`, size `m`) — it adapts to
  light/dark.
- A centered **message** (`bodyLarge`, `onSurface`).
- **Optional action**: when `onClearFilter != null`, a secondary "Clear"
  `AppTextButton` (fixed width `AppSizes.s128`).

## Accessibility (Rule 8)

- The message in `onSurface` over the `surface` (the contract's AA pair).
- The illustration is decorative; the message carries the meaning.

## Tests

- No **pixel golden** (the illustration is a network SVG through
  `cache_manager`); the message's contrast is validated by assertion across 2
  brands × 2 brightnesses.

## Example

```dart
AppListEmpty(
  illustration: AppIllustrations.empty,
  text: 'No results found.',
  onClearFilter: clearFilters,
)
```
