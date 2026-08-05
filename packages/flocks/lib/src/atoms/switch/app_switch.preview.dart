import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_switch.dart';

// Previews nativos (Regra 5).

@Preview(name: 'AppSwitch • ligado (claro)')
Widget appSwitchOnLight() => AppTheme(
  data: AppThemeData.light,
  child: AppSwitch(value: true, onChanged: (_) {}),
);

@Preview(name: 'AppSwitch • desligado (escuro)')
Widget appSwitchOffDark() => AppTheme(
  data: AppThemeData.dark,
  child: AppSwitch(value: false, onChanged: (_) {}),
);
