import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'app_filter_chip.dart';

// Previews nativos (Regra 5) — filtros aplicados, com e sem remoção.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(
    width: 420,
    child: Wrap(
      spacing: AppSpacings.s8,
      runSpacing: AppSpacings.s8,
      children: <Widget>[
        AppFilterChip(field: 'Tipo', value: 'client.created', onRemove: () {}),
        AppFilterChip(field: 'Resultado', value: 'Negado', onRemove: () {}),
        AppFilterChip(
          field: 'Período',
          value: 'últimos 7 dias',
          onRemove: () {},
        ),
        const AppFilterChip(value: 'somente meus eventos'),
      ],
    ),
  ),
);

@Preview(name: 'AppFilterChip • claro')
Widget appFilterChipLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppFilterChip • escuro')
Widget appFilterChipDarkPreview() => _sample(AppThemeData.dark);
