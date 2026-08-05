# AppIcon

The design system's icon. It resolves the slug through the theme's
`AppIconProvider` (`theme.iconTheme.provider`), applies color through a
`ColorFilter` and size through `AppIconSize`. Free of Material and Cupertino.

The widget does not know where the drawing comes from: the package's default is
the bundled SVGs (no network), a brand can point at a CDN, and a sibling package
can bring another set. Swapping the provider swaps the whole system.

## When to use

- Action, status and navigation icons, drawn from `AppIconToken` — the contract
  of 55 names every provider guarantees to serve. `AppIcons` (~880) is JotaPe's
  own catalog and only draws under a provider that knows it.

## When NOT to use

- Large or decorative artwork → use **AppIllustration**.

## Anatomy

- While loading: a placeholder the size of the icon. On error: a circle in the
  theme's `danger` color (or in the `color` given).
- `color == null` keeps the SVG's original colors; otherwise a `ColorFilter` is
  applied. Prefer a theme color for meaningful icons (Rule 9).

## Accessibility (Rule 8)

- `semanticLabel == null` (the default) → **decorative**: excluded from the
  semantics tree (`ExcludeSemantics`).
- `semanticLabel != null` → `Semantics(image: true, label: ...)` — use it when
  the icon carries meaning with no text beside it (a status icon, for instance).

## Do / Don't

- ✅ Pass `semanticLabel` when the icon carries meaning of its own.
- ❌ Do not pin a color outside the theme for meaningful icons.

## Testing note

`AppIcon.debugIconBuilder` replaces the drawing with a synchronous glyph,
installed by `test/flutter_test_config.dart`. It serves two purposes: it makes
every golden containing an icon deterministic, and it isolates the goldens from
whichever provider is in force — a component test should not break because the
icon set changed.

That is why **there is no pixel golden of AppIcon itself**. The coverage lives
in the widget tests (decorative/labelled semantics, size, `color`/`ColorFilter`)
and in `test/architecture/icon_axis_test.dart`, which requires a file from the
default provider for every `AppIconToken` and proves that swapping the provider
swaps the pixel. Visually checking the real render happens in the Widgetbook.
Same criterion as AppIllustration.

## Examples

```dart
AppIcon(AppIconToken.check, size: AppIconSize.l)

AppIcon(AppIconToken.alert, color: theme.colorTheme.danger, semanticLabel: 'Alert')
```
