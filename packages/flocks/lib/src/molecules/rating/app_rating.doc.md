# AppRating

**Star** rating (display and input), with an optional half step. The star is
**painted** through a `CustomPainter` — deterministic and with no dependency on a
network icon (which is why it has a pixel golden).

## When to use

- Showing or capturing a short score (satisfaction, quality, a 0–5 rating).

## When NOT to use

- A wide numeric scale → a slider or a numeric field.
- Progress or measurement → a determinate `AppLinearLoading`.

## Anatomy / states

- **Star**: an accent outline always visible + a solid fill up to the fraction
  (clipped from the left) + a dimmed track (the accent at 18%).
- **value**: 0..`count`, accepting `.5` when `allowHalf`.
- **onChanged**: `null` = read-only; otherwise click and keyboard set the value.
- **allowHalf**: clicking the left half of a star counts as a half.
- **iconSize** / **spacing** / **color** (defaulting to an amber `warning`,
  legible on the surface).
- **Hover** (input): it previews the value under the pointer.

## Accessibility (Rule 8)

- Read-only: it exposes the value as a label (`AppSemantics.label`).
- Interactive: it is a **slider** (`onIncrease`/`onDecrease`); the keyboard
  **arrows** adjust by the step (0.5 with `allowHalf`, otherwise 1).

## Motion

- No looping animation; the hover preview is immediate (nothing to collapse under
  reduce-motion).

## Example

```dart
AppRating(
  value: rating,
  allowHalf: true,
  onChanged: (v) => setState(() => rating = v),
)
```
