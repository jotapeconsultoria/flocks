# AppColorPickerInput & AppColorPickerPanel

The design system's color picker, with no Material and no external dependency.

| Component | What it is |
| --- | --- |
| `AppColorPickerInput` | The **field**: a painted swatch + an editable hex; it opens the panel in an overlay. |
| `AppColorPickerPanel` | The **panel**: an HSV area, a hue bar and presets. It works on its own. |

## Three routes to the same color

People arrive by different routes, and all three have to exist:

- **pasting the hex** — it came from the brand guide and is already settled;
- **picking a preset** — they need "a distinguishable color", not a specific one;
- **hunting through the spectrum** — they know the tone, not the code.

Closing off any one of them turns a two-second gesture into a hunt.

## The hex comes out canonical

`onChanged` **always** emits `'#RRGGBB'` — or `''` when the field is cleared. The
consumer never receives `#abc`, `abc` or `#AABBCCDD` to normalize later.
Normalizing at the edge is what keeps the same color from being stored in three
different formats and never matching in a comparison.

## The swatch is a prefix, not a suffix

It shows the field's **value**, and the eye reads the value before the label. The
suffix is where actions live (clear, open) — putting the swatch there would make
it look clickable without being so.

## Literal colors in the panel are not an exception to the rule

The hue spectrum and the gradient stops are written as `Color(0xFF…)`. That is
not tokenization debt: **it is the color space**. Tokenizing the spectrum's pure
red would deform the tool, which exists precisely to navigate outside the theme's
palette.

The panel's chrome (the selection ring, the cursor's shadow) is interface, and
that does read from the theme.

## Presets

The default is a palette of map colors that are **highly distinguishable from
each other** — that is the real use case: categories that have to be told apart
at a distance, not combined aesthetically. When the domain has a palette of its
own, pass `presets`.

## `onColorChanged` is not a confirmation

It fires **while the user drags**. Persisting on every event writes dozens of
intermediate values; confirm when the panel closes.

## Accessibility

Color is never the only channel: the textual value (the hex) always accompanies
the swatch. The HSV area and the hue bar respond to the keyboard, and the presets
are buttons labelled with the hex — choosing must not depend on seeing the
difference between two near-identical tones.

## Example

```dart
AppColorPickerInput(
  label: 'Color',
  value: group.colorHex,
  onChanged: form.setColor,
);

AppColorPickerPanel(
  color: current,
  onColorChanged: (Color c) => setState(() => current = c),
);
```

## Presets-only (`AppColorPickerPanel.showSpectrum`)

`showSpectrum: false` hides the whole free-editing spectrum — the
saturation/brightness area, the hue bar AND the hex preview (the hex belongs
to free editing) — leaving only the preset palette: the fixed-palette picker
of a tag screen. At least one of `showSpectrum`/`showSuggestedColors` must
stay on (asserted); the breathing room between sections leaves with the
spectrum, so presets-only opens straight at the label.
