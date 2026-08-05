@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Matriz {claro,escuro} × {jotape,zxtrack}. Gerar:
//   flutter test --update-goldens --tags golden
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  List<AppFormWizardStep> steps() => <AppFormWizardStep>[
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

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('AppFormWizard golden · $label', (tester) async {
        final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(1000, 700)),
              child: AppTheme(
                data: data,
                child: Container(
                  key: const Key('golden'),
                  color: data.colorTheme.surface,
                  width: 680,
                  height: 340,
                  padding: const EdgeInsets.all(24),
                  child: AppFormWizard(currentStep: 1, steps: steps()),
                ),
              ),
            ),
          ),
        );

        await expectLater(
          find.byKey(const Key('golden')),
          matchesGoldenFile('goldens/app_form_wizard_$label.png'),
        );
      });
    }
  }
}
