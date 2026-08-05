import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppSideSheet — a superfície (Playground) + CTA que abre o modal real
// (showAppSideSheet: barrier + slide lateral; opcionalmente arrastável).
// ---------------------------------------------------------------------------

Widget _body() => const Padding(
  padding: EdgeInsets.all(AppSpacings.s24),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      AppText('Detalhes do veículo'),
      SizedBox(height: AppSpacings.s12),
      AppText('Placa, modelo, motorista e último evento.'),
    ],
  ),
);

const Widget _footer = Padding(
  padding: EdgeInsets.all(AppSpacings.s16),
  child: AppText('Editar'),
);

@widgetbook.UseCase(name: 'Playground', type: AppSideSheet)
Widget sideSheetPlayground(BuildContext context) {
  final AppStyle? style = wbStyleKnob(context);
  final AppRadiusMode? radiusMode = wbRadiusModeKnob(context);
  final AppSheetSide side = context.knobs.object.dropdown<AppSheetSide>(
    label: 'side',
    options: AppSheetSide.values,
    initialOption: AppSheetSide.end,
    labelBuilder: (AppSheetSide v) => v.name,
  );
  final bool draggable = context.knobs.boolean(label: 'draggable');
  final bool alwaysClose = context.knobs.boolean(label: 'alwaysClose');
  final bool showHandle = context.knobs.boolean(label: 'showHandle');
  final bool showCloseButton = context.knobs.boolean(
    label: 'showCloseButton',
    initialValue: true,
  );
  // Nulo (o default do side sheet) resolve para o canto INTERNO — o oposto do
  // dialog e do bottom sheet, que fixam `end`.
  final AppSheetCloseSide? closeSide = context.knobs.object
      .dropdown<AppSheetCloseSide?>(
        label: 'closeSide',
        options: <AppSheetCloseSide?>[null, ...AppSheetCloseSide.values],
        labelBuilder: (AppSheetCloseSide? v) =>
            v?.name ?? 'auto (inner corner)',
      );
  final String title = context.knobs.string(
    label: 'title',
    initialValue: 'Veículo',
  );
  final String? titleOrNull = title.isEmpty ? null : title;
  final bool? glass = wbGlassKnob(context);

  return wbUseCase(
    context,
    name: 'AppSideSheet',
    description:
        'The floating side panel. Use the CTA to open it as a real modal '
        '(barrier + side slide). Enable "draggable" to resize (40/70/full). '
        'The preview below is the resting surface.',
    cta: wbCta(
      context,
      label: 'Open side sheet',
      onPressed: () => showAppSideSheet<void>(
        context: context,
        side: side,
        draggable: draggable,
        alwaysClose: alwaysClose,
        showHandle: showHandle,
        showCloseButton: showCloseButton,
        closeSide: closeSide,
        title: titleOrNull,
        footer: _footer,
        style: style,
        glass: glass,
        radiusMode: radiusMode,
        child: _body(),
      ),
    ),
    child: SizedBox(
      width: 380,
      height: 420,
      child: AppSideSheet(
        glass: glass,
        side: side,
        showHandle: showHandle,
        showCloseButton: showCloseButton,
        closeSide: closeSide,
        title: titleOrNull,
        footer: _footer,
        style: style,
        radiusMode: radiusMode,
        child: _body(),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppSideSheet)
Widget sideSheetStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppSideSheet',
  description: 'The AppStyle container treatments (default is elevated).',
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
          width: 280,
          child: SizedBox(
            height: 360,
            child: AppSideSheet(
              title: 'Veículo',
              footer: _footer,
              style: style,
              child: _body(),
            ),
          ),
        ),
    ],
  ),
);

// ---------------------------------------------------------------------------
// AppSideSheetPage — visually IDENTICAL to AppSideSheet. What differs is the
// route class (SideSheetPageRoute, persistent), so the cases exist to show the
// route behaviour, not a different look. The CTA is the point.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppSideSheetPage)
Widget sideSheetPagePlayground(BuildContext context) {
  final AppStyle? style = wbStyleKnob(context);
  final AppRadiusMode? radiusMode = wbRadiusModeKnob(context);
  final AppSheetSide side = context.knobs.object.dropdown<AppSheetSide>(
    label: 'side',
    options: AppSheetSide.values,
    initialOption: AppSheetSide.end,
    labelBuilder: (AppSheetSide v) => v.name,
  );
  final bool draggable = context.knobs.boolean(label: 'draggable');
  final bool showHandle = context.knobs.boolean(label: 'showHandle');
  final bool showCloseButton = context.knobs.boolean(
    label: 'showCloseButton',
    initialValue: true,
  );
  final String title = context.knobs.string(
    label: 'title',
    initialValue: 'Ficha do veículo',
  );
  final String? titleOrNull = title.isEmpty ? null : title;

  return wbUseCase(
    context,
    name: 'AppSideSheetPage',
    description:
        'Same surface as AppSideSheet — pick by the nature of the content, not '
        'by looks. The page rides a persistent PageRoute, so it survives an '
        'ephemeral sheet opening ON TOP of it; with an ephemeral route the '
        'second sheet would close the first. Open it, then open a bottom sheet '
        'from inside to see it hold.',
    cta: wbCta(
      context,
      label: 'Open as page route',
      onPressed: () => showAppSideSheetPage<void>(
        context: context,
        side: side,
        draggable: draggable,
        showHandle: showHandle,
        showCloseButton: showCloseButton,
        title: titleOrNull,
        footer: _footer,
        style: style,
        radiusMode: radiusMode,
        child: _body(),
      ),
    ),
    child: SizedBox(
      width: 380,
      height: 420,
      child: AppSideSheetPage(
        side: side,
        showHandle: showHandle,
        showCloseButton: showCloseButton,
        title: titleOrNull,
        footer: _footer,
        style: style,
        radiusMode: radiusMode,
        child: _body(),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppSideSheetPage)
Widget sideSheetPageStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppSideSheetPage',
  description:
      'The AppStyle container treatments — identical to AppSideSheet, which is '
      'the point: the difference lives in the route, not in the paint.',
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
          width: 280,
          child: SizedBox(
            height: 360,
            child: AppSideSheetPage(
              title: 'Ficha do veículo',
              footer: _footer,
              style: style,
              child: _body(),
            ),
          ),
        ),
    ],
  ),
);
