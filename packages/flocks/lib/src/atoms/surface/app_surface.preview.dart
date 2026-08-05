import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import '../texts/texts.dart';
import 'app_surface.dart';

// Previews nativos (Regra 5). As 3 variantes sobre a `surface` do tema, claro
// e escuro (a elevação por tom aparece no contraste com o fundo).

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: ColoredBox(
    color: data.colorTheme.surface,
    child: const Padding(
      padding: EdgeInsets.all(AppSpacings.s16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppSurface(
            padding: EdgeInsets.all(AppSpacings.s16),
            child: AppText('flat'),
          ),
          SizedBox(width: AppSpacings.s12),
          AppSurface(
            variant: AppSurfaceVariant.raised,
            padding: EdgeInsets.all(AppSpacings.s16),
            child: AppText('raised'),
          ),
          SizedBox(width: AppSpacings.s12),
          AppSurface(
            variant: AppSurfaceVariant.bordered,
            padding: EdgeInsets.all(AppSpacings.s16),
            child: AppText('bordered'),
          ),
        ],
      ),
    ),
  ),
);

@Preview(name: 'AppSurface • claro')
Widget appSurfaceLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppSurface • escuro')
Widget appSurfaceDarkPreview() => _sample(AppThemeData.dark);
