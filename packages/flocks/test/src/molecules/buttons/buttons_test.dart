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
        _host(AppButton(label: 'Salvar', onPressed: () => taps++)),
      );
      await tester.tap(find.byType(AppButton));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('disabled não dispara', (tester) async {
      int taps = 0;
      await tester.pumpWidget(
        _host(AppButton(label: 'X', enabled: false, onPressed: () => taps++)),
      );
      await tester.tap(find.byType(AppButton), warnIfMissed: false);
      await tester.pump();
      expect(taps, 0);
    });

    testWidgets('loading não dispara e mostra spinner', (tester) async {
      int taps = 0;
      await tester.pumpWidget(
        _host(AppButton(label: 'X', loading: true, onPressed: () => taps++)),
      );
      await tester.tap(find.byType(AppButton), warnIfMissed: false);
      await tester.pump();
      expect(taps, 0);
      expect(find.byType(AppCircularLoading), findsOneWidget);
    });

    testWidgets('outlined: tap dispara', (tester) async {
      int a = 0;
      await tester.pumpWidget(
        _host(
          AppButton(style: AppStyle.outlined, label: 'A', onPressed: () => a++),
        ),
      );
      await tester.tap(find.byType(AppButton));
      await tester.pump();
      expect(a, 1);
    });
  });

  // A decoração da caixa por AppStyle: filled (nada), outlined (borda),
  // elevated (sombra).
  group('estilo → decoração', () {
    Future<BoxDecoration> deco(WidgetTester tester, AppStyle style) async {
      await tester.pumpWidget(
        _host(AppButton(style: style, label: 'X', onPressed: () {})),
      );
      final AnimatedContainer c = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      return c.decoration! as BoxDecoration;
    }

    testWidgets('filled: sem borda e sem sombra', (tester) async {
      final BoxDecoration d = await deco(tester, AppStyle.filled);
      expect(d.border, isNull);
      expect(d.boxShadow, isNull);
    });

    testWidgets('outlined: com borda, sem sombra', (tester) async {
      final BoxDecoration d = await deco(tester, AppStyle.outlined);
      expect(d.border, isNotNull);
      expect(d.boxShadow, isNull);
    });

    testWidgets('elevated: com sombra, sem borda', (tester) async {
      final BoxDecoration d = await deco(tester, AppStyle.elevated);
      expect(d.boxShadow, isNotNull);
      expect(d.boxShadow, isNotEmpty);
      expect(d.border, isNull);
    });
  });

  // Micro-interação de press-scale respeita o reduce-motion global.
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
                child: AppButton(label: 'X', onPressed: () {}),
              ),
            ),
          ),
        ),
      );
      final TestGesture gesture = await tester.startGesture(
        tester.getCenter(find.byType(AppButton)),
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

  // Contraste por estado nas 2 marcas × 2 brilhos × 8 papéis × 4 variantes.
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

          test('ghost ${role.name} (line/text/icon) · $bl', () {
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
              // fg legível sobre a surface (repouso) e sobre o realce de press.
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

  test('botões no catálogo como migrados', () {
    for (final String id in <String>['app_button']) {
      expect(
        flocksCatalog.any(
          (m) => m.id == id && m.status == ComponentStatus.migrated,
        ),
        isTrue,
        reason: '$id ausente do catálogo',
      );
    }
  });
}
