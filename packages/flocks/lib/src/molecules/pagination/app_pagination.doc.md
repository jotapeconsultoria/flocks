# AppPagination

Standalone **page** navigation (decoupled from any table): a `‹` previous +
numbers with an ellipsis (`1 … 5 [6] 7 … 20`) + a `›` next, with an optional
"items per page" selector.

## When to use

- Paginating a large list or table (in the footer) with direct navigation by
  number.

## When NOT to use

- Infinite scrolling / "load more" → a different pattern.
- A few items that fit on one page → do not paginate.

## Anatomy / states

- **Previous / Next**: neutral `AppIconButton`s; they disable at the ends.
- **Current page**: a filled pill (`readableStopOn(primary, surface)` +
  `onColorFor`), marked as selected.
- **Other pages**: ghosts (`onSurface`) with a neutral hover highlight.
- **Ellipsis** (`…`): it replaces gaps; a gap of **one** page becomes that page
  (it never hides a single one).
- **siblingCount** / **boundaryCount**: how many pages around the current one and
  at each end. When everything fits, it shows them all (no ellipsis).
- **perPage** (`AppPaginationPerPage`): a label + an `AppDropdown` of items per
  page.

## Accessibility (Rule 8)

- Each number is a "Page N" button; the current one is `selected`. Previous and
  Next carry labels and disable at the limits.
- The truncation is a **pure function** (`paginationRange`) — testable in
  isolation.

## Motion

- Only the hover/press highlight; it honors reduce-motion.

## Example

```dart
AppPagination(
  currentPage: page,
  pageCount: totalPages,
  onPageChanged: (p) => setState(() => page = p),
  perPage: AppPaginationPerPage(
    value: perPage,
    options: const <int>[10, 20, 50],
    onChanged: (v) => setState(() => perPage = v),
  ),
)
```
