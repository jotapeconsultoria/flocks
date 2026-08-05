import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_tile_info.dart';

// Previews nativos (Regra 5) — claro e escuro.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: const Padding(
    padding: EdgeInsets.all(AppSpacings.s16),
    child: AppTileInfo(title: 'Identificador', text: 'TTS4G47'),
  ),
);

@Preview(name: 'AppTileInfo • claro')
Widget appTileInfoLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppTileInfo • escuro')
Widget appTileInfoDarkPreview() => _sample(AppThemeData.dark);
