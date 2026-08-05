# AppNavigationFooter

**Bottom navigation** bar: icon+title items, with the current route's item
highlighted.

## When to use

- Primary navigation on mobile (3–5 destinations).

## When NOT to use

- Form actions → `AppButtonsFooter`.
- Many destinations → a menu.

## Anatomy

- **Items** (`AppNavigationFooterItemData`): an icon + an optional title; each
  one on `FlocksInteraction` (hover/press/Tab focus + a neutral highlight).
- **Active**: a **legible stop** (≥ 3:1) of the `secondary` accent;
  **inactive**: a legible neutral (`neutralPrimary.s600` — the legacy used
  `s300`, far too faint).
- **Current route**: `getCurrentRoute` decides which item is active.
- **Safe area**: the bottom inset is added to the height.

## Accessibility (Rule 8)

- Each item carries a button role (`AppSemantics.button`).
- Active/inactive contrast ≥ 3:1 against the surface, validated across 2 brands ×
  2 brightnesses.

## Tests

- No **pixel golden** (the icons are network `AppIcon`s); contrast by assertion.

## Example

```dart
AppNavigationFooter(
  getCurrentRoute: (context) => currentRoute,
  items: <AppNavigationFooterItemData>[
    AppNavigationFooterItemData(icon: AppIconToken.dashboard, title: 'Home',
      route: '/home', onPressed: (c, r) => go(r)),
    // ...
  ],
)
```
