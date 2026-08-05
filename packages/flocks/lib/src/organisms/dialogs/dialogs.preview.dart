import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_dialog.dart';
import 'app_dialog_content.dart';

// Previews nativos (Regra 5) — a superfície do dialog com a barra de topo e o
// corpo padrão, em claro e escuro. (O modal completo com barrier é exibido via
// showAppDialog.)

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: const Center(
    child: SizedBox(
      width: 440,
      child: AppDialog(
        title: 'Excluir veículo?',
        child: AppDialogContent(
          message: 'Esta ação não pode ser desfeita.',
          illustration: 'assets/illustrations/delete.svg',
        ),
      ),
    ),
  ),
);

@Preview(name: 'AppDialog • claro')
Widget appDialogLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppDialog • escuro')
Widget appDialogDarkPreview() => _sample(AppThemeData.dark);
