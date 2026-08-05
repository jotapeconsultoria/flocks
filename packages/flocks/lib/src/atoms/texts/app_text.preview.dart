import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_text.dart';

// Previews nativos (Regra 5) — renderizam no previewer da IDE (Flutter 3.44+).
// AppText sem `style` adapta a cor ao brilho do tema, então os dois previews
// exercitam claro e escuro.

@Preview(name: 'AppText • claro')
Widget appTextLightPreview() => AppTheme(
  data: AppThemeData.light,
  child: const AppText('O texto padrão do Flocks — claro'),
);

@Preview(name: 'AppText • escuro')
Widget appTextDarkPreview() => AppTheme(
  data: AppThemeData.dark,
  child: const AppText('O texto padrão do Flocks — escuro'),
);
