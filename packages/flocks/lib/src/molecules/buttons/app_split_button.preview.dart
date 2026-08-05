import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_style.dart';
import '../menu/menu.dart';
import 'app_split_button.dart';

// Previews nativos (Regra 5). Clique no caret (▾) para abrir as ações.

@Preview(name: 'AppSplitButton • claro (fill)')
Widget appSplitButtonLight() => AppTheme(
  data: AppThemeData.light,
  child: Center(
    child: AppSplitButton(
      label: 'Salvar',
      onPressed: () {},
      menuEntries: <AppMenuEntry>[
        AppMenuItem(label: 'Salvar e sair', onPressed: () {}),
        AppMenuItem(label: 'Salvar como rascunho', onPressed: () {}),
      ],
    ),
  ),
);

@Preview(name: 'AppSplitButton • escuro (outlined)')
Widget appSplitButtonDark() => AppTheme(
  data: AppThemeData.dark,
  child: Center(
    child: AppSplitButton(
      label: 'Exportar',
      style: AppStyle.outlined,
      onPressed: () {},
      menuEntries: <AppMenuEntry>[
        AppMenuItem(label: 'Exportar CSV', onPressed: () {}),
        AppMenuItem(label: 'Exportar PDF', onPressed: () {}),
      ],
    ),
  ),
);
