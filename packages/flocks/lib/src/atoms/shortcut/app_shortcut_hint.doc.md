# AppShortcutHint

Badge that **shows** a keyboard shortcut. A shortcut nobody sees goes unused —
this is the component that makes it discoverable, with no tour and no
documentation.

## When to use

- At the far right of a field, button, tab or menu item that has a shortcut.
- To teach a new shortcut in the place where it is useful.

## When NOT to use

- To **register** the shortcut → `AppShortcutsScope`/`Shortcuts`. The badge only
  draws.
- A generic label in a pill → `AppBadge`.

## AppShortcut: describe, don't write

The badge does not take ready-made text; it takes an `AppShortcut` — key +
modifiers — and resolves it at paint time:

```dart
const AppShortcut.primary('K')   // ⌘K on macOS/iOS · Ctrl+K everywhere else
const AppShortcut('/')           // /
```

Writing `'Ctrl+K'` in a `String` teaches the wrong key to half the users, and
the mistake is invisible to whoever wrote it (it works on their machine). That
is why the platform enters the component, not the call site.

`semanticsLabel()` walks the other way for the screen reader: "Command K",
spelled out, because no reader pronounces `⌘`.

## Decorative by definition

The badge **takes no pointer input**. It indicates that a shortcut exists;
whoever wants the action clickable puts the badge *inside* the control itself. A
clickable badge would be a second target competing with the control it merely
annotates.

## Color: the surface picks it

The color comes from a legible `secondary` stop (not from grey — the shortcut is
new in the product and needs to be noticed). The stop depends on **where the
badge is set**:

- default `surfaceContainer` — cards, sheets, the composer, tabs;
- pass `background: colorTheme.surface` in the header and in the rail.

A fixed value scored 3.88 in light and 1.61 in dark in some combinations. And
inside a painted control (the `trailing` of a filled button) the surface is not
even the theme's: whatever paints it installs `AppShortcutHintColor` with its own
foreground, and the badge consumes that.

## Geometry

**Fixed** height per size (20 / 24) and a square width floor. Without that the
box would follow the font's metrics — `⌘` rises higher than a digit, `1` is much
narrower than `3` — and a row of tabs would show badges of differing sizes.

## Accessibility

A single node labelled `Shortcut: Command K`, with `excludeSemantics` so the
keys are not read one by one. The fixed height also guards against deforming at
large text scales.

## Example

```dart
AppShortcutHint(
  const AppShortcut.primary('K'),
  size: AppShortcutHintSize.m,
  background: theme.colorTheme.surface,
);
```
