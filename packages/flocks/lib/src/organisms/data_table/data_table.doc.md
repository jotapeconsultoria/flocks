# AppDataTable & AppSimpleDataTable

The design system's data grids. **`AppDataTable`** is the rich grid (pagination +
per-column sorting + row actions) used in the backoffice listings;
**`AppSimpleDataTable`** is the static grid (header + rows), with no pagination
or sorting.

## When to use

- **AppDataTable**: paginated listings (CRUDs) with sorting and row actions.
- **AppSimpleDataTable**: short, static blocks with a header.

## Anatomy (AppDataTable)

- **Header**: labelled columns; clicking cycles the sort (none→desc→asc), with an
  **`AppTooltip`** describing the next state (no Material).
- **Body**: rows of widgets (`List<List<Widget>>`); click, right-click and row
  selection (`selectedRowIndex`).
- **Footer**: pagination (page/perPage/total) — **server-side** in the consumers.
- Rounded corners (`AppRadius.l`) at the top (header) and the bottom (footer).

## Migration notes

- The dependency on Material's `Tooltip` was removed → `AppTooltip`.
- Colors are already 100% from the theme (`surface`/`onSurface`/`outline`).
- Pagination is the server's (16/page by default); the component only renders it.

## Accessibility

The sort tooltips describe the action; `AppSimpleDataTable`'s text is selectable
(`AppSelectionRegion`). The colors pass WCAG AA in light and dark.

## Example

```dart
AppDataTable(
  columnLabels: const ['Plate', 'Model'],
  rows: rows,
  page: page, perPage: 16, total: total, totalPages: pages,
  onPageChange: cubit.setPage,
  onPerPageChange: cubit.setPerPage,
);
```

## `AppSimpleDataTable.columnFlex`

Per-column flex factors (e.g. `[2.2, 1, 1]`) for the simple grid. `null` keeps
the uniform split of always. Factors must be > 0 and match `columnLabels` in
length (asserted). In an unbounded-width context (the table goes intrinsic)
the factor only splits the leftover space — with `null`, nothing changes.
Unlike `AppDataTable.columnWidths` (pixels), this is a proportion — the two
APIs stay deliberately apart.
