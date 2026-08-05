import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppDatePicker — the raw calendar panel (reused inside AppDatePickerInput and
// AppPickerAnchor). Clicking a day IS the interaction, so there is NO CTA.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppDatePicker)
Widget appDatePickerPlayground(BuildContext context) {
  final int year = context.knobs.int
      .slider(label: 'initial year', initialValue: 2026, min: 2024, max: 2028)
      .round();
  final int month = context.knobs.int
      .slider(label: 'initial month', initialValue: 7, min: 1, max: 12)
      .round();
  final bool bounded = context.knobs.boolean(
    label: 'restrict to that year',
    initialValue: false,
  );
  final bool markToday = context.knobs.boolean(
    label: 'mark today',
    initialValue: true,
  );
  return wbUseCase(
    context,
    name: 'AppDatePicker',
    description:
        'Month/year calendar; pick a day, or tap the header to jump '
        'across months and years. firstDate/lastDate bound the range.',
    child: SizedBox(
      width: 300,
      child: AppDatePicker(
        initialDate: DateTime(year, month, 14),
        firstDate: bounded ? DateTime(year) : DateTime(2020),
        lastDate: bounded ? DateTime(year, 12, 31) : DateTime(2030, 12, 31),
        markToday: markToday,
        onDateSelected: (_) {},
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppDateRangePicker)
Widget appDateRangePickerPlayground(BuildContext context) {
  final bool preset = context.knobs.boolean(
    label: 'preset range',
    initialValue: true,
  );
  final bool markToday = context.knobs.boolean(
    label: 'mark today',
    initialValue: true,
  );
  return wbUseCase(
    context,
    name: 'AppDateRangePicker',
    description:
        'Range calendar; tap the start day, then the end day. Endpoints '
        'get the filled pill and the days between them a continuous band.',
    child: SizedBox(
      width: 300,
      child: AppDateRangePicker(
        initialRange: preset
            ? AppDateRange(DateTime(2027, 9, 9), DateTime(2027, 9, 18))
            : null,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030, 12, 31),
        markToday: markToday,
        onRangeSelected: (_) {},
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppDateRangePicker)
Widget appDateRangePickerStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppDateRangePicker',
  description:
      'A complete range, a start-only selection and a cross-month '
      'range at a glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Complete',
        when: 'Start and end chosen',
        width: 300,
        child: SizedBox(
          width: 300,
          child: AppDateRangePicker(
            initialRange: AppDateRange(
              DateTime(2027, 9, 9),
              DateTime(2027, 9, 18),
            ),
            firstDate: DateTime(2020),
            lastDate: DateTime(2030, 12, 31),
            onRangeSelected: (_) {},
          ),
        ),
      ),
      wbState(
        context,
        name: 'Start only',
        when: 'Awaiting the end',
        width: 300,
        child: SizedBox(
          width: 300,
          child: AppDateRangePicker(
            initialRange: AppDateRange(DateTime(2027, 9, 12)),
            firstDate: DateTime(2020),
            lastDate: DateTime(2030, 12, 31),
            onRangeSelected: (_) {},
          ),
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppDatePicker)
Widget appDatePickerStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppDatePicker',
  description:
      'A free month, a bounded range and a different month at a glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Selected',
        when: 'A day is chosen',
        width: 300,
        child: SizedBox(
          width: 300,
          child: AppDatePicker(
            initialDate: DateTime(2026, 7, 14),
            firstDate: DateTime(2020),
            lastDate: DateTime(2030, 12, 31),
            onDateSelected: (_) {},
          ),
        ),
      ),
      wbState(
        context,
        name: 'Bounded',
        when: 'Days outside range disabled',
        width: 300,
        child: SizedBox(
          width: 300,
          child: AppDatePicker(
            initialDate: DateTime(2026, 7, 14),
            firstDate: DateTime(2026, 7, 10),
            lastDate: DateTime(2026, 7, 20),
            onDateSelected: (_) {},
          ),
        ),
      ),
      wbState(
        context,
        name: 'Other month',
        when: 'Different view',
        width: 300,
        child: SizedBox(
          width: 300,
          child: AppDatePicker(
            initialDate: DateTime(2026, 2, 10),
            firstDate: DateTime(2020),
            lastDate: DateTime(2030, 12, 31),
            onDateSelected: (_) {},
          ),
        ),
      ),
    ],
  ),
);
