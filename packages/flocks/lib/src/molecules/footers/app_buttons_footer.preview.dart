import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/bars/bar_preview_scene.dart';
import '../../theme/theme.dart';
import '../../tokens/app_style.dart';
import '../buttons/buttons.dart';
import 'app_buttons_footer.dart';

// Previews nativos (Regra 5) — claro e escuro.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: barPreviewScene(
    footer: AppButtonsFooter(
      primary: AppButton(label: 'Salvar', onPressed: () {}),
      secondary: AppButton(
        style: AppStyle.outlined,
        label: 'Cancelar',
        onPressed: () {},
      ),
    ),
  ),
);

@Preview(name: 'AppButtonsFooter • claro')
Widget appButtonsFooterLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppButtonsFooter • escuro')
Widget appButtonsFooterDarkPreview() => _sample(AppThemeData.dark);
