import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_style.dart';
import '../buttons/buttons.dart';
import 'app_alert.dart';

// Previews nativos (Regra 5) — claro e escuro, com e sem os slots.

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

Widget _slotsSample(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(
    width: 320,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacings.s16),
      child: AppAlert(
        title: 'Troca agendada',
        description: 'O novo pacote entra no próximo ciclo.',
        color: AppAlertColor.warning,
        onDismiss: () {},
        action: AppButton(
          onPressed: () {},
          label: 'Cancelar troca',
          size: AppButtonSize.s,
          style: AppStyle.outlined,
        ),
      ),
    ),
  ),
);

@Preview(name: 'AppAlert • claro')
Widget appOverlayAlertLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppAlert • escuro')
Widget appOverlayAlertDarkPreview() => _sample(AppThemeData.dark);

@Preview(name: 'AppAlert com ação • claro')
Widget appAlertActionLightPreview() => _slotsSample(AppThemeData.light);

@Preview(name: 'AppAlert com ação • escuro')
Widget appAlertActionDarkPreview() => _slotsSample(AppThemeData.dark);
