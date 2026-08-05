import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_dropdown_option.dart';
import 'app_searchable_dropdown.dart';

// Previews nativos (Regra 5) — trigger fechado, claro e escuro.

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
      child: AppSearchableDropdown<String>(
        label: 'Cliente',
        hintText: 'Selecione',
        searchHintText: 'Buscar…',
        options: _opts,
        onChanged: (_) {},
      ),
    ),
  ),
);

@Preview(name: 'AppSearchableDropdown • claro')
Widget appSearchableDropdownLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppSearchableDropdown • escuro')
Widget appSearchableDropdownDarkPreview() => _sample(AppThemeData.dark);
