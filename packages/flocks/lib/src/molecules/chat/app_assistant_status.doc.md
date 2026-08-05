# AppAssistantStatus

The assistant's step label ("Understanding the request" → "Fetching data" → …),
with a smooth transition (fade + rise) on every change of `label`.

## Anatomy

- `label`: the current step (the timing and cycling belong to the consumer).
- `showIndicator` (default `true`): prefixes an `AppTypingIndicator`.
- The text's `style`/`color`.

## Motion (Rule 10)

- The swap uses an `AnimatedSwitcher` whose duration comes from `AppMotion` —
  under reduce-motion the change is instant.

## Accessibility (Rule 8)

- `AppSemantics.status`: a live region that announces the new label when it
  changes.

## Example

```dart
AppAssistantStatus(label: 'Fetching data')
```
