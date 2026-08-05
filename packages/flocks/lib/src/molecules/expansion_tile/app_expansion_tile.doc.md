# AppExpansionTile

Collapsible section: a **clickable header + an animated body**. No Material.

## When to use

- Secondary content that can start hidden: details, an FAQ, advanced filters.

## When NOT to use

- Navigation between sibling panels → tabs (organism).
- A simple option row → `AppListTile` / `AppActionItem`.

## Anatomy

- **Envelope (card)**: a clipped `Container` (`Clip.antiAlias`) that carries the
  global **style** (`AppStyle` → background/border/shadow) and **shape**
  (`AppRadiusMode` → radius) axes, wrapping **header + body** as a single card.
  See "Style and shape".
- **Header**: `FlocksInteraction` (hover/press/Tab focus + Enter/Space). A
  hover/press highlight blended (`onSurface` 8%/12%) over the card's background,
  a `focusRing`, the same radius as the envelope.
- **Chevron**: `AppAnimatedRotation` (0 → 0.5 turns) — it runs through
  `AppMotion`.
- **Body**: `AppExpand` (an AnimatedSize, `alignment: topCenter`) — it opens and
  closes through `AppMotion` (reduce-motion collapses it to instant).
- **Chevron tooltip**: `AppTooltip` (`collapsedIconTooltip` /
  `expandedIconTooltip`).
- Title and chevron in `onSurface`; disabled dimmed by **tone**.

## Style and shape (the global axes)

- **`style`** (`AppStyle?`): the container treatment applied to the whole card,
  additive over a **ghost** container (no fill of its own). `null` (the default)
  follows the global `theme.styleTheme.style`:
  - `filled` / `elevated` → a `surfaceContainer` background (with a symmetric
    shadow in `elevated`);
  - `outlined` → transparent + an `outline` border.
- **`radiusMode`** (`AppRadiusMode?`) and **`radius`** (`BorderRadius?`): the
  card's corner shape (raw `radius` > `radiusMode` > global). The component's
  default: `AppRadiusMode.redondo`. The body is clipped to the radius.
- **`background`** (`Color?`): overrides the background when the style fills.

## Motion (Rule 10)

- The chevron's rotation and the body's opening use `AppDurations.medium`/`normal`
  + `AppCurves.standard`, **always** through `AppMotion.resolve` — never a literal
  `Duration` (the legacy had a hardcoded `220ms`).

## Accessibility (Rule 8)

- The header carries a button role (`AppSemantics.button`); activation with
  Enter/Space.
- Text selection is disabled in the header (`SelectionContainer.disabled`) so the
  selectable text does not steal the click.

## Tests

- No **pixel golden** (the chevron is a network `AppIcon`); contrast (`onSurface`
  over `surface` **and** `surfaceContainer`, enabled and disabled) validated by
  assertion across 2 brands × 2 brightnesses.
- The `AppStyle`/`AppRadius` axes are covered by asserting the envelope's
  decoration (filled ⇒ `surfaceContainer`; outlined ⇒ a border; elevated ⇒ a
  shadow; `reto` ⇒ radius 0; local precedence over global).

## Example

```dart
AppExpansionTile(
  title: 'Details',
  children: <Widget>[AppText('...')],
)
```
