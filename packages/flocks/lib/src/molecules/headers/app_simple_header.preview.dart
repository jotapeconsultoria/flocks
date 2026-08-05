import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/bars/bar_preview_scene.dart';
import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import 'app_simple_header.dart';

// Previews nativos (Regra 5) — claro e escuro.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: barPreviewScene(
    header: const AppSimpleHeader(child: AppText('Título da página')),
  ),
);

@Preview(name: 'AppSimpleHeader • claro')
Widget appSimpleHeaderLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppSimpleHeader • escuro')
Widget appSimpleHeaderDarkPreview() => _sample(AppThemeData.dark);
