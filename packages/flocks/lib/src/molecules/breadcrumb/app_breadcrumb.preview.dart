import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_breadcrumb.dart';

// Previews nativos (Regra 5) — claro e escuro.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: Padding(
    padding: const EdgeInsets.all(AppSpacings.s16),
    child: AppBreadcrumb(
      items: <AppBreadcrumbItem>[
        AppBreadcrumbItem(label: 'Início', onTap: () {}),
        AppBreadcrumbItem(label: 'Veículos', onTap: () {}),
        const AppBreadcrumbItem(label: 'Detalhes'),
      ],
    ),
  ),
);

@Preview(name: 'AppBreadcrumb • claro')
Widget appBreadcrumbLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppBreadcrumb • escuro')
Widget appBreadcrumbDarkPreview() => _sample(AppThemeData.dark);
