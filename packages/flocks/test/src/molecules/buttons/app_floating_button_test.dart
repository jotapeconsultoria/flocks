import 'dart:ui' show ImageFilter;

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
  group('comportamento', () {
    testWidgets('tap dispara onPressed', (tester) async {
      int taps = 0;
      await tester.pumpWidget(
        _host(AppFloatingButton(icon: AppIcons.add, onPressed: () => taps++)),
      );
      await tester.tap(find.byType(AppFloatingButton));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('só-texto: tap dispara', (tester) async {
      int taps = 0;
      await tester.pumpWidget(
        _host(AppFloatingButton(label: 'Novo', onPressed: () => taps++)),
      );
      await tester.tap(find.byType(AppFloatingButton));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('glass: tap dispara', (tester) async {
      int taps = 0;
      await tester.pumpWidget(
        _host(
          AppFloatingButton(
            glass: true,
            icon: AppIcons.add,
            onPressed: () => taps++,
          ),
        ),
      );
      await tester.tap(find.byType(AppFloatingButton));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('disabled não dispara', (tester) async {
      int taps = 0;
      await tester.pumpWidget(
        _host(
          AppFloatingButton(
            icon: AppIcons.add,
            enabled: false,
            onPressed: () => taps++,
          ),
        ),
      );
      await tester.tap(find.byType(AppFloatingButton), warnIfMissed: false);
      await tester.pump();
      expect(taps, 0);
    });

    testWidgets('loading não dispara e mostra spinner', (tester) async {
      int taps = 0;
      await tester.pumpWidget(
        _host(
          AppFloatingButton(
            icon: AppIcons.add,
            loading: true,
            onPressed: () => taps++,
          ),
        ),
      );
      await tester.tap(find.byType(AppFloatingButton), warnIfMissed: false);
      await tester.pump();
      expect(taps, 0);
      expect(find.byType(AppCircularLoading), findsOneWidget);
    });
  });

  // O diferencial do FAB: sombra SEMPRE presente (mesmo filled/outlined). Glass
  // renderiza a superfície frosted real (BackdropFilter), sem AnimatedContainer.
  group('estilo → decoração', () {
    Future<BoxDecoration> deco(WidgetTester tester, AppStyle style) async {
      await tester.pumpWidget(
        _host(
          // Caminho não-glass: valida a decoração de cada `style` (o eixo glass é
          // testado à parte); `glass: false` neutraliza o default da marca.
          AppFloatingButton(
            style: style,
            glass: false,
            icon: AppIcons.add,
            onPressed: () {},
          ),
        ),
      );
      final AnimatedContainer c = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      return c.decoration! as BoxDecoration;
    }

    testWidgets('filled: com sombra, sem borda', (tester) async {
      final BoxDecoration d = await deco(tester, AppStyle.filled);
      expect(d.boxShadow, isNotNull);
      expect(d.boxShadow, isNotEmpty);
      expect(d.border, isNull);
    });

    testWidgets('outlined: com sombra E borda, fill opaco (sombra não vaza)', (
      tester,
    ) async {
      final BoxDecoration d = await deco(tester, AppStyle.outlined);
      expect(d.boxShadow, isNotEmpty);
      expect(d.border, isNotNull);
      // Fundo OPACO: a sombra não aparece através do miolo do botão.
      expect(d.color, isNotNull);
      expect(d.color!.a, 1.0);
    });

    testWidgets('elevated: com sombra, sem borda', (tester) async {
      final BoxDecoration d = await deco(tester, AppStyle.elevated);
      expect(d.boxShadow, isNotEmpty);
      expect(d.border, isNull);
    });

    testWidgets('glass: superfície frosted real (BackdropFilter)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          AppFloatingButton(glass: true, icon: AppIcons.add, onPressed: () {}),
        ),
      );
      // BackdropFilter (blur) presente e sem o AnimatedContainer decorado.
      final BackdropFilter bf = tester.widget<BackdropFilter>(
        find.byType(BackdropFilter),
      );
      expect(bf.filter, isA<ImageFilter>());
      expect(find.byType(AnimatedContainer), findsNothing);
    });
  });

  // Press-scale respeita o reduce-motion global.
  group('reduce-motion', () {
    Future<double> scaleWhilePressed(
      WidgetTester tester, {
      required bool disableAnimations,
    }) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: MediaQueryData(disableAnimations: disableAnimations),
            child: AppTheme(
              data: AppThemeData.light,
              child: Center(
                child: AppFloatingButton(icon: AppIcons.add, onPressed: () {}),
              ),
            ),
          ),
        ),
      );
      final TestGesture gesture = await tester.startGesture(
        tester.getCenter(find.byType(AppFloatingButton)),
      );
      await tester.pump();
      final double scale = tester
          .widget<AnimatedScale>(find.byType(AnimatedScale))
          .scale;
      await gesture.up();
      return scale;
    }

    testWidgets('motion ligado: press encolhe (< 1.0)', (tester) async {
      expect(
        await scaleWhilePressed(tester, disableAnimations: false),
        lessThan(1.0),
      );
    });

    testWidgets('reduce-motion: press NÃO encolhe (== 1.0)', (tester) async {
      expect(await scaleWhilePressed(tester, disableAnimations: true), 1.0);
    });
  });

  // Contraste por estado nas 2 marcas × 2 brilhos × 8 papéis. O FAB usa os
  // mesmos resolvers (filled p/ filled/elevated; ghost p/ outlined/glass).
  group('contraste por estado', () {
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
        for (final AppButtonColor role in AppButtonColor.values) {
          final ColorSwatch<int> r = role.role(c);
          final ColorSwatch<int> onR = role.onRole(c);

          test('fill ${role.name} · $bl', () {
            for (final ({bool hovered, bool pressed}) st
                in const <({bool hovered, bool pressed})>[
                  (hovered: false, pressed: false),
                  (hovered: true, pressed: false),
                  (hovered: false, pressed: true),
                ]) {
              final ButtonColors col = appFilledButtonColors(
                c,
                r,
                onR,
                hovered: st.hovered,
                pressed: st.pressed,
                disabled: false,
              );
              expect(
                meetsWcag(col.foreground, col.background),
                isTrue,
                reason: 'fill ${role.name} $st conteúdo < 4.5 em $bl',
              );
            }
            final ButtonColors dis = appFilledButtonColors(
              c,
              r,
              onR,
              hovered: false,
              pressed: false,
              disabled: true,
            );
            expect(
              contrastRatio(dis.foreground, dis.background) >=
                  kDisabledMinRatio,
              isTrue,
              reason: 'fill ${role.name} disabled imperceptível em $bl',
            );
          });

          test('ghost ${role.name} (outlined/glass) · $bl', () {
            final Color pressBg = Color.alphaBlend(
              c.onSurface.withValues(alpha: 0.12),
              c.surface,
            );
            for (final bool bordered in <bool>[true, false]) {
              final ButtonColors rest = appGhostButtonColors(
                c,
                r,
                bordered: bordered,
                hovered: false,
                pressed: false,
                disabled: false,
              );
              expect(
                meetsWcag(rest.foreground, c.surface),
                isTrue,
                reason: 'ghost ${role.name} conteúdo < 4.5 vs surface em $bl',
              );
              expect(
                meetsWcag(rest.foreground, pressBg),
                isTrue,
                reason: 'ghost ${role.name} conteúdo < 4.5 vs press em $bl',
              );
            }
          });
        }
      }
    }
  });

  test('FAB no catálogo como migrado', () {
    expect(
      flocksCatalog.any(
        (m) =>
            m.id == 'app_floating_button' &&
            m.status == ComponentStatus.migrated,
      ),
      isTrue,
      reason: 'app_floating_button ausente do catálogo',
    );
  });
}
