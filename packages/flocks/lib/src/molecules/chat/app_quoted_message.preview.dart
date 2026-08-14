import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_chat_bubble.dart';
import 'app_quoted_message.dart';

// Previews nativos (Regra 5) — a citação avulsa (caso composer, com "×") e
// dentro de uma bolha (caso resposta), em claro e escuro.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: Center(
    child: SizedBox(
      width: 320,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppQuotedMessage(
            author: 'Você',
            excerpt: 'A reunião fica para amanhã às 10h.',
            onRemove: () {},
          ),
          const SizedBox(height: 16),
          AppChatBubble(
            author: AppChatAuthor.me,
            header: AppQuotedMessage(
              author: 'Ana',
              excerpt: 'Consegue mandar o relatório de ontem?',
              onTap: () {},
            ),
            child: const Text('Mandando agora!'),
          ),
        ],
      ),
    ),
  ),
);

@Preview(name: 'AppQuotedMessage • claro')
Widget appQuotedMessageLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppQuotedMessage • escuro')
Widget appQuotedMessageDarkPreview() => _sample(AppThemeData.dark);
