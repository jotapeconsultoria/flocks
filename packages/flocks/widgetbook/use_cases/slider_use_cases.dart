import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppSlider — the range control. The Playground holds its own value in a
// StatefulBuilder so the drag actually moves (the component is controlled).
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppSlider)
Widget appSliderPlayground(BuildContext context) {
  final double min = context.knobs.double.slider(
    label: 'min',
    initialValue: 1,
    max: 30,
  );
  final double max = context.knobs.double.slider(
    label: 'max',
    initialValue: 60,
    min: 31,
    max: 120,
  );
  final String stepChoice = context.knobs.object.dropdown<String>(
    label: 'step (none = continuous)',
    options: const <String>['none', '0.1', '1', '5'],
    initialOption: '1',
  );
  final double? step = stepChoice == 'none' ? null : double.parse(stepChoice);
  final bool showValue = context.knobs.boolean(
    label: 'showValue',
    initialValue: true,
  );
  final bool enabled = context.knobs.boolean(
    label: 'enabled (onChanged != null)',
    initialValue: true,
  );
  final String semanticLabel = context.knobs.string(
    label: 'semanticLabel',
    initialValue: 'Sending rate',
  );
  final Color? color = wbSemanticColorKnob(context, label: 'color');
  final double trackThickness = wbStrokeKnob(
    context,
    label: 'trackThickness',
    initial: AppStrokes.l,
  );
  final double thumbSize = wbSizeKnob(
    context,
    label: 'thumbSize',
    initial: AppSizes.s16,
  );

  double value = min + (max - min) / 2;
  return wbUseCase(
    context,
    name: 'AppSlider',
    description:
        'Controlled range input: value + onChanged, state in the caller. '
        'step quantizes in domain units; formatValue feeds both the inline '
        'label and the screen reader.',
    child: StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) => SizedBox(
        width: 320,
        child: AppSlider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          step: step,
          showValue: showValue,
          formatValue: (double v) => '${v.round()}/min',
          semanticLabel: semanticLabel,
          color: color,
          trackThickness: trackThickness,
          thumbSize: thumbSize,
          onChanged: enabled ? (double v) => setState(() => value = v) : null,
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppSlider)
Widget appSliderStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppSlider',
  description:
      'Rest at mid-range, the two extremes, the stepped variant with its '
      'inline value label, and disabled.',
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s24,
    children: <Widget>[
      wbState(
        context,
        name: 'rest (50%)',
        width: 280,
        child: AppSlider(value: 0.5, onChanged: (_) {}),
      ),
      wbState(
        context,
        name: 'at-min',
        width: 280,
        child: AppSlider(value: 0, onChanged: (_) {}),
      ),
      wbState(
        context,
        name: 'at-max',
        width: 280,
        child: AppSlider(value: 1, onChanged: (_) {}),
      ),
      wbState(
        context,
        name: 'stepped + showValue',
        width: 280,
        child: AppSlider(
          value: 42,
          min: 1,
          max: 60,
          step: 1,
          showValue: true,
          formatValue: (double v) => '${v.round()}/min',
          onChanged: (_) {},
        ),
      ),
      wbState(
        context,
        name: 'disabled',
        width: 280,
        child: const AppSlider(value: 0.35, onChanged: null),
      ),
    ],
  ),
);
