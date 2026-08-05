import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_step_data.dart';
import 'app_stepper.dart';

// Previews nativos (Regra 5).

const _steps = <AppStepData>[
  AppStepData(title: 'Dados'),
  AppStepData(title: 'Trigger'),
  AppStepData(title: 'Ações'),
];

@Preview(name: 'AppStepper • horizontal (claro)')
Widget appStepperHorizontalLight() => AppTheme(
  data: AppThemeData.light,
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: AppStepper(currentStep: 1, steps: _steps),
  ),
);

@Preview(name: 'AppStepper • horizontal (escuro)')
Widget appStepperHorizontalDark() => AppTheme(
  data: AppThemeData.dark,
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: AppStepper(currentStep: 0, steps: _steps),
  ),
);

@Preview(name: 'AppStepper • vertical (claro)')
Widget appStepperVerticalLight() => AppTheme(
  data: AppThemeData.light,
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: AppStepper(currentStep: 1, axis: Axis.vertical, steps: _steps),
  ),
);

@Preview(name: 'AppStepper • vertical (escuro)')
Widget appStepperVerticalDark() => AppTheme(
  data: AppThemeData.dark,
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: AppStepper(currentStep: 1, axis: Axis.vertical, steps: _steps),
  ),
);
