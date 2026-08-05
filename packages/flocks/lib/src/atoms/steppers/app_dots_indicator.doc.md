# AppDotsIndicator

Progress indicator in "dots" form: a row of circles where the current step takes
the accent color. Ideal for carousels and onboarding with few pages. For steps
with a title or icon, use **AppStepper**.

## When to use

- Showing the current position among 2–6 pages of a simple flow.

## When NOT to use

- Labelled steps (title/subtitle) → **AppStepper**.
- As a clickable navigation control.

## Anatomy / states

- **Active dot**: `theme.colorTheme.primary` (or `activeColor`), with a "pop".
- **Previous dot**: `primary` (or `completedColor`).
- **Upcoming dot**: `theme.colorTheme.neutralPrimary.s500` (or `inactiveColor`).
- The dots sit inside a **pill** (the container) that follows the style axis.

## Style (AppStyle)

The global container axis (`theme.styleTheme.style`, overridable through
`style:`) applies to the **pill** — additively, with the dots remaining the
content:

- `filled` (the design system's default): a `neutralPrimary.s100` background
  (the current look), no border.
- `outlined`: an `s100` background + an `outline` border.
- `elevated`: an `s100` background + a symmetric shadow (`AppElevation`).

## Shape (radius)

It follows the global radius (dots = circular mode; the pill = round mode).
`radiusMode` overrides the mode for this indicator alone (pill + dots); `radius`
is the pill's raw override. Square mode → square dots; anything else → a circle
(the dot is small and saturates).

## Interaction states

With `onStepTapped`, the tappable dots expose **focus (Tab), hover and click**: a
focus/hover ring (`focusRing`), a state overlay (`onSurface` — press 0.12 ›
hover/focus 0.08) and a slight scale on press — all motion-gated (`AppMotion`).

## Accessibility (Rule 8)

- `AppSemantics.status` exposes a live region labelled "Step X of Y", announced
  when it changes. The dots themselves are decorative.

## Example

```dart
AppDotsIndicator(currentStep: currentPage, totalSteps: pages.length)
```
