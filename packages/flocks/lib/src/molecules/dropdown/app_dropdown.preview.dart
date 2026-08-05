import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_dropdown.dart';
import 'app_dropdown_option.dart';

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
      child: AppDropdown<String>(
        label: 'Fruta',
        options: _opts,
        selectedValue: 'b',
        onChanged: (_) {},
      ),
    ),
  ),
);

@Preview(name: 'AppDropdown • claro')
Widget appDropdownLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppDropdown • escuro')
Widget appDropdownDarkPreview() => _sample(AppThemeData.dark);
