import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import 'app_resizable_panel.dart';

// Previews nativos (Regra 5) — claro e escuro.

Widget _area(AppThemeData data, String label) => ColoredBox(
  color: data.colorTheme.surfaceContainer,
  child: Center(child: AppText(label)),
);

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(
    height: 240,
    width: 520,
    child: Row(
      children: <Widget>[
        Expanded(child: _area(data, 'Conteúdo')),
        AppResizablePanel(
          initialWidth: 180,
          minWidth: 120,
          maxWidth: 320,
          child: _area(data, 'Assistente'),
        ),
      ],
    ),
  ),
);

@Preview(name: 'AppResizablePanel • claro')
Widget appResizablePanelLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppResizablePanel • escuro')
Widget appResizablePanelDarkPreview() => _sample(AppThemeData.dark);
