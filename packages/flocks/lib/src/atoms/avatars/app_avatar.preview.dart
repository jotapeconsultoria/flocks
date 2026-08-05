import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_avatar.dart';

// Previews nativos (Regra 5).

@Preview(name: 'AppAvatar • fallback texto (claro)')
Widget appAvatarTextLight() => AppTheme(
  data: AppThemeData.light,
  child: const AppAvatar(size: AppAvatarSize.l, fallback: 'JP'),
);

@Preview(name: 'AppAvatar • fallback ícone (escuro)')
Widget appAvatarIconDark() => AppTheme(
  data: AppThemeData.dark,
  child: const AppAvatar(size: AppAvatarSize.l),
);
