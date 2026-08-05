# AppChatActionBar

Row of icon actions under a reply (copy / regenerate / like / dislike). Each
`AppChatAction` becomes an `AppInteraction` (hover/press/focus, a tooltip and
button semantics).

## Anatomy

- `actions`: a list of `AppChatAction(icon, label, onPressed, active, activeColor)`.
- Active tints the icon with `secondary` (or `activeColor`); inactive uses a
  dimmed neutral (`color`).
- `iconSize` (default `s`), `spacing`.

## Accessibility (Rule 8)

- Each action is a labelled button, with the tooltip taken from `label`.

## Example

```dart
AppChatActionBar(actions: <AppChatAction>[
  AppChatAction(icon: AppIconToken.copy, label: 'Copy', onPressed: _copy),
  AppChatAction(icon: AppIconToken.thumbsUp, label: 'Like', active: liked, onPressed: _like),
])
```
