# AppSearchFooter

**Floating search** footer (iOS Notes style): a capsule with a search field over
an `AppBarSurface`, taking part in the `AppStyle` axis
(`filled`/`outlined`/`elevated`/`glass`), with the bottom safe area built in and
an optional detached `trailing` (a compose FAB, say).

## Anatomy
- **Capsule** (`AppBarSurface`, `contentEdge: top`, circular radius by default) —
  it carries the style (including `glass` = blur + gradient).
- **Field** — a "bare" `AppInput` (`style: filled`, transparent background) with a
  search `prefixIcon` and an optional `suffixIcon` (a microphone, say).
- **Trailing** — the capsule's sibling, outside it (an `AppFloatingButton`, say).

## Usage
```dart
AppSearchFooter(
  controller: controller,
  hintText: 'Search',
  suffixIcon: AppIconToken.microphone,
  onSuffixIconTap: onVoice,
  trailing: AppFloatingButton(icon: AppIconToken.add, onPressed: onCompose),
)
```

## Glass (the Notes effect)
With `style: AppStyle.glass`, the capsule blurs the content behind it. For the
content to scroll **underneath** it, use it inside an `AppScaffold` (which
overlays glass bars on the content). It falls back to an opaque surface when
transparency is reduced (`AppTransparency`).

## When NOT to use
- Message or chat composition → `AppChatFooter`.
- A filter inside a dropdown → `AppSearchableDropdown`.
