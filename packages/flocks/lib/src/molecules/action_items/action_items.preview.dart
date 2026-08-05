import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_spacings.dart';
import 'app_action_item.dart';

// Previews nativos (Regra 5) — claro e escuro.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(
    width: 280,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacings.s16),
      child: AppActionItem(
        icon: AppIconToken.infoCircle,
        text: 'Suporte',
        onPressed: () {},
      ),
    ),
  ),
);

@Preview(name: 'AppActionItem • claro')
Widget appActionItemLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppActionItem • escuro')
Widget appActionItemDarkPreview() => _sample(AppThemeData.dark);
