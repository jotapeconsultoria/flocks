import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppDivider — Playground (all knobs). A rule renders a static line; there is
// no interactive transition, so NO CTA.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppDivider)
Widget appDividerPlayground(BuildContext context) {
  final axis = context.knobs.object.dropdown<Axis>(
    label: 'axis',
    options: Axis.values,
    initialOption: Axis.horizontal,
    labelBuilder: (a) => 'Axis.${a.name}',
  );
  final thickness = wbStrokeKnob(
    context,
    label: 'thickness',
    initial: AppStrokes.s,
  );
  final indent = wbSpacingKnob(
    context,
    label: 'indent',
    initial: AppSpacings.s0,
  );
  final endIndent = wbSpacingKnob(
    context,
    label: 'endIndent',
    initial: AppSpacings.s0,
  );
  final color = wbSemanticColorKnob(context);

  final horizontal = axis == Axis.horizontal;
  final divider = horizontal
      ? AppDivider(
          thickness: thickness,
          indent: indent,
          endIndent: endIndent,
          color: color,
        )
      : AppDivider.vertical(
          thickness: thickness,
          indent: indent,
          endIndent: endIndent,
          color: color,
        );

  return wbUseCase(
    context,
    name: 'AppDivider',
    description: horizontal
        ? 'A horizontal rule; fills the width between two items.'
        : 'A vertical rule; fills the bounded height between two items.',
    child: SizedBox(
      width: 260,
      height: horizontal ? null : 96,
      child: horizontal
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppText('Above'),
                const SizedBox(height: AppSpacings.s12),
                divider,
                const SizedBox(height: AppSpacings.s12),
                const AppText('Below'),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppText('Left'),
                const SizedBox(width: AppSpacings.s12),
                divider,
                const SizedBox(width: AppSpacings.s12),
                const AppText('Right'),
              ],
            ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppDivider)
Widget appDividerStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppDivider',
  description:
      'Horizontal and vertical, thickness on the stroke scale, indented, and '
      'with rounded caps. It fills the parent on its main axis — a divider '
      'that stops short of the edge reads as a mistake, not as a choice.',
  maxWidth: 720,
  panelPadding: AppSpacings.s32,
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s32,
    runSpacing: AppSpacings.s32,
    children: [
      wbState(
        context,
        name: 'horizontal',
        width: 200,
        child: const AppDivider(),
      ),
      wbState(
        context,
        name: 'thickness: l',
        width: 200,
        child: const AppDivider(thickness: AppStrokes.l),
      ),
      wbState(
        context,
        name: 'indented',
        width: 200,
        child: const AppDivider(
          indent: AppSpacings.s32,
          endIndent: AppSpacings.s32,
        ),
      ),
      wbState(
        context,
        name: 'rounded caps',
        width: 200,
        child: const AppDivider(thickness: AppStrokes.xl, radius: AppRadius.m),
      ),
      wbState(
        context,
        name: 'vertical',
        width: 200,
        child: const SizedBox(height: 64, child: AppDivider.vertical()),
      ),
      wbState(
        context,
        name: 'accent colour',
        width: 200,
        child: AppDivider(color: AppTheme.of(context).colorTheme.primary),
      ),
    ],
  ),
);
