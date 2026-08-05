@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Matriz {claro,escuro} × {jotape,zxtrack} — prova visual da Regra 9 (tema E
// brand). Tagueado `golden` e EXCLUÍDO da CI geral. Gerar/atualizar:
//   flutter test --update-goldens --tags golden
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('AppRichText golden · $label', (tester) async {
        final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);
        final TextStyle base = data.textTheme.bodyMedium.withColor(
          data.colorTheme.onSurface,
        );

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
                  padding: const EdgeInsets.all(24),
                  child: AppRichText(
                    AppTextSpan(
                      style: base,
                      children: <InlineSpan>[
                        const TextSpan(text: 'Speed: '),
                        TextSpan(
                          text: '92 km/h',
                          style: base.bold.withColor(data.colorTheme.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        await expectLater(
          find.byKey(const Key('golden')),
          matchesGoldenFile('goldens/app_rich_text_$label.png'),
        );
      });
    }
  }
}
