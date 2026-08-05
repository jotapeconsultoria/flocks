import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(size: Size(1000, 700)),
    child: AppTheme(
      data: AppThemeData.light,
      child: SizedBox(height: 400, child: child),
    ),
  ),
);

List<AppFormWizardStep> _steps() => <AppFormWizardStep>[
  AppFormWizardStep(
    title: 'Dados',
    builder: (BuildContext _) => const AppText('painel-dados'),
  ),
  AppFormWizardStep(
    title: 'Revisão',
    builder: (BuildContext _) => const AppText('painel-revisao'),
  ),
];

void main() {
  testWidgets('AppFormWizard mostra o painel do passo atual + títulos', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(AppFormWizard(currentStep: 0, steps: _steps())),
    );
    expect(find.text('Dados'), findsWidgets);
    expect(find.text('painel-dados'), findsOneWidget);
  });

  testWidgets('AppFormWizard troca o painel conforme currentStep', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(AppFormWizard(currentStep: 1, steps: _steps())),
    );
    // O painel agora mostra o segundo passo; o indicador lista ambos.
    expect(find.text('painel-revisao'), findsOneWidget);
    expect(find.text('painel-dados'), findsNothing);
    expect(find.text('Dados'), findsWidgets);
    expect(find.text('Revisão'), findsWidgets);
  });

  test('AppFormWizard no catálogo como migrated', () {
    expect(
      flocksCatalog.any(
        (AppComponentMeta m) =>
            m.id == 'app_form_wizard' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
