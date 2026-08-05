import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_radio.dart';

// Previews nativos (Regra 5).

@Preview(name: 'AppRadio • selecionado (claro)')
Widget appRadioSelectedLight() => AppTheme(
  data: AppThemeData.light,
  child: AppRadio<int>(value: 1, groupValue: 1, onChanged: (_) {}),
);

@Preview(name: 'AppRadio • desmarcado (escuro)')
Widget appRadioUnselectedDark() => AppTheme(
  data: AppThemeData.dark,
  child: AppRadio<int>(value: 1, groupValue: 2, onChanged: (_) {}),
);
