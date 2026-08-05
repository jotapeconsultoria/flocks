import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// `find.byTooltip` só enxerga o `Tooltip` do Material; o DS usa [AppTooltip].
Finder _appTooltip(String message) => find.byWidgetPredicate(
  (widget) => widget is AppTooltip && widget.message == message,
);

Future<void> _pumpFilter(
  WidgetTester tester, {
  String? value,
  bool enabled = true,
  bool collapsed = false,
  VoidCallback? onTap,
}) async {
  tester.view
    ..physicalSize = const Size(400, 300)
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    AppTheme(
      data: AppThemeData.light,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: AppNavigationRailScope(
          isCollapsed: collapsed,
          child: SizedBox(
            width: collapsed ? 81 : 288,
            child: AppNavigationRailFilter(
              icon: AppIcons.group,
              label: 'Grupo',
              value: value,
              enabled: enabled,
              onTap: onTap,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('AppNavigationRailFilter — valor', () {
    testWidgets('mostra o valor selecionado', (tester) async {
      await _pumpFilter(tester, value: 'Caminhos Dourados');

      expect(find.text('Grupo'), findsOneWidget);
      expect(find.text('Caminhos Dourados'), findsOneWidget);
    });

    testWidgets('sem valor mostra "Todos"', (tester) async {
      await _pumpFilter(tester);

      // Estado explícito é melhor que um espaço vazio ambíguo.
      expect(find.text('Todos'), findsOneWidget);
    });

    testWidgets('valor só com espaços conta como vazio', (tester) async {
      await _pumpFilter(tester, value: '   ');

      expect(find.text('Todos'), findsOneWidget);
    });

    testWidgets('valor é aparado', (tester) async {
      await _pumpFilter(tester, value: '  Frota Sul  ');

      expect(find.text('Frota Sul'), findsOneWidget);
    });
  });

  group('AppNavigationRailFilter — interação', () {
    testWidgets('toque abre o seletor', (tester) async {
      var taps = 0;
      await _pumpFilter(tester, value: 'Frota Sul', onTap: () => taps++);

      await tester.tap(find.text('Frota Sul'));
      await tester.pumpAndSettle();

      expect(taps, 1);
    });

    testWidgets('desabilitado não dispara', (tester) async {
      var taps = 0;
      await _pumpFilter(
        tester,
        value: 'Frota Sul',
        enabled: false,
        onTap: () => taps++,
      );

      await tester.tap(find.text('Frota Sul'), warnIfMissed: false);
      await tester.pumpAndSettle();

      // O valor continua legível — o usuário precisa entender o estado.
      expect(find.text('Frota Sul'), findsOneWidget);
      expect(taps, 0);
    });
  });

  group('AppNavigationRailFilter — colapsado', () {
    testWidgets('esconde os textos e mantém o recorte no tooltip', (
      tester,
    ) async {
      await _pumpFilter(tester, value: 'Frota Sul', collapsed: true);

      expect(find.text('Grupo'), findsNothing);
      expect(find.text('Frota Sul'), findsNothing);
      // Colapsado só sobra o ícone: sem tooltip não haveria como saber o
      // recorte em vigor.
      expect(_appTooltip('Grupo: Frota Sul'), findsOneWidget);
    });

    testWidgets('tooltip reflete "Todos" quando não há seleção', (
      tester,
    ) async {
      await _pumpFilter(tester, collapsed: true);

      expect(_appTooltip('Grupo: Todos'), findsOneWidget);
    });
  });

  group('AppNavigationRailFilter — rail estreito', () {
    testWidgets('não estoura o layout no rail colapsado', (tester) async {
      // Regressão: o rail colapsado tem 81px e a linha transbordava 3px,
      // pintando a faixa de overflow no rodapé.
      tester.view
        ..physicalSize = const Size(200, 300)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        AppTheme(
          data: AppThemeData.light,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: AppNavigationRailScope(
              isCollapsed: true,
              child: SizedBox(
                width: 81,
                child: AppNavigationRailFilter(
                  icon: AppIcons.group,
                  label: 'Grupo',
                  value: 'Um nome de grupo bem comprido',
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('nem durante a transição de largura', (tester) async {
      // Largura intermediária: é onde o conteúdo não cabe mas ainda é medido.
      tester.view
        ..physicalSize = const Size(200, 300)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      for (final width in const [60.0, 81.0, 120.0, 200.0]) {
        await tester.pumpWidget(
          AppTheme(
            data: AppThemeData.light,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: AppNavigationRailScope(
                isCollapsed: width < 150,
                child: SizedBox(
                  width: width,
                  child: const AppNavigationRailFilter(
                    icon: AppIcons.client,
                    label: 'Cliente',
                    value: 'ZIRIX SOLUCOES EM RASTREAMENTO',
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: 'largura $width');
      }
    });
  });
}
