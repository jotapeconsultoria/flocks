import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'app_attachment_kind.dart';
import 'app_chat_attachment_card.dart';

// Previews nativos (Regra 5) — a versão grande do chip: cabe subtítulo e o
// ícone do tipo em tamanho de leitura. O caso de imagem depende de bytes do
// app, então aqui só arquivos.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: Wrap(
    spacing: AppSpacings.s12,
    runSpacing: AppSpacings.s12,
    children: <Widget>[
      const AppChatAttachmentCard(
        label: 'rota-2026-07.xlsx',
        subtitle: '240 KB',
        kind: AppAttachmentKind.spreadsheet,
      ),
      AppChatAttachmentCard(
        label: 'contrato.pdf',
        subtitle: '1,2 MB',
        kind: AppAttachmentKind.pdf,
        onRemove: () {},
      ),
    ],
  ),
);

@Preview(name: 'AppChatAttachmentCard • claro')
Widget appChatAttachmentCardLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppChatAttachmentCard • escuro')
Widget appChatAttachmentCardDarkPreview() => _sample(AppThemeData.dark);
