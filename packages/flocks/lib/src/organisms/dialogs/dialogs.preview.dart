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

// O corpo de confirmação puro (sem ilustração): o bloco da arte sai inteiro do
// layout — é o que o showAppConfirm monta por padrão.
Widget _confirmSample(AppThemeData data) => AppTheme(
  data: data,
  child: const Center(
    child: SizedBox(
      width: 440,
      child: AppDialog(
        title: 'Excluir empresa?',
        child: AppDialogContent(
          message: 'Os usuários dela perdem o acesso. Não dá para desfazer.',
        ),
      ),
    ),
  ),
);

@Preview(name: 'AppDialog • confirm sem ilustração • claro')
Widget appDialogConfirmLightPreview() => _confirmSample(AppThemeData.light);

@Preview(name: 'AppDialog • confirm sem ilustração • escuro')
Widget appDialogConfirmDarkPreview() => _confirmSample(AppThemeData.dark);
