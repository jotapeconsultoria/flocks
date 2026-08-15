# AppSlider

A horizontal slider for picking a value in a range — the design system's first
public slider (the color picker's hue bar is a private, special-purpose strip).

## When to use

- A numeric setting inside a form: a sending rate (1–60 msg/min), a
  percentage, a threshold.
- Continuous or stepped values where dragging beats typing.

## When NOT to use

- Picking one of a handful of discrete, labelled options →
  `AppSegmentedButton` or `AppChoiceChip`.
- Exact numeric entry where precision matters more than speed → `AppInput`
  with a numeric keyboard.

## API decisions

- **Controlled**: `value` + `onChanged`, state lives in the caller (the
  `AppRating` idiom). `onChanged: null` disables; the parameter is required so
  the decision is explicit.
- **`step` in domain units** (`1.0` = integers), not Material's `divisions`:
  "1 by 1 msg/min" is the use case, and `divisions = (max - min) / step` is
  arithmetic every call site would get wrong. `null` = continuous.
- **`formatValue` is one single source of formatting** for both the visible
  label (`showValue`) and the semantics values — a separate semantic formatter
  would create exactly the divergence Rule 8 exists to prevent.
- **Inline value label**, no floating tooltip: an overlay is golden-test
  nondeterminism and motion cost this control does not need.
- **`onChangeEnd`** commits on release (and after each keyboard step) for
  callers that persist the value and do not want to do it per pixel.

## Anatomy & geometry

- The widget is at least **48px tall** (`AppSizes.s48`) with an opaque hit
  area — it is born meeting the Android/iOS tap-target guidelines; the track
  stays thin (`trackThickness`, default 4).
- Inactive track: accent at 18%; active track and thumb: the accent
  (`color ?? readableStopOn(primary, surface)` — readable in both themes).
- The thumb grows +4px while dragging (`AppMotion` duration, collapses under
  reduce-motion). The focus ring has **no duration** — it survives
  reduce-motion, since Rule 10 shortens transitions, never erases state.
- Disabled dims everything by the package's muted factor (38%).
- Track corners are half the track thickness — the line's own cap, not a
  surface corner, so the shape axis does not apply.

## Keyboard & RTL

- Arrows step by `step ?? (max - min) / 20`; **Home/End** jump to min/max.
- Left/Right mirror under RTL (`Directionality`); Up/Down and Home/End do
  not. Pointer geometry mirrors as well.

## Accessibility (Rule 8)

- One `slider` semantics node: `label` (`semanticLabel`), `value`,
  `increasedValue`/`decreasedValue` — all through `formatValue` — and
  `onIncrease`/`onDecrease` for the screen reader's adjust gesture.
- Disabled **keeps** the node with `enabled: false` (announces the state, the
  `AppButton` philosophy) and drops the gesture handlers.
- The visible value label is excluded from semantics: the node already
  announces it — a second text would read the number twice.

## Example

```dart
AppSlider(
  value: rate,
  min: 1,
  max: 60,
  step: 1,
  showValue: true,
  formatValue: (v) => '${v.round()}/min',
  semanticLabel: 'Sending rate',
  onChanged: (v) => setState(() => rate = v),
  onChangeEnd: settings.saveRate,
)
```
