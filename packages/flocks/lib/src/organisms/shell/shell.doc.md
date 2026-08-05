# AppShell

The desktop workspace's skeleton: **rail**, **header**, **content** and **side
panel**.

## Geometry

```
┌──────────────────────────────────────┬────────┐
│ header                               │        │
├────────┬─────────────────────────────┤ aside  │
│        │ ╭─────────────────────────╮ │        │
│  rail  │ │        content          │ │        │
│        │ ╰─────────────────────────╯ │        │
└────────┴─────────────────────────────┴────────┘
```

- `aside` takes the **full height**, top to bottom;
- `header` runs from the left edge **up to** the `aside` — it is not full-width;
- `rail` sits **below** the header, it does not cross it;
- `content` is a **floating card**: rounded corners on all four sides and a
  margin that lifts it off the bottom.

## When to use

- A work app with side navigation and an always-present panel.
- When the content should read as a card over the background.

## When NOT to use

- A single screen with no persistent navigation → `AppScaffold`.
- An authentication layout → `AppAuthSplitLayout`.

## Continuity by color, not by geometry

Rail, header and aside share `colorTheme.surface` and have **no** dividers
between them: the frame around the content reads as a single piece. The contrast
comes from the card, in `colorTheme.surfaceContainer`.

That holds in **both themes**. The shell pins neither light nor dark — the app's
`AppThemeScope` decides. Do not nest a fixed theme here just to reproduce a dark
mockup: the surface/surfaceContainer pair already provides the contrast in both.

## Widths

The shell does **not** impose a width on `rail` or on `aside`; each one sizes
itself. That is what allows the side panel to be draggable without the design
system having to know anything about persistence — the same philosophy as
`AppResizableSplit`.

```dart
AppShell(
  rail: AppNavigationRail(items: items, footer: footer, logoCollapsed: logo),
  header: shellHeader,
  aside: SizedBox(width: asideWidth, child: AppAssistantPanel(...)),
  content: workspace,
);
```

## Fullscreen

`fullscreen: true` hides the rail, the header and the aside. The `content`
**stays in the same place in the tree**, so the state of the mounted screens
(maps, live tabs) survives the toggle — there is no remount.

## Accessibility

Layout only: it creates no semantics nodes of its own and captures no focus.
Traversal order is header → rail → content → aside.
