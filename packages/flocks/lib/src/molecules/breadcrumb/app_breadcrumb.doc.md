# AppBreadcrumb

Navigation trail: **clickable items** separated by ` / `, ending at the current
item.

## When to use

- Showing the current page's hierarchy and letting the user return to an
  ancestor level.

## When NOT to use

- Primary navigation between sections → a menu or navigation rail (organism).

## Anatomy

- **Clickable item**: `FlocksInteraction` (hover/press/Tab focus + Enter/Space).
  A **neutral** background highlight (`onSurface` 8%/12% — not the accent's hue,
  so it does not collide with the link text), a `focusRing`, the global radius
  (round mode), and a transition through `AppMotion`.
- **Link text**: a **legible stop** (≥ AA/4.5) of the accent color (`tertiary`),
  chosen against the press highlight (the extreme state) — the swatch's base does
  not guarantee contrast (RULES §5).
- **Current item** (`onTap` null): a strong `onSurface` ("you are here").
- **Separator** ` / `: the same legible accent.

## Accessibility (Rule 8)

- Clickable items with a button role (`AppSemantics.button`) + keyboard
  activation; text selection is disabled so it does not steal the click.
- Contrast validated across 2 brands × 2 brightnesses: the link ≥ AA against the
  surface and against the press highlight; the current item's `onSurface` ≥ AA.

## Tests

- No **pixel golden** (a textual trail depends on the host and the font — and the
  design system's standard is to validate color by assertion); contrast is
  checked in the test.

## Example

```dart
AppBreadcrumb(
  items: <AppBreadcrumbItem>[
    AppBreadcrumbItem(label: 'Home', onTap: goHome),
    AppBreadcrumbItem(label: 'Vehicles', onTap: goVehicles),
    AppBreadcrumbItem(label: 'Details'), // current
  ],
)
```
