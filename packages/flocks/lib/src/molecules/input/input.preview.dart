import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_date_picker_input.dart';
import 'app_date_time_picker_input.dart';
import 'app_time_picker_input.dart';

// Previews nativos (Regra 5) — os três campos com seletor, lado a lado. O
// painel só existe depois de um toque, então o que se vê aqui é o campo em
// repouso: máscara no hint e o ícone que abre o seletor.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: ColoredBox(
    color: data.colorTheme.surface,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacings.s24),
      child: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacings.s16,
          children: <Widget>[
            AppDatePickerInput(
              label: 'Vencimento',
              hintText: 'DD/MM/AAAA',
              onDateSelected: (DateTime _) {},
            ),
            AppTimePickerInput(
              label: 'Abre às',
              hintText: 'HH:mm',
              onTimeSelected: (_) {},
            ),
            AppDateTimePickerInput(
              label: 'Executar em',
              hintText: 'DD/MM/AAAA HH:mm',
              helperText: 'Data e hora são um dado só.',
              onDateTimeSelected: (DateTime _) {},
            ),
          ],
        ),
      ),
    ),
  ),
);

@Preview(name: 'Campos com seletor • claro')
Widget pickerInputsLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'Campos com seletor • escuro')
Widget pickerInputsDarkPreview() => _sample(AppThemeData.dark);
