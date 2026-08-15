import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_spacings.dart';
import 'app_tile_info.dart';

// Previews nativos (Regra 5) — claro e escuro.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: const Padding(
    padding: EdgeInsets.all(AppSpacings.s16),
    child: SizedBox(
      width: 280,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacings.s16,
        children: <Widget>[
          AppTileInfo(title: 'Identificador', text: 'TTS4G47'),
          AppTileInfo(
            title: 'Telefone',
            text: '+55 11 91234-5678',
            icon: AppIconToken.infoCircle,
            layout: AppTileInfoLayout.horizontal,
          ),
        ],
      ),
    ),
  ),
);

@Preview(name: 'AppTileInfo • claro')
Widget appTileInfoLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppTileInfo • escuro')
Widget appTileInfoDarkPreview() => _sample(AppThemeData.dark);
