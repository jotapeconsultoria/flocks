import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppInteractiveMotion — Playground (single, interactive, all knobs).
// The trigger (hover / focus / press) is on the target itself, so there is NO
// CTA. The consolidated `trigger` knob replaces the old OnClick/OnHover/OnFocus.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppInteractiveMotion)
Widget motionPlayground(BuildContext context) {
  final theme = AppTheme.of(context);
  final trigger = context.knobs.object.dropdown<AppMotionTrigger>(
    label: 'trigger',
    options: AppMotionTrigger.values,
    initialOption: AppMotionTrigger.hover,
    labelBuilder: (t) => 'AppMotionTrigger.${t.name}',
  );
  final scale = context.knobs.double.slider(
    label: 'scale',
    initialValue: 1.12,
    min: 0.5,
    max: 1.5,
  );
  final turns = context.knobs.double.slider(
    label: 'turns',
    initialValue: 0,
    min: -1,
    max: 1,
  );
  final duration = wbDurationKnob(context, initial: AppDurations.fast);
  final enabled = context.knobs.boolean(label: 'enabled', initialValue: true);

  return wbUseCase(
    context,
    name: 'AppInteractiveMotion',
    description: 'Scale and rotate a target on hover, focus, or press.',
    child: AppInteractiveMotion(
      trigger: trigger,
      scale: scale,
      turns: turns,
      duration: duration,
      enabled: enabled,
      onPressed: () {},
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorTheme.primary,
          borderRadius: theme.radiusTheme.resolve(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacings.s64,
            vertical: AppSpacings.s32,
          ),
          child: AppText(
            _labelFor(trigger),
            style: theme.textTheme.titleMedium.withColor(
              theme.colorTheme.onPrimary,
            ),
          ),
        ),
      ),
    ),
  );
}

/// Label that reflects the active [trigger] so the target hints at how to
/// activate the motion.
String _labelFor(AppMotionTrigger trigger) => switch (trigger) {
  AppMotionTrigger.hover => 'Hover me',
  AppMotionTrigger.focus => 'Tab to focus me',
  AppMotionTrigger.press => 'Press me',
};
