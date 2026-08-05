import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(disableAnimations: true),
    child: AppTheme(
      data: AppThemeData.light,
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(builder: (BuildContext context) => Center(child: child)),
        ],
      ),
    ),
  ),
);

AppPopover _popover({AppPopoverTrigger mode = AppPopoverTrigger.click}) =>
    AppPopover(
      triggerMode: mode,
      trigger: const Text('TRIGGER'),
      child: const Text('BODY'),
    );

void main() {
  testWidgets('clique abre e alterna o painel', (tester) async {
    await tester.pumpWidget(_host(_popover()));
    expect(find.text('BODY'), findsNothing);

    await tester.tap(find.text('TRIGGER'));
    await tester.pumpAndSettle();
    expect(find.text('BODY'), findsOneWidget);

    // Segundo toque no trigger fecha (mesmo groupId → não conta como "fora").
    await tester.tap(find.text('TRIGGER'));
    await tester.pumpAndSettle();
    expect(find.text('BODY'), findsNothing);
  });

  testWidgets('hover abre e fecha ao sair', (tester) async {
    await tester.pumpWidget(_host(_popover(mode: AppPopoverTrigger.hover)));

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);

    await gesture.moveTo(tester.getCenter(find.text('TRIGGER')));
    await tester.pumpAndSettle();
    expect(find.text('BODY'), findsOneWidget);

    await gesture.moveTo(const Offset(-200, -200));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();
    expect(find.text('BODY'), findsNothing);
  });

  testWidgets('funciona com o tema abaixo do Overlay (cenário Widgetbook)', (
    tester,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Overlay(
            initialEntries: <OverlayEntry>[
              OverlayEntry(
                builder: (BuildContext context) => AppTheme(
                  data: AppThemeData.light,
                  child: Center(child: _popover()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('TRIGGER'));
    await tester.pumpAndSettle();
    // Sem reprovê AppTheme na entry, isto lançaria "No AppTheme found".
    expect(tester.takeException(), isNull);
    expect(find.text('BODY'), findsOneWidget);
  });

  testWidgets('limita o painel à área visível', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(
            disableAnimations: true,
            size: Size(320, 568),
          ),
          child: AppTheme(
            data: AppThemeData.light,
            child: Overlay(
              initialEntries: <OverlayEntry>[
                OverlayEntry(
                  builder: (BuildContext context) => const Align(
                    alignment: Alignment.bottomRight,
                    child: AppPopover(
                      placement: AppOverlayPlacement.topEnd,
                      trigger: Text('TRIGGER'),
                      child: Text(
                        'Um conteúdo longo que precisa respeitar a tela.',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('TRIGGER'));
    await tester.pumpAndSettle();

    final bounds = tester.widget<ConstrainedBox>(
      find.byKey(const ValueKey<String>('app-popover-viewport-bounds')),
    );
    final panelRect = tester.getRect(
      find.byKey(const ValueKey<String>('app-popover-viewport-bounds')),
    );
    expect(bounds.constraints.maxHeight, 520);
    expect(bounds.constraints.maxWidth, 272);
    expect(panelRect.left, greaterThanOrEqualTo(24));
    expect(panelRect.right, lessThanOrEqualTo(296));
    expect(panelRect.top, greaterThanOrEqualTo(24));
    expect(panelRect.bottom, lessThanOrEqualTo(544));
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
        test('título sobre o card · $bl', () {
          // O título (onSurface) precisa ser legível sobre o card
          // (surfaceContainer). A borda/seta usa o token `outline` (mesma
          // hairline decorativa do AppOverlayCard), não uma fronteira ≥ 3:1.
          expect(
            meetsWcag(c.onSurface, c.surfaceContainer),
            isTrue,
            reason: 'título onSurface < 4.5 sobre surfaceContainer em $bl',
          );
        });
      }
    }
  });

  test('está no catálogo como migrado', () {
    expect(
      flocksCatalog.any(
        (m) => m.id == 'app_popover' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
