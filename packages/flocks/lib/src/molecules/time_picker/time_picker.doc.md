# AppTimePicker

Hour and minute wheels (and seconds, optionally) in 24h format. The **bare** time
panel — no field, no overlay. It is what `AppTimePickerInput` assembles
underneath.

## When to use

- A hand-assembled time panel.
- Time selection kept visible on a screen.

## When NOT to use

- A form field → `AppTimePickerInput`, which brings the mask and typing.
- A duration (2h30) → a numeric field. This is a time **of day**.

## Finite wheels

The list **stops** at 00 and at 23; it is not circular. Spinning forever looks
elegant and removes the only reference the user has for where they are — with
finite wheels the end is felt, not hunted for.

## 24h, always

The product is operational: shift rosters, service windows, cutoff times. AM/PM
introduces a 12-hour error that goes unnoticed in review and only surfaces when
the command fires at the wrong time.

## The minimum disables, it does not hide

`minHour`/`minMinute`/`minSecond` leave the earlier values **disabled**. Removing
them would shrink the wheel and the user would conclude that the list starts
there — never knowing a limit exists, or where it came from.

The case that motivates the floors is "end time after the start time": the limit
is not fixed, it comes from another field. Tying it here avoids validating later,
once the user has already chosen.

## Accessibility

Each wheel is a keyboard-navigable list, with the current value announced on
change. Disabled items **announce their state** — the limit cannot depend on
their merely being lighter.

## Example

```dart
AppTimePicker(
  initialHour: 8,
  onTimeSelected: (({int hour, int minute, int second}) t) =>
      form.setTime(t.hour, t.minute),
);

// The end time tied to the start.
AppTimePicker(
  minHour: start.hour,
  minMinute: start.minute,
  onTimeSelected: form.setEnd,
);
```
