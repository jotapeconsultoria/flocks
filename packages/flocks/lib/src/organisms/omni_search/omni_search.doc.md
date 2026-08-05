# AppOmniSearch

Global search: **one field, two sources**. Async autocomplete with results
grouped by entity, plus a command palette triggered by `/`.

## When to use

- Search that crosses several entities from a single field (plate, IMEI, ICCID,
  driver…).
- A command palette combined with search.

## When NOT to use

- Selection from a fixed, known list → `AppSearchableDropdown`.
- Filtering a table → that toolbar's own field.

## The two sources

| Term | Where it goes |
| --- | --- |
| ordinary | `onSearch`, async, with a `debounce` |
| starts with `/` | **never leaves the machine**: it resolves locally in `AppCommandScope`'s `AppCommandRegistry` |

Commands are local for two reasons: they stay instant (nobody wants to wait on
the network to open a screen) and they do not leak — without that, typing
`/logout` would send the word "logout" to the search server on every keystroke.

## Out of order

Even with a debounce, several requests are in flight. The panel **discards
out-of-order responses**: if the search for "ABC" comes back after the one for
"ABC1234", the first is ignored. Without that the list flickers back to the old
result exactly when the user has finished typing.

## Results

- **Grouped by entity** (`AppOmniSearchGroup`): the block's label is what keeps a
  list mixing plate, IMEI and ICCID readable. Without the grouping, two results of
  different kinds with similar text become noise.
- The **typed fragment is highlighted** in the title, so the user can see why
  that item matched.
- With no result, `emptyLabel` — an explicit state, not an empty panel.

## Keyboard

The arrows cross the groups (they do not stop at the boundary), Enter picks, Esc
closes. The panel **never steals focus from the field**: whoever navigates with
the arrows can keep typing without clicking back.

## Accessibility

The field is a `textField` with `hintText` as its label; the panel is a list of
options with the current item marked. `shortcut` shows the shortcut in the field
itself — a shortcut that never appears on screen does not get discovered.

## Example

```dart
AppOmniSearch(
  hintText: 'Search a vehicle, SIM or driver',
  shortcut: const AppShortcut(key: '/'),
  onSearch: (String term) => repository.search(term),
);
```
