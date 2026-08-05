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
  testWidgets('tocar na 4ª estrela define o valor 4', (tester) async {
    double? picked;
    await tester.pumpWidget(
      _host(
        AppRating(
          value: 0,
          iconSize: 40,
          spacing: 0,
          onChanged: (v) => picked = v,
        ),
      ),
    );
    // 5 estrelas de 40px, sem espaçamento: centro da 4ª ≈ x = 3*40 + 20.
    final Offset topLeft = tester.getTopLeft(find.byType(AppRating));
    await tester.tapAt(topLeft + const Offset(3 * 40 + 20, 20));
    await tester.pump();
    expect(picked, 4.0);
  });

  testWidgets('allowHalf: metade esquerda vale meia', (tester) async {
    double? picked;
    await tester.pumpWidget(
      _host(
        AppRating(
          value: 0,
          iconSize: 40,
          spacing: 0,
          allowHalf: true,
          onChanged: (v) => picked = v,
        ),
      ),
    );
    // Metade esquerda da 3ª estrela: x ≈ 2*40 + 10.
    final Offset topLeft = tester.getTopLeft(find.byType(AppRating));
    await tester.tapAt(topLeft + const Offset(2 * 40 + 10, 20));
    await tester.pump();
    expect(picked, 2.5);
  });

  testWidgets('somente-leitura não dispara', (tester) async {
    await tester.pumpWidget(_host(const AppRating(value: 3)));
    // Sem onChanged, tocar não deve lançar nem alterar nada.
    await tester.tap(find.byType(AppRating), warnIfMissed: false);
    await tester.pump();
    expect(tester.takeException(), isNull);
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
        test('acento da estrela ≥ 3:1 sobre a surface · $bl', () {
          expect(
            contrastRatio(readableStopOn(c.warning, c.surface), c.surface) >=
                kUi,
            isTrue,
            reason: 'estrela âmbar < 3:1 sobre surface em $bl',
          );
        });
      }
    }
  });

  test('está no catálogo como migrado', () {
    expect(
      flocksCatalog.any(
        (m) => m.id == 'app_rating' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
