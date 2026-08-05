# AppChatBubble

Flocks' message bubble — the visual shell of any conversation (an LLM chat or a
WhatsApp-style one). It is **content-agnostic**: it takes an arbitrary `child`;
the app injects text, markdown, an image, a table.

## When to use

- Rendering a message in a conversation.
- The user's bubble in an LLM chat, or both sides in a WhatsApp-style chat.

## When NOT to use

- A "flat" assistant reply (full width, no bubble) → render the content directly
  + `AppChatActionBar`.
- A confirmation or question card → `AppQuestionCard` / `AppAlert`.

## Anatomy

- `author` (`me`/`other`): drives the alignment (right/left) and the default
  background. `me` = the role's tint (`color`); `other` = `surfaceContainer`.
- `tail` (`none`/`top`/`bottom`): the square corner (the little "ear") on the
  author's side.
- `header` (the sender's name) and `footer` (an `AppMessageMeta`, say) slots.
- `maxWidthFraction` limits the width to a fraction of the viewport (default
  0.78).

## Global axes

- `style` (filled/outlined/elevated) through `resolveStyleDecoration`; shape
  through `radiusMode`/`radius`; color 100% from the theme (light/dark + brand).

## Accessibility (Rule 8)

- `semanticLabel` groups the message into one labelled node ("You: … 10:32,
  read", say). `null` lets the `child`/`footer` semantics flow through.

## Example

```dart
AppChatBubble(
  author: AppChatAuthor.me,
  footer: const AppMessageMeta(time: '10:32', status: AppMessageStatus.read),
  child: const AppText('Let us go tracking!'),
)
```
