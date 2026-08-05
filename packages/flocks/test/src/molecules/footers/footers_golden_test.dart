@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flocks/src/atoms/bars/bar_preview_scene.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Matriz {claro,escuro} × {jotape,zxtrack} — footers sem ícone de rede
// (AppButtonsFooter só-rótulo + AppSimpleFooter). Gerar:
//   flutter test --update-goldens --tags golden
//
// Sobre `barPreviewScene` (ver a nota gêmea no golden dos headers): num fundo
// chapado o eixo glass — ligado nas duas marcas — não tem o que desfocar.
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('Footers golden · $label', (tester) async {
        final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(),
              child: AppTheme(
                data: data,
                child: Container(
                  key: const Key('golden'),
                  color: data.colorTheme.surface,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      barPreviewScene(
                        footer: AppButtonsFooter(
                          style: AppButtonsFooterStyle.card,
                          primary: AppButton(label: 'Salvar', onPressed: () {}),
                          secondary: AppButton(
                            style: AppStyle.outlined,
                            label: 'Cancelar',
                            onPressed: () {},
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      barPreviewScene(
                        footer: const AppSimpleFooter(
                          child: AppText('© 2026 Tracked'),
                        ),
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
          matchesGoldenFile('goldens/footers_$label.png'),
        );
      });
    }
  }
}
