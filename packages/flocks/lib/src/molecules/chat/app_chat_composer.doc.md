# AppChatComposer

Multimodal input field — the composer bar. The design system's **surface** wraps
**only the compose area** (the "bare" multiline `AppInput` + the send button);
the attachments sit **above** and the **toolbar** **below** — both **outside the
surface** (as in Claude). It replaces Material's `TextField`.

## Anatomy

- **Attachment strip** (ABOVE the input, OUTSIDE the surface, optional):
  `AppChatAttachmentChip`/`Card`.
- **Surface / compose** (the `AppInput` + the **send/stop** button on the right —
  a "bare" clickable icon with no background, larger; it becomes **stop** when
  `busy`+`onStop`). It is the **only** thing on the surface.
- **Toolbar** (BELOW, OUTSIDE the surface, shown only when it has items):
  - **Left**: the **attachment** button (`onAttach`) and the **model**
    (`modelLabel` + `onModelTap`/`modelOptions`).
  - **Right**: the **info** icon (`info` → a popover) and the **context
    progress** (`contextProgress` 0..1 → a ring; `contextPopover` → a popover).
- The model, info and context controls (and the attachment one) have
  **hover/focus/click** feedback + a **tooltip** (through `AppInteraction`, or a
  hover highlight for the overlay triggers).
- **Color**: every button uses a **neutral shade** (a dimmed `onSurface`). The
  **only colored element is the context ring** (the progress, `secondary`).
- **Attachments follow the composer's style** (filled/outlined/elevated) —
  through a scoped theme; an explicit `style` on the chip or card still wins.
- Keyboard: **Enter** sends; **Shift+Enter** breaks the line. With `shortcut`,
  the send button's place shows an `AppShortcutHint` **while there is nothing to
  send** — a dimmed arrow teaches nothing, the badge teaches the key that brings
  focus here. As soon as there is text (or an attachment), the badge gives way to
  the active arrow.
- `attachmentLimit` (default 2): on reaching it, the attachment button
  **disables** and shows a **tooltip** (`attachLimitMessage`) on hover.
- `size` defaults to **`AppFieldSize.s`**.

## Global axes

- **Style** (`style`): the surface (which wraps only the compose area) resolves
  the global `filled`/`outlined`/`elevated` axis through `styleBoxDecoration`.
  The background is always **opaque** (`surfaceContainer`) — in `elevated`, the
  symmetric shadow does not bleed underneath (there is a background); in
  `outlined`, it gains the `outline` border.
- **Shape** (`radiusMode`/`radius`): the surface follows the global axis
  (`reto`/`redondo`/`circular`). **Exception**: `circular` (a pill) only fits a
  **single-line** compose area — with **attachments**, or when the text turns
  **multiline**, it falls back to `redondo` (measured with `LayoutBuilder` +
  `TextPainter`).
- Popovers open **upward** (`AppOverlayPlacement.topEnd`).

## Accessibility (Rule 8)

- Attachment/model/info/send/stop with labelled semantics; a tooltip on the limit.

## Example

```dart
AppChatComposer(
  controller: _controller,
  hintText: 'Ask anything…',
  onSend: _send,
  onAttach: _pick,
  modelLabel: 'Atlas', onModelTap: _swapModel,
  info: const AppText('Shift+Enter breaks the line.'),
  contextProgress: 0.35,
  contextPopover: const AppText('35% of the context used.'),
)
```
