import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/bars/bar_preview_scene.dart';
import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import 'app_simple_footer.dart';

// Previews nativos (Regra 5) — claro e escuro.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: barPreviewScene(
    footer: const AppSimpleFooter(child: AppText('© 2026 Tracked')),
  ),
);

@Preview(name: 'AppSimpleFooter • claro')
Widget appSimpleFooterLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppSimpleFooter • escuro')
Widget appSimpleFooterDarkPreview() => _sample(AppThemeData.dark);
