# AppActionItem

Action item (**icon + text**) on a clickable tinted surface, for menus and
option lists.

## When to use

- Quick actions in an option list or a menu.

## When NOT to use

- A rich list row (avatar, trailing, selection) → `AppListTile`.

## Anatomy

- A tinted **surface** (`primary.s50` by default), taking part in the `AppStyle`
  and `AppRadiusMode` axes.
- An **icon** (`secondary`) on the left + **text**
  (`bodyLarge`/`neutralPrimary.s900`, 1 line) on the right.

## Accessibility

Text with a `semanticLabel`; the icon and the text over the tinted background
pass WCAG AA in light and dark.

## Example

```dart
AppActionItem(icon: AppIconToken.support, text: 'Support', onPressed: openSupport);
```

## Direction

`Axis.horizontal` (default) is the row of always — icon left of the text.
`Axis.vertical` stacks the icon over a centered label with the same padding,
radius and colors: the cell of an attach-options grid in a sheet. Color roles
stay put in both (tinted primary fill, secondary icon) — opening the color is
a separate backlog item.
