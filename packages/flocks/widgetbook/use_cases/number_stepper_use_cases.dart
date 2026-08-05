import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppNumberStepper — Playground (all knobs). The − / + are the interaction, so
// there is NO CTA. State is held by a small stateful demo.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppNumberStepper)
Widget numberStepperPlayground(BuildContext context) {
  final min = context.knobs.int
      .slider(label: 'min', initialValue: 0, min: 0, max: 10)
      .round();
  final max = context.knobs.int
      .slider(label: 'max', initialValue: 10, min: 1, max: 100)
      .round();
  final step = context.knobs.int
      .slider(label: 'step', initialValue: 1, min: 1, max: 10)
      .round();
  final size = context.knobs.object.dropdown<AppButtonSize>(
    label: 'size',
    options: AppButtonSize.values,
    initialOption: AppButtonSize.m,
    labelBuilder: (s) => 'AppButtonSize.${s.name}',
  );
  final enabled = context.knobs.boolean(label: 'enabled', initialValue: true);

  return wbUseCase(
    context,
    name: 'AppNumberStepper',
    description: 'Decrement / display / increment with min, max and step.',
    child: _StepperDemo(
      min: min,
      max: max < min ? min : max,
      step: step,
      size: size,
      enabled: enabled,
    ),
  );
}

class _StepperDemo extends StatefulWidget {
  const _StepperDemo({
    required this.min,
    required this.max,
    required this.step,
    required this.size,
    required this.enabled,
  });

  final int min;
  final int max;
  final int step;
  final AppButtonSize size;
  final bool enabled;

  @override
  State<_StepperDemo> createState() => _StepperDemoState();
}

class _StepperDemoState extends State<_StepperDemo> {
  num _value = 3;

  @override
  Widget build(BuildContext context) {
    final num value = _value.clamp(widget.min, widget.max);
    return AppNumberStepper(
      value: value,
      min: widget.min,
      max: widget.max,
      step: widget.step,
      size: widget.size,
      enabled: widget.enabled,
      onChanged: (v) => setState(() => _value = v),
    );
  }
}

@widgetbook.UseCase(name: 'States', type: AppNumberStepper)
Widget numberStepperStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppNumberStepper',
  description: 'At the bounds and disabled at a glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'At minimum',
        when: 'Decrement disabled',
        width: 170,
        child: AppNumberStepper(value: 0, min: 0, max: 10, onChanged: (_) {}),
      ),
      wbState(
        context,
        name: 'Middle',
        when: 'Both enabled',
        width: 170,
        child: AppNumberStepper(value: 3, min: 0, max: 10, onChanged: (_) {}),
      ),
      wbState(
        context,
        name: 'At maximum',
        when: 'Increment disabled',
        width: 170,
        child: AppNumberStepper(value: 10, min: 0, max: 10, onChanged: (_) {}),
      ),
      wbState(
        context,
        name: 'Disabled',
        when: 'Unavailable',
        width: 170,
        child: AppNumberStepper(
          value: 3,
          min: 0,
          max: 10,
          enabled: false,
          onChanged: (_) {},
        ),
      ),
    ],
  ),
);
