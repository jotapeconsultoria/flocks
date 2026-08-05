import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppWorkspaceTabs — barra de abas estilo navegador (controlada).
// ---------------------------------------------------------------------------

List<AppWorkspaceTabItem> _tabs(int n) => <AppWorkspaceTabItem>[
  for (int i = 0; i < n; i++)
    AppWorkspaceTabItem(
      id: 'tab_$i',
      title: <String>['Veículos', 'Alertas', 'Relatórios', 'Config'][i % 4],
      icon: <String>[
        AppIconToken.infoCircle,
        AppIconToken.alert,
        AppIconToken.checkCircle,
        AppIconToken.errorCircle,
      ][i % 4],
    ),
];

@widgetbook.UseCase(name: 'Playground', type: AppWorkspaceTabs)
Widget workspaceTabsPlayground(BuildContext context) {
  final int count = context.knobs.int.slider(
    label: 'tabs',
    initialValue: 3,
    min: 1,
    max: 4,
  );
  return wbUseCase(
    context,
    name: 'AppWorkspaceTabs',
    description:
        'Browser-like workspace tab strip (controlled). Only the active tab is '
        'filled; tabs animate on hover.',
    maxWidth: 560,
    child: SizedBox(
      height: 56,
      child: AppWorkspaceTabs(
        tabs: _tabs(count),
        activeId: 'tab_0',
        onSelect: (_) {},
        onClose: (_) {},
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppWorkspaceTabs)
Widget workspaceTabsStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppWorkspaceTabs',
  description: 'Different active tabs.',
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      for (final String active in <String>['tab_0', 'tab_1', 'tab_2'])
        wbState(
          context,
          name: 'active $active',
          width: 520,
          child: SizedBox(
            height: 56,
            child: AppWorkspaceTabs(
              tabs: _tabs(3),
              activeId: active,
              onSelect: (_) {},
              onClose: (_) {},
            ),
          ),
        ),
    ],
  ),
);
