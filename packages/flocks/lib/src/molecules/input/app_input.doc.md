# AppInput

The design system's text field. Built on a **bare `EditableText`** — no
Material, no Cupertino — and responsible for everything a field has to have:
label, help, error, icons, counter, multiline, mouse selection and keyboard
focus.

It is the design system's highest-traffic component (hundreds of call sites).
Almost any change here is felt in every form in the product — which makes it the
worst place for a one-off fix and the best one for a rule.

## When to use

- Any form text input.
- An action field that opens a picker (date, time, color): pass `onTap` and the
  touch fires the action instead of placing the caret. That is how
  `AppDatePickerInput`, `AppTimePickerInput`, `AppDateTimePickerInput` and
  `AppColorPickerInput` are built.

## When NOT to use

- Choosing from a list of options → `AppDropdown` / `AppSearchableDropdown`.
- Global search with autocomplete → `AppOmniSearch`.
- A search field inside a design system panel (dropdown, menu): they already
  embed their own, simpler one.

## Anatomy

| Region | Props |
| --- | --- |
| Label above | `label`, `info` (a help popover beside it) |
| Field | `controller`/`initialValue`, `hintText`, `prefixIcon`, `suffixIcon` + `onSuffixIconTap`, `onClear` |
| Below | `helperText`, `errorText`, the counter (`maxLength` + `showCounter`) |

`helperText` and `errorText` occupy the **same line**: the error message
replaces the help one instead of stacking, otherwise the whole form jumps
downward on the first validation.

## Error state

Two doors, deliberately: `hasError` (the red frame only, when the message lives
somewhere else — a summary at the top of the form) and `errorText` (frame +
message). With an error **and** content, the suffix becomes a "✕" that clears the
field: in the state where the user most wants to start over, starting over is one
tap.

## Global axes

It takes part in the style (`AppStyle`) and shape (`AppRadiusMode`) axes, like
`AppCard`/`AppDropdown`:

- **`outlined`** (the field's default): the border carries the state — rest /
  focus / error / disabled.
- **`filled`** / **`elevated`**: they change the container's treatment; the state
  color migrates to the fill and to the focus ring.

The colors come from `inputFieldColors`, the same recipe as the dropdown's
trigger — a field and a picker side by side in a form have to read as siblings.

`size` (`AppFieldSize.s/m/l` = 40/48/56) sets the height; `isDense` tightens the
inner padding for dense grids without changing the size family.

## Cross-platform (Rule 7)

Mouse selection with web parity (double/triple click, dragging, the context
menu) comes from `AppTextSelectionGestures` over the bare `EditableText`. It is
the reason the field is not a `TextField`: the selection recipe needs
`rendererIgnoresPointer: true` and controls of its own, and swapping that
halfway makes copy/paste disappear.

Tab focus runs through `FlocksInteraction`, so the focus ring appears during
keyboard navigation and disappears on touch.

## Accessibility

It exposes `textField: true` with `label` as the label; the error enters as a
live region, so the screen reader announces the validation without the user
having to go back to the field. `info` is a labelled button, not a mute icon.

## Example

```dart
AppInput(
  label: 'Email',
  hintText: 'name@domain.com',
  prefixIcon: AppIconToken.user,
  helperText: 'We use your email for sign-in only.',
  keyboardType: TextInputType.emailAddress,
  onChanged: form.setEmail,
);

// An action field: the touch opens a picker instead of editing.
AppInput(
  label: 'Date',
  readOnly: true,
  controller: dateController,
  suffixIcon: AppIconToken.calendar,
  onTap: openDatePicker,
);
```

## `textAlign`

Horizontal alignment of the typed text AND the hint (they move together — a
left hint over centered text would lie). `start` is the default field;
`center` is the OTP code field; `end` aligns numeric values. The free
`TextStyle` stays out on purpose: the text style belongs to the typography
axis.
