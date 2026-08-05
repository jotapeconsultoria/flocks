# AppListTile

The design system's list row, in **two styles** and with **orthogonal
variations**.

## Styles (`AppListTileStyle`)

- **grouped** (default): a `surfaceContainer` background — the focus is
  **actionable** (clicks).
- **bordered**: an `outline` border, no background — the focus is
  **informational**.

## Variations (named constructors)

- `AppListTile(...)` — generic: an optional custom `trailing` + `onTap`.
- `AppListTile.navigation(..., onTap)` — trailing = a chevron; tapping navigates.
- `AppListTile.checkbox(..., value, onChanged)` — tapping the row toggles it.
- `AppListTile.toggle(..., value, onChanged)` — a switch; tapping the row toggles
  it.
- `AppListTile.badge(..., badge, badgeColor, onTap)` — an `AppBadge` in the
  trailing.

All of them accept **`leading`** (an icon or avatar), **`subtitle`** and
**`reorderIndex`** (draggable — it adds a drag handle). For single selection use
`AppListTileRadio`.

## Anatomy and states

- Layout: `[drag handle?] [leading?]  title / subtitle  [trailing]`.
- Title in `onSurface` (strong); subtitle in `neutralPrimary.s700` (muted).
- Hover/press (`onSurface` 8%/12%) and a `focusRing` through
  `FlocksInteraction`; transitions through `AppMotion`; the global radius (round
  mode).
- Standalone, it draws its own container by `style`; inside an
  `AppListTileGroup`, the group draws the container and the dividers.

## Accessibility (Rule 8)

- `navigation`/`badge` carry a button role; `checkbox`/`toggle` do a
  `MergeSemantics` (title + control read together).
- Title and subtitle contrast validated across 2 brands × 2 brightnesses × 2
  surfaces.

## Tests

- No pixel golden when the leading is a network `AppIcon`; contrast by assertion.
  The "Examples" case (a text `AppAvatar` leading + a deterministic trailing) does
  have a golden.

## Example

```dart
AppListTileGroup(children: <Widget>[
  AppListTile.navigation(leading: AppIcon(AppIconToken.support), title: 'Support', onTap: open),
  AppListTile.toggle(title: 'Notifications', value: on, onChanged: setOn),
  AppListTile.badge(title: 'Alerts', badge: '5', badgeColor: AppBadgeColor.danger),
])
```
