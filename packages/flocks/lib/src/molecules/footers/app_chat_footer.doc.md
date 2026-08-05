# AppChatFooter

**Chat** footer that wraps `AppChatComposer`, adding the bottom safe area (which
the composer does not handle) and the **bar** style axis (`AppStyle`, including
`glass`).

## How it works
- The **composer** is forced to `style: filled` (an opaque neutral pill).
- The **bar** (`AppBarSurface`, `contentEdge: top`) carries the style axis → no
  double styling.
- `floating: false` (the default) → a full-bleed docked band (with the safe area
  built in); `floating: true` → a rounded floating panel.

## Usage
```dart
AppChatFooter(
  controller: controller,
  hintText: 'Ask something…',
  busy: isStreaming,
  onSend: send,
  onStop: stop,
  onAttach: attach,
)
```

## Glass
With `style: AppStyle.glass`, the bar blurs the content behind it (the
composer's pill stays opaque on top). Inside an `AppScaffold`, the glass bar
overlays the content (the Notes effect). It falls back to opaque when
transparency is reduced (`AppTransparency`).

## When NOT to use
- Composing with no bar and no safe area → use `AppChatComposer` directly.
- Search → `AppSearchFooter`.
