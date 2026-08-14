# AppTileInfo

**Label/value** pair (not clickable): the label on top, the value below.

## When to use

- Showing a `label/value` field on detail screens.

## When NOT to use

- A clickable row → `AppListTile` / `AppListTileAction`.

## Anatomy

- **Label**: `titleSmall`, a legible neutral (`neutralPrimary.s700`).
- **Value**: `bodyLarge`, `onSurface`.

## Accessibility

- Label and value at AA contrast against the surface (2 brands × 2 brightnesses).

## Example

```dart
AppTileInfo(title: 'Identifier', text: 'TTS4G47')
```

## Layout & icon

`layout: vertical` (default) stacks label over value — the tree of always.
`layout: horizontal` is the record row: label (with its optional `icon`, same
muted color, `AppIconSize.s`) on the left, value taking the remaining width —
no magic widths at the call site. `textAlign` keeps applying to both texts.
