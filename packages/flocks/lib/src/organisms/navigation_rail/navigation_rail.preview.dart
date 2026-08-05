import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_spacings.dart';
import 'app_navigation_rail.dart';
import 'app_navigation_rail_filter.dart';
import 'app_navigation_rail_profile.dart';

// Previews nativos (Regra 5) — o rail expandido, em claro e escuro.

List<AppNavigationRailItemData> _items() => <AppNavigationRailItemData>[
  AppNavigationRailItemData(
    icon: AppIconToken.infoCircle,
    route: '/inicio',
    title: 'Início',
    onPressed: (_, _) {},
  ),
  AppNavigationRailItemData(
    icon: AppIconToken.checkCircle,
    route: '/veiculos',
    title: 'Veículos',
    onPressed: (_, _) {},
  ),
];

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(
    height: 420,
    child: AppNavigationRail(
      items: _items(),
      logoCollapsed: AppIconToken.infoCircle,
      getCurrentRoute: (_) => '/inicio',
      footer: const AppNavigationRailProfile(
        title: 'João Martins',
        subtitle: 'Operador',
        initials: 'JM',
      ),
    ),
  ),
);

@Preview(name: 'AppNavigationRail • claro')
Widget appNavigationRailLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppNavigationRail • escuro')
Widget appNavigationRailDarkPreview() => _sample(AppThemeData.dark);

// As duas linhas do rail, fora dele: o item (selecionado e não) e o filtro de
// escopo (com valor e vazio). É aqui que se compara o realce do selecionado
// com o do filtro preenchido, que no rail inteiro ficam longe um do outro.

Widget _rows(AppThemeData data) => AppTheme(
  data: data,
  child: ColoredBox(
    color: data.colorTheme.surface,
    child: SizedBox(
      width: 260,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacings.s12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacings.s8,
          children: <Widget>[
            AppNavigationRailItem(
              icon: AppIconToken.infoCircle,
              title: 'Início',
              isSelected: true,
              onPressed: () {},
            ),
            AppNavigationRailItem(
              icon: AppIconToken.checkCircle,
              title: 'Veículos',
              onPressed: () {},
            ),
            AppNavigationRailFilter(
              icon: AppIconToken.filter,
              label: 'Conta',
              value: 'Jotape',
              onTap: () {},
            ),
            AppNavigationRailFilter(
              icon: AppIconToken.filter,
              label: 'Grupo',
              onTap: () {},
            ),
          ],
        ),
      ),
    ),
  ),
);

@Preview(name: 'Item + filtro • claro')
Widget appNavigationRailRowsLightPreview() => _rows(AppThemeData.light);

@Preview(name: 'Item + filtro • escuro')
Widget appNavigationRailRowsDarkPreview() => _rows(AppThemeData.dark);
