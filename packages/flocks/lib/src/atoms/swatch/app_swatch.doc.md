# AppSwatch

Color swatch: a rounded square (or a circle) painted with a color. A reusable
leaf for showing a color in lists, grids and the color picker.

## When to use

- Showing a color: a color picker, a chart legend, a vehicle color chip, a palette.

## When NOT to use

- A status label → **AppBadge**.
- An icon → **AppIcon**.

## Anatomy

- `color` paints the middle; `shape` (`square`/`circle`); `size` = the side or
  diameter.
- A subtle `borderColor` border (default `theme.colorTheme.outline`,
  `AppStrokes.s`) keeps light colors legible against the surface.
- `square` uses the global radius (round mode).

## Accessibility (Rule 8)

- `semanticLabel == null` (the default) → decorative. Pass the **color's name**
  when the color carries meaning with no text beside it — color must not be the
  only channel.

## Do / Don't

- ✅ Pass `semanticLabel` with the color's name or hex when it carries meaning.
- ❌ Do not use it for textual status (that is `AppBadge`).

## Examples

```dart
AppSwatch(color: Color(0xFF1E88E5), semanticLabel: 'Blue')

AppSwatch(color: vehicle.color, shape: AppSwatchShape.circle, size: 16)
```
