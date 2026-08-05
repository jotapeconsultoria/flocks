import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'app_illustration.dart';
import 'app_illustration_size.dart';

// Previews nativos (Regra 5).

@Preview(name: 'AppIllustration • claro')
Widget appIllustrationLight() => AppTheme(
  data: AppThemeData.light,
  child: const AppIllustration(
    AppIllustrations.empty,
    size: AppIllustrationSize.l,
  ),
);

@Preview(name: 'AppIllustration • escuro')
Widget appIllustrationDark() => AppTheme(
  data: AppThemeData.dark,
  child: const AppIllustration(
    AppIllustrations.support,
    size: AppIllustrationSize.l,
  ),
);
