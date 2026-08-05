import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_card.dart';

// Previews nativos (Regra 5) — claro e escuro.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: const Padding(
    padding: EdgeInsets.all(AppSpacings.s16),
    child: AppCard(
      headerTitle: 'Localização',
      child: AppText('Detalhes do veículo'),
    ),
  ),
);

@Preview(name: 'AppCard • claro')
Widget appCardLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppCard • escuro')
Widget appCardDarkPreview() => _sample(AppThemeData.dark);
