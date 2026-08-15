import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppDialog — a superfície flutuante (Playground) + CTA que abre o modal real
// (showAppDialog: barrier + transição de fade + gestão de foco).
// ---------------------------------------------------------------------------

const String _illustration = 'assets/illustrations/delete.svg';

@widgetbook.UseCase(name: 'Playground', type: AppDialog)
Widget dialogPlayground(BuildContext context) {
  final String headerTitle = context.knobs.string(
    label: 'header title',
    initialValue: 'Excluir veículo?',
  );
  final bool showCloseButton = context.knobs.boolean(
    label: 'showCloseButton',
    initialValue: true,
  );
  final AppSheetCloseSide closeSide = context.knobs.object
      .dropdown<AppSheetCloseSide>(
        label: 'closeSide',
        options: AppSheetCloseSide.values,
        initialOption: AppSheetCloseSide.end,
        labelBuilder: (AppSheetCloseSide v) => v.name,
      );
  final String message = context.knobs.string(
    label: 'message',
    initialValue: 'Esta ação não pode ser desfeita.',
  );
  final AppStyle? style = wbStyleKnob(context);
  final AppRadiusMode? radiusMode = wbRadiusModeKnob(context);
  final glass = wbGlassKnob(context);

  // Vazio = sem título: com `showCloseButton` desligado também, a barra some.
  final String? title = headerTitle.isEmpty ? null : headerTitle;

  Widget content() =>
      AppDialogContent(message: message, illustration: _illustration);

  return wbUseCase(
    context,
    name: 'AppDialog',
    description:
        'The floating dialog surface. Use the CTA to open it as a real modal '
        '(barrier + fade transition). The top bar carries the title (start '
        'aligned) and the close chip; clear the title and turn the chip off to '
        'collapse the bar. style/radius follow the addons unless overridden.',
    cta: wbCta(
      context,
      label: 'Open modal',
      onPressed: () => showAppDialog<void>(
        context: context,
        title: title,
        showCloseButton: showCloseButton,
        closeSide: closeSide,
        style: style,
        glass: glass,
        radiusMode: radiusMode,
        child: content(),
      ),
    ),
    child: SizedBox(
      width: 440,
      child: AppDialog(
        title: title,
        showCloseButton: showCloseButton,
        closeSide: closeSide,
        style: style,
        glass: glass,
        radiusMode: radiusMode,
        child: content(),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Scenario — o confirm real (showAppConfirm) aberto por CTA: Future<bool> que
// nunca é nulo, corpo sem ilustração, destrutivo opcional. O resultado aparece
// num AppText controlado pelo próprio use case.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Scenario', type: AppDialog)
Widget dialogConfirmScenario(BuildContext context) {
  final String title = context.knobs.string(
    label: 'title',
    initialValue: 'Excluir empresa',
  );
  final String message = context.knobs.string(
    label: 'message',
    initialValue: 'Os usuários dela perdem o acesso. Não dá para desfazer.',
  );
  final String confirmLabel = context.knobs.string(
    label: 'confirmLabel',
    initialValue: 'Excluir',
  );
  final bool destructive = context.knobs.boolean(
    label: 'destructive',
    initialValue: true,
  );
  final bool barrierDismissible = context.knobs.boolean(
    label: 'barrierDismissible',
    initialValue: true,
  );
  final AppStyle? style = wbStyleKnob(context);
  final AppRadiusMode? radiusMode = wbRadiusModeKnob(context);
  final glass = wbGlassKnob(context);

  return wbUseCase(
    context,
    name: 'AppDialog',
    description:
        'showAppConfirm: the yes/no convenience over showAppDialog. The future '
        'resolves true only on the confirm button; cancel, barrier, "X" and Esc '
        'all resolve false — never null. destructive paints the confirm button '
        'danger and tints the (optional) illustration with the same accent.',
    cta: wbCta(
      context,
      label: 'Open confirm',
      onPressed: () async {
        final bool ok = await showAppConfirm(
          context: context,
          title: title,
          message: message,
          confirmLabel: confirmLabel,
          destructive: destructive,
          barrierDismissible: barrierDismissible,
          style: style,
          glass: glass,
          radiusMode: radiusMode,
        );
        if (!context.mounted) return;
        showAppSnackbar(
          context: context,
          title: ok ? 'Resolved: true' : 'Resolved: false',
          description: 'Every dismissal path resolves to false.',
          type: ok ? AppSnackbarType.success : AppSnackbarType.info,
        );
      },
    ),
    child: const AppText(
      'The confirm is a real modal — open it with the CTA. Every dismissal '
      'path (cancel, barrier, "X", Esc) resolves to false.',
    ),
  );
}

// ---------------------------------------------------------------------------
// AppDialogContent — o corpo padrão (título, mensagem, ilustração).
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppDialogContent)
Widget dialogContentPlayground(BuildContext context) {
  final String title = context.knobs.string(
    label: 'title',
    initialValue: 'Tudo certo!',
  );
  final String message = context.knobs.string(
    label: 'message',
    initialValue: 'As alterações foram salvas.',
  );
  return wbUseCase(
    context,
    name: 'AppDialogContent',
    description: 'The standard dialog body: title, message and illustration.',
    child: SizedBox(
      width: 440,
      child: AppDialogContent(
        title: title,
        message: message,
        illustration: 'assets/illustrations/success.svg',
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppDialog)
Widget dialogStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppDialog',
  description:
      'The AppStyle container treatments (default is elevated), then the top '
      'bar states: close chip on either side, and no bar at all.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      for (final AppStyle style in AppStyle.values)
        wbState(
          context,
          name: style.name,
          width: 260,
          child: AppDialog(
            style: style,
            title: 'Excluir veículo?',
            child: const AppDialogContent(
              message: 'Esta ação não pode ser desfeita.',
              illustration: _illustration,
            ),
          ),
        ),
      wbState(
        context,
        name: 'closeSide.start',
        width: 260,
        child: const AppDialog(
          title: 'Excluir veículo?',
          closeSide: AppSheetCloseSide.start,
          child: AppDialogContent(
            message: 'Esta ação não pode ser desfeita.',
            illustration: _illustration,
          ),
        ),
      ),
      wbState(
        context,
        name: 'no top bar',
        width: 260,
        child: const AppDialog(
          showCloseButton: false,
          child: AppDialogContent(
            title: 'Excluir veículo?',
            message: 'Esta ação não pode ser desfeita.',
            illustration: _illustration,
          ),
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppDialogContent)
Widget dialogContentStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppDialogContent',
  description: 'Accent color: default (secondary) vs a custom accent.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Default',
        width: 260,
        child: const AppDialogContent(
          title: 'Tudo certo!',
          message: 'As alterações foram salvas.',
          illustration: 'assets/illustrations/success.svg',
        ),
      ),
      wbState(
        context,
        name: 'Custom accent',
        width: 260,
        child: AppDialogContent(
          title: 'Atenção',
          message: 'Confira os dados informados.',
          illustration: _illustration,
          accentRole: AppTheme.of(context).colorTheme.warning,
        ),
      ),
    ],
  ),
);
