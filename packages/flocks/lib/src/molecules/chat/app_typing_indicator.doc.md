# AppTypingIndicator

Three "typing…" dots that rise and fall in sequence. It serves both "is typing"
(WhatsApp) and "assistant thinking".

## Anatomy

- `dotSize`/`spacing`/`color` (defaulting to a dimmed `onSurface`).

## Motion (Rule 10)

- Motion-aware through `AppMotion`: under reduce-motion, or with the global
  switch off, the dots stay **still** (no bouncing).

## Accessibility (Rule 8)

- A labelled live region (`semanticLabel`, "Typing" by default) — the screen
  reader does not wait for the animation.

## Example

```dart
AppTypingIndicator()
```
