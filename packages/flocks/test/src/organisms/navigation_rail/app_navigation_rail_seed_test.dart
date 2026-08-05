import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

AppNavigationRailItemData _leaf(String title, String route) =>
    AppNavigationRailItemData(
      icon: AppIcons.car,
      onPressed: (_, _) {},
      route: route,
      title: title,
    );

AppNavigationRailItemData _group(
  String title,
  String route,
  List<AppNavigationRailItemData> children,
) => AppNavigationRailItemData(
  icon: AppIcons.inventory,
  onPressed: (_, _) {},
  route: route,
  title: title,
  children: children,
);

/// Só o que USER alcança — o que o shell monta antes da sessão carregar.
final _restrictedItems = [
  _group('Administração', '/organizations', [_leaf('Motoristas', '/drivers')]),
];

/// O menu do ADMIN, disponível depois que a sessão resolve.
final _fullItems = [
  _group('Administração', '/organizations', [
    _leaf('Clientes', '/clients'),
    _leaf('Motoristas', '/drivers'),
  ]),
];

/// Rail cujos itens podem trocar depois de montado — é o que acontece de
/// verdade quando o `SessionCubit` sai de `SessionInitial`.
class _MutableRail extends StatefulWidget {
  const _MutableRail({
    required this.route,
    required this.initialItems,
    super.key,
  });

  final String route;
  final List<AppNavigationRailItemData> initialItems;

  @override
  State<_MutableRail> createState() => _MutableRailState();
}

class _MutableRailState extends State<_MutableRail> {
  late List<AppNavigationRailItemData> _items = widget.initialItems;

  void promoteToFullMenu() => setState(() => _items = _fullItems);

  @override
  Widget build(BuildContext context) => AppNavigationRail(
    getCurrentRoute: (_) => widget.route,
    items: _items,
    showFloatingToggle: false,
  );
}

Future<_MutableRailState> _pumpRail(
  WidgetTester tester, {
  required String route,
  required List<AppNavigationRailItemData> items,
}) async {
  tester.view
    ..physicalSize = const Size(600, 900)
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final key = GlobalKey<_MutableRailState>();
  await tester.pumpWidget(
    AppTheme(
      data: AppThemeData.light,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _MutableRail(key: key, route: route, initialItems: items),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return key.currentState!;
}

void main() {
  group('AppNavigationRail — semeadura por rota', () {
    testWidgets('abre o grupo da rota atual no primeiro build', (tester) async {
      await _pumpRail(tester, route: '/clients', items: _fullItems);

      expect(find.text('Clientes'), findsOneWidget);
    });

    testWidgets('reavalia quando os itens chegam depois (bug do deep-link)', (
      tester,
    ) async {
      // Cenário real: no primeiro build a sessão ainda não carregou, então o
      // menu só tem o que USER alcança e /clients não casa com nada.
      final state = await _pumpRail(
        tester,
        route: '/clients',
        items: _restrictedItems,
      );
      expect(find.text('Clientes'), findsNothing);

      // A sessão resolve e o menu de ADMIN chega.
      state.promoteToFullMenu();
      await tester.pumpAndSettle();

      // Antes da correção o rail já havia marcado "semeei" e o grupo nunca
      // mais abria: quem entrasse por link direto via o menu fechado.
      expect(find.text('Clientes'), findsOneWidget);
    });

    testWidgets('não reabre o que o usuário fechou', (tester) async {
      final state = await _pumpRail(
        tester,
        route: '/clients',
        items: _fullItems,
      );
      expect(find.text('Clientes'), findsOneWidget);

      // Usuário fecha o grupo de propósito.
      await tester.tap(find.text('Administração'));
      await tester.pumpAndSettle();
      expect(find.text('Clientes'), findsNothing);

      // Um rebuild com novos itens não deve desfazer a escolha dele.
      state.promoteToFullMenu();
      await tester.pumpAndSettle();

      expect(find.text('Clientes'), findsNothing);
    });
  });

  group('AppNavigationRail — logo e colapso', () {
    testWidgets('sem logo o bloco de marca não é renderizado', (tester) async {
      await _pumpRail(tester, route: '/clients', items: _fullItems);

      // `logoCollapsed` nulo: nenhuma logo, e os itens sobem.
      expect(find.byType(AppIcon), findsWidgets);
      final railBox = tester.getRect(find.byType(AppNavigationRail));
      final firstItem = tester.getRect(find.text('Administração'));
      // Sem o bloco de 56px + 16 de respiro, o primeiro item começa cedo.
      expect(firstItem.top - railBox.top, lessThan(56));
    });

    testWidgets('showFloatingToggle: false remove o chevron e o gutter', (
      tester,
    ) async {
      await _pumpRail(tester, route: '/clients', items: _fullItems);

      // O chevron é o único uso de AppTooltip com estes rótulos.
      expect(find.byTooltip('Abrir'), findsNothing);
      expect(find.byTooltip('Fechar'), findsNothing);
    });

    testWidgets('o rodapé consegue alternar o colapso pelo escopo', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(600, 900)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        AppTheme(
          data: AppThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: AppNavigationRail(
              getCurrentRoute: (_) => '/clients',
              items: _fullItems,
              showFloatingToggle: false,
              footer: Builder(
                builder: (context) => AppNavigationRailItem(
                  icon: AppIcons.collapse,
                  title: 'Recolher menu',
                  onPressed: AppNavigationRailScope.toggleOf(context) ?? () {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Expandido: o rótulo do filho está visível.
      expect(find.text('Clientes'), findsOneWidget);

      await tester.tap(find.text('Recolher menu'));
      await tester.pumpAndSettle();

      // Colapsar fecha o accordion — é o comportamento que o chevron tinha.
      expect(find.text('Clientes'), findsNothing);
    });
  });
}
