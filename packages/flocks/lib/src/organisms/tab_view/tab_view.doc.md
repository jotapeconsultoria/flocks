# AppTabView

Horizontal tabs with a **sliding indicator** and **lazily loaded** content.
`AppTabViewItem` describes each tab (a label + a content builder).

## When to use

- Switching between parallel sections of one context.

## When NOT to use

- A flow with an order or progress → `AppFormWizard`.
- The app's primary navigation → `AppNavigationRail`.

## Anatomy

- **Tab bar**: labels; the active tab is marked by an **indicator** that slides
  (animating through motion tokens, honoring reduce-motion).
- **Content**: `item.builder`, loaded on demand when `lazyLoadOnFirstOpen` (the
  default).

## Accessibility

The active tab is highlighted by a theme color (AA in light and dark). The
content enters the reading focus order.

## Example

```dart
AppTabView(
  items: <AppTabViewItem>[
    AppTabViewItem(label: 'Summary', builder: (_) => summary),
    AppTabViewItem(label: 'Details', builder: (_) => details),
  ],
);
```
