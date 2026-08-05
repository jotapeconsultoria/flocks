import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppTimePicker — the raw wheels panel (reused inside AppTimePickerInput).
// Scrolling a wheel IS the interaction, so there is NO CTA.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppTimePicker)
Widget appTimePickerPlayground(BuildContext context) {
  final int hour = context.knobs.int
      .slider(label: 'initialHour', initialValue: 9, min: 0, max: 23)
      .round();
  final int minute = context.knobs.int
      .slider(label: 'initialMinute', initialValue: 30, min: 0, max: 59)
      .round();
  final int minHour = context.knobs.int
      .slider(label: 'minHour', initialValue: 0, min: 0, max: 23)
      .round();
  final bool seconds = context.knobs.boolean(
    label: 'showSeconds',
    initialValue: false,
  );
  return wbUseCase(
    context,
    name: 'AppTimePicker',
    description:
        '24h scroll wheels for hours/minutes (and optional seconds); '
        'values below the minimum are disabled.',
    child: SizedBox(
      width: 280,
      child: AppTimePicker(
        initialHour: hour,
        initialMinute: minute,
        minHour: minHour,
        showSeconds: seconds,
        onTimeSelected: (_) {},
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppTimePicker)
Widget appTimePickerStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppTimePicker',
  description: 'HH:mm, HH:mm:ss and a bounded minimum at a glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'HH:mm',
        when: 'Hours + minutes',
        width: 240,
        child: SizedBox(
          width: 240,
          child: AppTimePicker(
            initialHour: 9,
            initialMinute: 30,
            onTimeSelected: (_) {},
          ),
        ),
      ),
      wbState(
        context,
        name: 'HH:mm:ss',
        when: 'With seconds',
        width: 280,
        child: SizedBox(
          width: 280,
          child: AppTimePicker(
            initialHour: 9,
            initialMinute: 30,
            initialSecond: 15,
            showSeconds: true,
            onTimeSelected: (_) {},
          ),
        ),
      ),
      wbState(
        context,
        name: 'Min bound',
        when: 'Hours below 8 disabled',
        width: 240,
        child: SizedBox(
          width: 240,
          child: AppTimePicker(
            initialHour: 9,
            initialMinute: 30,
            minHour: 8,
            onTimeSelected: (_) {},
          ),
        ),
      ),
    ],
  ),
);
