# AppNavigationRail & friends

The design system's collapsible side menu. Four pieces:

| Widget | Role |
| --- | --- |
| `AppNavigationRail` | The rail: logo + items + expandable parent items, toggling between narrow and wide. |
| `AppNavigationRailItem` | The clickable row (icon + title, with states). |
| `AppNavigationRailFilter` | The **scope** row (account/group/client): it opens a picker and shows the current value, or `emptyLabel` when there is no filter. |
| `AppNavigationRailProfile` | The identity footer (avatar + name + role). |

`AppNavigationRailFilter` looks like an item but **does not navigate**: it
narrows what the rest of the app shows. That is why the "filled" highlight
differs from an item's "selected" highlight — two states that coexist in the same
column and must not be confused.

## When to use

- Primary side navigation for the backoffice/desktop.

## When NOT to use

- Horizontal tabs within a section → `AppTabView`.
- Bottom navigation on mobile → `AppNavigationFooter`.

## Anatomy

- **Logo**: `logoCollapsed`/`logoExpanded` (icons) at the top.
- **Items** (`AppNavigationRailItemData`): an icon + a title; items with
  `children` become an **expandable parent** (an animated chevron, push-down).
- **Filters** (`AppNavigationRailFilter`): a fixed label + the current value.
  With no value it shows `emptyLabel` ("All"), which is a neutral state rather
  than an empty one — the user needs to know they are seeing everything, not that
  they forgot to choose.
- **Footer** (`AppNavigationRailProfile`): it goes in the `footer` slot.
  Collapsed, it reduces to the avatar.
- **States**: selected (a tinted `secondary` pill), hover (a light tint). In
  **collapsed** mode, the title appears through an **`AppTooltip`** (no Material).
- **Collapse/expand transition**: width 81↔288 with motion tokens
  (`AppDurations.medium`/`AppCurves.standard`), honoring reduce-motion.

## Migration notes

- The dependency on Material's `Tooltip` was removed → `AppTooltip`.
- `AppColors.transparent`/`AppColors.brandPrimary` → theme tokens
  (`colorTheme.transparent`/`colorTheme.primary`).
- Durations and curves run through `AppMotion.resolve` (reduce-motion).

## Accessibility

Clickable items carry `Semantics(button: true, label:)`; collapsed ones expose
the title through a tooltip. The colors (`secondary`/`tertiary`) pass WCAG AA in
light and dark.

## Example

```dart
AppNavigationRail(
  items: items,
  logoCollapsed: AppIconToken.infoCircle,
  getCurrentRoute: (context) => router.location,
);
```
