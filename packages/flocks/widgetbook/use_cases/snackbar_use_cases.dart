import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppSnackbar — o card em si (Playground) + CTA que dispara showAppSnackbar.
// ---------------------------------------------------------------------------

AppSnackbarType _typeKnob(BuildContext context) =>
    context.knobs.object.dropdown<AppSnackbarType>(
      label: 'type',
      options: AppSnackbarType.values,
      initialOption: AppSnackbarType.success,
      labelBuilder: (AppSnackbarType t) => 'AppSnackbarType.${t.name}',
    );

@widgetbook.UseCase(name: 'Playground', type: AppSnackbar)
Widget snackbarPlayground(BuildContext context) {
  final String titleRaw = context.knobs.string(
    label: 'title (empty = one-line toast)',
    initialValue: 'Salvo',
  );
  final String? title = titleRaw.isEmpty ? null : titleRaw;
  final String description = context.knobs.string(
    label: 'description',
    initialValue: 'As alterações foram aplicadas.',
  );
  final AppSnackbarType type = _typeKnob(context);
  final AppOverlayPosition position = context.knobs.object
      .dropdown<AppOverlayPosition>(
        label: 'position',
        options: AppOverlayPosition.values,
        initialOption: AppOverlayPosition.bottomRight,
        labelBuilder: (AppOverlayPosition p) => 'AppOverlayPosition.${p.name}',
      );
  final AppStyle? style = wbStyleKnob(context);
  final AppRadiusMode? radiusMode = wbRadiusModeKnob(context);

  return wbUseCase(
    context,
    name: 'AppSnackbar',
    description:
        'The feedback card; pick the semantic type. Use the CTA to show it via '
        'showAppSnackbar (auto-dismiss; position picks the corner).',
    cta: wbCta(
      context,
      label: 'Show snackbar',
      onPressed: () => showAppSnackbar(
        context: context,
        title: title,
        description: description,
        type: type,
        position: position,
      ),
    ),
    child: SizedBox(
      width: 384,
      child: AppSnackbar(
        title: title,
        description: description,
        type: type,
        style: style,
        radiusMode: radiusMode,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppSnackbar)
Widget snackbarStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppSnackbar',
  description:
      'The four semantic types (color + icon) and the one-line toast at a '
      'glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      for (final AppSnackbarType type in AppSnackbarType.values)
        wbState(
          context,
          name: type.name,
          when: switch (type) {
            AppSnackbarType.success => 'Operação concluída',
            AppSnackbarType.error => 'Algo falhou',
            AppSnackbarType.info => 'Aviso neutro',
            AppSnackbarType.warning => 'Atenção antes de seguir',
          },
          width: 300,
          child: AppSnackbar(
            title: 'Título',
            description: 'Mensagem do tipo ${type.name}.',
            type: type,
          ),
        ),
      wbState(
        context,
        name: 'message only',
        when: 'A frase única, sem título',
        width: 300,
        child: const AppSnackbar(description: 'Link copiado.'),
      ),
    ],
  ),
);
