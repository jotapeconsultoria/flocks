import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import 'app_chat_bubble.dart';
import 'app_chat_day_divider.dart';
import 'app_chat_message_list.dart';
import 'app_message_meta.dart';

// Previews nativos (Regra 5) — a lista rolável com um divisor de dia e duas
// bolhas (o consumidor escolhe item a item o que renderizar).

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(
    width: 320,
    height: 240,
    child: AppChatMessageList(
      itemCount: 3,
      itemBuilder: (BuildContext context, int i) => switch (i) {
        0 => const AppChatDayDivider(label: 'Hoje'),
        1 => const AppChatBubble(
          child: AppText('Oi! Tudo certo com o caminhão?'),
        ),
        _ => const AppChatBubble(
          author: AppChatAuthor.me,
          footer: AppMessageMeta(
            time: '09:12',
            status: AppMessageStatus.delivered,
          ),
          child: AppText('Tudo certo, chegou agora.'),
        ),
      },
    ),
  ),
);

@Preview(name: 'AppChatMessageList • claro')
Widget appChatMessageListLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppChatMessageList • escuro')
Widget appChatMessageListDarkPreview() => _sample(AppThemeData.dark);
