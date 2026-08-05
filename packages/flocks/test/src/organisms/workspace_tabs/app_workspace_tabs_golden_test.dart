@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  List<AppWorkspaceTabItem> tabs() => <AppWorkspaceTabItem>[
    const AppWorkspaceTabItem(
      id: 'a',
      title: 'Veículos',
      icon: AppIcons.infoCircle,
    ),
    const AppWorkspaceTabItem(id: 'b', title: 'Alertas', icon: AppIcons.alert),
    const AppWorkspaceTabItem(
      id: 'c',
      title: 'Relatórios',
      icon: AppIcons.checkCircle,
    ),
  ];

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';
      testWidgets('AppWorkspaceTabs golden · $label', (tester) async {
        final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(800, 200)),
              child: AppTheme(
                data: data,
                child: Container(
                  key: const Key('golden'),
                  color: data.colorTheme.surface,
                  width: 560,
                  height: 72,
                  padding: const EdgeInsets.only(top: 12),
                  child: AppWorkspaceTabs(
                    tabs: tabs(),
                    activeId: 'a',
                    onSelect: (_) {},
                    onClose: (_) {},
                  ),
                ),
              ),
            ),
          ),
        );
        await expectLater(
          find.byKey(const Key('golden')),
          matchesGoldenFile('goldens/app_workspace_tabs_$label.png'),
        );
      });
    }
  }
}
