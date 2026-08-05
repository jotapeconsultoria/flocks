@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Os 3 tratamentos de container (filled/outlined/elevated) do eixo AppStyle no
// AppSegmentedButton. `filled` = trilho `surfaceContainer` sem borda; `outlined`
// = trilho VAZADO (transparente) só com a borda `outline`; `elevated` = trilho
// com sombra E a pílula selecionada acompanha a sombra (seleção flutuante). A
// pílula continua sendo o indicador sólido (`primary`). Matriz
// {jotape,zxtrack} × {claro,escuro}. Gerar:
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

      testWidgets('AppSegmentedButton styles golden · $label', (tester) async {
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
                  width: 360,
                  // Padding folgado para a sombra do `elevated` caber no golden.
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 28,
                    children: <Widget>[
                      for (final AppStyle style in styles)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 12,
                          children: <Widget>[
                            AppText('AppStyle.${style.name}'),
                            AppSegmentedButton<int>(
                              value: 1,
                              style: style,
                              onChanged: _noop,
                              segments: const <AppSegment<int>>[
                                AppSegment<int>(value: 0, label: 'Dia'),
                                AppSegment<int>(value: 1, label: 'Semana'),
                                AppSegment<int>(value: 2, label: 'Mês'),
                              ],
                            ),
                            AppSegmentedButton<int>(
                              value: 0,
                              style: style,
                              expanded: true,
                              onChanged: _noop,
                              segments: const <AppSegment<int>>[
                                AppSegment<int>(value: 0, label: 'A'),
                                AppSegment<int>(value: 1, label: 'B'),
                                AppSegment<int>(value: 2, label: 'C'),
                              ],
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
          matchesGoldenFile('goldens/app_segmented_button_styles_$label.png'),
        );
      });
    }
  }
}

void _noop(int _) {}
