# AppSurface

Flocks' themeable base container — the surface content rests on (cards, panels,
menus, sheets). It standardizes the ubiquitous
`DecoratedBox`/`Container` pattern of a surface color + radius (+ border),
reading all of it from the theme.

## When to use

- Any elevated or bounded box that groups content: a card, a side panel, a menu
  item, the body of a sheet or dialog.

## When NOT to use

- Spacing or grouping alone with no background → use `Padding`/`Column`.
- A clickable target → compose it with `AppInteractive` on the outside.

## Anatomy

- **Elevation by TONE, not by shadow** (the design system's contrast philosophy
  — "to elevate is to lighten"):
  - `flat` → `colorTheme.surface` (the page's level).
  - `raised` → `colorTheme.surfaceContainer` (one tone step above; ΔT ≥ 12 in
    light / ≥ 24 in dark, guaranteed by the token).
  - `bordered` → `surface` + a `colorTheme.outline` border (`AppStrokes.s`).
- `radius` defaults to the global radius (round mode); `padding` is internal;
  `clip` clips the content to the radius (default `antiAlias`).

## Accessibility (Rule 8)

- Semantically neutral: it passes the `child` through (the content carries its
  own role). The tone separation of `raised`/`bordered` already satisfies UI
  contrast.

## Do / Don't

- ✅ Use `raised` to elevate; let the color come from the theme.
- ✅ Compose cards, menus and sheets on `AppSurface` instead of repainting boxes.
- ❌ Do not add a `boxShadow` to elevate — raise the `variant`.

## Examples

```dart
AppSurface(
  variant: AppSurfaceVariant.raised,
  padding: const EdgeInsets.all(AppSpacings.s16),
  child: AppText('Card content'),
)

AppSurface(
  variant: AppSurfaceVariant.bordered,
  radius: theme.radiusTheme.resolve(),
  child: content,
)
```
