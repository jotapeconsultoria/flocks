import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppRadio — States (reference grid) + Playground (interactive group, all knobs).
// Selector: the interaction is on the component itself, so there is NO CTA.
// Selection is `value == groupValue`, so each state fixes those two knobs.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'States', type: AppRadio)
Widget radioStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppRadio',
  description: 'Every visual state of the radio.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s16,
    runSpacing: AppSpacings.s32,
    children: [
      wbState(
        context,
        name: 'Selected',
        when: 'This option is chosen',
        child: AppRadio<int>(value: 1, groupValue: 1, onChanged: (_) {}),
      ),
      wbState(
        context,
        name: 'Unselected',
        when: 'Another option is chosen',
        child: AppRadio<int>(value: 1, groupValue: 0, onChanged: (_) {}),
      ),
      wbState(
        context,
        name: 'Selected · disabled',
        when: 'Chosen, read-only',
        child: const AppRadio<int>(value: 1, groupValue: 1, enabled: false),
      ),
      wbState(
        context,
        name: 'Unselected · disabled',
        when: 'Not chosen, read-only',
        child: const AppRadio<int>(value: 1, groupValue: 0, enabled: false),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'Playground', type: AppRadio)
Widget radioPlayground(BuildContext context) {
  final enabled = context.knobs.boolean(label: 'enabled', initialValue: true);
  final optionCount = context.knobs.int.slider(
    label: 'optionCount',
    initialValue: 3,
    min: 2,
    max: 5,
    divisions: 3,
  );
  final style = wbStyleKnob(context);
  final radiusMode = wbRadiusModeKnob(context);
  return wbUseCase(
    context,
    name: 'AppRadio',
    description:
        'Pick one option from a mutually-exclusive group. '
        'style/radius follow the addons unless overridden here.',
    child: _RadioGroupDemo(
      enabled: enabled,
      optionCount: optionCount,
      style: style,
      radiusMode: radiusMode,
    ),
  );
}

// ---------------------------------------------------------------------------
// Interactive demo (stateful) — the CTA rule does not apply: tapping a radio
// selects it and clears the rest of the group.
// ---------------------------------------------------------------------------

class _RadioGroupDemo extends StatefulWidget {
  const _RadioGroupDemo({
    required this.enabled,
    required this.optionCount,
    this.style,
    this.radiusMode,
  });

  final bool enabled;
  final int optionCount;
  final AppStyle? style;
  final AppRadiusMode? radiusMode;

  @override
  State<_RadioGroupDemo> createState() => _RadioGroupDemoState();
}

class _RadioGroupDemoState extends State<_RadioGroupDemo> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < widget.optionCount; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacings.s4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacings.s8,
              children: [
                AppRadio<int>(
                  value: i,
                  groupValue: _selected,
                  enabled: widget.enabled,
                  semanticLabel: 'Option ${i + 1}',
                  style: widget.style,
                  radiusMode: widget.radiusMode,
                  onChanged: (v) => setState(() => _selected = v ?? _selected),
                ),
                AppText('Option ${i + 1}', style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
      ],
    );
  }
}
