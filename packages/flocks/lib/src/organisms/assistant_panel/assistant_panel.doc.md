# AppAssistantPanel

The assistant's side panel: **header · fixed banner · conversation · composer**,
in a full-height column beside the content.

The decision that defines the component is this: **a column, not an overlay**. An
assistant that covers the screen forces the user to choose between seeing the
data and asking about it — and they always choose wrong, because they only find
out which one they needed after closing it. Here you can talk while looking at
the screen that prompted the question.

## When to use

- An assistant that has to coexist with the content, not cover it.
- A side panel with a header, a scrollable body and a fixed composer.

## When NOT to use

- A full-screen conversation (kiosk mode) → the chat screen directly.
- An ephemeral panel triggered by a button → `AppSideSheet`.

## Anatomy

- **Header**: `avatar` + `title` + `statusLabel`, with the presence dot driven by
  `isOnline`, plus the corner's `actions`. It is where the shortcut badge lives —
  a shortcut nobody sees does not exist.
- **`alertBanner`**: a **fixed** strip between the header and the conversation. It
  sits outside the scroll on purpose: a card inside the flow leaves the viewport
  on the first scroll, and the requirement was "alerts visible at all times".
- **`body`**: the conversation (typically an `AppChatMessageList`), the only
  region that scrolls.
- **`composer`**: fixed at the bottom (typically an `AppChatComposer`).

## Width

The panel **fills whatever it is given** — the shell decides the width, not the
component. That way the same panel serves both a fixed backoffice column and an
`AppResizablePanel` the user drags.

## Global axes

Structural: it places regions and paints a background, so it takes no part in the
style or shape axes. `decoration` is the escape hatch for a shell that needs to
match the panel's border to the rest of the layout. No animation of its own —
what moves is the conversation inside the `body`.

## Accessibility

Each region brings its own semantics (the header is a header, the conversation
comes from the `AppChatBubble`s, the composer is a text field). The `alertBanner`
should enter as a live region when its content changes on its own — the panel does
not impose that, so as not to re-announce an alert that was already there when the
screen opened.

## Example

```dart
AppAssistantPanel(
  title: 'Atlas',
  statusLabel: 'Always online',
  alertBanner: alertsStrip,
  body: AppChatMessageList(itemCount: n, itemBuilder: buildMessage),
  composer: AppChatComposer(controller: controller, onSend: send),
);
```
