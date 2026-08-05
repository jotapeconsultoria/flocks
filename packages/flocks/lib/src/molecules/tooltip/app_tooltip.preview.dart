import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'app_tooltip.dart';

// Previews nativos (Regra 5). Passe o mouse sobre o alvo para ver o balão.

@Preview(name: 'AppTooltip • claro (passe o mouse)')
Widget appTooltipLight() => AppTheme(
  data: AppThemeData.light,
  child: const Center(
    child: AppTooltip(
      message: 'Dica: passe o mouse para ver o balão',
      child: Padding(
        padding: EdgeInsets.all(AppSpacings.s8),
        child: AppText('Passe o mouse'),
      ),
    ),
  ),
);

@Preview(name: 'AppTooltip • escuro (abaixo)')
Widget appTooltipDark() => AppTheme(
  data: AppThemeData.dark,
  child: const Center(
    child: AppTooltip(
      message: 'Tooltip abaixo do alvo',
      position: AppTooltipPosition.bottom,
      child: Padding(
        padding: EdgeInsets.all(AppSpacings.s8),
        child: AppText('Passe o mouse'),
      ),
    ),
  ),
);
