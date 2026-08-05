# AppChatAttachmentChip

Compact preview of a composer attachment: an image **thumbnail** (through an
`ImageProvider`) or an icon+name **pill** for files.

## Anatomy

- `image` != null → a square thumbnail (`size`, `BoxFit.cover`) clipped to the
  radius.
- `image` == null → a pill: icon + name. The **icon and the tone** come from
  `label`'s extension through `AppAttachmentKind`
  (image/video/audio/pdf/xls/csv/doc/ppt/zip; the fallback is a generic file).
  Pass `kind`/`icon` to override.
- `onTap` → opens or previews the attachment (the pill or thumbnail becomes
  tappable).
- `onRemove` → the remove button (a discreet X on the pill; a small circular
  badge in the thumbnail's corner).

## Accessibility (Rule 8)

- `onTap` and the remove control are labelled buttons ("See …", "Remove
  attachment").

## Related

- `AppChatAttachmentCard` (the card format), `AppAttachmentKind` (resolution by
  extension), `AppChatComposer` (the attachment strip).

## Example

```dart
AppChatAttachmentChip(image: MemoryImage(bytes), onTap: _view, onRemove: _rm)
AppChatAttachmentChip(label: 'report.pdf', onTap: _view, onRemove: _rm)
```
