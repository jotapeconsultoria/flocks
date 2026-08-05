# AppTooltip

Text balloon shown when the mouse hovers over the `child`. It renders through the
`Overlay` (so a parent container can never clip it) and anchors to the target
through `LayerLink`/`CompositedTransformFollower` — keeping the right position
even under transforms (zoom, centering). The theme is captured and re-provided
inside the overlay, so it works in any host.

## When to use

- Short help or refinement labels on icons and compact actions (desktop/web,
  where there is a mouse).

## When NOT to use

- Essential content that has to stay visible (a tooltip only appears on hover;
  there is no touch equivalent).
- Long or interactive text → prefer a popover or a sheet.

## Anatomy / states

- **Balloon**: a `tertiary.s800` background, `neutralWhite` text, the global
  radius (round mode), padding according to `size`.
- **Size** (`size`): it varies the **font** — `small` (`bodySmall`, 12) ·
  `medium` (`bodyMedium`, 14, the default) · `large` (`bodyLarge`, 16). The
  padding is constant (medium).
- **Position** (`position`): `top` (default) / `bottom` / `left` / `right`,
  centered on the target, with a gap.
- **maxWidth**: when set, the text wraps across several lines; when `null`, the
  balloon stays on one line (the text's width).
- **enabled=false** or an empty `message` → it does not show.

## Accessibility (Rule 8)

- The tooltip is a visual hover hint (not focusable). For screen readers, make
  sure the `child` already has a semantic label of its own (a `semanticLabel` on
  the `AppIcon`, say), because the balloon itself is not announced.

## Motion

- The balloon is static (no entrance animation) — nothing to collapse under
  reduce-motion.

## Example

```dart
AppTooltip(
  message: 'Previous month',
  child: AppIcon(AppIconToken.chevronLeft, semanticLabel: 'Previous month'),
)
```
