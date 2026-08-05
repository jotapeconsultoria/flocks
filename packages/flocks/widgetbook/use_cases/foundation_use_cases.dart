import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// FlocksInteraction — the shared interaction primitive. Playground paints the
// box from its WidgetState set (hover / press / focus). The interaction is on
// the component itself, so there is NO CTA.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: FlocksInteraction)
Widget flocksInteractionPlayground(BuildContext context) {
  final enabled = context.knobs.boolean(label: 'enabled', initialValue: true);
  return wbUseCase(
    context,
    name: 'FlocksInteraction',
    description:
        'Shared interaction primitive: hover, press, focus, keyboard activation.',
    child: FlocksInteraction(
      onPressed: () {},
      enabled: enabled,
      builder: (context, states) {
        final theme = AppTheme.of(context);
        var background = theme.colorTheme.primary as Color;
        if (states.contains(WidgetState.disabled)) {
          background = theme.colorTheme.neutralPrimary.s400;
        } else if (states.contains(WidgetState.pressed)) {
          background = Color.alphaBlend(const Color(0x33000000), background);
        } else if (states.contains(WidgetState.hovered)) {
          background = Color.alphaBlend(const Color(0x22FFFFFF), background);
        }
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacings.s32,
            vertical: AppSpacings.s16,
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppRadius.l),
            border: Border.all(
              color: states.contains(WidgetState.focused)
                  ? theme.colorTheme.onSurface
                  : background,
              width: AppStrokes.l,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          child: AppText(
            'Interact: hover, click, Tab + Enter',
            style: theme.textTheme.titleMedium.withColor(
              theme.colorTheme.onPrimary,
            ),
          ),
        );
      },
    ),
  );
}

// ---------------------------------------------------------------------------
// AppScaleOnTap — press-scale feedback. The interaction is pressing the child,
// so there is NO CTA.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppScaleOnTap)
Widget appScaleOnTapPlayground(BuildContext context) {
  final theme = AppTheme.of(context);
  final scale = context.knobs.double.slider(
    label: 'scale',
    initialValue: 0.96,
    min: 0.8,
    max: 1.0,
  );
  final duration = wbDurationKnob(context, initial: AppDurations.normal);
  final enabled = context.knobs.boolean(label: 'enabled', initialValue: true);
  return wbUseCase(
    context,
    name: 'AppScaleOnTap',
    description: 'Press-scale feedback on tap.',
    child: AppScaleOnTap(
      onPressed: () {},
      enabled: enabled,
      scale: scale,
      duration: duration,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorTheme.secondary,
          borderRadius: theme.radiusTheme.resolve(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacings.s16,
            vertical: AppSpacings.s8,
          ),
          child: AppText(
            'Press me (scales)',
            style: theme.textTheme.labelLarge.withColor(
              theme.colorTheme.onSecondary,
            ),
          ),
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// States — hover/press/focus só aparecem sob o cursor, um de cada vez. Aqui os
// estados são SEMEADOS num controller, para a grade mostrar todos juntos. Quem
// semeia é dono do dispose, por isso o card é stateful.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'States', type: FlocksInteraction)
Widget flocksInteractionStates(BuildContext context) => wbUseCase(
  context,
  name: 'FlocksInteraction',
  description:
      'Every interaction state at once, seeded through a FlocksStatesController '
      'instead of chased with the cursor. This is the primitive every clickable '
      'component in the DS builds on, so these five boxes are the vocabulary.',
  maxWidth: 760,
  panelPadding: AppSpacings.s32,
  child: const _InteractionStatesGrid(),
);

class _InteractionStatesGrid extends StatefulWidget {
  const _InteractionStatesGrid();
  @override
  State<_InteractionStatesGrid> createState() => _InteractionStatesGridState();
}

class _InteractionStatesGridState extends State<_InteractionStatesGrid> {
  static const Map<String, Set<WidgetState>> _cases =
      <String, Set<WidgetState>>{
        'default': <WidgetState>{},
        'hovered': <WidgetState>{WidgetState.hovered},
        'pressed': <WidgetState>{WidgetState.pressed},
        'focused': <WidgetState>{WidgetState.focused},
        'disabled': <WidgetState>{WidgetState.disabled},
      };

  late final Map<String, FlocksStatesController> _controllers =
      <String, FlocksStatesController>{
        for (final MapEntry<String, Set<WidgetState>> e in _cases.entries)
          e.key: FlocksStatesController(e.value),
      };

  @override
  void dispose() {
    for (final FlocksStatesController c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacings.s24,
      runSpacing: AppSpacings.s24,
      children: [
        for (final MapEntry<String, FlocksStatesController> e
            in _controllers.entries)
          wbState(
            context,
            name: e.key,
            width: 130,
            child: FlocksInteraction(
              onPressed: () {},
              enabled: e.key != 'disabled',
              statesController: e.value,
              builder: (BuildContext context, Set<WidgetState> states) {
                var background = theme.colorTheme.primary as Color;
                if (states.contains(WidgetState.disabled)) {
                  background = theme.colorTheme.neutralPrimary.s400;
                } else if (states.contains(WidgetState.pressed)) {
                  background = Color.alphaBlend(
                    const Color(0x33000000),
                    background,
                  );
                } else if (states.contains(WidgetState.hovered)) {
                  background = Color.alphaBlend(
                    const Color(0x22FFFFFF),
                    background,
                  );
                }
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacings.s16,
                    vertical: AppSpacings.s12,
                  ),
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: theme.radiusTheme.resolve(),
                    border: states.contains(WidgetState.focused)
                        ? Border.all(
                            color: theme.colorTheme.focusRing,
                            width: AppStrokes.l,
                          )
                        : null,
                  ),
                  child: AppText(
                    e.key,
                    style: theme.textTheme.labelLarge.withColor(
                      theme.colorTheme.onPrimary,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
