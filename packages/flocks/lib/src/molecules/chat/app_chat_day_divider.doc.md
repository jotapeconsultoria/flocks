# AppChatDayDivider

Centered "Today" / "Yesterday" / date pill that separates messages by day
(WhatsApp's signature).

## Anatomy

- `label`: already-formatted text (the design system does not format dates).
- `withRules`: draws rules (`AppDivider`) on both sides of the pill.

## Theme (Rule 9)

- The pill = a `raised` `AppSurface` (`surfaceContainer`); the text is a dimmed
  `labelSmall`. Colors 100% from the theme.

## Example

```dart
AppChatDayDivider(label: 'Today')
AppChatDayDivider(label: 'Jul 14', withRules: true)
```
