import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/bars/bar_preview_scene.dart';
import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import 'app_primary_header.dart';

// Previews nativos (Regra 5) — claro e escuro.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: barPreviewScene(
    header: const AppPrimaryHeader(
      leading: AppText('‹'),
      trailing: AppText('•••'),
      child: AppText('Detalhes'),
    ),
  ),
);

@Preview(name: 'AppPrimaryHeader • claro')
Widget appPrimaryHeaderLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppPrimaryHeader • escuro')
Widget appPrimaryHeaderDarkPreview() => _sample(AppThemeData.dark);
