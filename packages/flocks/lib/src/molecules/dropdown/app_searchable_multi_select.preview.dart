import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_dropdown_option.dart';
import 'app_searchable_multi_select.dart';

// Previews nativos (Regra 5) — trigger com chips, claro e escuro.

const List<AppDropdownOption<String>> _opts = <AppDropdownOption<String>>[
  AppDropdownOption<String>(value: 'b', label: 'Banana'),
  AppDropdownOption<String>(value: 'm', label: 'Manga'),
];

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(
    width: 280,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacings.s16),
      child: AppSearchableMultiSelect<String>(
        label: 'Clientes',
        searchHintText: 'Buscar…',
        options: _opts,
        selectedValues: const <String>['b'],
        onChanged: (_) {},
      ),
    ),
  ),
);

@Preview(name: 'AppSearchableMultiSelect • claro')
Widget appSearchableMultiSelectLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppSearchableMultiSelect • escuro')
Widget appSearchableMultiSelectDarkPreview() => _sample(AppThemeData.dark);
