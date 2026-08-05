import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_style.dart';
import 'app_floating_button.dart';

// Previews nativos (Regra 5) — claro e escuro, os 4 estilos + formas.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: Padding(
    padding: const EdgeInsets.all(AppSpacings.s16),
    child: Wrap(
      spacing: AppSpacings.s16,
      runSpacing: AppSpacings.s16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        AppFloatingButton(icon: AppIconToken.add, onPressed: () {}),
        AppFloatingButton(
          style: AppStyle.outlined,
          icon: AppIconToken.add,
          onPressed: () {},
        ),
        AppFloatingButton(
          style: AppStyle.elevated,
          icon: AppIconToken.add,
          label: 'Novo',
          onPressed: () {},
        ),
        AppFloatingButton(
          glass: true,
          icon: AppIconToken.add,
          onPressed: () {},
        ),
      ],
    ),
  ),
);

@Preview(name: 'AppFloatingButton • claro')
Widget appFloatingButtonLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppFloatingButton • escuro')
Widget appFloatingButtonDarkPreview() => _sample(AppThemeData.dark);
