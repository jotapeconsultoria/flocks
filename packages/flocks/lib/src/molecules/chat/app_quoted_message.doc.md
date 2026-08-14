# AppQuotedMessage

The reply/quote block of the chat subsystem — the pair `AppChatBubble` and
`AppChatComposer` were missing. It shows **who** wrote the quoted message, a
dimmed **excerpt** and an optional **thumbnail**, behind a vertical accent bar.

## When to use

- The message a bubble replies to, above its content (pass it as the bubble's
  `header`).
- The "replying to…" preview in the composer, with `onRemove` as the cancel
  "×".
- A forwarded/quoted excerpt anywhere the chat idiom applies.

## When NOT to use

- Long-form quotations inside documents → the content renderer's blockquote.
- An attachment with no quoted text → `AppChatAttachmentChip`.

## Anatomy

- **Accent bar**: a 4px (`AppStrokes.l`) vertical bar in the role's readable
  accent (`AppChatBubbleColor.accentOn`), stretched and clipped by the corner
  radius.
- **Author** (optional): `labelMedium` tinted with the same accent, one line
  with ellipsis. `author: null` hides the line.
- **Excerpt**: `bodySmall` at `onSurface` 72%, `maxLines` (default 2) with
  ellipsis.
- **Thumbnail** (optional): cover-cropped on the end edge, 48px wide,
  excluded from semantics.
- **"×"** (optional): `onRemove` renders the close icon as its **own** tap
  target, the `AppFilterChip` idiom — cancelling and navigating are different
  actions.

## Color

`color` is the `AppChatBubbleColor` the conversation already uses — never a
raw `Color`. The background is the role at **10%** opacity, one step below
the bubble's 14%: the quote lives INSIDE an already-tinted surface and must
read as a nested layer, not a second bubble. On `elevated` the tint is
alpha-blended onto `surfaceContainer` so the shadow cannot leak through.

## Global axes

- **Style**: `style` (`filled`/`outlined`/`elevated`; default global). The
  `outlined` border uses the role accent — a grey outline over the tint would
  muddy the quote (same rule as the bubble's `me` side).
- **Radius**: `radiusMode`/`radius` (default global).
- **Motion**: none — the block is static.

## Accessibility (Rule 8)

- With `onTap`, the whole body is **one** named button — default label
  `'Mensagem citada de {author}'` (or `'Ver mensagem citada'`), overridable
  through `semanticLabel`.
- With `onRemove`, the "×" is a **separate** named target
  (`'Remover citação'`): two actions, two nodes.
- The thumbnail is decorative (`ExcludeSemantics`); the excerpt carries the
  information.
- The accent passes 3:1 against the surface in light and dark on both brands
  (it comes from `readableStopOn`); the excerpt reads at `onSurface` 72%.

## Example

```dart
AppChatBubble(
  author: AppChatAuthor.me,
  header: AppQuotedMessage(
    author: 'Ana',
    excerpt: 'Consegue mandar o relatório de ontem?',
    onTap: () => scrollTo(original),
  ),
  child: const Text('Mandando agora!'),
)
```
