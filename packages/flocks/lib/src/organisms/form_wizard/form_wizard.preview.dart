import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import 'app_form_wizard.dart';
import 'app_form_wizard_step.dart';

// Previews nativos (Regra 5) — wizard de 3 passos, claro e escuro.

List<AppFormWizardStep> _steps() => <AppFormWizardStep>[
  AppFormWizardStep(
    title: 'Dados',
    subtitle: 'Identificação',
    builder: (BuildContext _) => const AppText('Formulário de dados'),
  ),
  AppFormWizardStep(
    title: 'Endereço',
    builder: (BuildContext _) => const AppText('Formulário de endereço'),
  ),
  AppFormWizardStep(
    title: 'Revisão',
    builder: (BuildContext _) => const AppText('Confira e conclua'),
  ),
];

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(
    height: 360,
    width: 640,
    child: AppFormWizard(currentStep: 1, steps: _steps()),
  ),
);

@Preview(name: 'AppFormWizard • claro')
Widget appFormWizardLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppFormWizard • escuro')
Widget appFormWizardDarkPreview() => _sample(AppThemeData.dark);
