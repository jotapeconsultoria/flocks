import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_simple_data_table.dart';

// Previews nativos (Regra 5) — o grid estático, em claro e escuro. (O
// AppDataTable paginado é exercitado no Widgetbook.)

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: const Padding(
    padding: EdgeInsets.all(AppSpacings.s16),
    child: AppSimpleDataTable(
      columnLabels: <String>['Placa', 'Modelo'],
      rows: <List<Widget>>[
        <Widget>[AppText('ABC-1234'), AppText('GV75')],
        <Widget>[AppText('XYZ-9876'), AppText('GV55')],
      ],
    ),
  ),
);

@Preview(name: 'AppSimpleDataTable • claro')
Widget appSimpleDataTableLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppSimpleDataTable • escuro')
Widget appSimpleDataTableDarkPreview() => _sample(AppThemeData.dark);
