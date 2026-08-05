import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_expansion_tile.dart';

// Previews nativos (Regra 5) — colapsado (claro) e expandido (escuro).

Widget _sample(AppThemeData data, {required bool expanded}) => AppTheme(
  data: data,
  child: SizedBox(
    width: 320,
    child: AppExpansionTile(
      title: 'Detalhes do veículo',
      initiallyExpanded: expanded,
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.all(AppSpacings.s16),
          child: AppText('Placa, modelo, cor e demais informações.'),
        ),
      ],
    ),
  ),
);

@Preview(name: 'AppExpansionTile • colapsado (claro)')
Widget appExpansionTileCollapsedLightPreview() =>
    _sample(AppThemeData.light, expanded: false);

@Preview(name: 'AppExpansionTile • expandido (escuro)')
Widget appExpansionTileExpandedDarkPreview() =>
    _sample(AppThemeData.dark, expanded: true);
