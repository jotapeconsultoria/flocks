import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppBottomSheet — a superfície (Playground) + CTA que abre o modal real
// (showAppBottomSheet: barrier + slide-up; opcionalmente arrastável com morph).
// ---------------------------------------------------------------------------

const Widget _footer = Padding(
  padding: EdgeInsets.all(AppSpacings.s16),
  child: AppText('Aplicar'),
);

Widget _body() => const AppBottomSheetContent(
  title: 'Filtros',
  message: 'Refine a busca pelos veículos.',
  illustration: 'assets/illustrations/filter.svg',
);

@widgetbook.UseCase(name: 'Playground', type: AppBottomSheet)
Widget bottomSheetPlayground(BuildContext context) {
  final AppStyle? style = wbStyleKnob(context);
  final AppRadiusMode? radiusMode = wbRadiusModeKnob(context);
  final bool draggable = context.knobs.boolean(label: 'draggable');
  final bool alwaysClose = context.knobs.boolean(label: 'alwaysClose');
  final bool showHandle = context.knobs.boolean(label: 'showHandle');
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
  final String title = context.knobs.string(
    label: 'title',
    initialValue: 'Filtros',
  );
  final String? titleOrNull = title.isEmpty ? null : title;
  final bool? glass = wbGlassKnob(context);

  return wbUseCase(
    context,
    name: 'AppBottomSheet',
    description:
        'The floating bottom card. Use the CTA to open it as a real modal '
        '(barrier + slide-up). Enable "draggable" to snap rest ⇄ page with a '
        'fluid morph. The preview below shows the resting card.',
    cta: wbCta(
      context,
      label: 'Open sheet',
      onPressed: () => showAppBottomSheet<void>(
        context: context,
        draggable: draggable,
        alwaysClose: alwaysClose,
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
    child: SizedBox(
      width: 380,
      child: AppBottomSheet(
        glass: glass,
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

@widgetbook.UseCase(name: 'States', type: AppBottomSheet)
Widget bottomSheetStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppBottomSheet',
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
          width: 260,
          child: AppBottomSheet(
            footer: _footer,
            title: 'Filtros',
            style: style,
            child: _body(),
          ),
        ),
    ],
  ),
);

// ---------------------------------------------------------------------------
// AppBottomSheetPage — página estilo iOS (peek no topo, edge-to-edge).
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppBottomSheetPage)
Widget bottomSheetPagePlayground(BuildContext context) {
  final AppStyle? style = wbStyleKnob(context);
  final AppRadiusMode? radiusMode = wbRadiusModeKnob(context);
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
  final String title = context.knobs.string(
    label: 'title',
    initialValue: 'Ajustes',
  );
  final String? titleOrNull = title.isEmpty ? null : title;

  return wbUseCase(
    context,
    name: 'AppBottomSheetPage',
    description:
        'The iOS-style full page (top peek, edge-to-edge). Use the CTA to open '
        'it as a real modal (slide-up + swipe-to-dismiss). Preview below is the '
        'page surface.',
    cta: wbCta(
      context,
      label: 'Open page',
      onPressed: () => showAppBottomSheetPage<void>(
        context: context,
        showCloseButton: showCloseButton,
        closeSide: closeSide,
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
      child: AppBottomSheetPage(
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

@widgetbook.UseCase(name: 'States', type: AppBottomSheetPage)
Widget bottomSheetPageStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppBottomSheetPage',
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
          width: 260,
          child: SizedBox(
            height: 360,
            child: AppBottomSheetPage(
              title: 'Ajustes',
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
// AppBottomSheetContent — o corpo padrão (título, mensagem, ilustração).
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppBottomSheetContent)
Widget bottomSheetContentPlayground(BuildContext context) {
  final String title = context.knobs.string(
    label: 'title',
    initialValue: 'Atenção',
  );
  final String message = context.knobs.string(
    label: 'message',
    initialValue: 'Confira os dados antes de continuar.',
  );
  return wbUseCase(
    context,
    name: 'AppBottomSheetContent',
    description:
        'The standard bottom-sheet body: title, message, illustration.',
    child: SizedBox(
      width: 380,
      child: AppBottomSheetContent(
        title: title,
        message: message,
        illustration: 'assets/illustrations/warning.svg',
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppBottomSheetContent)
Widget bottomSheetContentStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppBottomSheetContent',
  description: 'Two example bodies.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Filtros',
        width: 300,
        child: const AppBottomSheetContent(
          title: 'Filtros',
          message: 'Refine a busca pelos veículos.',
          illustration: 'assets/illustrations/filter.svg',
        ),
      ),
      wbState(
        context,
        name: 'warning',
        width: 300,
        child: const AppBottomSheetContent(
          title: 'Atenção',
          message: 'Confira os dados antes de continuar.',
          illustration: 'assets/illustrations/warning.svg',
        ),
      ),
    ],
  ),
);
