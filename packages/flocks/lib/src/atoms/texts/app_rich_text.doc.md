# AppRichText

The Flocks design system's rich text. It wraps the `widgets` layer's `Text.rich`
to compose **multiple inline styles** on one line or paragraph (a bold word, a
colored fragment, a link) and enables native mouse selection.

## When to use

- Sentences with pointed emphasis: a highlighted value in mid-text, a bold word,
  a colored fragment, an inline link.

## When NOT to use

- Single-style text (a label, a paragraph, a table value) → use **AppText**.

## Anatomy

- It takes an **AppTextSpan** (a `TextSpan` subclass) assembled by the caller,
  with a base `style` and `children` for the fragments that carry their own.
- Derive the styles from `AppTheme.of(context)` (`textTheme.bodyMedium`,
  `colorTheme.primary`) so the text adapts to light/dark and to the brand.
- It wraps the content in an `AppSelectionRegion`, giving mouse text selection
  with web/desktop parity (Rule 7).

## Accessibility (Rule 8)

- It exposes `semanticLabel`; by default it uses `data.text`. Since an
  `AppTextSpan` may have no `text` on its root node (only `children`), pass an
  explicit `semanticLabel` when the visible text cannot be derived — it is what
  the screen reader reads.
- It honors `MediaQuery.textScaler` (the system's text scale).

## Do / Don't

- ✅ Derive the colors and styles from the theme (`AppTheme.of(context)`).
- ✅ Pass `semanticLabel` when the root span has no `text`.
- ❌ Do not use it for a single-style sentence — prefer `AppText`.
- ❌ Do not hardcode colors in the spans.

## Examples

```dart
final base = AppTheme.of(context).textTheme.bodyMedium;

AppRichText(
  AppTextSpan(
    style: base,
    children: <TextSpan>[
      const TextSpan(text: 'This is an '),
      TextSpan(text: 'important', style: base.bold.withColor(
        AppTheme.of(context).colorTheme.primary,
      )),
      const TextSpan(text: ' highlight.'),
    ],
  ),
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  semanticLabel: 'This is an important highlight.',
)
```
