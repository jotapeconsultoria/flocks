import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_interaction.dart';

// Previews nativos (Regra 5). O realce/anel só aparecem em hover/foco/press
// (interação em runtime); aqui mostramos o alvo em repouso, claro e escuro.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: AppInteraction(
    tooltip: 'Adicionar',
    onTap: () {},
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacings.s12,
      vertical: AppSpacings.s8,
    ),
    child: const AppText('Tap me'),
  ),
);

@Preview(name: 'AppInteraction • claro')
Widget appInteractionLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppInteraction • escuro')
Widget appInteractionDarkPreview() => _sample(AppThemeData.dark);
