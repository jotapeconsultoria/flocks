import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_segmented_button.dart';

// Previews nativos (Regra 5). Estado fixo (o onChanged é no-op no preview).

@Preview(name: 'AppSegmentedButton • claro')
Widget appSegmentedButtonLight() => AppTheme(
  data: AppThemeData.light,
  child: Center(
    child: AppSegmentedButton<int>(
      value: 1,
      onChanged: (_) {},
      segments: const <AppSegment<int>>[
        AppSegment<int>(value: 0, label: 'Dia'),
        AppSegment<int>(value: 1, label: 'Semana'),
        AppSegment<int>(value: 2, label: 'Mês'),
      ],
    ),
  ),
);

@Preview(name: 'AppSegmentedButton • escuro (expandido)')
Widget appSegmentedButtonDark() => AppTheme(
  data: AppThemeData.dark,
  child: Padding(
    padding: const EdgeInsets.all(24),
    child: AppSegmentedButton<int>(
      value: 0,
      expanded: true,
      onChanged: (_) {},
      segments: const <AppSegment<int>>[
        AppSegment<int>(value: 0, label: 'Ruas'),
        AppSegment<int>(value: 1, label: 'Satélite'),
      ],
    ),
  ),
);
