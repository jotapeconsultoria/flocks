import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import '../card/card.dart';
import 'app_popover.dart';

// Previews nativos (Regra 5). Clique no alvo para abrir o painel.

@Preview(name: 'AppPopover • claro (clique para abrir)')
Widget appPopoverLight() => AppTheme(
  data: AppThemeData.light,
  child: const Center(
    child: AppPopover(
      title: 'Sobre o score',
      maxWidth: 240,
      trigger: Padding(
        padding: EdgeInsets.all(AppSpacings.s8),
        child: AppText('Ver detalhes'),
      ),
      child: AppText(
        'O score combina frenagens bruscas, curvas e velocidade média.',
      ),
    ),
  ),
);

@Preview(name: 'AppPopover • escuro (acima)')
Widget appPopoverDark() => AppTheme(
  data: AppThemeData.dark,
  child: const Center(
    child: AppPopover(
      placement: AppOverlayPlacement.topCenter,
      maxWidth: 240,
      trigger: Padding(
        padding: EdgeInsets.all(AppSpacings.s8),
        child: AppText('Passe o conteúdo'),
      ),
      child: AppText('Popover acima do alvo, com seta apontando abaixo.'),
    ),
  ),
);
