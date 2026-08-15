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
  group('AppSegment.tooltip', () {
    Widget host(Widget child) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: AppTheme(
          data: AppThemeData.light,
          child: Overlay(
            initialEntries: <OverlayEntry>[
              OverlayEntry(
                builder: (BuildContext context) => Center(child: child),
              ),
            ],
          ),
        ),
      ),
    );

    AppSegmentedButton<int> button({String? tooltip}) =>
        AppSegmentedButton<int>(
          segments: <AppSegment<int>>[
            AppSegment<int>(value: 0, label: 'Res', tooltip: tooltip),
            const AppSegment<int>(value: 1, label: 'Perd'),
          ],
          value: 0,
          onChanged: (_) {},
        );

    testWidgets('sem tooltip → nenhum AppTooltip (a árvore de sempre)', (
      tester,
    ) async {
      await tester.pumpWidget(host(button()));
      expect(find.byType(AppTooltip), findsNothing);
    });

    testWidgets('com tooltip → AppTooltip com a mensagem, toggle intacto', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(host(button(tooltip: 'Resolvidos')));
      final AppTooltip tip = tester.widget<AppTooltip>(find.byType(AppTooltip));
      expect(tip.message, 'Resolvidos');
      // O nome do controle continua o do toggle (label) — o nó do tooltip
      // também o carrega (annotation), por isso findsWidgets e não OneWidget.
      expect(find.bySemanticsLabel('Res'), findsWidgets);
      expect(find.bySemanticsLabel('Resolvidos'), findsNothing);
      handle.dispose();
    });

    testWidgets('o toque continua selecionando com o tooltip presente', (
      tester,
    ) async {
      int? picked;
      await tester.pumpWidget(
        host(
          AppSegmentedButton<int>(
            segments: const <AppSegment<int>>[
              AppSegment<int>(value: 0, label: 'A', tooltip: 'Primeiro'),
              AppSegment<int>(value: 1, label: 'B'),
            ],
            value: 1,
            onChanged: (int v) => picked = v,
          ),
        ),
      );
      await tester.tap(find.text('A'));
      expect(picked, 0);
    });
  });

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
