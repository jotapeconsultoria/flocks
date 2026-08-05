# AppSplitButton

**Split action** button: a primary segment (the default action) + a caret (▾)
that opens an `AppMenu` with related secondary actions. It follows `AppButton`'s
global rules — it varies along the `AppStyle` axis
(`filled`/`outlined`/`elevated`, defaulting to `theme.styleTheme.style`), accepts
a shape override (`radiusMode`/`radius`) and reuses the design system's button
color model (`appFilledButtonColors` / `appGhostButtonColors`), so both segments
look identical to an `AppButton`.

## When to use

- One default action with variations from the same family (Save · Save and exit ·
  Save as draft).
- Cutting the visual noise when several related actions compete for space.

## When NOT to use

- Unrelated actions → separate buttons or a plain `AppMenu`.
- A single action → `AppButton`.

## Anatomy / states

- **Primary segment**: an optional icon + `label`, firing `onPressed`. It is a
  real `FlocksInteraction`: hover/press deepen the background (filled/elevated)
  or highlight neutrally (outlined), with a dedicated focus ring and press-scale.
- **Divider**: a thin line between the segments.
- **Caret**: also a `FlocksInteraction` (press/focus/keyboard); the chevron
  **rotates** when it opens and anchors the `AppMenu` (`menuEntries`) at the
  bottom-right corner.
- **style**: `filled` (the theme's default), `outlined` or `elevated` (with a
  shadow) — the global `AppStyle` axis, like `AppButton`.
- **color** / **size**: the same enums as the buttons (`AppButtonColor` /
  `AppButtonSize`).
- **radiusMode** / **radius**: a per-instance shape override (they beat the
  global one).
- **loading**: a spinner in the primary segment; **enabled=false** dims by tone
  (the caret disables too).
- Each segment rounds only its own side (the global radius, with an override);
  the divider stays square. The set's border (outlined) and shadow (elevated)
  live on the outer container.

## Accessibility (Rule 8)

- Two button nodes: the primary one (`label`) and the caret
  (`menuSemanticsLabel`, "More actions" by default), both with Tab focus (a
  dedicated ring) and Enter/Space activation. The caret opens an `AppMenu` with
  Tab/arrow navigation and `Esc`.
- Highlight, rotation and press honor reduce-motion.

## Example

```dart
AppSplitButton(
  label: 'Save',
  onPressed: save,
  menuEntries: <AppMenuEntry>[
    AppMenuItem(label: 'Save and exit', onPressed: saveAndExit),
    AppMenuItem(label: 'Save as draft', onPressed: draft),
  ],
)
```
