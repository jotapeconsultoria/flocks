import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppListEmpty — Playground. The optional "Limpar" action is part of the
// component (toggled by a knob), not a use-case CTA.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppListEmpty)
Widget listEmptyPlayground(BuildContext context) {
  final String text = context.knobs.string(
    label: 'text',
    initialValue: 'Nenhum resultado encontrado.',
  );
  final bool withAction = context.knobs.boolean(
    label: 'with clear action',
    initialValue: true,
  );
  return wbUseCase(
    context,
    name: 'AppListEmpty',
    description: 'Empty state for a list; toggle the clear-filter action.',
    child: SizedBox(
      width: 360,
      height: 380,
      child: AppListEmpty(
        illustration: AppIllustrations.empty,
        text: text,
        onClearFilter: withAction ? () {} : null,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppListEmpty)
Widget listEmptyStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppListEmpty',
  description: 'With and without the clear action, and an error illustration.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'With action',
        when: 'A filter is active',
        width: 300,
        child: SizedBox(
          width: 300,
          height: 320,
          child: AppListEmpty(
            illustration: AppIllustrations.empty,
            text: 'Nenhum resultado encontrado.',
            onClearFilter: () {},
          ),
        ),
      ),
      wbState(
        context,
        name: 'No action',
        when: 'Nothing to clear',
        width: 300,
        child: const SizedBox(
          width: 300,
          height: 320,
          child: AppListEmpty(
            illustration: AppIllustrations.empty,
            text: 'Ainda não há dados por aqui.',
          ),
        ),
      ),
      wbState(
        context,
        name: 'Error',
        when: 'Failed to load',
        width: 300,
        child: const SizedBox(
          width: 300,
          height: 320,
          child: AppListEmpty(
            illustration: AppIllustrations.errorConnection,
            text: 'Não foi possível carregar a lista.',
          ),
        ),
      ),
    ],
  ),
);
