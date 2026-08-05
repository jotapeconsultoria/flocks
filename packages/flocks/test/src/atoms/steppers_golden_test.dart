@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Matriz {claro,escuro} × {jotape,zxtrack}. Cores `primary`/`secondary`/`tertiary`
// são brand-aware → Regra 9. O indicador usa currentStep: 0 para não renderizar o
// check dos passos concluídos (AppIcon bateria na rede); esse estado é coberto
// pelos widget tests. disableAnimations congela as transições.
const _steps = <AppStepData>[
  AppStepData(title: 'Dados'),
  AppStepData(title: 'Trigger'),
  AppStepData(title: 'Ações'),
];

// Com subtítulo → label mais alto que o círculo. Prova que a linha vertical
// encosta nos dois círculos mesmo com título+subtítulo.
const _stepsSub = <AppStepData>[
  AppStepData(title: 'Dados', subtitle: 'Identificação'),
  AppStepData(title: 'Trigger', subtitle: 'Condições'),
  AppStepData(title: 'Ações', subtitle: 'O que fazer'),
];

void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('Steppers golden · $label', (tester) async {
        final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: AppTheme(
                data: data,
                child: Container(
                  key: const Key('golden'),
                  width: 460,
                  color: data.colorTheme.surface,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 24,
                    children: [
                      const AppDotsIndicator(currentStep: 1, totalSteps: 4),
                      AppStepper(currentStep: 0, steps: _steps),
                      AppStepper(
                        currentStep: 0,
                        axis: Axis.vertical,
                        steps: _stepsSub,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        await expectLater(
          find.byKey(const Key('golden')),
          matchesGoldenFile('goldens/steppers_$label.png'),
        );
      });
    }
  }
}
