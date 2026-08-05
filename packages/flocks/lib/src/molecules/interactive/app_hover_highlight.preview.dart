import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_hover_highlight.dart';

// Previews nativos (Regra 5). O realce só aparece sob o cursor, então o
// preview mostra a GEOMETRIA: com padding o realce tem corpo; sem ele nasce
// colado no texto e some.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: ColoredBox(
    color: data.colorTheme.surfaceContainer,
    child: const Padding(
      padding: EdgeInsets.all(AppSpacings.s24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacings.s8,
        children: <Widget>[
          AppHoverHighlight(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacings.s8,
              vertical: AppSpacings.s4,
            ),
            child: AppText('Com padding (realce tem corpo)'),
          ),
          AppHoverHighlight(child: AppText('Sem padding (colado no texto)')),
        ],
      ),
    ),
  ),
);

@Preview(name: 'AppHoverHighlight • claro')
Widget appHoverHighlightLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppHoverHighlight • escuro')
Widget appHoverHighlightDarkPreview() => _sample(AppThemeData.dark);
