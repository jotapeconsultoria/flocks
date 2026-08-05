import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'app_chat_day_divider.dart';

// Previews nativos (Regra 5) — a pílula central de dia, solta e com filetes.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: const SizedBox(
    width: 360,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppChatDayDivider(label: 'Hoje'),
        SizedBox(height: AppSpacings.s12),
        AppChatDayDivider(label: '14 jul', withRules: true),
      ],
    ),
  ),
);

@Preview(name: 'AppChatDayDivider • claro')
Widget appChatDayDividerLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppChatDayDivider • escuro')
Widget appChatDayDividerDarkPreview() => _sample(AppThemeData.dark);
