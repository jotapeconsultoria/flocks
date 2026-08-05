import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_dots_indicator.dart';

// Previews nativos (Regra 5).

@Preview(name: 'AppDotsIndicator • claro')
Widget appDotsIndicatorLight() => AppTheme(
  data: AppThemeData.light,
  child: const AppDotsIndicator(currentStep: 1, totalSteps: 4),
);

@Preview(name: 'AppDotsIndicator • escuro')
Widget appDotsIndicatorDark() => AppTheme(
  data: AppThemeData.dark,
  child: const AppDotsIndicator(currentStep: 1, totalSteps: 4),
);
