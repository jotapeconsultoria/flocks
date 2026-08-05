import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_illustrations.dart';
import 'app_list_empty.dart';

// Previews nativos (Regra 5) — claro e escuro.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: const SizedBox(
    width: 360,
    height: 360,
    child: AppListEmpty(
      illustration: AppIllustrations.empty,
      text: 'Nenhum resultado encontrado.',
    ),
  ),
);

@Preview(name: 'AppListEmpty • claro')
Widget appListEmptyLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppListEmpty • escuro')
Widget appListEmptyDarkPreview() => _sample(AppThemeData.dark);
