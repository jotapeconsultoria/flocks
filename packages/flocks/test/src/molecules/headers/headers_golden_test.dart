@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flocks/src/atoms/bars/bar_preview_scene.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Matriz {claro,escuro} × {jotape,zxtrack}. Gerar:
//   flutter test --update-goldens --tags golden
//
// Os headers são capturados sobre `barPreviewScene` — a MESMA cena dos previews
// — e não sobre um retângulo chapado de `surface`. Num fundo liso o vidro não
// tem o que desfocar: as duas marcas ligam o eixo glass, então um golden chapado
// registrava um degradê de tint e nada da rampa de blur, deixando justamente o
// tratamento mais frágil sem cobertura.
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('Headers golden · $label', (tester) async {
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
                        header: const AppSimpleHeader(
                          child: AppText('Título da página'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      barPreviewScene(
                        header: const AppPrimaryHeader(
                          leading: AppText('‹'),
                          trailing: AppText('•••'),
                          child: AppText('Detalhes'),
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
          matchesGoldenFile('goldens/headers_$label.png'),
        );
      });
    }
  }
}
