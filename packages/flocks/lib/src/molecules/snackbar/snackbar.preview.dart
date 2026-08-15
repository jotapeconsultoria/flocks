import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_snackbar.dart';
import 'app_snackbar_type.dart';

// Previews nativos (Regra 5) — tipos e o toast de uma frase, claro e escuro.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: const Padding(
    padding: EdgeInsets.all(AppSpacings.s16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacings.s16,
      children: <Widget>[
        AppSnackbar(
          title: 'Salvo',
          description: 'As alterações foram aplicadas.',
          type: AppSnackbarType.success,
        ),
        AppSnackbar(
          title: 'Falha ao salvar',
          description: 'Tente novamente em instantes.',
          type: AppSnackbarType.error,
        ),
        AppSnackbar(
          title: 'Janela quase no fim',
          description: 'Restam 10 minutos para responder.',
          type: AppSnackbarType.warning,
        ),
        AppSnackbar(description: 'Link copiado.'),
      ],
    ),
  ),
);

@Preview(name: 'AppSnackbar • claro')
Widget appSnackbarLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppSnackbar • escuro')
Widget appSnackbarDarkPreview() => _sample(AppThemeData.dark);
