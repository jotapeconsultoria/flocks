import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// Headers — Playground (knobs de style/glass/radius) sobre a cena de barra
// compartilhada: conteúdo ROLÁVEL sob o header, com safe-area falsa. Só assim
// dá para julgar o vidro — num fundo parado o blur não tem o que revelar.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppSimpleHeader)
Widget simpleHeaderPlayground(BuildContext context) {
  final theme = AppTheme.of(context);
  final AppStyle? style = wbStyleKnob(context);
  final bool? glass = wbGlassKnob(context);
  final AppRadiusMode? radiusMode = wbRadiusModeKnob(context);
  final String title = context.knobs.string(
    label: 'title',
    initialValue: 'Título da página',
  );
  return wbUseCase(
    context,
    name: 'AppSimpleHeader',
    description: 'Simple page header band — style + glass axes over content.',
    maxWidth: 600,
    panel: false,
    child: wbBarScene(
      context,
      header: AppSimpleHeader(
        style: style ?? AppStyle.filled,
        glass: glass,
        radiusMode: radiusMode,
        child: AppText(title, style: theme.textTheme.titleLarge),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppPrimaryHeader)
Widget primaryHeaderPlayground(BuildContext context) {
  final theme = AppTheme.of(context);
  final AppStyle? style = wbStyleKnob(context);
  final bool? glass = wbGlassKnob(context);
  final AppRadiusMode? radiusMode = wbRadiusModeKnob(context);
  final String title = context.knobs.string(
    label: 'title',
    initialValue: 'Detalhes',
  );
  final bool center = context.knobs.boolean(
    label: 'centerChild',
    initialValue: true,
  );
  final bool withLeading = context.knobs.boolean(
    label: 'leading',
    initialValue: true,
  );
  final bool withTrailing = context.knobs.boolean(
    label: 'trailing',
    initialValue: true,
  );
  final bool withBottom = context.knobs.boolean(
    label: 'bottom',
    initialValue: false,
  );
  final AppStyle effStyle = style ?? AppStyle.filled;
  final bool glassOn = glass ?? theme.glassTheme.enabled;
  return wbUseCase(
    context,
    name: 'AppPrimaryHeader',
    description: 'Primary header — centered title, ghost/FAB actions, glass.',
    maxWidth: 600,
    panel: false,
    child: wbBarScene(
      context,
      header: AppPrimaryHeader(
        style: effStyle,
        glass: glass,
        radiusMode: radiusMode,
        centerChild: center,
        leading: withLeading
            ? AppPrimaryHeader.action(
                context,
                icon: AppIconToken.chevronLeft,
                onTap: () {},
                glass: glassOn,
                semanticLabel: 'Voltar',
              )
            : null,
        trailing: withTrailing
            ? AppPrimaryHeader.action(
                context,
                icon: AppIconToken.settings,
                onTap: () {},
                glass: glassOn,
                semanticLabel: 'Configurações',
              )
            : null,
        bottom: withBottom
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: AppSpacings.s16,
                children: <Widget>[
                  AppText('Todas', style: theme.textTheme.labelMedium),
                  AppText('Ativas', style: theme.textTheme.labelMedium),
                  AppText('Arquivadas', style: theme.textTheme.labelMedium),
                ],
              )
            : null,
        bottomHeight: withBottom ? 40 : 0,
        child: AppText(title, style: theme.textTheme.titleLarge),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// States — one grid per header type.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'States', type: AppSimpleHeader)
Widget simpleHeaderStates(BuildContext context) {
  final theme = AppTheme.of(context);
  Widget header(String title) => SizedBox(
    width: 420,
    child: AppSimpleHeader(
      child: AppText(title, style: theme.textTheme.titleLarge),
    ),
  );

  return wbUseCase(
    context,
    name: 'AppSimpleHeader',
    description: 'Short and long titles on the header band.',
    maxWidth: 600,
    panelPadding: AppSpacings.s32,
    child: Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: AppSpacings.s24,
      runSpacing: AppSpacings.s32,
      children: <Widget>[
        wbState(
          context,
          name: 'Short',
          when: 'Concise title',
          width: 420,
          child: header('Detalhes'),
        ),
        wbState(
          context,
          name: 'Long',
          when: 'Title that wraps',
          width: 420,
          child: header('Histórico de eventos e telemetria do veículo'),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppPrimaryHeader)
Widget primaryHeaderStates(BuildContext context) {
  final theme = AppTheme.of(context);

  Widget back() => AppPrimaryHeader.action(
    context,
    icon: AppIconToken.chevronLeft,
    onTap: () {},
    semanticLabel: 'Voltar',
  );
  Widget gear() => AppPrimaryHeader.action(
    context,
    icon: AppIconToken.settings,
    onTap: () {},
    semanticLabel: 'Configurações',
  );

  return wbUseCase(
    context,
    name: 'AppPrimaryHeader',
    description: 'With both side slots, title only, and leading only.',
    maxWidth: 600,
    panelPadding: AppSpacings.s32,
    child: Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: AppSpacings.s24,
      runSpacing: AppSpacings.s32,
      children: <Widget>[
        wbState(
          context,
          name: 'Both slots',
          when: 'Back + action',
          width: 420,
          child: SizedBox(
            width: 420,
            child: AppPrimaryHeader(
              leading: back(),
              trailing: gear(),
              child: AppText('Detalhes', style: theme.textTheme.titleLarge),
            ),
          ),
        ),
        wbState(
          context,
          name: 'Title only',
          when: 'No side actions',
          width: 420,
          child: SizedBox(
            width: 420,
            child: AppPrimaryHeader(
              child: AppText('Detalhes', style: theme.textTheme.titleLarge),
            ),
          ),
        ),
        wbState(
          context,
          name: 'Leading only',
          when: 'Back button (child inset)',
          width: 420,
          child: SizedBox(
            width: 420,
            child: AppPrimaryHeader(
              centerChild: false,
              leading: back(),
              child: AppText('Detalhes', style: theme.textTheme.titleLarge),
            ),
          ),
        ),
      ],
    ),
  );
}
