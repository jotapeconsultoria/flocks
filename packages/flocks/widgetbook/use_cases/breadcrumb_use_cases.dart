import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppBreadcrumb — Playground. Hover/press/focus happen on the items, no CTA.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppBreadcrumb)
Widget breadcrumbPlayground(BuildContext context) {
  final int depth = context.knobs.int.slider(
    label: 'depth',
    initialValue: 3,
    min: 1,
    max: 5,
    divisions: 4,
  );
  const List<String> labels = <String>[
    'Início',
    'Veículos',
    'Detalhes',
    'Histórico',
    'Evento',
  ];
  final List<AppBreadcrumbItem> items = <AppBreadcrumbItem>[
    for (int i = 0; i < depth; i++)
      AppBreadcrumbItem(
        label: labels[i],
        // O último é o item atual (sem onTap).
        onTap: i == depth - 1 ? null : () {},
      ),
  ];

  return wbUseCase(
    context,
    name: 'AppBreadcrumb',
    description: 'Navigation trail; last item is the current page.',
    child: AppBreadcrumb(items: items),
  );
}

const List<String> _trail = <String>[
  'Início',
  'Veículos',
  'Detalhes',
  'Histórico',
];

List<AppBreadcrumbItem> _trailItems(int depth) => <AppBreadcrumbItem>[
  for (int i = 0; i < depth; i++)
    AppBreadcrumbItem(label: _trail[i], onTap: i == depth - 1 ? null : () {}),
];

@widgetbook.UseCase(name: 'States', type: AppBreadcrumb)
Widget breadcrumbStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppBreadcrumb',
  description: 'Trails of increasing depth; the last item is the current page.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Two levels',
        when: 'One step deep',
        width: 320,
        child: AppBreadcrumb(items: _trailItems(2)),
      ),
      wbState(
        context,
        name: 'Three levels',
        when: 'Typical',
        width: 320,
        child: AppBreadcrumb(items: _trailItems(3)),
      ),
      wbState(
        context,
        name: 'Four levels',
        when: 'Deep trail',
        width: 320,
        child: AppBreadcrumb(items: _trailItems(4)),
      ),
    ],
  ),
);
