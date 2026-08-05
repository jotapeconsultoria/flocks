import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppInteraction — Playground (all knobs). The interaction IS the demo (hover
// for highlight/tooltip, press for the motion), so NO CTA.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppInteraction)
Widget appInteractionPlayground(BuildContext context) {
  final label = context.knobs.string(
    label: 'child text',
    initialValue: 'Tap me',
  );
  final tooltip = context.knobs.string(
    label: 'tooltip',
    initialValue: 'Adicionar',
  );
  final motion = context.knobs.object.dropdown<AppMotionPreset>(
    label: 'motion',
    options: AppMotionPreset.values,
    initialOption: AppMotionPreset.scale,
    labelBuilder: (m) => 'AppMotionPreset.${m.name}',
  );
  final highlight = context.knobs.boolean(
    label: 'highlight',
    initialValue: true,
  );
  final enabled = context.knobs.boolean(label: 'enabled', initialValue: true);
  final loading = context.knobs.boolean(label: 'loading', initialValue: false);
  final padding = wbSpacingKnob(
    context,
    label: 'padding',
    initial: AppSpacings.s12,
  );

  return wbUseCase(
    context,
    name: 'AppInteraction',
    description: 'Hover for highlight + tooltip; press for the motion.',
    child: AppInteraction(
      tooltip: tooltip.isEmpty ? null : tooltip,
      motion: motion,
      highlight: highlight,
      enabled: enabled,
      loading: loading,
      padding: EdgeInsets.all(padding),
      onTap: () {},
      child: AppText(label),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppInteraction)
Widget appInteractionStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppInteraction',
  description: 'Default, no highlight, loading and disabled at a glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Default',
        when: 'Hover to highlight',
        width: 150,
        child: AppInteraction(
          tooltip: 'Adicionar',
          padding: const EdgeInsets.all(AppSpacings.s12),
          onTap: () {},
          child: const AppText('Tap me'),
        ),
      ),
      wbState(
        context,
        name: 'No highlight',
        when: 'Bare target',
        width: 150,
        child: AppInteraction(
          highlight: false,
          padding: const EdgeInsets.all(AppSpacings.s12),
          onTap: () {},
          child: const AppText('Tap me'),
        ),
      ),
      wbState(
        context,
        name: 'Loading',
        when: 'Awaiting result',
        width: 150,
        child: AppInteraction(
          loading: true,
          padding: const EdgeInsets.all(AppSpacings.s12),
          onTap: () {},
          child: const AppText('Tap me'),
        ),
      ),
      wbState(
        context,
        name: 'Disabled',
        when: 'Unavailable',
        width: 150,
        child: AppInteraction(
          enabled: false,
          padding: const EdgeInsets.all(AppSpacings.s12),
          onTap: () {},
          child: const AppText('Tap me'),
        ),
      ),
    ],
  ),
);

// ---------------------------------------------------------------------------
// AppHoverHighlight — visual-only hover. No CTA and no States grid of pressed/
// focused: it has neither. The two cases contrast it with AppInteraction, which
// is the whole reason it exists.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppHoverHighlight)
Widget appHoverHighlightPlayground(BuildContext context) {
  final padding = wbSpacingKnob(
    context,
    label: 'padding',
    initial: AppSpacings.s8,
  );
  final radius = wbRadiusKnob(context, label: 'borderRadius');

  return wbUseCase(
    context,
    name: 'AppHoverHighlight',
    description:
        'Hover highlight with no gesture, no focus and no Tab stop. It exists '
        'for overlay triggers (AppMenu, AppPopover) that already own the click '
        'and the focus: wrapping their content in AppInteraction would add a '
        'second target — an extra Tab stop and the classic double-toggle. Drop '
        'padding to 0 and the highlight collapses onto the text: that padding '
        'is what gives the painted area a body.',
    child: AppHoverHighlight(
      padding: EdgeInsets.all(padding),
      borderRadius: BorderRadius.circular(radius),
      child: const AppText('Hover me'),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppHoverHighlight)
Widget appHoverHighlightStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppHoverHighlight',
  description:
      'Same highlight, different geometry — and the contrast with '
      'AppInteraction, which does own the gesture. Hover both: they look the '
      'same; Tab through them: only AppInteraction stops.',
  maxWidth: 640,
  panelPadding: AppSpacings.s32,
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s24,
    children: [
      wbState(
        context,
        name: 'with padding',
        width: 190,
        child: const AppHoverHighlight(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacings.s8,
            vertical: AppSpacings.s4,
          ),
          child: AppText('Has a body'),
        ),
      ),
      wbState(
        context,
        name: 'no padding',
        width: 190,
        child: const AppHoverHighlight(child: AppText('Collapses')),
      ),
      wbState(
        context,
        name: 'AppInteraction (owns it)',
        width: 190,
        child: AppInteraction(
          onTap: () {},
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacings.s8,
            vertical: AppSpacings.s4,
          ),
          child: const AppText('Tab stops here'),
        ),
      ),
    ],
  ),
);
