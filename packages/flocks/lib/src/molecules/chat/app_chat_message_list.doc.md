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
