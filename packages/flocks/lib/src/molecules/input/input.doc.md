# Picker fields: AppDatePickerInput · AppTimePickerInput · AppDateTimePickerInput

The design system's three **structured-value** fields. They are the same piece —
an `AppInput` in action mode, with a typing mask and an anchored panel — varying
the mask and what the panel shows.

> The generic field is documented in [`app_input.doc.md`](app_input.doc.md).

| Component | Mask | Panel |
| --- | --- | --- |
| `AppDatePickerInput` | `DD/MM/YYYY` | a calendar |
| `AppTimePickerInput` | `HH:mm` (`:ss` with `showSeconds`) | hour wheels |
| `AppDateTimePickerInput` | `DD/MM/YYYY HH:mm` | a calendar + wheels |

## Two doors, deliberately

Typing and picking **coexist**. Whoever already knows the date types it — always
faster than navigating months in a calendar — and the mask
(`AppDateMaskFormatter` and friends) fixes the format as they type. Whoever only
knows "next Tuesday" opens the panel from the icon.

Blocking typing to "force" the calendar looks safer and is slower for everyone
who knows the value. The validation still exists on both paths.

## Bounds

`firstDate`/`lastDate` bound **the calendar and the typing**. A bound only the
panel honors is a bound the form does not have: whoever types walks straight past
it.

In the time field, the floors (`minHour`/`minMinute`/`minSecond`) exist for the
"end time after the start time" case, where the limit is not fixed — it comes
from another field.

## The panel

An elevated `AppCard` anchored to the field, exactly like `AppDropdown`'s panel.
It is the same overlay mechanics as the whole design system: the same gesture to
open, the same key to close, the same behavior when clicking outside. A form with
a dropdown and a date field should not teach two interactions.

## When NOT to use

- A date range (from/to) → `AppDateRangePicker`.
- A calendar kept visible on the screen → `AppDatePicker` directly.
- A duration (2h30) → a numeric field. These are times **of day**.
- Only the date matters → do not ask for a time for nothing; use
  `AppDatePickerInput`.

## One field or two?

`AppDateTimePickerInput` exists for the instant that is **one piece of data**
(the moment of an event, the scheduling of a command). Two separate fields let
the form accept a date with no time, and then somebody picks a silent default —
midnight — that nobody chose.

The test: if either one can exist without the other, they are two fields.

## Global axes

They inherit the style (`AppStyle`) and shape (`AppRadiusMode`) axes from
`AppInput`, plus the `AppFieldSize` scale (s/m/l = 40/48/56). The panel follows
the same axes, so the overlay does not clash with the field that opened it.

## Accessibility

A `textField` labelled by `label`, with the format in `hintText`; the icon that
opens the panel is a **labelled button**, not a mute glyph. The error enters as a
live region, so validation is announced without the user going back to the field.

## Example

```dart
AppDatePickerInput(
  label: 'Due date',
  hintText: 'DD/MM/YYYY',
  firstDate: DateTime.now(),
  onDateSelected: form.setDueDate,
);

AppDateTimePickerInput(
  label: 'Run at',
  hintText: 'DD/MM/YYYY HH:mm',
  onDateTimeSelected: form.setScheduledAt,
);
```
