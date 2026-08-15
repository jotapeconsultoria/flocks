# AppChatMessageList

The conversation's "floor" — a scrollable list that **sticks to the bottom**
(anchoring the content to the base when it is short), **auto-scrolls** when a new
message arrives and **spaces** the items.

## Anatomy

- `itemCount` + `itemBuilder` (which builds each row — a bubble, a divider, and
  so on).
- An optional external `controller`; otherwise the list creates and disposes its
  own.
- `spacing`, `padding`, `stickToBottom`, `autoScroll`.

## Virtualized (and what that means for the controller)

- Items are built **on demand** (viewport + cache): `itemBuilder` is not called
  for indices far from view, so a thousand-message thread costs what the screen
  shows. Virtualization needs bounded height — inside a `Column`, wrap it in
  `Expanded`. Under UNBOUNDED height (the list embedded in a scrollable page)
  it degrades to shrink-wrap: it renders without overflowing, but materializes
  every item, like the old implementation did.
- Do not rely on raw offsets from the external `controller` — the scroll origin
  depends on the mode. With `stickToBottom` (the default) the origin is the
  **end of the conversation**: top of the history = `position.extentAfter == 0`,
  end = `position.extentBefore == 0`. Without `stickToBottom` it is the mirrored
  classic: top = `extentBefore == 0`, end = `extentAfter == 0`.
- **Item identity**: with your own key on the item widget (a `ValueKey` of the
  message id), per-item state survives a new message arriving at the end
  (append) and NEVER sticks to the wrong message; on history pagination (items
  entering at the FRONT) the item remounts — right content, fresh state.
  Without a key, identity is the index: append preserves; on pagination the
  index changes owner (as the old implementation did). State that must survive
  pagination uses a `GlobalKey` on the item, which survives any mutation.

## Domain-agnostic

- It does **not** group by author or insert day dividers (it does not know the
  messages). The consumer expresses that in `itemBuilder` — by choosing an
  `AppChatBubble` (with `tail`/grouping) or an `AppChatDayDivider`.

## Motion (Rule 10)

- The auto-scroll only animates with `AppMotion` on; otherwise it jumps
  straight there.

## Example

```dart
AppChatMessageList(
  itemCount: rows.length,
  itemBuilder: (context, i) => rows[i],
)
```
