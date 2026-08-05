import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'app_suggestion_chip.dart';

// Previews nativos (Regra 5) — prompts iniciais tocáveis, com e sem ícone.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(
    width: 320,
    child: Wrap(
      spacing: AppSpacings.s8,
      runSpacing: AppSpacings.s8,
      children: <Widget>[
        AppSuggestionChip(
          label: 'Resumo do dia',
          icon: AppIconToken.chat,
          onTap: () {},
        ),
        AppSuggestionChip(label: 'Veículos parados', onTap: () {}),
        AppSuggestionChip(label: 'Alertas de hoje', onTap: () {}),
      ],
    ),
  ),
);

@Preview(name: 'AppSuggestionChip • claro')
Widget appSuggestionChipLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppSuggestionChip • escuro')
Widget appSuggestionChipDarkPreview() => _sample(AppThemeData.dark);
