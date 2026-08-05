import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_alert.dart';

// Previews nativos (Regra 5) — claro e escuro.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: const SizedBox(
    width: 320,
    child: Padding(
      padding: EdgeInsets.all(AppSpacings.s16),
      child: AppAlert(
        title: 'Sem conexão',
        description: 'Verifique sua internet e tente novamente.',
        color: AppAlertColor.danger,
      ),
    ),
  ),
);

@Preview(name: 'AppAlert • claro')
Widget appOverlayAlertLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppAlert • escuro')
Widget appOverlayAlertDarkPreview() => _sample(AppThemeData.dark);
