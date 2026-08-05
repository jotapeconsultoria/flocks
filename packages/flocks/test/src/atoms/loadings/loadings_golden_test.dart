@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Matriz {claro,escuro} × {jotape,zxtrack} — prova visual da Regra 9. Roda sob
// reduce-motion (disableAnimations) para colapsar os loops indeterminados num
// frame estável. Gerar: flutter test --update-goldens --tags golden
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('Loadings golden · $label', (tester) async {
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
                  child: SizedBox(
                    width: 220,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const AppCircularLoading(size: 40),
                        const SizedBox(height: 24),
                        const AppCircularLoading(size: 40, value: 0.7),
                        const SizedBox(height: 24),
                        const AppLinearLoading(),
                        const SizedBox(height: 24),
                        const AppLinearLoading(value: 0.6),
                        const SizedBox(height: 24),
                        AppBorderProgress(
                          progress: 0.6,
                          borderRadius: BorderRadius.circular(AppRadius.m),
                          child: const Padding(
                            padding: EdgeInsets.all(12),
                            child: AppText('Uploading…'),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const AppShimmerLoading(height: 24, width: 160),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byKey(const Key('golden')),
          matchesGoldenFile('goldens/loadings_$label.png'),
        );
      });
    }
  }
}
