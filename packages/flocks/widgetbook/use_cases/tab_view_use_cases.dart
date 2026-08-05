import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppTabView — abas horizontais com indicador deslizante.
// ---------------------------------------------------------------------------

List<AppTabViewItem> _items(int n) => <AppTabViewItem>[
  for (int i = 0; i < n; i++)
    AppTabViewItem(
      label: <String>['Resumo', 'Detalhes', 'Histórico', 'Config'][i % 4],
      builder: (BuildContext _) => AppText('Conteúdo da aba ${i + 1}'),
    ),
];

@widgetbook.UseCase(name: 'Playground', type: AppTabView)
Widget tabViewPlayground(BuildContext context) {
  final int count = context.knobs.int.slider(
    label: 'tabs',
    initialValue: 3,
    min: 2,
    max: 4,
  );
  return wbUseCase(
    context,
    name: 'AppTabView',
    description:
        'Horizontal tabs with a sliding indicator and lazy content. Tap a tab '
        'to see the indicator animate.',
    maxWidth: 520,
    child: SizedBox(height: 220, child: AppTabView(items: _items(count))),
  );
}

@widgetbook.UseCase(name: 'States', type: AppTabView)
Widget tabViewStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppTabView',
  description: 'The indicator on different active tabs.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      for (final int index in <int>[0, 1, 2])
        wbState(
          context,
          name: 'Tab $index active',
          width: 320,
          child: SizedBox(
            height: 180,
            child: AppTabView(items: _items(3), initialIndex: index),
          ),
        ),
    ],
  ),
);
