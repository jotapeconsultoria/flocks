import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import '../date_picker/app_date_picker.dart';
import 'app_picker_anchor.dart';

// Previews nativos (Regra 5). Clique no trigger para abrir o painel ancorado.

@Preview(name: 'AppPickerAnchor • date picker (clique p/ abrir)')
Widget appPickerAnchorLight() => AppTheme(
  data: AppThemeData.light,
  child: Center(
    child: AppPickerAnchor(
      width: const AppPickerWidth.matchTrigger(min: 300),
      trigger: (context, handle) => GestureDetector(
        onTap: handle.toggle,
        child: const Padding(
          padding: EdgeInsets.all(AppSpacings.s8),
          child: AppText('Escolher data'),
        ),
      ),
      panel: (context, handle) => AppDatePicker(
        initialDate: DateTime(2026, 7, 14),
        onDateSelected: (_) => handle.close(),
      ),
    ),
  ),
);
