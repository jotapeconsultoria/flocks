import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/bars/bar_preview_scene.dart';
import '../../theme/theme.dart';
import '../../tokens/app_icon_token.dart';
import 'app_navigation_footer.dart';

// Previews nativos (Regra 5) — claro e escuro. O 2º item é o ativo.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: barPreviewScene(
    footer: AppNavigationFooter(
      getCurrentRoute: (_) => '/vehicles',
      items: <AppNavigationFooterItemData>[
        AppNavigationFooterItemData(
          icon: AppIconToken.dashboard,
          title: 'Início',
          route: '/home',
          onPressed: (_, _) {},
        ),
        AppNavigationFooterItemData(
          icon: AppIconToken.car,
          title: 'Veículos',
          route: '/vehicles',
          onPressed: (_, _) {},
        ),
      ],
    ),
  ),
);

@Preview(name: 'AppNavigationFooter • claro')
Widget appNavigationFooterLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppNavigationFooter • escuro')
Widget appNavigationFooterDarkPreview() => _sample(AppThemeData.dark);
