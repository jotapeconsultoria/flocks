@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Matriz {claro,escuro} × {jotape,zxtrack} — prova visual da Regra 9. Gerar:
//   flutter test --update-goldens --tags golden
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('AppCard golden · $label', (tester) async {
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
                  width: 360,
                  padding: const EdgeInsets.all(32),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 20,
                    children: <Widget>[
                      // Header (título + ação) + child, elevado.
                      AppCard(
                        style: AppStyle.elevated,
                        headerTitle: 'Localização',
                        headerTrailing: AppText('Ver no mapa'),
                        child: AppText('Av. Quintino Bocaiúva, 61'),
                      ),
                      // Header + child + footer, com divisórias.
                      AppCard(
                        style: AppStyle.elevated,
                        showDividers: true,
                        headerTitle: 'Erro inesperado',
                        footer: AppText('Tentar novamente'),
                        child: AppText('Ocorreu um erro!'),
                      ),
                      // Outlined com borda de destaque.
                      AppCard(
                        style: AppStyle.outlined,
                        accentColor: Color(0xFF3B82F6),
                        child: AppText('Outlined destaque'),
                      ),
                      // Filled.
                      AppCard(
                        style: AppStyle.filled,
                        headerTitle: 'Filled',
                        child: AppText('Corpo do card'),
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
          matchesGoldenFile('goldens/app_card_$label.png'),
        );
      });
    }
  }
}
