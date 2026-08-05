import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(data: AppThemeData.light, child: child),
  ),
);

void main() {
  testWidgets('AppButtonsFooter mostra primary e secondary', (tester) async {
    await tester.pumpWidget(
      _host(
        SizedBox(
          width: 420,
          child: AppButtonsFooter(
            primary: AppButton(label: 'Salvar', onPressed: () {}),
            secondary: AppButton(
              style: AppStyle.outlined,
              label: 'Cancelar',
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
    expect(find.text('Salvar'), findsOneWidget);
    expect(find.text('Cancelar'), findsOneWidget);
  });

  testWidgets('AppSimpleFooter mostra o child', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 420,
          child: AppSimpleFooter(child: AppText('rodapé')),
        ),
      ),
    );
    expect(find.text('rodapé'), findsOneWidget);
  });

  testWidgets('AppNavigationFooter navega no item tocado', (tester) async {
    String? navigated;
    await tester.pumpWidget(
      _host(
        SizedBox(
          width: 420,
          child: AppNavigationFooter(
            getCurrentRoute: (_) => '/home',
            items: <AppNavigationFooterItemData>[
              AppNavigationFooterItemData(
                icon: AppIcons.dashboard,
                title: 'Início',
                route: '/home',
                onPressed: (_, r) => navigated = r,
              ),
              AppNavigationFooterItemData(
                icon: AppIcons.car,
                title: 'Veículos',
                route: '/vehicles',
                onPressed: (_, r) => navigated = r,
              ),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('Veículos'));
    await tester.pump();
    expect(navigated, '/vehicles');
  });

  // Contraste dos itens ativo/inativo da barra de navegação.
  group('nav footer contraste (jotape/zxtrack × claro/escuro)', () {
    final List<AppBrandConfig> brands = <AppBrandConfig>[
      jotapeBrand,
      zxtrackBrand,
    ];
    for (final AppBrandConfig brand in brands) {
      for (final bool dark in <bool>[false, true]) {
        final String bl = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';
        final AppColorTheme c = dark
            ? brand.toDarkColorTheme()
            : brand.toLightColorTheme();
        test('ativo e inativo ≥ 3:1 · $bl', () {
          final Color active = readableStopOn(c.primary, c.surface);
          expect(
            contrastRatio(active, c.surface) >= kUi,
            isTrue,
            reason: 'item ativo < 3:1 sobre surface em $bl',
          );
          expect(
            contrastRatio(c.neutralPrimary.s600, c.surface) >= kUi,
            isTrue,
            reason: 'item inativo (s600) < 3:1 sobre surface em $bl',
          );
        });
      }
    }
  });

  test('footers no catálogo como migrados', () {
    for (final String id in <String>[
      'app_buttons_footer',
      'app_simple_footer',
      'app_navigation_footer',
    ]) {
      expect(
        flocksCatalog.any(
          (m) => m.id == id && m.status == ComponentStatus.migrated,
        ),
        isTrue,
        reason: '$id ausente',
      );
    }
  });
}
