import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppOverlayAlert — card de alerta com cor semântica via ColorSwatch.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppOverlayAlert)
Widget overlayAlertPlayground(BuildContext context) {
  final AppColorTheme colors = AppTheme.of(context).colorTheme;
  final String title = context.knobs.string(
    label: 'title',
    initialValue: 'Falha ao salvar',
  );
  final String description = context.knobs.string(
    label: 'description',
    initialValue: 'Tente novamente em instantes.',
  );
  final ColorSwatch<int> color = context.knobs.object
      .dropdown<ColorSwatch<int>>(
        label: 'color',
        options: <ColorSwatch<int>>[
          colors.info,
          colors.success,
          colors.warning,
          colors.danger,
        ],
        labelBuilder: (ColorSwatch<int> c) => switch (c) {
          _ when c == colors.info => 'info',
          _ when c == colors.success => 'success',
          _ when c == colors.warning => 'warning',
          _ => 'danger',
        },
      );
  final AppStyle? style = wbStyleKnob(context);
  final AppRadiusMode? radiusMode = wbRadiusModeKnob(context);
  return wbUseCase(
    context,
    name: 'AppOverlayAlert',
    description:
        'Alert card taking the semantic color as a ColorSwatch. Prefer AppAlert '
        'when you can use the role enum.',
    child: SizedBox(
      width: 340,
      child: AppOverlayAlert(
        title: title,
        description: description,
        color: color,
        style: style,
        radiusMode: radiusMode,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppOverlayAlert)
Widget overlayAlertStates(BuildContext context) {
  final AppColorTheme colors = AppTheme.of(context).colorTheme;
  return wbUseCase(
    context,
    name: 'AppOverlayAlert',
    description: 'The four semantic colors.',
    child: Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: AppSpacings.s24,
      runSpacing: AppSpacings.s32,
      children: <Widget>[
        for (final (String, ColorSwatch<int>) item
            in <(String, ColorSwatch<int>)>[
              ('info', colors.info),
              ('success', colors.success),
              ('warning', colors.warning),
              ('danger', colors.danger),
            ])
          wbState(
            context,
            name: item.$1,
            width: 300,
            child: AppOverlayAlert(
              title: 'Título',
              description: 'Mensagem ${item.$1}.',
              color: item.$2,
            ),
          ),
      ],
    ),
  );
}
