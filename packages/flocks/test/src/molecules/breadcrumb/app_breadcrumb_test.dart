import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: AppThemeData.light,
      child: Center(child: child),
    ),
  ),
);

void main() {
  testWidgets('item clicável dispara onTap', (tester) async {
    int taps = 0;
    await tester.pumpWidget(
      _host(
        AppBreadcrumb(
          items: <AppBreadcrumbItem>[
            AppBreadcrumbItem(label: 'Início', onTap: () => taps++),
            const AppBreadcrumbItem(label: 'Atual'),
          ],
        ),
      ),
    );
    await tester.tap(find.text('Início'));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('item atual (sem onTap) não é botão', (tester) async {
    await tester.pumpWidget(
      _host(
        const AppBreadcrumb(
          items: <AppBreadcrumbItem>[AppBreadcrumbItem(label: 'Atual')],
        ),
      ),
    );
    expect(find.byType(FlocksInteraction), findsNothing);
    expect(find.text('Atual'), findsOneWidget);
  });

  testWidgets('lista vazia → SizedBox.shrink', (tester) async {
    await tester.pumpWidget(
      _host(const AppBreadcrumb(items: <AppBreadcrumbItem>[])),
    );
    expect(find.byType(AppText), findsNothing);
  });

  // Contraste do link (acento legível) e do item atual nas 2 marcas × 2 brilhos.
  group('contraste (jotape/zxtrack × claro/escuro)', () {
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
        test('link ≥ AA (surface e press) e atual ≥ AA · $bl', () {
          // Realce neutro de press: onSurface @ 12% sobre a surface.
          final Color pressBg = Color.alphaBlend(
            c.onSurface.withValues(alpha: 0.12),
            c.surface,
          );
          final Color link = readableStopOn(c.tertiary, pressBg, minRatio: 4.5);
          expect(
            meetsWcag(link, c.surface),
            isTrue,
            reason: 'link sobre surface < 4.5 em $bl',
          );
          expect(
            meetsWcag(link, pressBg),
            isTrue,
            reason: 'link sobre o realce de press < 4.5 em $bl',
          );
          expect(
            meetsWcag(c.onSurface, c.surface),
            isTrue,
            reason: 'item atual onSurface sobre surface < 4.5 em $bl',
          );
        });
      }
    }
  });

  test('está no catálogo como migrado', () {
    expect(
      flocksCatalog.any(
        (m) => m.id == 'app_breadcrumb' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
