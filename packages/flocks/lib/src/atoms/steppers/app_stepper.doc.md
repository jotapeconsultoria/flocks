# AppStepper

Labelled step indicator for multi-step forms and wizards. It shows numbered
circles (or checked ones on completed steps) connected by progress lines, with a
title and subtitle per step. It supports horizontal and vertical orientation.
Completed steps can be tapped to go back.

## When to use

- Wizards and long forms split into named steps.

## When NOT to use

- Only the position among pages, with no labels → **AppDotsIndicator**.

## Anatomy / states

The circle's **semantic fill** (independent of style): reached
(completed/active) = `primary` (or `activeColor`/`completedColor`), with the
number in an on-color and a check when completed; upcoming = no fill of its own
(surface/ghost, resolved by the style) with the number in `neutralPrimary.s700`
and a neutral border (`s600`). **Line**: filled (`primary`) up to the current
step; empty (`s600`). **Labels**: the active title in `s900` (bold), the rest in
`s700`; subtitle `s700` (AA-legible floors over `surfaceContainer` in the dark).
Colors come only from **primary** (progress) + **neutral** — no
`secondary`/`tertiary`.

## Style (AppStyle)

The global container axis (`theme.styleTheme.style`, overridable through
`style:`) applies to each **circle** — the reached/upcoming duality is the same
mapping as the checkbox, additive over the semantic fill:

- `filled` (the design system's default): reached = a `primary` circle with no
  border; **upcoming = a `neutralPrimary.s200` well** (with the number), no
  border.
- `outlined`: reached = `primary` + a border; upcoming = transparent + an `s600`
  border — the classic bordered look.
- `elevated`: like `filled` + a symmetric shadow (`AppElevation`).

## Shape (radius)

The node follows the global radius (round mode), saturating into a circle.
`radiusMode` overrides the mode for this stepper alone; `radius` is the circle's
raw override. Square → a square · Round → soft corners · Circular → a circle.

## Interaction states

Tappable steps (`onStepTapped`) expose **focus (Tab), hover and click**: a
focus/hover ring (`focusRing`), a state overlay over the circle (`onSurface` —
press 0.12 › hover/focus 0.08) and a slight scale on press — all motion-gated
(`AppMotion`).

## Layout / scale

- **Horizontal**: each step takes a cell of equal width; the line is split into
  two halves inside the cell, so it **always meets the circle** and stays
  centered (vertically), regardless of the label (which centers below and
  ellipsizes when long).
- **Text scale (a11y)**: the node (circle + number/check + radius) **scales along
  with the `textScaler`**, preserving the padding. At scale 1.0 nothing changes.

Each step's data comes from `AppStepData(title, subtitle?, icon?)`.

## Motion (Rule 10)

- The color transitions and the number↔check swap use `AppMotion.resolve`
  (`AppDurations.medium`/`normal` + `AppCurves.standard`). Under reduce-motion
  the swap is instant.

## Accessibility (Rule 8)

- Each step is labelled "Step N: title, <state>". Completed steps are exposed as
  **buttons** (the go-back action) through `AppSemantics.button`; the rest as
  labels through `AppSemantics.label`.

## Example

```dart
AppStepper(
  currentStep: 1,
  onStepTapped: (i) => goToStep(i),
  steps: const [
    AppStepData(title: 'Details'),
    AppStepData(title: 'Trigger'),
    AppStepData(title: 'Actions'),
  ],
)
```
