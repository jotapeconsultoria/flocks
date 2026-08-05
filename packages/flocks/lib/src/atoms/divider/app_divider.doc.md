# AppDivider

Thin rule that separates content in the Flocks design system. It draws a
hairline whose color comes from the theme (`outline` by default), adapting to
light/dark and to the brand.

## When to use

- Separating sections of a list or column (horizontal), or items in a bar
  (vertical).

## When NOT to use

- As a container's frame or border → use `BoxDecoration.border` on the container
  itself.
- For pure spacing (no visible line) → use `SizedBox`/`AppSpacings`.

## Anatomy

- **Horizontal** (default): fills the width of a width-bounded parent.
- **Vertical** (`AppDivider.vertical`): fills the height of a height-bounded
  parent — use it between the items of a `Row`.
- `thickness` comes from `AppStrokes` (default `s` = 1.0); `indent`/`endIndent`
  inset the line along its main axis.
- Default color: `theme.colorTheme.outline` (contrast ≥ 3:1 / ΔT ≥ 40 against
  the surface — Rule 8).
- `radius` (default: the global radius, round mode) rounds the end caps
  following the **themeable global radius** (clamped to the thickness — visible
  on thick rules).

## Accessibility (Rule 8)

- It is **decorative**: excluded from the semantics tree
  (`AppSemantics.decorative`), never read by screen readers.

## Do / Don't

- ✅ Let the color come from the theme (`outline`).
- ✅ Use `AppDivider.vertical` inside a `Row` with a bounded height.
- ❌ Do not hardcode a color; do not use it as a card border.

## Examples

```dart
Column(
  children: <Widget>[
    AppText('Above'),
    AppDivider(indent: 8, endIndent: 8),
    AppText('Below'),
  ],
)

// Between the items of a bar:
Row(
  children: <Widget>[
    AppText('A'),
    SizedBox(height: 16, child: AppDivider.vertical()),
    AppText('B'),
  ],
)
```
