import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_slider.dart';

// Previews nativos (Regra 5) — o slider por passo com rótulo de valor e o
// contínuo desabilitado, em claro e escuro.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: Center(
    child: SizedBox(
      width: 320,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppSlider(
            value: 42,
            min: 1,
            max: 60,
            step: 1,
            showValue: true,
            formatValue: (double v) => '${v.round()}/min',
            semanticLabel: 'Ritmo de envio',
            onChanged: (_) {},
          ),
          const AppSlider(value: 0.35, onChanged: null),
        ],
      ),
    ),
  ),
);

@Preview(name: 'AppSlider • claro')
Widget appSliderLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppSlider • escuro')
Widget appSliderDarkPreview() => _sample(AppThemeData.dark);
