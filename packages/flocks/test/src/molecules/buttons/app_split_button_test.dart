import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void _noop() {}

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

void main() {
  testWidgets('segmento primário dispara; caret abre o menu', (tester) async {
    bool primary = false;
    String? picked;
    await tester.pumpWidget(
      _host(
        AppSplitButton(
          label: 'Save',
          onPressed: () => primary = true,
          menuEntries: <AppMenuEntry>[
            AppMenuItem(label: 'Draft', onPressed: () => picked = 'draft'),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(primary, isTrue);
    expect(find.text('Draft'), findsNothing);

    // O caret é o único AppIcon (chevron) na árvore antes de abrir.
    await tester.tap(find.byType(AppIcon));
    await tester.pumpAndSettle();
    expect(find.text('Draft'), findsOneWidget);

    await tester.tap(find.text('Draft'));
    await tester.pumpAndSettle();
    expect(picked, 'draft');
  });

  testWidgets('desabilitado não dispara nem abre', (tester) async {
    bool primary = false;
    await tester.pumpWidget(
      _host(
        AppSplitButton(
          label: 'Save',
          onPressed: () => primary = true,
          enabled: false,
          menuEntries: <AppMenuEntry>[
            AppMenuItem(label: 'Draft', onPressed: () {}),
          ],
        ),
      ),
    );
    await tester.tap(find.text('Save'), warnIfMissed: false);
    await tester.tap(find.byType(AppIcon), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(primary, isFalse);
    expect(find.text('Draft'), findsNothing);
  });

  testWidgets('style elevated adiciona sombra ao conjunto', (tester) async {
    await tester.pumpWidget(
      _host(
        const AppSplitButton(
          label: 'Save',
          style: AppStyle.elevated,
          onPressed: _noop,
          menuEntries: <AppMenuEntry>[],
        ),
      ),
    );
    // Ao menos um DecoratedBox do conjunto carrega boxShadow (elevação real).
    final bool hasShadow = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .any(
          (DecoratedBox d) =>
              d.decoration is BoxDecoration &&
              ((d.decoration as BoxDecoration).boxShadow?.isNotEmpty ?? false),
        );
    expect(hasShadow, isTrue, reason: 'AppStyle.elevated deveria ter sombra');
  });

  testWidgets('style outlined contorna o conjunto (sem sombra)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppSplitButton(
          label: 'Save',
          style: AppStyle.outlined,
          onPressed: _noop,
          menuEntries: <AppMenuEntry>[],
        ),
      ),
    );
    final Iterable<BoxDecoration> decos = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((DecoratedBox d) => d.decoration)
        .whereType<BoxDecoration>();
    expect(
      decos.any((BoxDecoration d) => d.border != null),
      isTrue,
      reason: 'AppStyle.outlined deveria ter borda',
    );
    expect(
      decos.every((BoxDecoration d) => d.boxShadow?.isEmpty ?? true),
      isTrue,
      reason: 'outlined não deveria ter sombra',
    );
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
        test('fill primary conteúdo/fundo · $bl', () {
          final ButtonColors rest = appFilledButtonColors(
            c,
            AppButtonColor.primary.role(c),
            AppButtonColor.primary.onRole(c),
            hovered: false,
            pressed: false,
            disabled: false,
          );
          expect(
            meetsWcag(rest.foreground, rest.background),
            isTrue,
            reason: 'conteúdo/fundo do split button < 4.5 em $bl',
          );
        });
      }
    }
  });

  test('está no catálogo como migrado', () {
    expect(
      flocksCatalog.any(
        (m) =>
            m.id == 'app_split_button' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
