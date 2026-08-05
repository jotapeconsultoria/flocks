import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_sheet_side.dart';
import 'app_side_sheet.dart';
import 'app_side_sheet_page.dart';

// Previews nativos (Regra 5) — a superfície do side sheet (repouso) ancorada à
// direita/esquerda, em claro/escuro. (O modal com barrier/arraste vem de
// showAppSideSheet.)

Widget _sample(AppThemeData data, AppSheetSide side) => AppTheme(
  data: data,
  child: Align(
    alignment: side == AppSheetSide.end
        ? Alignment.centerRight
        : Alignment.centerLeft,
    child: SizedBox(
      width: 360,
      height: 520,
      child: AppSideSheet(
        side: side,
        title: 'Veículo',
        footer: Padding(
          padding: const EdgeInsets.all(AppSpacings.s16),
          child: AppText('Editar', style: data.textTheme.titleMedium),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacings.s24),
          child: AppText('Detalhes', style: data.textTheme.bodyLarge),
        ),
      ),
    ),
  ),
);

@Preview(name: 'AppSideSheet • direita (end) • claro')
Widget appSideSheetEndLightPreview() =>
    _sample(AppThemeData.light, AppSheetSide.end);

@Preview(name: 'AppSideSheet • esquerda (start) • escuro')
Widget appSideSheetStartDarkPreview() =>
    _sample(AppThemeData.dark, AppSheetSide.start);

// A variante PAGE. Visualmente é a MESMA superfície — o que muda é a classe da
// rota (`SideSheetPageRoute`, persistente). O preview existe para o widget não
// ficar sem cobertura, não para mostrar diferença: não há.
Widget _page(AppThemeData data) => AppTheme(
  data: data,
  child: Align(
    alignment: Alignment.centerRight,
    child: SizedBox(
      width: 360,
      height: 520,
      child: AppSideSheetPage(
        title: 'Ficha do veículo',
        footer: Padding(
          padding: const EdgeInsets.all(AppSpacings.s16),
          child: AppText('Editar', style: data.textTheme.titleMedium),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacings.s24),
          child: AppText('Detalhes', style: data.textTheme.bodyLarge),
        ),
      ),
    ),
  ),
);

@Preview(name: 'AppSideSheetPage • claro')
Widget appSideSheetPageLightPreview() => _page(AppThemeData.light);

@Preview(name: 'AppSideSheetPage • escuro')
Widget appSideSheetPageDarkPreview() => _page(AppThemeData.dark);
