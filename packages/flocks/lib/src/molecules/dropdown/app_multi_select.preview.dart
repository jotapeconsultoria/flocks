import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_dropdown_option.dart';
import 'app_multi_select.dart';

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
      child: AppMultiSelect<String>(
        label: 'Frutas',
        options: _opts,
        selectedValues: const <String>['b', 'm'],
        onChanged: (_) {},
      ),
    ),
  ),
);

@Preview(name: 'AppMultiSelect • claro')
Widget appMultiSelectLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppMultiSelect • escuro')
Widget appMultiSelectDarkPreview() => _sample(AppThemeData.dark);
