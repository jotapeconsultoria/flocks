import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(disableAnimations: true),
    child: AppTheme(
      data: AppThemeData.light.copyWith(
        glassTheme: const AppGlassTheme(enabled: false),
      ),
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(builder: (BuildContext context) => Center(child: child)),
        ],
      ),
    ),
  ),
);

void main() {
  group('AppMenuItem.subtitle', () {
    Future<void> openMenu(WidgetTester tester, AppMenuItem item) async {
      await tester.pumpWidget(
        _host(
          AppMenu(entries: <AppMenuEntry>[item], trigger: const Text('MENU')),
        ),
      );
      await tester.tap(find.text('MENU'));
      await tester.pumpAndSettle();
    }

    testWidgets('sem subtitle a linha é a de sempre', (tester) async {
      await openMenu(tester, AppMenuItem(label: 'Copiar', onPressed: () {}));
      expect(find.text('Copiar'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(FlocksInteraction),
          matching: find.byType(AppText),
        ),
        findsOneWidget,
      );
    });

    testWidgets('com subtitle: 2 linhas, prévia no neutro s600', (
      tester,
    ) async {
      await openMenu(
        tester,
        AppMenuItem(
          label: '/saudacao',
          subtitle: 'Olá! Como posso ajudar você hoje?',
          onPressed: () {},
        ),
      );
      expect(find.text('/saudacao'), findsOneWidget);
      final AppText sub = tester.widget<AppText>(
        find.widgetWithText(AppText, 'Olá! Como posso ajudar você hoje?'),
      );
      expect(sub.maxLines, 2);
      expect(
        sub.style?.color,
        AppThemeData.light.colorTheme.neutralPrimary.s600,
      );
      final Rect label = tester.getRect(find.text('/saudacao'));
      final Rect subtitle = tester.getRect(
        find.text('Olá! Como posso ajudar você hoje?'),
      );
      expect(subtitle.top, greaterThanOrEqualTo(label.bottom - 1));
    });

    testWidgets('o rótulo semântico carrega label e subtitle', (tester) async {
      final handle = tester.ensureSemantics();
      await openMenu(
        tester,
        AppMenuItem(label: '/saudacao', subtitle: 'Olá!', onPressed: () {}),
      );
      expect(find.bySemanticsLabel('/saudacao, Olá!'), findsOneWidget);
      handle.dispose();
    });
  });

  testWidgets('abre no clique e seleciona (dispara callback e fecha)', (
    tester,
  ) async {
    String? picked;
    await tester.pumpWidget(
      _host(
        AppMenu(
          trigger: const Text('MENU'),
          entries: <AppMenuEntry>[
            AppMenuItem(label: 'Edit', onPressed: () => picked = 'edit'),
            const AppMenuDivider(),
            AppMenuItem(
              label: 'Delete',
              danger: true,
              onPressed: () => picked = 'delete',
            ),
          ],
        ),
      ),
    );

    expect(find.text('Edit'), findsNothing);
    await tester.tap(find.text('MENU'));
    await tester.pumpAndSettle();
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(picked, 'delete');
    expect(find.text('Delete'), findsNothing); // fechou
  });

  testWidgets('item desabilitado não dispara', (tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      _host(
        AppMenu(
          trigger: const Text('MENU'),
          entries: <AppMenuEntry>[
            const AppMenuItem(label: 'Off', enabled: false),
            AppMenuItem(label: 'On', onPressed: () => tapped = true),
          ],
        ),
      ),
    );
    await tester.tap(find.text('MENU'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Off'));
    await tester.pumpAndSettle();
    expect(tapped, isFalse);
    expect(find.text('Off'), findsOneWidget); // continua aberto
  });

  testWidgets('mantém margem mínima das bordas da viewport', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(
            disableAnimations: true,
            size: Size(320, 568),
          ),
          child: AppTheme(
            data: AppThemeData.light.copyWith(
              glassTheme: const AppGlassTheme(enabled: false),
            ),
            child: Overlay(
              initialEntries: <OverlayEntry>[
                OverlayEntry(
                  builder: (context) => Align(
                    alignment: Alignment.bottomRight,
                    child: AppMenu(
                      entries: <AppMenuEntry>[
                        AppMenuItem(label: 'Ação', onPressed: () {}),
                      ],
                      placement: AppOverlayPlacement.topEnd,
                      trigger: const SizedBox(
                        key: ValueKey<String>('menu-trigger'),
                        height: 40,
                        width: 40,
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

    await tester.tapAt(
      tester.getCenter(find.byKey(const ValueKey<String>('menu-trigger'))),
    );
    await tester.pumpAndSettle();

    final menuRect = tester.getRect(find.byType(AppCard));
    expect(menuRect.left, greaterThanOrEqualTo(24));
    expect(menuRect.right, lessThanOrEqualTo(296));
  });

  testWidgets('item selecionado usa texto em negrito', (tester) async {
    await tester.pumpWidget(
      _host(
        AppMenu(
          entries: <AppMenuEntry>[
            AppMenuItem(label: 'Atual', onPressed: () {}, selected: true),
            AppMenuItem(label: 'Outra', onPressed: () {}),
          ],
          trigger: const Text('MENU'),
        ),
      ),
    );

    await tester.tap(find.text('MENU'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<Text>(find.text('Atual')).style?.fontWeight,
      FontWeight.bold,
    );
    expect(
      tester.widget<Text>(find.text('Outra')).style?.fontWeight,
      FontWeight.normal,
    );
  });

  testWidgets('Esc fecha o menu', (tester) async {
    await tester.pumpWidget(
      _host(
        AppMenu(
          trigger: const Text('MENU'),
          entries: <AppMenuEntry>[AppMenuItem(label: 'Edit', onPressed: () {})],
        ),
      ),
    );
    await tester.tap(find.text('MENU'));
    await tester.pumpAndSettle();
    expect(find.text('Edit'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Edit'), findsNothing);
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
        test('item/danger sobre o card · $bl', () {
          expect(
            meetsWcag(c.onSurface, c.surfaceContainer),
            isTrue,
            reason: 'item onSurface < 4.5 sobre surfaceContainer em $bl',
          );
          expect(
            meetsWcag(
              readableStopOn(c.danger, c.surfaceContainer, minRatio: 4.5),
              c.surfaceContainer,
            ),
            isTrue,
            reason: 'item danger < 4.5 sobre surfaceContainer em $bl',
          );
        });
      }
    }
  });

  test('está no catálogo como migrado', () {
    expect(
      flocksCatalog.any(
        (m) => m.id == 'app_menu' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
