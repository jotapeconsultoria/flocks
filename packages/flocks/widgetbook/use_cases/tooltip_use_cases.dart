import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppTooltip — Playground (interactive, all knobs). Hover IS the interaction
// (the balloon opens on mouse enter), so there is NO CTA.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppTooltip)
Widget tooltipPlayground(BuildContext context) {
  final theme = AppTheme.of(context);
  final message = context.knobs.string(
    label: 'message',
    initialValue: 'Tooltip text that can be long and wrap across lines',
  );
  final position = context.knobs.object.dropdown<AppTooltipPosition>(
    label: 'position',
    options: AppTooltipPosition.values,
    initialOption: AppTooltipPosition.top,
    labelBuilder: (p) => 'AppTooltipPosition.${p.name}',
  );
  final size = context.knobs.object.dropdown<AppTooltipSize>(
    label: 'size',
    options: AppTooltipSize.values,
    initialOption: AppTooltipSize.medium,
    labelBuilder: (s) => 'AppTooltipSize.${s.name}',
  );
  final maxWidth = context.knobs.double.slider(
    label: 'maxWidth (0 = no limit)',
    initialValue: 0,
    min: 0,
    max: 320,
  );
  final enabled = context.knobs.boolean(label: 'enabled', initialValue: true);

  return wbUseCase(
    context,
    name: 'AppTooltip',
    description: 'Hover the target; control message, position, size and width.',
    child: AppTooltip(
      message: message,
      position: position,
      size: size,
      maxWidth: maxWidth == 0 ? null : maxWidth,
      enabled: enabled,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorTheme.primary,
          borderRadius: theme.radiusTheme.resolve(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacings.s32,
            vertical: AppSpacings.s16,
          ),
          child: AppText(
            'Hover me',
            style: theme.textTheme.titleMedium.withColor(
              theme.colorTheme.onPrimary,
            ),
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppTooltip)
Widget tooltipStates(BuildContext context) {
  final theme = AppTheme.of(context);
  Widget target(String label) => DecoratedBox(
    decoration: BoxDecoration(
      color: theme.colorTheme.primary,
      borderRadius: theme.radiusTheme.resolve(),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.s24,
        vertical: AppSpacings.s12,
      ),
      child: AppText(
        label,
        style: theme.textTheme.titleMedium.withColor(
          theme.colorTheme.onPrimary,
        ),
      ),
    ),
  );

  return wbUseCase(
    context,
    name: 'AppTooltip',
    description: 'Every placement (hover a target to see the balloon).',
    child: Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: AppSpacings.s24,
      runSpacing: AppSpacings.s32,
      children: <Widget>[
        for (final AppTooltipPosition position in AppTooltipPosition.values)
          wbState(
            context,
            name: position.name,
            when: 'Hover to see',
            width: 150,
            child: AppTooltip(
              message: 'Tooltip on ${position.name}',
              position: position,
              child: target(position.name),
            ),
          ),
      ],
    ),
  );
}
