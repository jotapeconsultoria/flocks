# AppChatAttachmentCard

**Square** attachment card — the "card" alternative to `AppChatAttachmentChip`
(same information, larger format, in the style of Claude's attachments).

## Anatomy

- `image` != null → the thumbnail fills the card, with the name over a gradient
  at the bottom.
- `image` == null → a large icon tinted by category (`AppAttachmentKind`,
  resolved from `label`'s extension) in a soft square, with the name (up to 2
  lines) and the optional `subtitle` below.
- `onTap` → previews it; `onRemove` → a remove badge in the corner.
- `size` (default 104) sets the square's side.

## When NOT to use

- The compact (row) format → `AppChatAttachmentChip`.

## Composer

- In `AppChatComposer`'s strip, use `attachmentLayout:
  AppChatAttachmentLayout.row` (horizontal scrolling) for the cards; `wrap` for
  the chips.

## Example

```dart
AppChatAttachmentCard(image: MemoryImage(bytes), label: 'photo.png', onTap: _view, onRemove: _rm)
AppChatAttachmentCard(label: 'report.pdf', subtitle: 'PDF', onRemove: _rm)
```
