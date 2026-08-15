# AppMessageMeta

Time + delivery ticks in an `AppChatBubble`'s footer. Compact (`labelSmall`) and
read-only.

## Anatomy

- `time`: an already-formatted time (the design system does not format dates).
  Optional: `null` renders the **status-only** meta (a table cell, a compact
  marker) and requires `status != none` — asserted, because a meta with
  neither would render an empty row (`edited` alone is a modifier, not meta).
- `status` (`AppMessageStatus`): `none`/`sending` (a clock) / `sent` (1 tick) /
  `delivered` (2 ticks) / `read` (2 ticks in `info`) / `failed` (an error in
  `danger`).
- `edited`: prefixes "edited".

## Accessibility (Rule 8)

- The status is exposed as a label too (image + label) — it does not depend on
  color alone.

## Theme (Rule 9)

- Colors 100% from the theme; the double tick is drawn from two
  `AppIconToken.check` glyphs (the set has no double-tick glyph).

## Example

```dart
AppMessageMeta(time: '10:32', status: AppMessageStatus.read)
```
