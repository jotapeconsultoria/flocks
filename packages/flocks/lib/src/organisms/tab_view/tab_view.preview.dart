import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import 'app_tab_view.dart';

// Previews nativos (Regra 5) — abas em claro e escuro.

List<AppTabViewItem> _items() => <AppTabViewItem>[
  AppTabViewItem(
    label: 'Resumo',
    builder: (BuildContext _) => const AppText('Conteúdo do resumo'),
  ),
  AppTabViewItem(
    label: 'Detalhes',
    builder: (BuildContext _) => const AppText('Conteúdo dos detalhes'),
  ),
  AppTabViewItem(
    label: 'Histórico',
    builder: (BuildContext _) => const AppText('Conteúdo do histórico'),
  ),
];

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(height: 220, width: 480, child: AppTabView(items: _items())),
);

@Preview(name: 'AppTabView • claro')
Widget appTabViewLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppTabView • escuro')
Widget appTabViewDarkPreview() => _sample(AppThemeData.dark);
