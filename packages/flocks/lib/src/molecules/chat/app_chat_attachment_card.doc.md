# AppChatAttachmentCard

Attachment card — the "card" alternative to `AppChatAttachmentChip` (same
information, larger format, in the style of Claude's attachments). **Square**
by default; `layout: row` lays it down into a horizontal block.

## Layouts

- **`square`** (default): the card of always — `size` × `size` (104 default).
- **`row`**: a horizontal block — thumb (40px, clipped to the theme radius) or
  the same tinted icon tile, then name + `subtitle`, with the remove X
  **inline** at the end (the chip idiom — no overlaid corner button). Width is
  `2 × size`, height comes from the content, so text scale is respected. The
  radius resolves without a size (round keeps the ~12 cap; circular saturates
  into a pill), the file-pill precedent from the chip. Cards with and without a
  subtitle differ by a few pixels in height on the same strip — expected, the
  content drives it.

## The boundary with the chip

`AppChatAttachmentChip` is the compact one-line pill (maxWidth 180, 48px thumb)
for dense strips inside the composer; the card-row is the **rich** horizontal
block — subtitle, a larger target, `2 × size` wide — for the file bubble and
the attachment list.

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
