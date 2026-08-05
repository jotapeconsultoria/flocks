import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppFormWizard — formulário multi-passo com indicador de progresso.
// ---------------------------------------------------------------------------

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

@widgetbook.UseCase(name: 'Playground', type: AppFormWizard)
Widget formWizardPlayground(BuildContext context) {
  final int currentStep = context.knobs.int.slider(
    label: 'currentStep',
    initialValue: 1,
    min: 0,
    max: 2,
  );
  final bool showIndicator = context.knobs.boolean(
    label: 'showIndicator',
    initialValue: true,
  );
  return wbUseCase(
    context,
    name: 'AppFormWizard',
    description:
        'Multi-step form. The indicator sits beside (desktop) or above (mobile) '
        'the panel — resize the device frame to see it switch.',
    maxWidth: 680,
    child: SizedBox(
      height: 360,
      child: AppFormWizard(
        currentStep: currentStep,
        steps: _steps(),
        showIndicator: showIndicator,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppFormWizard)
Widget formWizardStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppFormWizard',
  description: 'Progress at the first, middle and last step.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      for (final int step in <int>[0, 1, 2])
        wbState(
          context,
          name: 'Step $step',
          width: 300,
          child: SizedBox(
            height: 320,
            child: AppFormWizard(currentStep: step, steps: _steps()),
          ),
        ),
    ],
  ),
);
