# AppSegmentedButton

**Segmented** single-selection button: 2–4 mutually exclusive options of **equal
width** in a pill. The selected option is a **sliding pill** that slides
underneath the text when it changes (a legible accent over the track); the rest
stay neutral with a hover/press highlight. *Inset* style (the pill floats over
the track, which in `filled` is a well recessed one step out of the `surface`).

It reuses `AppButton`'s pattern: the pill's color = filled primary
(`appFilledButtonColors`), neutral segments = the ghost highlight (`onSurface`
8%/12%), plus a focus ring and press-scale.

## When to use

- Switching between a few always-visible views or modes (Day/Week/Month,
  Streets/Satellite, units).
- A binary or ternary filter that is not worth hiding in a dropdown.

## When NOT to use

- More than ~4 options → `AppDropdown`.
- Multiple selection → `AppMultiSelect` or checkboxes.

## Anatomy / states

- **Track**: the `AppStyle` axis (`filled` = a well one step out of the `surface`
  — it stands out from the page and from cards; `outlined` = hollow with only the
  `outline` border; `elevated` = surface + shadow), the global radius (round by
  default), inner padding `s2` (the inset effect).
- **Segment**: a label and/or an icon, all of **equal width** (the widest
  label's). **Selected** = covered by the sliding pill (filled primary) +
  `onColorFor` content. **Unselected** = transparent + `onSurface`, with a
  neutral highlight (`onSurface` 8% hover / 12% press). **Focus** = a `focusRing`.
  **Disabled** dims by tone.
- **expanded**: the control fills the available width (the segments split it
  equally); otherwise it fits its content (still at equal widths).
- **size**: the height, through `AppButtonSize` (default `m`).

## Accessibility (Rule 8)

- Each segment is a mutually exclusive toggle (`AppSemantics.toggle` with
  `inMutuallyExclusiveGroup`).
- Keyboard: **Tab** and the **←/→ arrows** navigate; **Enter/Space** selects.

## Motion

- The pill **slides** (a horizontal translation, `FractionallySizedBox` +
  `AnimatedAlign`) through `AppMotion`, honoring reduce-motion (it snaps). The
  label's color cross-fades in sync; press-scale follows `AppButton`.

## Example

```dart
AppSegmentedButton<MapMode>(
  value: mode,
  onChanged: (m) => setState(() => mode = m),
  segments: const <AppSegment<MapMode>>[
    AppSegment<MapMode>(value: MapMode.street, label: 'Streets'),
    AppSegment<MapMode>(value: MapMode.satellite, label: 'Satellite'),
  ],
)
```
