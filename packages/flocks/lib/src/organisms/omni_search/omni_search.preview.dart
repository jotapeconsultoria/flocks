import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_omni_search.dart';
import 'app_omni_search_models.dart';

// Previews nativos (Regra 5) — claro e escuro.

Future<AppOmniSearchResult> _fakeSearch(String term) async =>
    AppOmniSearchResult(
      groups: [
        AppOmniSearchGroup(
          label: 'Veículos',
          items: [
            AppOmniSearchItem(
              id: 'v1',
              title: 'KRO3E75',
              subtitle: 'Caminhos Dourados',
              onSelected: () {},
            ),
          ],
        ),
      ],
    );

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: const SizedBox(
    height: 120,
    width: 480,
    child: Align(
      alignment: Alignment.topCenter,
      child: AppOmniSearch(
        helperText: 'Placa, chassi, CPF, CNPJ, IMEI, ICCID…',
        onSearch: _fakeSearch,
      ),
    ),
  ),
);

@Preview(name: 'AppOmniSearch • claro')
Widget appOmniSearchLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppOmniSearch • escuro')
Widget appOmniSearchDarkPreview() => _sample(AppThemeData.dark);
