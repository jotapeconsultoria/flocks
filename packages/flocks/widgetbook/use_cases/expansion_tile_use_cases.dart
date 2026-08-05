import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppExpansionTile — Playground (all knobs). Tapping the header IS the
// interaction, so there is NO CTA.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppExpansionTile)
Widget expansionTilePlayground(BuildContext context) {
  final theme = AppTheme.of(context);
  final String title = context.knobs.string(
    label: 'title',
    initialValue: 'Detalhes do veículo',
  );
  final bool enabled = context.knobs.boolean(
    label: 'enabled',
    initialValue: true,
  );
  final bool hoverEnabled = context.knobs.boolean(
    label: 'hoverEnabled',
    initialValue: true,
  );
  final bool initiallyExpanded = context.knobs.boolean(
    label: 'initiallyExpanded',
    initialValue: false,
  );
  final style = wbStyleKnob(context);
  final radiusMode = wbRadiusModeKnob(context);

  return wbUseCase(
    context,
    name: 'AppExpansionTile',
    description:
        'Collapsible section; tap the header to expand/collapse. '
        'style/radius follow the addons unless overridden here.',
    child: SizedBox(
      width: 340,
      child: AppExpansionTile(
        title: title,
        enabled: enabled,
        hoverEnabled: hoverEnabled,
        initiallyExpanded: initiallyExpanded,
        style: style,
        radiusMode: radiusMode,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(AppSpacings.s16),
            child: AppText(
              'Placa, modelo, cor e demais informações.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppExpansionTile)
Widget expansionTileStates(BuildContext context) {
  final theme = AppTheme.of(context);
  List<Widget> body() => <Widget>[
    Padding(
      padding: const EdgeInsets.all(AppSpacings.s16),
      child: AppText(
        'Placa, modelo, cor e demais informações.',
        style: theme.textTheme.bodyMedium,
      ),
    ),
  ];

  return wbUseCase(
    context,
    name: 'AppExpansionTile',
    description: 'Collapsed and expanded, across container styles.',
    child: Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: AppSpacings.s24,
      runSpacing: AppSpacings.s32,
      children: <Widget>[
        wbState(
          context,
          name: 'Collapsed',
          when: 'Section closed',
          width: 300,
          child: SizedBox(
            width: 300,
            child: AppExpansionTile(
              title: 'Detalhes do veículo',
              style: AppStyle.filled,
              children: body(),
            ),
          ),
        ),
        wbState(
          context,
          name: 'Expanded',
          when: 'Section open',
          width: 300,
          child: SizedBox(
            width: 300,
            child: AppExpansionTile(
              title: 'Detalhes do veículo',
              style: AppStyle.filled,
              initiallyExpanded: true,
              children: body(),
            ),
          ),
        ),
        wbState(
          context,
          name: 'Outlined',
          when: 'On a busy surface',
          width: 300,
          child: SizedBox(
            width: 300,
            child: AppExpansionTile(
              title: 'Detalhes do veículo',
              style: AppStyle.outlined,
              children: body(),
            ),
          ),
        ),
        wbState(
          context,
          name: 'Disabled',
          when: 'Unavailable',
          width: 300,
          child: SizedBox(
            width: 300,
            child: AppExpansionTile(
              title: 'Detalhes do veículo',
              style: AppStyle.filled,
              enabled: false,
              children: body(),
            ),
          ),
        ),
      ],
    ),
  );
}
