# AppSnackbar

**Temporary feedback** card (success, error, info) with a title, a description
and a semantic icon. It is only the card — to show it (bottom-right corner,
auto-dismiss) use **`showAppSnackbar`**.

## When to use

- Confirming a quick action (saved, deleted) without blocking the flow.
- Warning about a transient operation error.

## When NOT to use

- Feedback that requires acknowledgement or an action → `AppDialog`.
- A persistent inline notice on the page → `AppAlert`.

## Anatomy

- **Card**: `surfaceContainer` tinted (10%) by the `type`'s color, following the
  `AppStyle` axis (default `elevated` — a shadow; `outlined` = a semantic
  border). Radius from the global axis. `maxWidth` 384.
- **Title** (`titleMedium`/`onSurface`): 1 line.
- **Description** (`bodyMedium`/`neutralPrimary.s700`): up to 3 lines.
- **Icon** (`type`, on the right): a semantic color legible against the tinted
  background.

## Showing it (`showAppSnackbar`)

- Bottom-right corner, a **single instance** (a new one replaces the previous),
  auto-dismissing after `duration` (3 s by default). It delegates to
  `showAppOverlay` (a slide-in with no Material, honoring reduce-motion).

## Types (`AppSnackbarType`)

`error` (red) · `info` (blue) · `success` (green) — each one resolves to the
theme's token (`danger`/`info`/`success`).

## Accessibility

Wrapped in `AppSemantics.liveRegion` → announced when it appears. Title,
description and icon pass WCAG AA in light and dark across both brands.

## Example

```dart
showAppSnackbar(
  context: context,
  title: 'Saved',
  description: 'Your changes have been applied.',
  type: AppSnackbarType.success,
);
```
