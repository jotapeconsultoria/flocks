import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(size: Size(1000, 700)),
    child: AppTheme(
      data: AppThemeData.light,
      child: SizedBox(height: 500, child: child),
    ),
  ),
);

/// Host que dá largura **frouxa** ao rail (como o Row do shell), para que ele
/// assuma a largura natural e o chevron flutuante fique na aresta.
Widget _railHost(Widget rail) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(size: Size(1000, 700)),
    child: AppTheme(
      data: AppThemeData.light,
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 360,
          height: 480,
          child: Row(children: <Widget>[rail, const Spacer()]),
        ),
      ),
    ),
  ),
);

List<AppNavigationRailItemData> _items(void Function() onTap) =>
    <AppNavigationRailItemData>[
      AppNavigationRailItemData(
        icon: AppIcons.infoCircle,
        route: '/inicio',
        title: 'Início',
        onPressed: (_, _) => onTap(),
      ),
      AppNavigationRailItemData(
        icon: AppIcons.checkCircle,
        route: '/veiculos',
        title: 'Veículos',
        onPressed: (_, _) {},
      ),
    ];

void main() {
  testWidgets('AppNavigationRail mostra itens e dispara onPressed', (
    tester,
  ) async {
    int taps = 0;
    await tester.pumpWidget(
      _host(
        AppNavigationRail(
          items: _items(() => taps++),
          logoCollapsed: AppIcons.infoCircle,
          getCurrentRoute: (_) => '/inicio',
        ),
      ),
    );
    expect(find.text('Início'), findsOneWidget);
    expect(find.text('Veículos'), findsOneWidget);

    await tester.tap(find.text('Início'));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('AppNavigationRailItem colapsado expõe título via AppTooltip', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppNavigationRailItem(
          icon: AppIcons.infoCircle,
          title: 'Início',
          isCollapsed: true,
          onPressed: _noop,
        ),
      ),
    );
    expect(
      find.byWidgetPredicate(
        (Widget w) => w is AppTooltip && w.message == 'Início',
      ),
      findsOneWidget,
    );
    // Sem exceção (não depende de MaterialLocalizations do Tooltip do Material).
    expect(tester.takeException(), isNull);
  });

  testWidgets('footer slot renderiza; showFooterDivider controla o divider', (
    tester,
  ) async {
    await tester.pumpWidget(
      _railHost(
        AppNavigationRail(
          items: _items(() {}),
          logoCollapsed: AppIcons.infoCircle,
          getCurrentRoute: (_) => '/inicio',
          footer: const Text('FOOTER'),
        ),
      ),
    );
    expect(find.text('FOOTER'), findsOneWidget);
    expect(find.byType(AppDivider), findsOneWidget);

    await tester.pumpWidget(
      _railHost(
        AppNavigationRail(
          items: _items(() {}),
          logoCollapsed: AppIcons.infoCircle,
          getCurrentRoute: (_) => '/inicio',
          showFooterDivider: false,
          footer: const Text('FOOTER'),
        ),
      ),
    );
    expect(find.text('FOOTER'), findsOneWidget);
    expect(find.byType(AppDivider), findsNothing);
  });

  testWidgets('chevron flutuante colapsa e expande o rail', (tester) async {
    await tester.pumpWidget(
      _railHost(
        AppNavigationRail(
          items: _items(() {}),
          logoCollapsed: AppIcons.infoCircle,
          getCurrentRoute: (_) => '/inicio',
        ),
      ),
    );
    // Expandido → o chevron aponta para recolher (chevronLeft).
    Finder chevron(String icon) =>
        find.byWidgetPredicate((Widget w) => w is AppIcon && w.icon == icon);
    expect(chevron(AppIcons.chevronLeft), findsOneWidget);
    expect(chevron(AppIcons.chevronRight), findsNothing);

    await tester.tap(chevron(AppIcons.chevronLeft));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Colapsado → o chevron vira expandir (chevronRight).
    expect(chevron(AppIcons.chevronRight), findsOneWidget);
    expect(chevron(AppIcons.chevronLeft), findsNothing);
  });

  testWidgets('AppNavigationRailItem lê isCollapsed do scope ancestral', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppNavigationRailScope(
          isCollapsed: true,
          child: AppNavigationRailItem(
            icon: AppIcons.infoCircle,
            title: 'Início',
            onPressed: _noop,
          ),
        ),
      ),
    );
    // Colapsado via scope → embrulha em AppTooltip com o título.
    expect(
      find.byWidgetPredicate(
        (Widget w) => w is AppTooltip && w.message == 'Início',
      ),
      findsOneWidget,
    );
  });

  testWidgets('AppNavigationRailItem sem scope assume expandido', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppNavigationRailItem(
          icon: AppIcons.infoCircle,
          title: 'Início',
          onPressed: _noop,
        ),
      ),
    );
    expect(
      find.byWidgetPredicate(
        (Widget w) => w is AppTooltip && w.message == 'Início',
      ),
      findsNothing,
    );
    expect(find.text('Início'), findsOneWidget);
  });

  testWidgets('AppNavigationRailProfile mostra nome/papel e dispara onTap', (
    tester,
  ) async {
    int taps = 0;
    await tester.pumpWidget(
      _host(
        AppNavigationRailProfile(
          title: 'João M.',
          subtitle: 'Operador',
          initials: 'JM',
          isCollapsed: false,
          onTap: () => taps++,
        ),
      ),
    );
    expect(find.text('João M.'), findsOneWidget);
    expect(find.text('Operador'), findsOneWidget);

    await tester.tap(find.byType(AppNavigationRailProfile));
    await tester.pump();
    expect(taps, 1);
  });

  test('AppNavigationRail(+Item) no catálogo como migrated', () {
    for (final String id in <String>[
      'app_navigation_rail',
      'app_navigation_rail_item',
      'app_navigation_rail_profile',
    ]) {
      expect(
        flocksCatalog.any(
          (AppComponentMeta m) =>
              m.id == id && m.status == ComponentStatus.migrated,
        ),
        isTrue,
        reason: '$id deve estar migrated',
      );
    }
  });
}

void _noop() {}
