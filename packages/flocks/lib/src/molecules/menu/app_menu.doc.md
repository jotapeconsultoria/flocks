# AppMenu

**Action** menu anchored to a `trigger` (a popup / context menu). It shows a list
of `AppMenuItem`s (with an optional icon and destructive items), groupable into
`AppMenuSection`s and separable by `AppMenuDivider`s. It renders through the
`Overlay`, anchored by a `LayerLink` (transform-safe), and re-provides the theme
inside the entry.

**Not to be confused with `AppDropdown`**: that one is a form *select* (it picks
a value); `AppMenu` fires *actions*.

## When to use

- Contextual actions for an element (edit / duplicate / delete).
- An overflow menu (⋯) in a toolbar, or a right-click menu.

## When NOT to use

- Choosing a value in a form → use `AppDropdown`.
- Showing rich content (text, fields) → use `AppPopover`.

## Anatomy / states

- **Trigger**: passive content (an icon, text, a box) — the menu makes it
  actionable on click (and on right-click / long-press when
  `openOnSecondaryTap`).
- **Panel**: an `AppCard`, minimum width `minWidth` (176 by default), sized to the
  widest item. **style** (the `AppStyle` axis): `elevated` (its own default, a
  shadow) / `outlined` (a border) / `filled` (flat) — it does not follow the
  global `styleTheme`. The **shape** follows the global radius
  (`radiusMode`/`radius`).
- **AppMenuItem**: an optional icon + a label. `danger: true` paints it in a
  legible `danger` against the card; `enabled: false` (or a null `onPressed`)
  dims it by tone. Hover/focus = a neutral highlight (`onSurface` 8%).
- **AppMenuSection**: an optional title (`labelSmall`, muted) + items.
- **AppMenuDivider**: an `AppDivider` between entries.
- Selecting an item fires `onPressed` and **closes** the menu. It also closes on
  an outside click and on `Esc`.

## Accessibility (Rule 8)

- The panel is a menu container (`AppSemantics.menu`); each item is a button
  (`AppSemantics.menuItem`) that merges icon and text.
- Keyboard: **Tab** and the **↑/↓ arrows** navigate; **Enter/Space** activates;
  **Esc** closes. The first item takes focus when it opens.

## Motion

- The panel enters with a **fade + pop** (`AppAppear`) and honors reduce-motion.

## Example

```dart
AppMenu(
  trigger: AppIcon(AppIconToken.settings, semanticLabel: 'Actions'),
  entries: <AppMenuEntry>[
    AppMenuItem(label: 'Edit', icon: AppIconToken.settings, onPressed: edit),
    AppMenuDivider(),
    AppMenuItem(label: 'Delete', icon: AppIconToken.remove, danger: true, onPressed: remove),
  ],
)
```

> Nested submenus are a future addition; today the menu is single-level.
