import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_list_tile.dart';
import 'app_list_tile_group.dart';

// Previews nativos (Regra 5) — variações num grupo, claro e escuro.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(
    width: 320,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacings.s16),
      child: AppListTileGroup(
        children: <Widget>[
          AppListTile.navigation(title: 'Navegação', onTap: () {}),
          AppListTile.toggle(title: 'Switch', value: true, onChanged: (_) {}),
          AppListTile.checkbox(
            title: 'Checkbox',
            value: true,
            onChanged: (_) {},
          ),
          const AppListTile.badge(title: 'Badge', badge: '5'),
        ],
      ),
    ),
  ),
);

@Preview(name: 'AppListTile • claro')
Widget appListTileLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppListTile • escuro')
Widget appListTileDarkPreview() => _sample(AppThemeData.dark);
