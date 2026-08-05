# AppOverlayAlert

Alert card whose semantic color comes as a **`ColorSwatch`** (`AppAlert`'s
sibling, which uses an enum). A `surfaceContainer` tinted by the color, the
container on the `AppStyle` axis (default `elevated`), the shape from the radius
axis.

## When to use

- An alert when you already have the semantic **swatch** in hand (not the enum).

## When NOT to use

- A known semantic role (info/success/warning/danger) → `AppAlert`.

## Anatomy

- A `surfaceContainer` **card** tinted (10%) by the color; a title
  (`titleMedium`/`onSurface`, 1 line), the semantic icon on the right, a
  description (`bodyMedium`/`neutralPrimary.s700`, up to 3 lines).
- Border and icon resolved to a legible stop (≥ 3:1) against the background.

## Accessibility

Wrapped in `AppSemantics.liveRegion` → announced when it appears. The colors pass
WCAG AA in light and dark.

## Example

```dart
AppOverlayAlert(
  title: 'Could not save',
  description: 'Please try again.',
  color: AppTheme.of(context).colorTheme.danger,
);
```
