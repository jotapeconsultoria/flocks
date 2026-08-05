import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_style.dart';
import 'app_button.dart';

// Previews nativos (Regra 5) — claro e escuro, os 3 estilos.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: Padding(
    padding: const EdgeInsets.all(AppSpacings.s16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacings.s16,
      children: <Widget>[
        AppButton(label: 'Salvar', onPressed: () {}),
        AppButton(
          style: AppStyle.outlined,
          label: 'Cancelar',
          onPressed: () {},
        ),
        AppButton(
          style: AppStyle.elevated,
          label: 'Publicar',
          onPressed: () {},
        ),
      ],
    ),
  ),
);

@Preview(name: 'AppButton • claro')
Widget appButtonLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppButton • escuro')
Widget appButtonDarkPreview() => _sample(AppThemeData.dark);
