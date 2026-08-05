import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppCopyButton — Playground (all knobs). The click IS the demo (icon and
// tooltip swap, then revert), so NO CTA.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppCopyButton)
Widget appCopyButtonPlayground(BuildContext context) {
  final value = context.knobs.string(
    label: 'value',
    initialValue: '860123456789012',
  );
  final copyTooltip = context.knobs.string(
    label: 'copyTooltip',
    initialValue: 'Copiar',
  );
  final copiedTooltip = context.knobs.string(
    label: 'copiedTooltip',
    initialValue: 'Copiado!',
  );
  final iconSize = context.knobs.object.dropdown<AppIconSize>(
    label: 'iconSize',
    options: AppIconSize.values,
    initialOption: AppIconSize.s,
    labelBuilder: (s) => 'AppIconSize.${s.name}',
  );
  final tooltipPosition = context.knobs.object.dropdown<AppTooltipPosition>(
    label: 'tooltipPosition',
    options: AppTooltipPosition.values,
    initialOption: AppTooltipPosition.top,
    labelBuilder: (p) => 'AppTooltipPosition.${p.name}',
  );
  final enabled = context.knobs.boolean(label: 'enabled', initialValue: true);
  final padding = wbSpacingKnob(
    context,
    label: 'padding',
    initial: AppSpacings.s4,
  );
  // The real default is `kAppCopiedFeedback` (1600ms); the knob offers the
  // duration tokens, so it starts on the nearest one.
  final copiedDuration = wbDurationKnob(
    context,
    label: 'copiedDuration',
    initial: AppDurations.loopSlow,
  );
  final color = wbSemanticColorKnob(context, label: 'color (rest)');

  return wbUseCase(
    context,
    name: 'AppCopyButton',
    description:
        'Click to copy: the icon becomes a check and the tooltip flips.',
    child: AppCopyButton(
      color: color,
      copiedDuration: copiedDuration,
      copiedTooltip: copiedTooltip,
      copyTooltip: copyTooltip,
      enabled: enabled,
      iconSize: iconSize,
      padding: EdgeInsets.all(padding),
      tooltipPosition: tooltipPosition,
      value: value,
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppCopyButton)
Widget appCopyButtonStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppCopyButton',
  description: 'Rest, copied and disabled at a glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Rest',
        when: 'Hover for the tooltip',
        child: const AppCopyButton(value: '860123456789012'),
      ),
      wbState(
        context,
        name: 'Copied',
        // The copied state only exists after a click, so this card holds it
        // instead of reverting — that way it can be compared side by side.
        when: 'Click once — it holds',
        child: const AppCopyButton(
          copiedDuration: Duration(days: 1),
          value: '860123456789012',
        ),
      ),
      wbState(
        context,
        name: 'Disabled',
        when: 'Nothing to copy',
        child: const AppCopyButton(enabled: false, value: ''),
      ),
    ],
  ),
);
