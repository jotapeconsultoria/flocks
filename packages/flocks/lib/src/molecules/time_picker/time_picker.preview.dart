import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_time_picker.dart';

// Previews nativos (Regra 5) — o painel com e sem segundos. Com `minHour` os
// valores anteriores aparecem desabilitados em vez de sumirem, que é o ponto:
// a roda mantém a altura e o limite fica visível.

Widget _frame(AppThemeData data, Widget child) => AppTheme(
  data: data,
  child: ColoredBox(
    color: data.colorTheme.surfaceContainer,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacings.s16),
      child: child,
    ),
  ),
);

Widget _sample({required bool showSeconds}) => AppTimePicker(
  initialHour: 8,
  initialMinute: 30,
  minHour: 6,
  showSeconds: showSeconds,
  onTimeSelected: (({int hour, int minute, int second}) _) {},
);

@Preview(name: 'AppTimePicker • claro')
Widget appTimePickerLightPreview() =>
    _frame(AppThemeData.light, _sample(showSeconds: false));

@Preview(name: 'AppTimePicker • escuro')
Widget appTimePickerDarkPreview() =>
    _frame(AppThemeData.dark, _sample(showSeconds: false));

@Preview(name: 'AppTimePicker • com segundos • claro')
Widget appTimePickerSecondsLightPreview() =>
    _frame(AppThemeData.light, _sample(showSeconds: true));
