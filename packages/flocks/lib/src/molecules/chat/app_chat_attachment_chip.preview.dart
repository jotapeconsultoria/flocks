import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'app_chat_attachment_chip.dart';

// Previews nativos (Regra 5) — pílulas de arquivo (somente-leitura e removível).
// O preview de imagem depende de bytes do app, então aqui mostramos só arquivo.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: Wrap(
    spacing: AppSpacings.s8,
    runSpacing: AppSpacings.s8,
    children: <Widget>[
      const AppChatAttachmentChip(label: 'relatorio.pdf'),
      AppChatAttachmentChip(label: 'foto.png', onRemove: () {}),
    ],
  ),
);

@Preview(name: 'AppChatAttachmentChip • claro')
Widget appChatAttachmentChipLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppChatAttachmentChip • escuro')
Widget appChatAttachmentChipDarkPreview() => _sample(AppThemeData.dark);
