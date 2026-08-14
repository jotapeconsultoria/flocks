# AppBadge

The Flocks design system's compact status pill. It shows short text tinted by a
semantic color role: the text uses the role's full color over a background of
the same color at 10%, adapting to light/dark and to the brand. Sized by a named
step (`AppBadgeSize`). An optional `icon` (an `AppIconToken` slug) sits LEFT of
the label, painted with the same role color and sized to the label's line box —
it widens the pill but never changes its height, so the proportional radius
stays put. Read-only by default; optionally interactive through `onTap`
(mirroring `AppAvatar`).

## When to use

- A state or category label: alert status (Pending/Resolved), severity, a short
  tag beside a title.
- With `onTap`: an actionable filter or chip (toggling a list filter, say).

## When NOT to use

- As a primary action or CTA → use a button (molecule). The badge is a label pill.
- For notification counters overlaid on an icon → (not covered; use a dedicated
  overlay).

## Anatomy

- `label`: short text; the text role follows `size`.
- `color` (`AppBadgeColor`): `neutral` (default), `primary`, `info`, `success`,
  `warning`, `danger`. It resolves to the theme's role.
- `size` (`AppBadgeSize`): `s` (labelSmall, h8/v2), `m` (default — labelSmall,
  h8/v4), `l` (labelMedium, h12/v8), `xl` (labelLarge, h16/v12). `m` reproduces
  the historical look.
- Background = the role's color at 10% opacity; radius from the global radius
  (round mode), themeable and following the brand.
- `onTap` (optional): makes the pill interactive. `effect`
  (`none`/`scale`/`lift`, default `scale`) controls the hover/press
  micro-animation.

## Accessibility (Rule 8)

- Read-only: it exposes `label` as a single labelled node
  (`AppSemantics.label`), excluding the inner semantics so the text is not read
  twice.
- Interactive (`onTap`): it becomes a button role (`AppSemantics.button`),
  keyboard-activatable (Enter/Space), with a visible focus ring.
- Do not rely on color **alone** to convey meaning — the `label` carries the
  state in writing.

## Theme (Rule 9)

- Colors and shadows come 100% from the theme (semantic roles +
  `resolveStyleDecoration`); light/dark and brand diverge with no hardcoding.

## Motion (Rule 10)

- `scale`/`lift` and the lift shadow honor the global animation switch
  (`AppMotion`): under reduce-motion the scale stays at 1.0, but the state
  highlight and the focus ring remain.

## Do / Don't

- ✅ Pick the semantic role by meaning (warning = attention, danger = error).
- ✅ Keep the text short (1–2 words).
- ✅ Use `onTap` only when the pill stands for an action or a filter.
- ❌ Do not use it as a primary CTA; do not hardcode a color (use `AppBadgeColor`).

## Examples

```dart
AppBadge('Pending', color: AppBadgeColor.warning)
AppBadge('Assigned', color: AppBadgeColor.info)
AppBadge('Resolved') // neutral
AppBadge('Active', color: AppBadgeColor.info, onTap: _toggle) // interactive
```
