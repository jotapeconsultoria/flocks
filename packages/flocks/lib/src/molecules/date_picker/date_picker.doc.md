# AppDatePicker & AppDateRangePicker

The design system's two calendars, **bare**: no field, no overlay. Whoever
assembles them decides where they live — `AppDatePickerInput` opens them
anchored, a scheduling screen keeps them fixed.

| Component | Selection |
| --- | --- |
| `AppDatePicker` | one date |
| `AppDateRangePicker` | a range (tap the start, tap the end) |

## When to use

- A calendar kept visible on a screen (scheduling, a report).
- The panel of a hand-assembled date field.

## When NOT to use

- A form field → `AppDatePickerInput`, which brings the mask and validation.
- A period with a time → two `AppDateTimePickerInput`s.

## The jump to year/month

Clicking the header's label swaps the day grid for the year/month one. Without
that, picking a date of birth costs dozens of taps on the chevron — and the user
gives up and types it, if they can.

## Days outside the range are disabled, not gone

`firstDate`/`lastDate` **disable**. Hiding scrambles the grid: the columns stop
matching the days of the week and the user loses the visual reference they use to
find the date.

## `markToday` is opt-in

Highlighting today only helps when the chosen date is near today. In a historical
calendar it is noise competing with the real selection. So the default is off,
and whoever knows the context turns it on.

`today` is **injectable** — it is what makes the calendar testable without
depending on the machine's clock.

## The range band

In the range picker the range is drawn as a **continuous band** behind the days:
half a cell on the first, half on the last, a whole cell in between. The
alternative (marking each day individually) reads as "these days", not as "from
this one to that one" — and the difference matters when the range crosses weeks.

While only the start is chosen, hover previews the band up to the day under the
cursor: it answers "how long does this cover?" before the second tap.

## Accessibility

Each day is a button labelled with the date spelled out; disabled ones announce
the state instead of disappearing. The header is a button (it opens the
year/month grid), not decorative text. In the range, the day that opens it and
the one that closes it announce their role — the band cannot depend on
background color alone.

## Example

```dart
AppDatePicker(
  initialDate: DateTime.now(),
  markToday: true,
  onDateSelected: controller.select,
);

AppDateRangePicker(
  lastDate: DateTime.now(),
  onRangeSelected: filters.setPeriod,
);
```
