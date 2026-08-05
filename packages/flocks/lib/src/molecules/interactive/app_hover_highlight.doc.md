# AppHoverHighlight

**Purely visual** hover highlight: no gesture, no focus, no Tab stop.

## Why it exists

The overlay triggers — `AppMenu`, `AppPopover`, `AppPickerAnchor` — already
install click and focus around the trigger. Wrapping the content in an
`AppInteraction` would create **two** targets, and the result is two predictable
bugs:

- a second Tab stop, in a place the user reads as a single control;
- the classic double-toggle: the overlay opens on the inner gesture and closes on
  the outer one.

This component paints the same translucent highlight as `AppInteraction`
(`onSurface` at 8%) and **nothing else**. The trigger gains the affordance of
every other clickable item without fighting over the gesture with whoever
already owns it.

## When to use

- The content of an overlay trigger that already has a gesture and focus around
  it.
- A row highlight where the click belongs to an ancestor.

## When NOT to use

- A genuinely clickable target → `AppInteraction`, which brings the gesture, the
  focus and the semantics.
- A button → `AppButton`.

## `padding` is not optional in practice

The padding is what gives the painted area its **body**. With `EdgeInsets.zero`
the highlight clings to the text and visually disappears — the user does not
notice they hovered over something interactive.

## Accessibility

It stays out of the semantics tree on purpose: the role, the label and the focus
belong to the trigger outside it. Not creating a second focusable node is exactly
why it exists.

## Example

```dart
AppMenu(
  entries: entries,
  child: const AppHoverHighlight(
    padding: EdgeInsets.symmetric(
      horizontal: AppSpacings.s8,
      vertical: AppSpacings.s4,
    ),
    child: AppText('Actions'),
  ),
);
```
