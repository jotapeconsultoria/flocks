@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Matriz {claro,escuro} × {jotape,zxtrack} — rail expandido com footer (perfil)
// e o chevron flutuante na aresta. O rail é posto num Row (largura frouxa, como
// no shell real) para dimensionar-se à sua largura natural. Gerar:
//   flutter test --update-goldens --tags golden
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  List<AppNavigationRailItemData> items() => <AppNavigationRailItemData>[
    AppNavigationRailItemData(
      icon: AppIcons.infoCircle,
      route: '/inicio',
      title: 'Início',
      onPressed: (_, _) {},
    ),
    AppNavigationRailItemData(
      icon: AppIcons.checkCircle,
      route: '/veiculos',
      title: 'Veículos',
      onPressed: (_, _) {},
    ),
    AppNavigationRailItemData(
      icon: AppIcons.errorCircle,
      route: '/alertas',
      title: 'Alertas',
      onPressed: (_, _) {},
    ),
  ];

  Widget rail() => AppNavigationRail(
    items: items(),
    logoCollapsed: AppIcons.infoCircle,
    getCurrentRoute: (_) => '/inicio',
    footer: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppNavigationRailItem(
          icon: AppIcons.support,
          title: 'Suporte',
          onPressed: () {},
        ),
        const AppNavigationRailProfile(
          title: 'João Martins',
          subtitle: 'Operador',
          initials: 'JM',
        ),
      ],
    ),
  );

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('AppNavigationRail golden · $label', (tester) async {
        final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(1000, 700)),
              child: AppTheme(
                data: data,
                child: ColoredBox(
                  color: data.colorTheme.surface,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      key: const Key('golden'),
                      width: 340,
                      height: 480,
                      // Row → largura frouxa: o rail assume sua largura natural
                      // (como no shell); o chevron flutua sobre a faixa restante.
                      child: Row(children: <Widget>[rail(), const Spacer()]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        // Avança além da animação de entrada dos labels/perfil (TweenAnimation
        // 0→1) para que o texto apareça e o contraste seja realmente revisável.
        await tester.pump(const Duration(milliseconds: 400));

        await expectLater(
          find.byKey(const Key('golden')),
          matchesGoldenFile('goldens/app_navigation_rail_$label.png'),
        );
      });
    }
  }
}
