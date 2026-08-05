# AppListTileRadio

List row with a **radio** (single selection within a group). Tapping the row
selects `value`. Generic `AppListTileRadio<T>`.

## When to use

- Choosing **one** option among several, in a list.

## When NOT to use

- Multiple selection → `AppListTile.checkbox`.
- On/off → `AppListTile.toggle`.

## Anatomy

- The same scaffold and variations as `AppListTile`:
  `leading`/`subtitle`/`style`/`reorderIndex`. Trailing = `AppRadio`. Group them
  with `AppListTileGroup`.

## Note

- It is a class of its own (not a named constructor of `AppListTile`) because a
  named constructor cannot introduce the type `<T>` — the same reason as
  Flutter's `RadioListTile<T>`.

## Accessibility (Rule 8)

- `AppRadio` exposes the exclusive group; a `MergeSemantics` with the title; AA
  contrast.

## Example

```dart
AppListTileGroup(children: <Widget>[
  AppListTileRadio<String>(title: 'Hub 01', value: 'a', groupValue: sel, onChanged: pick),
  AppListTileRadio<String>(title: 'Hub 02', value: 'b', groupValue: sel, onChanged: pick),
])
```
