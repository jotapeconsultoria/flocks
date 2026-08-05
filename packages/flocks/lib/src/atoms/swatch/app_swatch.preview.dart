import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_swatch.dart';

// Previews nativos (Regra 5). Quadrado e círculo em algumas cores, claro/escuro
// (a borda `outline` do tema adapta ao brilho).

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: const Wrap(
    spacing: AppSpacings.s12,
    runSpacing: AppSpacings.s12,
    children: <Widget>[
      AppSwatch(color: Color(0xFF1E88E5), size: 28),
      AppSwatch(color: Color(0xFFE53935), size: 28),
      AppSwatch(color: Color(0xFF43A047), size: 28),
      AppSwatch(
        color: Color(0xFFFFFFFF),
        size: 28,
        shape: AppSwatchShape.circle,
      ),
      AppSwatch(
        color: Color(0xFFFDD835),
        size: 28,
        shape: AppSwatchShape.circle,
      ),
    ],
  ),
);

@Preview(name: 'AppSwatch • claro')
Widget appSwatchLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppSwatch • escuro')
Widget appSwatchDarkPreview() => _sample(AppThemeData.dark);
