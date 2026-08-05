import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../texts/texts.dart';
import 'app_divider.dart';

// Previews nativos (Regra 5) — renderizam no previewer da IDE (Flutter 3.44+).
// A cor default vem do `outline` do tema, então claro e escuro diferem.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: const SizedBox(
    width: 240,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppText('Above'),
        SizedBox(height: 8),
        AppDivider(),
        SizedBox(height: 8),
        AppText('Below'),
      ],
    ),
  ),
);

@Preview(name: 'AppDivider • claro')
Widget appDividerLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppDivider • escuro')
Widget appDividerDarkPreview() => _sample(AppThemeData.dark);
