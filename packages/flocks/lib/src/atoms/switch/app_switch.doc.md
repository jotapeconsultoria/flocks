# AppSwitch

On/off switch for a single option. Rebuilt on `FlocksInteraction` — Tab focus,
Enter/Space activation, hover and a focus ring. The thumb's animation runs
through `AppMotion.resolve` (it honors reduce-motion: it teleports instead of
sliding when the user turns animations off).

## When to use

- Turning a setting on or off **immediately** (the effect applies at once).

## When NOT to use

- An action that requires confirmation → use a button.
- Multiple selections → use **AppCheckbox**.
- An exclusive single choice among options → use **AppRadio**.

## Anatomy / states

The **semantic fill** (independent of style): on = a `primary` track with the
`onPrimary` thumb on the right; off = a track with no fill of its own
(surface/ghost, resolved by the style) and the `outline` thumb on the left;
disabled = a neutral dimmed by tone. Focus (keyboard) = an outer ring in
`primary`.

## Style (AppStyle)

It follows the global container axis (`theme.styleTheme.style`, overridable
through `style:`), like `AppAvatar`/`AppBadge` — **additive** over the track's
semantic fill:

- `filled` (the design system's default): on = a `primary` track; **off = a
  neutral track (`neutralPrimary.s200`)** — distinct from
  `surface`/`surfaceContainer` so it does not disappear over a card or a panel;
  neither has a border.
- `outlined`: it adds the `outline` border over the track (in a foreground
  `DecoratedBox`, so the band does not narrow) — **off is hollow** (a
  transparent track with only the border).
- `elevated`: like `filled` + a symmetric shadow (`AppElevation`) under the track.

## Accessibility (Rule 8)

- `AppSemantics.toggle` exposes `toggled`/`enabled`. `semanticLabel` is optional.
- Tab-navigable, activatable with Enter/Space (through `FlocksInteraction`).

## Motion (Rule 10)

- `AnimatedContainer`/`AnimatedAlign` with `AppMotion.resolve(context,
  AppDurations.normal)` + `AppCurves.standard`. Under reduce-motion the duration
  becomes zero (an instant transition).

## Example

```dart
AppSwitch(
  value: notificationsOn,
  onChanged: (v) => setState(() => notificationsOn = v),
  semanticLabel: 'Notifications',
)
```
