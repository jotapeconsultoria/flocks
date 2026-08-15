import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppAlert — o card em si (Playground) + o helper de overlay showAppOverlay
// (Overlay: botão + knobs de posição/animação/largura).
// ---------------------------------------------------------------------------

AppAlertColor _colorKnob(BuildContext context) =>
    context.knobs.object.dropdown<AppAlertColor>(
      label: 'color',
      options: AppAlertColor.values,
      initialOption: AppAlertColor.info,
      labelBuilder: (c) => 'AppAlertColor.${c.name}',
    );

@widgetbook.UseCase(name: 'Playground', type: AppAlert)
Widget alertPlayground(BuildContext context) {
  final String title = context.knobs.string(
    label: 'title',
    initialValue: 'Sem conexão',
  );
  final String description = context.knobs.string(
    label: 'description',
    initialValue: 'Verifique sua internet e tente novamente.',
  );
  final AppAlertColor color = _colorKnob(context);
  final bool withAction = context.knobs.boolean(
    label: 'action',
    initialValue: false,
  );
  final AppAlertActionPlacement actionPlacement = context.knobs.object
      .dropdown<AppAlertActionPlacement>(
        label: 'actionPlacement',
        options: AppAlertActionPlacement.values,
        initialOption: AppAlertActionPlacement.footer,
        labelBuilder: (AppAlertActionPlacement p) =>
            'AppAlertActionPlacement.${p.name}',
      );
  final bool dismissible = context.knobs.boolean(
    label: 'onDismiss',
    initialValue: false,
  );
  final bool liveRegion = context.knobs.boolean(
    label: 'liveRegion',
    initialValue: true,
  );
  final int maxLinesValue = context.knobs.int.slider(
    label: 'maxLines (6 = no cap)',
    initialValue: 3,
    min: 1,
    max: 6,
  );
  final AppStyle? style = wbStyleKnob(context);
  final AppRadiusMode? radiusMode = wbRadiusModeKnob(context);
  return wbUseCase(
    context,
    name: 'AppAlert',
    description:
        'The alert card itself; pick the semantic color and the slots. '
        'style/radius follow the addons unless overridden here.',
    child: SizedBox(
      width: 340,
      child: AppAlert(
        title: title,
        description: description,
        color: color,
        action: withAction
            ? AppButton(
                onPressed: () {},
                label: 'Action',
                size: AppButtonSize.s,
                style: AppStyle.outlined,
              )
            : null,
        actionPlacement: actionPlacement,
        onDismiss: dismissible ? () {} : null,
        liveRegion: liveRegion,
        maxLines: maxLinesValue >= 6 ? null : maxLinesValue,
        style: style,
        radiusMode: radiusMode,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Scenario', type: AppAlert)
Widget alertOverlay(BuildContext context) {
  final String title = context.knobs.string(
    label: 'title',
    initialValue: 'Sem conexão',
  );
  final String description = context.knobs.string(
    label: 'description',
    initialValue: 'Verifique sua internet e tente novamente.',
  );
  final AppAlertColor color = _colorKnob(context);
  final AppOverlayPosition position = context.knobs.object
      .dropdown<AppOverlayPosition>(
        label: 'position',
        options: AppOverlayPosition.values,
        initialOption: AppOverlayPosition.topRight,
        labelBuilder: (p) => 'AppOverlayPosition.${p.name}',
      );
  final AppOverlayAnimation animation = context.knobs.object
      .dropdown<AppOverlayAnimation>(
        label: 'animation',
        options: AppOverlayAnimation.values,
        initialOption: AppOverlayAnimation.slide,
        labelBuilder: (a) => 'AppOverlayAnimation.${a.name}',
      );
  final double maxWidth = context.knobs.double.slider(
    label: 'maxWidth',
    initialValue: 360,
    min: 240,
    max: 640,
  );

  return wbUseCase(
    context,
    name: 'showAppOverlay',
    description:
        'Configure position, animation and maxWidth, then show the alert.',
    cta: wbCta(
      context,
      label: 'Show alert',
      onPressed: () => showAppOverlay(
        context: context,
        position: position,
        animation: animation,
        maxWidth: maxWidth,
        child: AppAlert(title: title, description: description, color: color),
      ),
    ),
    child: AppText(
      'Set the knobs and press "Show alert": it appears at the chosen '
      'position, with the chosen animation, and dismisses itself.',
      style: AppTheme.of(context).textTheme.bodyMedium,
      textAlign: TextAlign.center,
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppAlert)
Widget alertStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppAlert',
  description: 'Every semantic color and container style at a glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Info',
        when: 'Neutral notice',
        width: 300,
        child: const AppAlert(
          title: 'Sincronizando',
          description: 'Buscando os dados mais recentes.',
          color: AppAlertColor.info,
        ),
      ),
      wbState(
        context,
        name: 'Success',
        when: 'Confirmation',
        width: 300,
        child: const AppAlert(
          title: 'Tudo certo',
          description: 'As alterações foram salvas.',
          color: AppAlertColor.success,
        ),
      ),
      wbState(
        context,
        name: 'Warning',
        when: 'Caution',
        width: 300,
        child: const AppAlert(
          title: 'Atenção',
          description: 'A licença expira em 3 dias.',
          color: AppAlertColor.warning,
        ),
      ),
      wbState(
        context,
        name: 'With action',
        when: 'The notice offers a way out',
        width: 300,
        child: AppAlert(
          title: 'Troca agendada',
          description: 'O novo pacote entra no próximo ciclo.',
          color: AppAlertColor.warning,
          action: AppButton(
            onPressed: () {},
            label: 'Cancelar',
            size: AppButtonSize.s,
            style: AppStyle.outlined,
          ),
        ),
      ),
      wbState(
        context,
        name: 'Dismissible',
        when: 'The user can put it away',
        width: 300,
        child: AppAlert(
          title: 'Dica',
          description: 'Arraste colunas para reordenar o quadro.',
          onDismiss: () {},
        ),
      ),
      wbState(
        context,
        name: 'Danger',
        when: 'Error',
        width: 300,
        child: const AppAlert(
          title: 'Sem conexão',
          description: 'Verifique sua internet e tente novamente.',
          color: AppAlertColor.danger,
        ),
      ),
      wbState(
        context,
        name: 'Outlined',
        when: 'On a busy surface',
        width: 300,
        child: const AppAlert(
          title: 'Sincronizando',
          description: 'Buscando os dados mais recentes.',
          color: AppAlertColor.info,
          style: AppStyle.outlined,
        ),
      ),
      wbState(
        context,
        name: 'Elevated',
        when: 'Raised emphasis',
        width: 300,
        child: const AppAlert(
          title: 'Sincronizando',
          description: 'Buscando os dados mais recentes.',
          color: AppAlertColor.info,
          style: AppStyle.elevated,
        ),
      ),
    ],
  ),
);
