import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'app_icon.dart';
import 'app_icon_size.dart';

// Previews nativos (Regra 5). Carregam o SVG real da CDN no previewer da IDE.

@Preview(name: 'AppIcon • claro')
Widget appIconLightPreview() => AppTheme(
  data: AppThemeData.light,
  child: const AppIcon(AppIconToken.check, size: AppIconSize.xl),
);

@Preview(name: 'AppIcon • escuro')
Widget appIconDarkPreview() => AppTheme(
  data: AppThemeData.dark,
  child: const AppIcon(AppIconToken.check, size: AppIconSize.xl),
);
