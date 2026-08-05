# AppFloatingButton

FAB (_floating action button_) — an action that **floats** above the content.
Because it floats, it **always has a shadow**, even outside the `elevated`
style. It takes an **icon and/or a label**: icon-only (a circle), text-only or
extended (icon + label, stadium).

## Styles (`AppStyle`)

- **`filled`** — solid in the role's color; the prominent FAB.
- **`outlined`** — bordered, transparent background (it keeps the shadow).
- **`elevated`** — solid + a symmetric shadow (no border).
- **`glass`** — real glass (blur through `AppGlassSurface`); it degrades to
  opaque (`elevated`) when transparency is reduced (a11y). The icon and label
  stay tinted with the role over the glass.

`style` follows the global theme (`theme.styleTheme.style`) when `null`, and can
be overridden per FAB. **Whatever the style, the FAB always has a shadow.**

## Shape (`AppRadiusMode`)

- **Circular** by default (icon-only → a circle; extended → a stadium). A null
  `radiusMode` inherits the global one — which, for the FAB, resolves to
  `circular`.
- Local `reto` / `redondo` / `circular` are still honored, as is the raw override
  through `radius`.

## Color

- `AppButtonColor.primary` by default. It accepts any role (`AppButtonColor`).

## When to use

- A persistent primary action floating over the content (create/new, say).
- It pairs with `AppScaffold`'s `floatingAction` slot (bottom corner, RTL-aware).

## When NOT to use

- An inline action in the flow (on the content's line, with a label) → `AppButton`.
- A secondary or tertiary action with no floating prominence → `AppButton`.

## Anatomy and states

- **Background/content**: `filled`/`elevated` use the role's color + its paired
  on-color (AA); `outlined` is transparent + a border in the role's legible stop;
  `glass` shows the role tinted over translucent glass.
- **Shadow**: always present (`AppGlassSurface`'s own in `glass`; otherwise
  `AppElevation.symmetricShadows`).
- **Hover/press**: they deepen or veil the background; press applies a
  micro-scale (0.97) through `AppMotion`.
- **Focus (Tab)**: an outer `focusRing` (it does not shift the layout; it
  disappears on touch).
- **Loading**: a centered `AppCircularLoading`; it blocks touch.
- **Disabled**: background and content dimmed by tone.
- **Icon-only glyph**: derived from `size` (`s`→16, `m`→24, `l`→32), more
  prominent than the icon that accompanies a label (16, matched to the text).

## Accessibility

- `AppSemantics.button` (the label defaults to `label` or to the icon's name;
  `enabled`/`loading` are reflected); activation with Enter/Space.
- Content contrast ≥ AA in every state and style, validated across 2 brands × 2
  brightnesses × 8 colors (see `app_floating_button_test.dart`).

## Tests

- Behavior (tap/disabled/loading), per-style decoration with the **shadow always
  present** (including `filled`/`outlined`), the presence of `AppGlassSurface` in
  `glass`, reduce-motion, and the per-state contrast matrix.
- Goldens per brand × brightness covering the 4 styles and the 3 shapes.

## Example

```dart
AppFloatingButton(icon: AppIconToken.add, onPressed: create)                 // circle
AppFloatingButton(icon: AppIconToken.add, label: 'New', onPressed: create)   // extended
AppFloatingButton(style: AppStyle.glass, icon: AppIconToken.add, onPressed: create)

AppScaffold(
  floatingAction: AppFloatingButton(icon: AppIconToken.add, onPressed: create),
  child: content,
)
```
