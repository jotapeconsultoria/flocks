import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_shortcut_hint.dart';

// Previews nativos (Regra 5) — os dois tamanhos e as combinações de
// modificador. O piso quadrado aparece no `/`: ele fica do mesmo tamanho do
// selo de `Esc`, senão uma fileira de abas teria selos desalinhados.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: ColoredBox(
    color: data.colorTheme.surfaceContainer,
    child: const Padding(
      padding: EdgeInsets.all(AppSpacings.s24),
      child: Wrap(
        spacing: AppSpacings.s12,
        runSpacing: AppSpacings.s12,
        children: <Widget>[
          AppShortcutHint(AppShortcut('/')),
          AppShortcutHint(AppShortcut('Esc')),
          AppShortcutHint(AppShortcut.primary('K')),
          AppShortcutHint(AppShortcut.primary('S', shift: true)),
          AppShortcutHint(
            AppShortcut.primary('K'),
            size: AppShortcutHintSize.m,
          ),
        ],
      ),
    ),
  ),
);

@Preview(name: 'AppShortcutHint • claro')
Widget appShortcutHintLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppShortcutHint • escuro')
Widget appShortcutHintDarkPreview() => _sample(AppThemeData.dark);
