# AppButton

The single action button (label and/or icon) that varies along the global
**`AppStyle`** axis. It replaces `AppFillButton` and `AppLineButton`.

## Styles (`AppStyle`)

- **`filled`** (default) — solid in the role's color; the prominent primary action.
- **`outlined`** — bordered, transparent background; the secondary action.
- **`elevated`** — solid + a symmetric shadow (no border); prominence through
  elevation.

`style` follows the global theme (`theme.styleTheme.style`) when `null`, and can
be overridden per button.

## When to use

- Any action with a label or icon; pick the emphasis through `style`.

## When NOT to use

- Icon only → `AppIconButton`.
- Tertiary or link, with no container → `AppTextButton`.
- An action with a menu of secondary actions → `AppSplitButton`.

## Anatomy and states

- **Background/content**: in the `filled`/`elevated` styles, the role's color
  (`AppButtonColor`) + its paired on-color (AA contrast guaranteed); in
  `outlined`, a transparent background + border and content in a legible stop
  (≥ AA) of the role.
- **Hover/press**: `filled`/`elevated` deepen the background (10%/20%);
  `outlined` uses a neutral highlight. The text's contrast only increases.
- **Focus (Tab)**: an outer `focusRing` (it does not shift the layout; it
  disappears on touch).
- **Press**: a micro-scale (0.97) through `AppMotion`.
- **Loading**: a centered `AppCircularLoading`; it blocks touch.
- **Disabled**: background and content dimmed by tone + a legible indicator.
- **Radius/shape**: the global radius (round mode), overridable through
  `radiusMode`/`radius`.

## Accessibility (Rule 8)

- `AppSemantics.button` (the label defaults to `label`; `enabled`/`loading` are
  reflected); activation with Enter/Space.
- Content contrast ≥ AA in **every state and style**, validated across 2 brands ×
  2 brightnesses × 8 colors (see `buttons_test.dart`).

## Tests

- No **pixel golden** (the content may contain a network `AppIcon`); per-state
  contrast is validated by assertion over the pure resolvers
  (`appFilledButtonColors` / `appGhostButtonColors`) — `elevated` reuses fill's.
- Behavior tests (tap/disabled/loading) and per-style decoration tests (`filled`
  with no border or shadow, `outlined` with a border, `elevated` with a shadow).

## Example

```dart
AppButton(label: 'Save', onPressed: save)                              // filled
AppButton(style: AppStyle.outlined, label: 'Cancel', onPressed: cancel)
AppButton(style: AppStyle.elevated, label: 'Publish', onPressed: publish)
```
