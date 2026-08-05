@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Matriz {desktop,mobile} × {jotape,zxtrack} × {claro,escuro}. Sem imagem de
// fundo (usa o fallback determinístico). Gerar:
//   flutter test --update-goldens --tags golden
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];
  const Map<String, Size> layouts = <String, Size>{
    'desktop': Size(1000, 600),
    'mobile': Size(400, 760),
  };

  layouts.forEach((String layout, Size size) {
    for (final AppBrandConfig brand in brands) {
      for (final bool dark in <bool>[false, true]) {
        final String label =
            '${layout}_${brand.clientSlug}_${dark ? 'dark' : 'light'}';

        testWidgets('AppAuthSplitLayout golden · $label', (tester) async {
          final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);

          await tester.pumpWidget(
            Directionality(
              textDirection: TextDirection.ltr,
              child: MediaQuery(
                data: MediaQueryData(size: size),
                child: AppTheme(
                  data: data,
                  child: SizedBox.fromSize(
                    size: size,
                    child: const RepaintBoundary(
                      key: Key('golden'),
                      child: AppAuthSplitLayout(
                        brandTitle: 'Bem-vindo de volta',
                        brandSubtitle: 'Acesse sua conta para continuar.',
                        logoUrl: AppIcons.infoCircle,
                        // Com site: é o estado que os apps de fato embarcam —
                        // todos passam a URL da própria ficha de identidade. O
                        // logo linkado é 4px maior que o solto, porque o
                        // `AppInteraction` reserva a borda do anel de foco para
                        // ele não deslocar o layout ao aparecer. Golden que
                        // rendesse o estado solto mediria uma tela que ninguém
                        // vê.
                        websiteUrl: 'https://acme.example',
                        child: Center(child: AppText('formulário')),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );

          await expectLater(
            find.byKey(const Key('golden')),
            matchesGoldenFile('goldens/app_auth_split_layout_$label.png'),
          );
        });
      }
    }
  });
}
