import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppSwatch — Playground (all knobs) + States (square vs circle). Static; no CTA.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppSwatch)
Widget appSwatchPlayground(BuildContext context) {
  final color = context.knobs.color(
    label: 'color',
    initialValue: const Color(0xFF1E88E5),
  );
  final size = wbSizeKnob(context, label: 'size', initial: AppSizes.s24);
  final shape = context.knobs.object.dropdown<AppSwatchShape>(
    label: 'shape',
    options: AppSwatchShape.values,
    initialOption: AppSwatchShape.square,
    labelBuilder: (s) => 'AppSwatchShape.${s.name}',
  );

  return wbUseCase(
    context,
    name: 'AppSwatch',
    description: 'A color sample; square or circle.',
    child: AppSwatch(color: color, size: size, shape: shape),
  );
}

@widgetbook.UseCase(name: 'States', type: AppSwatch)
Widget appSwatchStates(BuildContext context) {
  const List<Color> colors = <Color>[
    Color(0xFF1E88E5),
    Color(0xFFE53935),
    Color(0xFF43A047),
    Color(0xFFFDD835),
    Color(0xFFFFFFFF),
  ];
  return wbUseCase(
    context,
    name: 'AppSwatch',
    description: 'Square and circle across sample colors.',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: AppSpacings.s12,
          children: [
            for (final c in colors) AppSwatch(color: c, size: AppSizes.s32),
          ],
        ),
        const SizedBox(height: AppSpacings.s16),
        Wrap(
          spacing: AppSpacings.s12,
          children: [
            for (final c in colors)
              AppSwatch(
                color: c,
                size: AppSizes.s32,
                shape: AppSwatchShape.circle,
              ),
          ],
        ),
      ],
    ),
  );
}
