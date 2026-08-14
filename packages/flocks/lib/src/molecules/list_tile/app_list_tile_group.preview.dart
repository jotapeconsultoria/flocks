import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_list_tile.dart';
import 'app_list_tile_group.dart';

// Previews nativos (Regra 5) — grouped (claro) e bordered (escuro).

Widget _sample(AppThemeData data, AppListTileStyle style) => AppTheme(
  data: data,
  child: SizedBox(
    width: 320,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacings.s16),
      child: AppListTileGroup(
        title: style == AppListTileStyle.grouped ? 'Atalhos' : null,
        style: style,
        children: <Widget>[
          AppListTile.navigation(title: 'Suporte', onTap: () {}),
          AppListTile.navigation(title: 'Configurações', onTap: () {}),
          AppListTile.navigation(title: 'Sair', onTap: () {}),
        ],
      ),
    ),
  ),
);

@Preview(name: 'AppListTileGroup • grouped (claro)')
Widget appListTileGroupGroupedLightPreview() =>
    _sample(AppThemeData.light, AppListTileStyle.grouped);

@Preview(name: 'AppListTileGroup • bordered (escuro)')
Widget appListTileGroupBorderedDarkPreview() =>
    _sample(AppThemeData.dark, AppListTileStyle.bordered);
