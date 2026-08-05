# AppAvatar

Generic circular avatar. It renders a network image when `imageUrl` is
available; while that downloads it shows an `AppCircularLoading`; if the URL is
empty or the load fails, it falls back to short text or a user icon.

## When to use

- A user's or entity's photo in lists, headers, menus and detail views.

## When NOT to use

- A plain icon that does not stand for a person or entity → use **AppIcon**.

## Anatomy / states

- **Image**: `Image.network` clipped to a circle (`BoxFit.cover`).
- **Loading**: a centered `AppCircularLoading` (40% of the diameter).
- **Text fallback**: `AppText` (initials, for instance) over `neutralPrimary.s100`.
- **Icon fallback**: `AppIconToken.user` when there is no text.

The fallback icon's size scales with the diameter (`s`/`m`/`l`/`xl`).

## Accessibility (Rule 8)

- `semanticLabel` (the user's name, for instance) → image semantics with a label.
- `null` → decorative (excluded from the tree), since the name usually appears
  as text beside it.

## Theme (Rule 9)

- Colors come 100% from `AppTheme` (`neutralPrimary`) and adapt to light/dark.
  The fallback is neutral by design (it does not use the brand accent).

## Example

```dart
AppAvatar(
  size: 40,
  imageUrl: user.pictureUrl,
  fallback: user.initials,
  semanticLabel: user.name,
)
```
