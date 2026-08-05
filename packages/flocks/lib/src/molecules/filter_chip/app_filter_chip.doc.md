# AppFilterChip

Filled chip showing a filter currently applied — `field: value` — with its own
`×` target to clear it. The sibling of `AppSuggestionChip`: that one invites you
to apply something, this one reports what is applied and lets you undo it.

Without it, an applied filter is invisible state: the list looks short and
nobody remembers why.

## Anatomy

- `field` (attenuated) + `value` (full weight). Fast reading lands on the value,
  which is what tells one chip from another in a row of them.
- `style` defaults to `filled` — an applied filter is *state*, and state reads
  by fill. `AppSuggestionChip` is an *action*, and action reads by border.
- `onRemove` renders the `×`; omitting it makes the chip informational only.

## When NOT to use

- A suggestion to be applied → `AppSuggestionChip`.
- A status label → `AppBadge`.

## Accessibility (Rule 8)

- Two independent targets. Removing and editing are different actions, and a
  single target would make one of them happen by accident every time.
- The `×` announces `Remover filtro <label>`, never a bare "close".

## Example

```dart
Wrap(spacing: 8, runSpacing: 8, children: <Widget>[
  AppFilterChip(field: 'Tipo', value: 'client.created', onRemove: _clearType),
  AppFilterChip(field: 'Resultado', value: 'Negado', onRemove: _clearResult),
])
```
