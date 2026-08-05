import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_bottom_sheet.dart';
import 'app_bottom_sheet_content.dart';
import 'app_bottom_sheet_page.dart';

// Previews nativos (Regra 5) — as superfícies dos bottom sheets em claro/escuro.
// (O modal com barrier/arraste vem de showAppBottomSheet/showAppBottomSheetPage.)

Widget _footer(AppThemeData data) => Padding(
  padding: const EdgeInsets.all(AppSpacings.s16),
  child: AppText('Aplicar', style: data.textTheme.titleMedium),
);

Widget _body(AppThemeData data) => Padding(
  padding: const EdgeInsets.all(AppSpacings.s24),
  child: AppText('Conteúdo', style: data.textTheme.bodyLarge),
);

Widget _sheet(AppThemeData data) => AppTheme(
  data: data,
  child: Align(
    alignment: Alignment.bottomCenter,
    child: SizedBox(
      width: 380,
      child: AppBottomSheet(
        title: 'Filtros',
        footer: _footer(data),
        child: _body(data),
      ),
    ),
  ),
);

Widget _page(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(
    width: 380,
    height: 420,
    child: AppBottomSheetPage(
      title: 'Ajustes',
      footer: _footer(data),
      child: _body(data),
    ),
  ),
);

@Preview(name: 'AppBottomSheet • claro')
Widget appBottomSheetLightPreview() => _sheet(AppThemeData.light);

@Preview(name: 'AppBottomSheet • escuro')
Widget appBottomSheetDarkPreview() => _sheet(AppThemeData.dark);

@Preview(name: 'AppBottomSheetPage • claro')
Widget appBottomSheetPageLightPreview() => _page(AppThemeData.light);

@Preview(name: 'AppBottomSheetPage • escuro')
Widget appBottomSheetPageDarkPreview() => _page(AppThemeData.dark);

// O corpo padrão, fora da sheet: é ele que carrega ilustração + título +
// mensagem centralizados. A sheet só o envelopa.
Widget _content(AppThemeData data) => AppTheme(
  data: data,
  child: ColoredBox(
    color: data.colorTheme.surface,
    child: const SizedBox(
      width: 380,
      child: AppBottomSheetContent(
        title: 'Atenção',
        message: 'Confira os dados antes de continuar.',
        illustration: 'assets/illustrations/warning.svg',
      ),
    ),
  ),
);

@Preview(name: 'AppBottomSheetContent • claro')
Widget appBottomSheetContentLightPreview() => _content(AppThemeData.light);

@Preview(name: 'AppBottomSheetContent • escuro')
Widget appBottomSheetContentDarkPreview() => _content(AppThemeData.dark);
