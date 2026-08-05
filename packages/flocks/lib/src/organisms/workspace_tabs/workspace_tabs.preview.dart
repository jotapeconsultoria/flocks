import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_icon_token.dart';
import 'app_workspace_tabs.dart';

// Previews nativos (Regra 5) — claro e escuro.

List<AppWorkspaceTabItem> _tabs() => const <AppWorkspaceTabItem>[
  AppWorkspaceTabItem(
    id: 'a',
    title: 'Veículos',
    icon: AppIconToken.infoCircle,
  ),
  AppWorkspaceTabItem(id: 'b', title: 'Alertas', icon: AppIconToken.alert),
  AppWorkspaceTabItem(
    id: 'c',
    title: 'Relatórios',
    icon: AppIconToken.checkCircle,
  ),
];

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(
    height: 56,
    width: 520,
    child: AppWorkspaceTabs(
      tabs: _tabs(),
      activeId: 'a',
      onSelect: (_) {},
      onClose: (_) {},
    ),
  ),
);

@Preview(name: 'AppWorkspaceTabs • claro')
Widget appWorkspaceTabsLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppWorkspaceTabs • escuro')
Widget appWorkspaceTabsDarkPreview() => _sample(AppThemeData.dark);
