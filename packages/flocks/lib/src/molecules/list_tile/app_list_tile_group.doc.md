# AppListTileGroup

Groups several `AppListTile` / `AppListTileRadio` into a single **card**.

## When to use

- Stacking related list rows (a menu, a selection, a short list).

## When NOT to use

- A standalone row → use `AppListTile` directly (it draws its own container
  according to `style`).

## Anatomy

- **grouped**: a `surfaceContainer` background; **bordered**: an `outline` border.
- Corners from the global radius (round mode) (through `ClipRRect`); `outline`
  **dividers** between the rows (never after the last one).
- It tells the child tiles (through an inherited scope) that it draws the
  container — each tile renders only the **row** (with no container or divider of
  its own).

## Accessibility (Rule 8)

- A visual container; the semantics come from the tiles. Background, border and
  divider follow the contrast contract in light and dark across both brands.

## Example

```dart
AppListTileGroup(children: <Widget>[
  AppListTile.navigation(title: 'Support', onTap: openSupport),
  AppListTile.navigation(title: 'Sign out', onTap: logout),
])
```
