import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'app_chat_bubble.dart';
import 'app_message_meta.dart';

// Previews nativos (Regra 5) — o par típico de uma conversa (other + me com
// meta). As cores vêm dos papéis do tema, então claro e escuro diferem.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: const SizedBox(
    width: 320,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppChatBubble(child: AppText('Bora rastrear a frota de hoje?')),
        SizedBox(height: AppSpacings.s8),
        AppChatBubble(
          author: AppChatAuthor.me,
          footer: AppMessageMeta(time: '10:32', status: AppMessageStatus.read),
          child: AppText('Bora! Já puxando os dados.'),
        ),
      ],
    ),
  ),
);

@Preview(name: 'AppChatBubble • claro')
Widget appChatBubbleLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppChatBubble • escuro')
Widget appChatBubbleDarkPreview() => _sample(AppThemeData.dark);
