# AppPickerAnchor

**Generic picker** anchor: a `trigger` (any widget) that opens a floating `panel`
anchored just below it, inside an elevated `AppOverlayPanel`, closing on an
outside click or on `Esc`. It is the design system's picker overlay machine
**decoupled from the input** — use it in `AppInput` (as the `*PickerInput`s do)
**or on any other trigger** (a button, a chip…).

It renders through the `Overlay`, anchored by a `LayerLink` (transform-safe,
reusing `AnchoredOverlayController`), and re-provides **theme + text scale +
`DefaultTextStyle`** inside the entry — it works in any host, with no theme crash
and no yellow underline, and it reflects the text scale.

## When to use

- Opening an `AppDatePicker` / `AppTimePicker` / `AppColorPickerPanel` from any
  widget.
- Building a new "picker input" by reusing the overlay machine (instead of
  recreating `OverlayEntry` + `CompositedTransformFollower` + `TapRegion`).

## When NOT to use

- A rich-content balloon with an arrow → use `AppPopover`.
- Choosing a value from a list → use `AppDropdown`.
- A list of actions → use `AppMenu`.

## Anatomy / states

- **trigger** `(context, handle)`: any widget. It is wrapped in a
  `CompositedTransformTarget` + a `TapRegion` (the same `groupId` as the panel →
  touching the trigger does **not** count as an "outside click"). Call
  `handle.open/close/toggle`.
- **panel** `(context, handle)`: the panel's content, inside the
  `AppOverlayPanel`.
- **AppPickerHandle**: `open()` / `close()` / `toggle()` / `isOpen` / `rebuild()`
  (which rebuilds the open panel — for panels that reflect the trigger's state
  live, such as a typed hex, or a date chosen before the time).
- **width** (`AppPickerWidth`): `matchTrigger({min})` matches the panel's width to
  the trigger's (through `LayerLink.leaderSize`, with no `GlobalKey`); `fixed(w)`
  pins the width (the color picker = 248, say).
- **placement**: `bottomStart` (default) / `bottomCenter` / `bottomEnd` /
  `topStart` / `topCenter` / `topEnd`.
- **panelGlass** (`bool?`): the panel's glass axis — `null` follows the global
  `glassTheme`; when on, the panel becomes real glass (blurring what is behind
  it) and falls back to opaque under reduced transparency.
- **panelStyle** / **panelAccentColor** / **panelPadding**: the panel's chrome in
  the non-glass render (default `elevated`, a `secondary` accent, `all(s8)`
  padding; pass `EdgeInsets.zero` when the panel already brings its own padding).
- It closes on an **outside click** or on **Esc**.

## Accessibility

- It closes on `Esc`; the trigger must carry its own semantics (the anchor only
  makes it actionable). `autofocus:false` — it does not steal focus from a field
  in the trigger.

## Motion

- No animation of its own; the panel appears and disappears with the `Overlay`.
  The animations live in the content (the `AppTimePicker`'s wheels, say, which
  honor reduce-motion).

## Example

```dart
AppPickerAnchor(
  width: const AppPickerWidth.matchTrigger(min: 300),
  trigger: (context, h) => AppButton(label: 'Date', onPressed: h.open),
  panel: (context, h) => AppDatePicker(
    onDateSelected: (d) { setState(() => _date = d); h.close(); },
  ),
)
```
