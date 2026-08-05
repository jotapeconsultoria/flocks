import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppPopover — Playground (all knobs). The trigger IS the interaction (click or
// hover opens the panel), so there is NO CTA.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppPopover)
Widget popoverPlayground(BuildContext context) {
  final theme = AppTheme.of(context);
  final title = context.knobs.string(label: 'title', initialValue: 'Details');
  final showArrow = context.knobs.boolean(
    label: 'showArrow',
    initialValue: true,
  );
  final withActions = context.knobs.boolean(
    label: 'with actions',
    initialValue: true,
  );
  final triggerMode = context.knobs.object.dropdown<AppPopoverTrigger>(
    label: 'triggerMode',
    options: AppPopoverTrigger.values,
    initialOption: AppPopoverTrigger.click,
    labelBuilder: (t) => 'AppPopoverTrigger.${t.name}',
  );
  final placement = context.knobs.object.dropdown<AppOverlayPlacement>(
    label: 'placement',
    options: AppOverlayPlacement.values,
    initialOption: AppOverlayPlacement.bottomCenter,
    labelBuilder: (p) => 'AppOverlayPlacement.${p.name}',
  );
  final maxWidth = context.knobs.double.slider(
    label: 'maxWidth (0 = no limit)',
    initialValue: 260,
    min: 0,
    max: 360,
  );
  // `wbStyleKnob` e não um dropdown cru do enum: sem a opção "não
  // sobrescrever", o Playground força um estilo e o addon global fica sem
  // efeito — o catálogo deixa de mostrar o que o app vai ver.
  final style = wbStyleKnob(context, nullLabel: 'Default (elevated)');
  final glass = wbGlassKnob(context);
  final radiusMode = wbRadiusModeKnob(context);

  return wbUseCase(
    context,
    name: 'AppPopover',
    description:
        'Open the panel from the trigger; rich content with a title, '
        'body and optional actions.',
    child: AppPopover(
      title: title.isEmpty ? null : title,
      showArrow: showArrow,
      triggerMode: triggerMode,
      placement: placement,
      style: style,
      glass: glass,
      radiusMode: radiusMode,
      maxWidth: maxWidth == 0 ? null : maxWidth,
      actions: withActions
          ? <Widget>[
              AppInteraction(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacings.s16,
                  vertical: AppSpacings.s12,
                ),
                onTap: () {},
                child: AppText(
                  'Dismiss',
                  maxLines: 1,
                  style: theme.textTheme.titleMedium.copyWith(
                    color: readableStopOn(
                      theme.colorTheme.primary,
                      theme.colorTheme.surface,
                    ),
                  ),
                ),
              ),
            ]
          : null,
      trigger: DecoratedBox(
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
            'Open popover',
            style: theme.textTheme.titleMedium.withColor(
              theme.colorTheme.onPrimary,
            ),
          ),
        ),
      ),
      child: AppText(
        'The driving score blends harsh braking, cornering and average speed '
        'over the selected period.',
        style: theme.textTheme.bodyMedium.withColor(theme.colorTheme.onSurface),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppPopover)
Widget popoverStates(BuildContext context) {
  final theme = AppTheme.of(context);
  Widget trigger(String label) => DecoratedBox(
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
    name: 'AppPopover',
    description: 'Each container style (open a trigger to compare).',
    child: Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: AppSpacings.s24,
      runSpacing: AppSpacings.s32,
      children: <Widget>[
        for (final AppStyle style in AppStyle.values)
          wbState(
            context,
            name: 'AppStyle.${style.name}',
            when: 'Open to compare',
            width: 180,
            child: AppPopover(
              title: 'Details',
              style: style,
              maxWidth: 240,
              trigger: trigger(style.name),
              child: AppText(
                'A rich panel anchored to the trigger.',
                style: theme.textTheme.bodyMedium.withColor(
                  theme.colorTheme.onSurface,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
