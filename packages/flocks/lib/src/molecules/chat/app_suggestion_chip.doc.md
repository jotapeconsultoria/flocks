# AppSuggestionChip

Tappable chip for a starter prompt (an LLM chat) or a quick reply (WhatsApp),
meant to go inside a `Wrap`. It reuses `AppSurface` (the shell) +
`AppInteraction` (the touch).

## Anatomy

- `label` + an optional `icon` (in `primary`), up to `maxLines` (default 2).
- `style` defaults to `outlined`; shape through `radiusMode`/`radius`.

## When NOT to use

- A status label → `AppBadge`. A primary action → `AppButton`.

## Accessibility (Rule 8)

- A button labelled by `label`, activatable by keyboard.

## Example

```dart
Wrap(spacing: 8, runSpacing: 8, children: <Widget>[
  AppSuggestionChip(label: 'Which vehicles are idle?', onTap: _ask),
  AppSuggestionChip(icon: AppIconToken.chat, label: 'Daily summary', onTap: _ask),
])
```
