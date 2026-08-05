import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_overlay_alert.dart';

// Previews nativos (Regra 5) — claro e escuro (cor danger).

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(
    width: 340,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacings.s16),
      child: AppOverlayAlert(
        title: 'Falha ao salvar',
        description: 'Tente novamente em instantes.',
        color: data.colorTheme.danger,
      ),
    ),
  ),
);

@Preview(name: 'AppOverlayAlert • claro')
Widget appOverlayAlertLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppOverlayAlert • escuro')
Widget appOverlayAlertDarkPreview() => _sample(AppThemeData.dark);
