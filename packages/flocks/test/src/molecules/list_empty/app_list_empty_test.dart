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
  testWidgets('renderiza a mensagem', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 360,
          height: 360,
          child: AppListEmpty(
            illustration: AppIllustrations.empty,
            text: 'Vazio',
          ),
        ),
      ),
    );
    expect(find.text('Vazio'), findsOneWidget);
  });

  testWidgets('sem onClearFilter → sem botão Limpar', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 360,
          height: 360,
          child: AppListEmpty(
            illustration: AppIllustrations.empty,
            text: 'Vazio',
          ),
        ),
      ),
    );
    expect(find.byType(AppInteraction), findsNothing);
  });

  testWidgets('com onClearFilter → botão dispara', (tester) async {
    int cleared = 0;
    await tester.pumpWidget(
      _host(
        SizedBox(
          width: 360,
          height: 380,
          child: AppListEmpty(
            illustration: AppIllustrations.empty,
            text: 'Vazio',
            onClearFilter: () => cleared++,
          ),
        ),
      ),
    );
    await tester.tap(find.byType(AppInteraction));
    await tester.pump();
    expect(cleared, 1);
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
        test('mensagem onSurface ≥ AA · $bl', () {
          expect(
            meetsWcag(c.onSurface, c.surface),
            isTrue,
            reason: 'mensagem onSurface sobre surface < 4.5 em $bl',
          );
        });
      }
    }
  });

  test('está no catálogo como migrado', () {
    expect(
      flocksCatalog.any(
        (m) => m.id == 'app_list_empty' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
