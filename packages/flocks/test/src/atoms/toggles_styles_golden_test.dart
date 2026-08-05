@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Os 3 tratamentos de container (filled/outlined/elevated) do eixo AppStyle
// aplicados aos toggles (checkbox + switch), cada um marcado e desmarcado.
// Prova visual: `filled` = poço `surfaceContainer` sem borda no vazio/off,
// `outlined` = borda (switch off vazado), `elevated` = superfície + sombra.
// Matriz {jotape,zxtrack} × {claro,escuro}. Gerar:
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

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('Toggles styles golden · $label', (tester) async {
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
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 24,
                    children: <Widget>[
                      for (final AppStyle style in styles)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 24,
                          children: <Widget>[
                            AppCheckbox(
                              checked: true,
                              style: style,
                              onChanged: (_) {},
                            ),
                            AppCheckbox(
                              checked: false,
                              style: style,
                              onChanged: (_) {},
                            ),
                            AppSwitch(
                              value: true,
                              style: style,
                              onChanged: (_) {},
                            ),
                            AppSwitch(
                              value: false,
                              style: style,
                              onChanged: (_) {},
                            ),
                          ],
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
          matchesGoldenFile('goldens/toggles_styles_$label.png'),
        );
      });
    }
  }
}
