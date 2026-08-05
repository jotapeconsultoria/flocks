# AppText

The Flocks design system's text. It wraps the `widgets` layer's `Text`, applying
the theme's typography and color and enabling native mouse selection.

## When to use

- Any UI text: labels, paragraphs, table values, titles.

## When NOT to use

- Text with multiple inline styles (bold in mid-sentence, links) → use
  **AppRichText** with an `AppTextSpan`.

## Anatomy

- By default it applies `theme.textTheme.bodyMedium` with the theme's `onSurface`
  color — so it adapts automatically to light/dark and to the brand.
- It wraps the content in an `AppSelectionRegion`, giving mouse text selection
  with web/desktop parity.

## Accessibility (Rule 8)

- It exposes `semanticsLabel` (defaults to `data`). Pass `semanticLabel` when the
  visible text is not the best reading for a screen reader.
- It honors `MediaQuery.textScaler` (the system's text scale).

## Do / Don't

- ✅ Let the color come from the theme — do not pass a fixed color in `style`.
- ❌ Do not use it to compose mixed styles on one line.

## Examples

```dart
AppText('Plate ABC-1234')

AppText(
  'Section title',
  style: AppTextStyles.titleLarge,
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
)
```
