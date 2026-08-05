# AppWorkspaceTabs

The desktop workspace's **browser-style** tab bar: tabs with an icon, a title and
a close button. `AppWorkspaceTabItem` describes each tab (id, title, icon).

## When to use

- Workspace tabs on desktop (open/close/select), with controlled state.

## When NOT to use

- Content tabs within a section → `AppTabView`.

## Anatomy

- A transparent **bar**; only the **active** tab has a fill (`tertiary`), with
  rounded top corners and a square base meeting the content.
- **Tab**: an icon + a title (fading at the end when narrow) + a close button
  (hover animates through motion tokens, honoring reduce-motion).
- A **controlled** component: the tabs' state lives outside (in a `TabsCubit`,
  say).

## Accessibility

The active tab is highlighted by color (`tertiary`, from the theme, AA in light
and dark). The close button has its own touch target.

## Example

```dart
AppWorkspaceTabs(
  tabs: tabs,
  activeId: active,
  onSelect: cubit.select,
  onClose: cubit.close,
);
```
