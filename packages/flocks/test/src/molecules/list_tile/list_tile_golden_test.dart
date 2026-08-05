@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Matriz {claro,escuro} × {jotape,zxtrack} — os 2 estilos × variações sem ícone
// de rede (leading = AppAvatar texto; trailings determinísticos). Gerar:
//   flutter test --update-goldens --tags golden
Widget _group(AppListTileStyle style) => AppListTileGroup(
  style: style,
  children: <Widget>[
    AppListTile.checkbox(
      style: style,
      leading: const AppAvatar(size: AppAvatarSize.s, fallback: 'A'),
      title: 'Title',
      value: true,
      onChanged: (_) {},
    ),
    AppListTile.toggle(
      style: style,
      title: 'Title',
      subtitle: 'Details',
      value: true,
      onChanged: (_) {},
    ),
    const AppListTileRadio<int>(
      style: AppListTileStyle.grouped,
      title: 'Title',
      value: 1,
      groupValue: 1,
    ),
    const AppListTile.badge(
      style: AppListTileStyle.grouped,
      title: 'Title',
      badge: '5',
      badgeColor: AppBadgeColor.danger,
    ),
  ],
);

void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('list_tile golden · $label', (tester) async {
        final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(),
              child: AppTheme(
                data: data,
                child: Container(
                  key: const Key('golden'),
                  width: 640,
                  color: data.colorTheme.surface,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(child: _group(AppListTileStyle.grouped)),
                      const SizedBox(width: 16),
                      Expanded(child: _group(AppListTileStyle.bordered)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        await expectLater(
          find.byKey(const Key('golden')),
          matchesGoldenFile('goldens/list_tile_$label.png'),
        );
      });
    }
  }
}
