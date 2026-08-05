@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Matriz {claro,escuro} × {jotape,zxtrack} — 4 estilos × formas (só-ícone,
// estendido, só-texto). Ícones via stub determinístico (flutter_test_config).
// Gerar:
//   flutter test --update-goldens --tags golden
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('AppFloatingButton golden · $label', (tester) async {
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
                  color: data.colorTheme.surface,
                  width: 420,
                  padding: const EdgeInsets.all(32),
                  child: Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      AppFloatingButton(icon: AppIcons.add, onPressed: () {}),
                      AppFloatingButton(
                        style: AppStyle.outlined,
                        icon: AppIcons.add,
                        onPressed: () {},
                      ),
                      AppFloatingButton(
                        style: AppStyle.elevated,
                        icon: AppIcons.add,
                        onPressed: () {},
                      ),
                      AppFloatingButton(
                        glass: true,
                        icon: AppIcons.add,
                        onPressed: () {},
                      ),
                      AppFloatingButton(
                        icon: AppIcons.add,
                        label: 'Novo',
                        onPressed: () {},
                      ),
                      AppFloatingButton(label: 'Novo', onPressed: () {}),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        await expectLater(
          find.byKey(const Key('golden')),
          matchesGoldenFile('goldens/app_floating_button_$label.png'),
        );
      });
    }
  }
}
