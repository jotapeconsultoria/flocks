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
      child: Center(child: SizedBox(width: 320, child: child)),
    ),
  ),
);

void main() {
  testWidgets('navigation: tap dispara onTap', (tester) async {
    int taps = 0;
    await tester.pumpWidget(
      _host(AppListTile.navigation(title: 'Suporte', onTap: () => taps++)),
    );
    await tester.tap(find.text('Suporte'));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('checkbox: tocar a linha alterna', (tester) async {
    bool? v;
    await tester.pumpWidget(
      _host(
        AppListTile.checkbox(
          title: 'Item',
          value: false,
          onChanged: (nv) => v = nv,
        ),
      ),
    );
    await tester.tap(find.text('Item'));
    await tester.pump();
    expect(v, isTrue);
  });

  testWidgets('toggle: tocar a linha alterna', (tester) async {
    bool? v;
    await tester.pumpWidget(
      _host(
        AppListTile.toggle(
          title: 'Item',
          value: false,
          onChanged: (nv) => v = nv,
        ),
      ),
    );
    await tester.tap(find.text('Item'));
    await tester.pump();
    expect(v, isTrue);
  });

  testWidgets('radio: tocar a linha seleciona', (tester) async {
    String? sel;
    await tester.pumpWidget(
      _host(
        AppListTileRadio<String>(
          title: 'Polo',
          value: 'a',
          groupValue: 'b',
          onChanged: (nv) => sel = nv,
        ),
      ),
    );
    await tester.tap(find.text('Polo'));
    await tester.pump();
    expect(sel, 'a');
  });

  testWidgets('draggable: mostra drag handle', (tester) async {
    await tester.pumpWidget(
      _host(
        AppListTile.checkbox(
          title: 'Item',
          value: false,
          reorderIndex: 0,
          onChanged: (_) {},
        ),
      ),
    );
    expect(find.byType(ReorderableDragStartListener), findsOneWidget);
  });

  testWidgets('action: tap dispara onPressed e mostra trailing', (
    tester,
  ) async {
    int taps = 0;
    await tester.pumpWidget(
      _host(
        AppListTileAction(
          title: 'Veículos',
          text: 'TTS4G47',
          trailing: const SizedBox(key: Key('trailing')),
          onPressed: () => taps++,
        ),
      ),
    );
    expect(find.byKey(const Key('trailing')), findsOneWidget);
    await tester.tap(find.text('TTS4G47'));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('action checkbox: tocar a linha alterna', (tester) async {
    bool? v;
    await tester.pumpWidget(
      _host(
        AppListTileCheckbox(
          title: 'Polo Track 01',
          text: 'TTS4G47',
          checked: false,
          onChanged: (nv) => v = nv,
        ),
      ),
    );
    await tester.tap(find.text('TTS4G47'));
    await tester.pump();
    expect(v, isTrue);
  });

  testWidgets('draggable checkbox: handle + tocar a linha alterna', (
    tester,
  ) async {
    bool? v;
    await tester.pumpWidget(
      _host(
        AppListTileDraggableCheckbox(
          reorderIndex: 0,
          title: 'Coluna',
          text: 'Placa',
          checked: false,
          onChanged: (nv) => v = nv,
        ),
      ),
    );
    expect(find.byType(ReorderableDragStartListener), findsOneWidget);
    await tester.tap(find.text('Placa'));
    await tester.pump();
    expect(v, isTrue);
  });

  testWidgets('group: desenha divisórias entre as linhas', (tester) async {
    await tester.pumpWidget(
      _host(
        AppListTileGroup(
          children: <Widget>[
            AppListTile.navigation(title: 'A', onTap: () {}),
            AppListTile.navigation(title: 'B', onTap: () {}),
            AppListTile.navigation(title: 'C', onTap: () {}),
          ],
        ),
      ),
    );
    expect(find.byType(AppDivider), findsNWidgets(2)); // n-1 divisórias
  });

  testWidgets('avulso bordered desenha borda; grouped desenha fundo', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppListTile(style: AppListTileStyle.bordered, title: 'B'),
            AppListTile(style: AppListTileStyle.grouped, title: 'G'),
          ],
        ),
      ),
    );
    final theme = AppThemeData.light;
    final Iterable<DecoratedBox> boxes = tester.widgetList<DecoratedBox>(
      find.byType(DecoratedBox),
    );
    final bool hasBorder = boxes.any(
      (b) => (b.decoration as BoxDecoration).border != null,
    );
    final bool hasFill = boxes.any(
      (b) =>
          (b.decoration as BoxDecoration).color ==
          theme.colorTheme.surfaceContainer,
    );
    expect(hasBorder, isTrue);
    expect(hasFill, isTrue);
  });

  // Contraste dos textos do tile sobre AMBAS as superfícies.
  group('contraste (jotape/zxtrack × claro/escuro × superfície)', () {
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
        test('título/subtítulo ≥ AA · $bl', () {
          for (final Color surface in <Color>[c.surfaceContainer, c.surface]) {
            expect(
              meetsWcag(c.onSurface, surface),
              isTrue,
              reason: 'título onSurface < 4.5 em $bl',
            );
            expect(
              meetsWcag(c.neutralPrimary.s700, surface),
              isTrue,
              reason: 'subtítulo s700 < 4.5 em $bl',
            );
          }
        });
      }
    }
  });

  test('família list no catálogo como migrada', () {
    for (final String id in <String>[
      'app_list_tile',
      'app_list_tile_action',
      'app_list_tile_checkbox',
      'app_list_tile_draggable_checkbox',
      'app_list_tile_radio',
      'app_list_tile_group',
      'app_tile_info',
    ]) {
      expect(
        flocksCatalog.any(
          (m) => m.id == id && m.status == ComponentStatus.migrated,
        ),
        isTrue,
        reason: '$id ausente',
      );
    }
  });
}
