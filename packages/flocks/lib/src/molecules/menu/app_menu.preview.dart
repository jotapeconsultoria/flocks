import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'app_menu.dart';

// Previews nativos (Regra 5). Clique no alvo para abrir o menu.

@Preview(name: 'AppMenu • claro (clique para abrir)')
Widget appMenuLight() => AppTheme(
  data: AppThemeData.light,
  child: Center(
    child: AppMenu(
      trigger: const Padding(
        padding: EdgeInsets.all(AppSpacings.s8),
        child: AppText('Ações'),
      ),
      entries: <AppMenuEntry>[
        AppMenuItem(
          label: 'Editar',
          icon: AppIconToken.settings,
          onPressed: () {},
        ),
        AppMenuItem(
          label: 'Duplicar',
          icon: AppIconToken.copy,
          onPressed: () {},
        ),
        const AppMenuDivider(),
        AppMenuItem(
          label: 'Excluir',
          icon: AppIconToken.remove,
          danger: true,
          onPressed: () {},
        ),
      ],
    ),
  ),
);

@Preview(name: 'AppMenu • escuro (com seção)')
Widget appMenuDark() => AppTheme(
  data: AppThemeData.dark,
  child: Center(
    child: AppMenu(
      trigger: const Padding(
        padding: EdgeInsets.all(AppSpacings.s8),
        child: AppText('Mais'),
      ),
      entries: <AppMenuEntry>[
        AppMenuSection(
          title: 'Exportar',
          items: <AppMenuItem>[
            AppMenuItem(label: 'CSV', icon: AppIconToken.csv, onPressed: () {}),
            AppMenuItem(label: 'PDF', icon: AppIconToken.pdf, onPressed: () {}),
          ],
        ),
        const AppMenuDivider(),
        const AppMenuItem(label: 'Indisponível', enabled: false),
      ],
    ),
  ),
);
