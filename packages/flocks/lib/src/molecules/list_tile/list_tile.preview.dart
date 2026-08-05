import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/icons/icons.dart';
import '../../theme/theme.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_spacings.dart';
import 'app_list_tile.dart';
import 'app_list_tile_action.dart';
import 'app_list_tile_checkbox.dart';
import 'app_list_tile_draggable_checkbox.dart';

// Previews nativos (Regra 5) dos três tiles LEGADOS (ver list_tile.doc.md).
// Ao lado, o equivalente novo: o preview existe para mostrar a diferença que
// sobrevive à tradução — o legado põe o rótulo apagado EM CIMA e o valor forte
// embaixo; o AppListTile faz o inverso.

Widget _frame(AppThemeData data, Widget child) => AppTheme(
  data: data,
  child: ColoredBox(
    color: data.colorTheme.surface,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacings.s16),
      child: SizedBox(width: 320, child: child),
    ),
  ),
);

Widget _gallery(AppThemeData data) => Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: <Widget>[
    AppListTileAction(
      title: 'VEÍCULOS',
      text: '3 selecionados',
      trailing: AppIcon(
        AppIconToken.swapArrow,
        color: data.colorTheme.secondary,
        size: AppIconSize.m,
      ),
      onPressed: () {},
    ),
    AppListTileCheckbox(
      title: 'TTS4G47',
      text: 'Polo Track 01',
      checked: true,
      onChanged: (bool _) {},
    ),
    AppListTileDraggableCheckbox(
      reorderIndex: 0,
      title: 'Placa',
      checked: true,
      onChanged: (bool _) {},
    ),
    const SizedBox(height: AppSpacings.s24),
    // O sucessor, para comparação: o peso troca de linha.
    AppListTile(
      title: 'VEÍCULOS',
      subtitle: '3 selecionados',
      trailing: AppIcon(
        AppIconToken.swapArrow,
        color: data.colorTheme.secondary,
        size: AppIconSize.m,
      ),
      onTap: () {},
    ),
  ],
);

@Preview(name: 'List tiles legados • claro')
Widget legacyListTilesLightPreview() =>
    _frame(AppThemeData.light, _gallery(AppThemeData.light));

@Preview(name: 'List tiles legados • escuro')
Widget legacyListTilesDarkPreview() =>
    _frame(AppThemeData.dark, _gallery(AppThemeData.dark));
