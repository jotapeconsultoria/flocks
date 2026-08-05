# AppScrollEdgeFade & AppScrollEdgeFadeOwner

Fades the edge of content that **scrolls**, so the cut against a fixed header or
footer is not a hard line.

## When to use

- The scrollable body of a sheet, dialog or panel with a fixed bar.
- A horizontal list that continues past the visible edge.

## When NOT to use

- An explicit separation between two regions → `AppDivider`.
- Content that does not scroll: the veil never appears, but the wrapper stays as
  dead weight.

## The veil only exists when there is something to hide

The gradient runs from the surface color (100%) to transparent (0%), and only on
the side where **hidden content actually exists**. With no scrolling possible,
nothing is painted.

That is a rule, not a detail: a permanent gradient says "there is more down
here" when there is not — the exact opposite of what the affordance is for. A
user who drags and sees nothing happen stops trusting the signal.

## Passive

`IgnorePointer` over the veil: touches pass through and reach the content. The
veil never eats a click meant for an item that ended up half-faded at the edge.

## The color is the REAL surface's

The default is `surfaceContainer` (cards, sheets, panels). When the content sits
on `surface` — the header, the rail — pass `color: colorTheme.surface`. The veil
fades *to a color*; if that color is not the background's, the gradient ends in a
visibly different band instead of disappearing.

## AppScrollEdgeFadeOwner: whoever knows where the content starts decides

A component that scrolls internally (tabs, stacked panels) already fades its own
content. But the outer `AppScrollEdgeFade` keeps listening to the **same** scroll
and paints its veil at the edge of the whole area — which is not the content's
edge there. In a sheet with tabs, the gradient fell over the tab bar.

`AppScrollEdgeFadeOwner` marks "from here inward the veil is mine" and switches
the ancestor off while it is mounted:

```dart
AppScrollEdgeFadeOwner(          // switches off the outer veil…
  child: Column(
    children: <Widget>[
      tabBar,
      Expanded(child: AppScrollEdgeFade(child: content)), // …and handles this one
    ],
  ),
);
```

With no `AppScrollEdgeFade` above it, it is a pass-through — mounting it on its
own is not an error, and that is deliberate: a component with tabs should not
have to know whether someone up there wrapped it.

## Accessibility

Purely visual and non-interactive: it does not enter the semantics tree, does
not intercept touches, and keyboard or screen-reader scrolling stays identical.

## Example

```dart
AppScrollEdgeFade(child: SingleChildScrollView(child: body));
```
