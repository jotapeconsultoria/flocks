import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_color_picker_input.dart';
import 'app_color_picker_panel.dart';

// Previews nativos (Regra 5) — o campo em repouso (amostra no prefixo, hex
// como valor) e o painel aberto. O overlay do campo só existe depois de um
// toque, então o painel aparece solto ao lado.

const Color _brand = Color(0xFFFF5B04);

Widget _frame(AppThemeData data, Widget child) => AppTheme(
  data: data,
  child: ColoredBox(
    color: data.colorTheme.surface,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacings.s24),
      child: child,
    ),
  ),
);

Widget _sample() => Row(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.start,
  spacing: AppSpacings.s24,
  children: <Widget>[
    SizedBox(
      width: 260,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacings.s16,
        children: <Widget>[
          AppColorPickerInput(
            label: 'Cor',
            value: '#FF5B04',
            onChanged: (String _) {},
          ),
          AppColorPickerInput(
            label: 'Cor',
            value: 'ZZZ',
            errorText: 'Hex inválido.',
            onChanged: (String _) {},
          ),
        ],
      ),
    ),
    SizedBox(
      width: 260,
      child: AppColorPickerPanel(color: _brand, onColorChanged: (Color _) {}),
    ),
  ],
);

@Preview(name: 'Color picker • claro')
Widget appColorPickerLightPreview() => _frame(AppThemeData.light, _sample());

@Preview(name: 'Color picker • escuro')
Widget appColorPickerDarkPreview() => _frame(AppThemeData.dark, _sample());
