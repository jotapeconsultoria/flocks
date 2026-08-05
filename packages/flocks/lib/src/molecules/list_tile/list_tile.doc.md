# AppListTileAction · AppListTileCheckbox · AppListTileDraggableCheckbox

> **Superseded by [`AppListTile`](app_list_tile.doc.md).** The 2026-07-06
> restructuring unified the family into a single component with named
> constructors (`.navigation` / `.checkbox` / `.toggle` / `.badge`) plus
> `reorderIndex`. These three remain because `tracked_shared_pkg` re-exports them
> and the apps still consume them — shared's `AppListTile` is still the legacy
> implementation, so those call sites **cannot reach** the new constructors until
> that shim is written. **Do not use them in new code.**

| Legacy | New equivalent |
| --- | --- |
| `AppListTileAction(title:, text:, trailing:, onPressed:)` | `AppListTile(title:, subtitle:, trailing:, onTap:)` |
| `AppListTileCheckbox(title:, text:, checked:, onChanged:)` | `AppListTile.checkbox(title:, subtitle:, value:, onChanged:)` |
| `AppListTileDraggableCheckbox(…, reorderIndex:)` | `AppListTile.checkbox(…, reorderIndex:)` |

## The difference that survives the translation

In all three legacy tiles the pair of texts has **inverted emphasis**: `title` is
the small, dimmed label **on top**, `text` is the strong value **below** — the
same reading as [`AppTileInfo`](app_tile_info.doc.md), which exists precisely for
label/value pairs.

The new `AppListTile` uses the opposite convention (a strong title on top, a
dimmed subtitle below), which is the settings-row one. Translating one into the
other **swaps which of the two texts carries the weight** — it is the migration's
only real visual change, and it is why this is not a find-and-replace.

## AppListTileAction

A clickable row with a label/value pair and an arbitrary `trailing`. It was born
on mobile's filter screen ("VEHICLES / 3 selected" + a swap icon): the `trailing`
is free because there it is not a chevron, it is the action's icon.

## AppListTileCheckbox

The same row, with a checkbox at the end. Tapping **the whole row** toggles it —
the target is the row, not the 20px box.

## AppListTileDraggableCheckbox

The previous one plus a drag handle (`ReorderableDragStartListener`) for use
inside a `ReorderableListView`. It is the row of the export and column-settings
dialogs: choosing **which** columns and in **what order** is the same task, so it
is the same control.

`reorderEnabled: false` keeps the row but removes the handle — for a list that
can be checked but not reordered.

## Accessibility

All three disable text selection in the content
(`SelectionContainer.disabled`): with selectable text, dragging over the row
selects instead of activating — and, in the handle variant, instead of
reordering.

## Example

```dart
// New code: use AppListTile.
AppListTile.checkbox(
  title: 'Plate',
  value: column.visible,
  reorderIndex: index,
  onChanged: (bool v) => toggle(column, v),
);
```
