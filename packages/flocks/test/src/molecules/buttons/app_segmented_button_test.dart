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
  testWidgets('seleciona ao tocar num segmento', (tester) async {
    int selected = 0;
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => _host(
          AppSegmentedButton<int>(
            value: selected,
            onChanged: (v) => setState(() => selected = v),
            segments: const <AppSegment<int>>[
              AppSegment<int>(value: 0, label: 'Dia'),
              AppSegment<int>(value: 1, label: 'Semana'),
              AppSegment<int>(value: 2, label: 'Mês'),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('Mês'));
    await tester.pumpAndSettle();
    expect(selected, 2);
  });

  testWidgets('desabilitado não seleciona', (tester) async {
    int selected = 0;
    await tester.pumpWidget(
      _host(
        AppSegmentedButton<int>(
          value: selected,
          enabled: false,
          onChanged: (v) => selected = v,
          segments: const <AppSegment<int>>[
            AppSegment<int>(value: 0, label: 'A'),
            AppSegment<int>(value: 1, label: 'B'),
          ],
        ),
      ),
    );
    await tester.tap(find.text('B'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(selected, 0);
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
        test('pílula/segmento neutro sobre o trilho · $bl', () {
          // Pílula selecionada = AppButton filled primary (mesmo resolver de cor).
          final ButtonColors pill = appFilledButtonColors(
            c,
            AppButtonColor.primary.role(c),
            AppButtonColor.primary.onRole(c),
            hovered: false,
            pressed: false,
            disabled: false,
          );
          expect(
            meetsWcag(pill.foreground, pill.background),
            isTrue,
            reason: 'conteúdo da pílula < 4.5 em $bl',
          );
          // Não selecionado: onSurface sobre o trilho surfaceContainer.
          expect(
            meetsWcag(c.onSurface, c.surfaceContainer),
            isTrue,
            reason: 'segmento neutro onSurface < 4.5 em $bl',
          );
        });
      }
    }
  });

  test('está no catálogo como migrado', () {
    expect(
      flocksCatalog.any(
        (m) =>
            m.id == 'app_segmented_button' &&
            m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
