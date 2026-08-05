import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/bars/bar_preview_scene.dart';
import '../../theme/theme.dart';
import '../../tokens/app_icon_token.dart';
import 'app_search_footer.dart';

// Previews nativos (Regra 5) — claro e escuro.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: barPreviewScene(
    footer: AppSearchFooter(
      hintText: 'Buscar',
      suffixIcon: AppIconToken.microphone,
      onSuffixIconTap: () {},
    ),
  ),
);

@Preview(name: 'AppSearchFooter • claro')
Widget appSearchFooterLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppSearchFooter • escuro')
Widget appSearchFooterDarkPreview() => _sample(AppThemeData.dark);
