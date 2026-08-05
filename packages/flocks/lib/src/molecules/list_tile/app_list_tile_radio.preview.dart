import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_list_tile_group.dart';
import 'app_list_tile_radio.dart';

// Previews nativos (Regra 5) — grupo de radios, claro e escuro.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(
    width: 320,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacings.s16),
      child: AppListTileGroup(
        children: <Widget>[
          AppListTileRadio<String>(
            title: 'Polo Track 01',
            value: 'a',
            groupValue: 'a',
            onChanged: (_) {},
          ),
          AppListTileRadio<String>(
            title: 'Polo Track 02',
            value: 'b',
            groupValue: 'a',
            onChanged: (_) {},
          ),
        ],
      ),
    ),
  ),
);

@Preview(name: 'AppListTileRadio • claro')
Widget appListTileRadioLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppListTileRadio • escuro')
Widget appListTileRadioDarkPreview() => _sample(AppThemeData.dark);
