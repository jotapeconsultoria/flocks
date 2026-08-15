# AppChoiceChip & AppChoiceChipBar

The **selectable** chip the package was missing, and the scrollable bar that
rows it up. `AppFilterChip` shows a filter already applied (with its "×");
`AppSuggestionChip` invites an action; **`AppChoiceChip`** answers "which of
these is in effect right now" — one target under TOGGLE semantics
(`checked`/`inMutuallyExclusiveGroup`), not a button. **`AppChoiceChipBar`**
is the filter bar: single or multiple selection over a typed list of options.

## When to use

- A status filter bar on top of a list (6 queues, each with a count).
- A period/group selector where the choice must stay visible.
- Multi-selection over a small set (an audience picker) — `AppChoiceChipBar.multi`.

## When NOT to use

- A filter already applied that the user can remove → `AppFilterChip`.
- A one-shot suggestion/action → `AppSuggestionChip`.
- Two to four options of similar width that must share one line with a
  sliding pill → `AppSegmentedButton` (it does NOT scroll; its cells share
  the widest label's width — six statuses of very different widths overflow).

## Anatomy (`AppChoiceChip`)

- **Selected** paints the **filled accent** — the very same
  `appFilledButtonColors` resolver of the `primary` role that
  `AppSegmentedButton` consumes, so the two answers to "one of N" can never
  drift apart. Hover/press deepen the fill; text contrast only goes up.
- **Unselected** is the `AppStyle` axis container (`filled` →
  `surfaceContainer`; `outlined` → transparent + `outline` border; `elevated`
  → container + shadow), with a neutral hover/press veil (`onSurface` 8/12%).
- On `outlined`, the SELECTED chip's border becomes the fill color itself —
  a grey outline over the accent would muddy the pill.
- Selection changes the label weight (w500 → w700) **and** the fill — never
  one alone: weight alone disappears in dark; fill alone loses at high text
  scale.
- **Count pill**: `fg` at 18% behind a w700 `labelSmall` — one formula for
  both states. `count: null` renders nothing; `count: 0` renders "0" (hiding
  the zero is the caller's decision).
- Minimum height **44** (the iOS tap-target floor, not the 40 of
  `AppButtonSize.s`), growing with text scale.
- Focus ring outside, with **no duration** — it survives reduce-motion.
  Press-scale 0.97 only while motion is enabled.

## Anatomy (`AppChoiceChipBar`)

- `AppChoiceChipOption<T>` is data, not a widget (like `AppSegment`).
- `layout: scroll` (single-selection default): horizontal
  `SingleChildScrollView` with an `AppScrollEdgeFade` veil on the overflowing
  edges. `layout: wrap` (multi default): a `Wrap` that grows downward.
- ←/→ move focus chip to chip (the `AppSegmentedButton` keyboard, copied);
  the focused chip is scrolled into view (`Scrollable.ensureVisible`,
  alignment 0.5, motion-axis duration).
- `.multi` hands back a **new** `Set` — the one you passed is never mutated.

## Global axes

- **Style**: `style` per chip (unselected container only — the selected fill
  is semantic and does not follow the axis, by the axis' own contract).
- **Radius**: `radiusMode`/`radius` (component default **circular** — a chip
  is a pill; `reto` squares chip AND count pill).
- **Motion**: fill/weight transition and press-scale through `AppMotion`;
  the focus ring has no duration on purpose.

## Accessibility (Rule 8)

- `AppChoiceChip` is ONE toggle node: `checked`, `inMutuallyExclusiveGroup`
  (default on; off for multi), label `'<label> (<count>)'` — pass
  `semanticLabel` to NAME THE UNIT ('Novos, 8 conversas na fila'): a bar
  with counts should always do this, or the reader announces a bare number.
- `tooltip` reaches `Semantics.tooltip`, not only the pixel.
- `AppChoiceChipBar` names the GROUP (`semanticLabel`) through a menu node —
  without it the reader hears six loose toggles.
- Tap target: minimum height 44 — it meets the iOS floor (44×44) and is
  measured by a gate; the Android floor (48×48) is not met and stays
  registered in `kA11yDebt`. On touch-first screens give the bar extra
  vertical padding.

## Example

```dart
AppChoiceChipBar<String>(
  value: statusFilter,
  onChanged: inbox.setStatusFilter,
  semanticLabel: 'Filtrar por status',
  options: <AppChoiceChipOption<String>>[
    const AppChoiceChipOption(value: 'all', label: 'Todas'),
    AppChoiceChipOption(
      value: 'queue',
      label: 'Novos',
      count: fila,
      semanticLabel: 'Novos, $fila conversas na fila',
    ),
  ],
)
```
