@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Os 3 tratamentos de container (filled/outlined/elevated) do eixo AppStyle nos
// dois indicadores. Wizard: círculo alcançado (ativo) = preenchido; futuro =
// poço `s200` (filled) / contorno (outlined) / poço+sombra (elevated). Dots: o
// estilo vai na pílula. currentStep: 0 evita o check dos concluídos (AppIcon de
// rede). Matriz {jotape,zxtrack} × {claro,escuro}. Gerar:
//   flutter test --update-goldens --tags golden
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];
  const List<AppStyle> styles = <AppStyle>[
    AppStyle.filled,
    AppStyle.outlined,
    AppStyle.elevated,
  ];
  const List<AppStepData> steps = <AppStepData>[
    AppStepData(title: 'Dados'),
    AppStepData(title: 'Trigger'),
    AppStepData(title: 'Ações'),
  ];

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('Steppers styles golden · $label', (tester) async {
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
                    children: <Widget>[
                      for (final AppStyle style in styles)
                        AppDotsIndicator(
                          currentStep: 1,
                          totalSteps: 4,
                          style: style,
                        ),
                      for (final AppStyle style in styles)
                        AppStepper(currentStep: 0, steps: steps, style: style),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        await expectLater(
          find.byKey(const Key('golden')),
          matchesGoldenFile('goldens/steppers_styles_$label.png'),
        );
      });
    }
  }
}
