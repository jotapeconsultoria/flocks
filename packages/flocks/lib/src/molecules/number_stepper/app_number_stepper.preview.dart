import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_number_stepper.dart';

// Previews nativos (Regra 5). onChanged no-op (estado fixo no preview).

@Preview(name: 'AppNumberStepper • claro')
Widget appNumberStepperLight() => AppTheme(
  data: AppThemeData.light,
  child: const Center(
    child: AppNumberStepper(value: 3, min: 0, max: 10, onChanged: _noop),
  ),
);

@Preview(name: 'AppNumberStepper • escuro (no mínimo)')
Widget appNumberStepperDark() => AppTheme(
  data: AppThemeData.dark,
  child: const Center(
    child: AppNumberStepper(value: 0, min: 0, max: 10, onChanged: _noop),
  ),
);

void _noop(num _) {}
