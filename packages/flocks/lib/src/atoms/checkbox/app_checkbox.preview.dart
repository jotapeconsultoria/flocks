import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_checkbox.dart';

// Previews nativos (Regra 5).

@Preview(name: 'AppCheckbox • marcado (claro)')
Widget appCheckboxCheckedLight() => AppTheme(
  data: AppThemeData.light,
  child: AppCheckbox(checked: true, onChanged: (_) {}),
);

@Preview(name: 'AppCheckbox • desmarcado (escuro)')
Widget appCheckboxUncheckedDark() => AppTheme(
  data: AppThemeData.dark,
  child: AppCheckbox(checked: false, onChanged: (_) {}),
);
