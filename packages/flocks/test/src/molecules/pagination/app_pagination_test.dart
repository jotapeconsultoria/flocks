import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(disableAnimations: true),
    child: AppTheme(
      data: AppThemeData.light,
      child: Center(child: child),
    ),
  ),
);

void main() {
  group('paginationRange (função pura)', () {
    test('poucas páginas: mostra todas, sem reticências', () {
      expect(paginationRange(currentPage: 2, pageCount: 5), <int?>[
        1,
        2,
        3,
        4,
        5,
      ]);
    });

    test('muitas páginas: reticências dos dois lados', () {
      expect(paginationRange(currentPage: 6, pageCount: 20), <int?>[
        1,
        null,
        5,
        6,
        7,
        null,
        20,
      ]);
    });

    test('início: reticências só à direita', () {
      expect(paginationRange(currentPage: 1, pageCount: 20), <int?>[
        1,
        2,
        null,
        20,
      ]);
    });

    test('fim: reticências só à esquerda', () {
      expect(paginationRange(currentPage: 20, pageCount: 20), <int?>[
        1,
        null,
        19,
        20,
      ]);
    });

    test('lacuna de 1 vira a própria página (não reticências)', () {
      // cur 4, count 20, boundary 1, sibling 1: {1,3,4,5,20}
      // 1→3 é lacuna de 2 → mostra 2; 5→20 é reticências.
      expect(paginationRange(currentPage: 4, pageCount: 20), <int?>[
        1,
        2,
        3,
        4,
        5,
        null,
        20,
      ]);
    });

    test('pageCount 0 → vazio', () {
      expect(paginationRange(currentPage: 1, pageCount: 0), <int?>[]);
    });
  });

  testWidgets('tocar num número navega; prev desabilita na página 1', (
    tester,
  ) async {
    int? navigated;
    await tester.pumpWidget(
      _host(
        AppPagination(
          currentPage: 1,
          pageCount: 10,
          onPageChanged: (p) => navigated = p,
        ),
      ),
    );
    await tester.tap(find.text('2'));
    await tester.pump();
    expect(navigated, 2);

    // Botão anterior (primeiro AppInteraction) desabilitado na página 1.
    await tester.tap(find.byType(AppInteraction).first, warnIfMissed: false);
    await tester.pump();
    expect(navigated, 2); // inalterado
  });

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
        test('página atual/inativa sobre a surface · $bl', () {
          final Color accent = readableStopOn(c.primary, c.surface);
          expect(
            meetsWcag(onColorFor(accent), accent),
            isTrue,
            reason: 'número da página atual < 4.5 em $bl',
          );
          expect(
            meetsWcag(c.onSurface, c.surface),
            isTrue,
            reason: 'número inativo onSurface < 4.5 em $bl',
          );
        });
      }
    }
  });

  test('está no catálogo como migrado', () {
    expect(
      flocksCatalog.any(
        (m) => m.id == 'app_pagination' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
