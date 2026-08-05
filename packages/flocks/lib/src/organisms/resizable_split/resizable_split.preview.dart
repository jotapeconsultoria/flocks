import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import 'app_resizable_split.dart';

// Previews nativos (Regra 5) — claro e escuro.

Widget _panel(AppThemeData data, String label) => ColoredBox(
  color: data.colorTheme.surfaceContainer,
  child: Center(child: AppText(label)),
);

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(
    height: 240,
    width: 520,
    child: AppResizableSplit(
      initialFirstFraction: 0.35,
      first: _panel(data, 'Lista'),
      second: _panel(data, 'Mapa'),
    ),
  ),
);

@Preview(name: 'AppResizableSplit • claro')
Widget appResizableSplitLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppResizableSplit • escuro')
Widget appResizableSplitDarkPreview() => _sample(AppThemeData.dark);
