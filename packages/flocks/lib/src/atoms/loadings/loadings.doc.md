# Loadings

The design system's family of loading indicators. All of them honor
reduce-motion (they go static when the user turns animations off) and read their
colors from the theme.

## Components

| Widget | Use |
|---|---|
| **AppCircularLoading** | A ring — an indeterminate spinner **or** a determinate arc (`value` 0..1). |
| **AppLinearLoading** | A bar — indeterminate **or** a determinate fill (`value` 0..1). |
| **AppBorderProgress** | A progress border around a child — controlled (`progress`) or on a timer (`duration`). |
| **AppOverlayLoading** | An overlay (barrier + indicator) over a child while it loads. |
| **AppShimmerLoading** | A skeleton placeholder with a sheen, while the data arrives. |

## When to use each

- **Indeterminate, small** → `AppCircularLoading`.
- **Indeterminate, at the top of a section** → `AppLinearLoading`.
- **Known progress / a countdown** → `AppBorderProgress`.
- **Blocking an area while keeping the content** → `AppOverlayLoading`.
- **Anticipating the content's layout** (cards, rows) → `AppShimmerLoading`.

## Progress and colors

- **Determinate**: `AppCircularLoading`/`AppLinearLoading` accept `value`
  (0..1) — with no `value` they are indeterminate (animated); with a `value`
  they draw a static arc or bar. `AppBorderProgress` uses `progress` (0..1).
- **Colors (defaults)** for
  `AppCircularLoading`/`AppLinearLoading`/`AppBorderProgress`: fill = `focusRing`
  (the primary accent resolved to hold ≥ 3:1 against the surface — the base
  `primary` disappeared in the dark); track = `surfaceContainer` (a perceptible
  tone step). The fill/track/surface contrast is locked per brand × brightness in
  `test/src/atoms/loadings/loadings_contrast_test.dart`.
- **End caps** follow the global radius: square mode → square; round → round.

## Accessibility (Rule 8)

The indicators are **visual**. When the loading state has to be announced to
screen readers, wrap the indicator (or the area it covers) in
`AppSemantics.liveRegion` with a label:

```dart
AppSemantics.liveRegion(
  Semantics(label: 'Loading…', child: const AppCircularLoading()),
)
```

## Motion (Rule 10)

Every animation runs through `AppMotion`. Under reduce-motion:
`AppCircularLoading`/`AppLinearLoading` go static, `AppShimmerLoading` shows the
base box with no sheen, and `AppBorderProgress` (auto mode) jumps straight to
the final state.

## Radius

`AppShimmerLoading` uses the global radius (round mode) by default (when
`borderRadius` is `null`), following the global rounding configuration.
