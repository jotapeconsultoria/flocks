import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppActionItem — item de ação (ícone + texto) numa superfície tingida.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppActionItem)
Widget actionItemPlayground(BuildContext context) {
  final String text = context.knobs.string(
    label: 'text',
    initialValue: 'Suporte',
  );
  final AppStyle? style = wbStyleKnob(context);
  final AppRadiusMode? radiusMode = wbRadiusModeKnob(context);
  return wbUseCase(
    context,
    name: 'AppActionItem',
    description: 'An action row (icon + text) on a tinted, clickable surface.',
    child: SizedBox(
      width: 280,
      child: AppActionItem(
        icon: AppIconToken.infoCircle,
        text: text,
        style: style,
        radiusMode: radiusMode,
        onPressed: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppActionItem)
Widget actionItemStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppActionItem',
  description: 'A few action items stacked.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s24,
    children: <Widget>[
      for (final (String, String) item in <(String, String)>[
        (AppIconToken.infoCircle, 'Suporte'),
        (AppIconToken.checkCircle, 'Concluir'),
        (AppIconToken.alert, 'Reportar'),
      ])
        wbState(
          context,
          name: item.$2,
          width: 260,
          child: AppActionItem(icon: item.$1, text: item.$2, onPressed: () {}),
        ),
    ],
  ),
);
