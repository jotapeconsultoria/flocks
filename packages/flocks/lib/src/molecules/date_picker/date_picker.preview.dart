import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_date_picker.dart';
import 'app_date_range_picker.dart';
import 'date_picker_core.dart';

// Previews nativos (Regra 5). `today` é fixo de propósito: um preview que lê o
// relógio muda de aparência a cada dia e deixa de servir de referência.

final DateTime _today = DateTime(2026, 7, 15);

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

@Preview(name: 'AppDatePicker • claro')
Widget appDatePickerLightPreview() => _frame(
  AppThemeData.light,
  AppDatePicker(
    initialDate: _today,
    today: _today,
    markToday: true,
    onDateSelected: (DateTime _) {},
  ),
);

@Preview(name: 'AppDatePicker • escuro')
Widget appDatePickerDarkPreview() => _frame(
  AppThemeData.dark,
  AppDatePicker(
    initialDate: _today,
    today: _today,
    markToday: true,
    onDateSelected: (DateTime _) {},
  ),
);

@Preview(name: 'AppDateRangePicker • claro')
Widget appDateRangePickerLightPreview() => _frame(
  AppThemeData.light,
  AppDateRangePicker(
    today: _today,
    initialRange: AppDateRange(DateTime(2026, 7, 8), DateTime(2026, 7, 21)),
    onRangeSelected: (AppDateRange _) {},
  ),
);

@Preview(name: 'AppDateRangePicker • escuro')
Widget appDateRangePickerDarkPreview() => _frame(
  AppThemeData.dark,
  AppDateRangePicker(
    today: _today,
    initialRange: AppDateRange(DateTime(2026, 7, 8), DateTime(2026, 7, 21)),
    onRangeSelected: (AppDateRange _) {},
  ),
);
