# AppSnackbar

**Temporary feedback** card (success, error, info, warning) with a description,
an optional title and a semantic icon. It is only the card — to show it
(auto-dismiss, bottom-right by default) use **`showAppSnackbar`**.

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
- **Title** (`titleMedium`/`onSurface`): 1 line, optional. With no title the
  card is the one-line toast: the title row and its breathing room disappear
  and the icon centers vertically with the message.
- **Description** (`bodyMedium`): up to 3 lines. With a title it uses
  `neutralPrimary.s700`; title-less it IS the card's content and uses
  `onSurface` — hierarchy follows the role, the background contrast holds
  either way.
- **Icon** (`type`, on the right): a semantic color legible against the tinted
  background.

## Showing it (`showAppSnackbar`)

- A **single instance** (a new one replaces the previous), auto-dismissing
  after `duration` (3 s by default). It delegates to `showAppOverlay` (a
  slide-in with no Material, honoring reduce-motion).
- `position` picks the corner (`AppOverlayPosition`, `bottomRight` by
  default) — mobile screens usually want `bottomCenter`.

## Types (`AppSnackbarType`)

`error` (red) · `info` (blue) · `success` (green) · `warning` (amber) — each
one resolves to the theme's token (`danger`/`info`/`success`/`warning`), with
the same amber and alert icon `AppAlert` uses. `type` defaults to `info`;
an error message MUST pass `error` explicitly — color and icon are the only
signal that something failed.

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

// The one-line toast most screens want:
showAppSnackbar(context: context, description: 'Link copied.');
```
