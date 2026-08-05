import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'app_chat_action_bar.dart';

// Previews nativos (Regra 5) — a linha de ações de uma resposta (com "gostei"
// ativo, tingido por secondary).

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: AppChatActionBar(
    actions: <AppChatAction>[
      AppChatAction(icon: AppIconToken.copy, label: 'Copiar', onPressed: () {}),
      AppChatAction(
        icon: AppIconToken.sync,
        label: 'Regerar',
        onPressed: () {},
      ),
      AppChatAction(
        icon: AppIconToken.thumbsUp,
        label: 'Gostei',
        active: true,
        onPressed: () {},
      ),
      AppChatAction(
        icon: AppIconToken.thumbsDown,
        label: 'Não gostei',
        onPressed: () {},
      ),
    ],
  ),
);

@Preview(name: 'AppChatActionBar • claro')
Widget appChatActionBarLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppChatActionBar • escuro')
Widget appChatActionBarDarkPreview() => _sample(AppThemeData.dark);
