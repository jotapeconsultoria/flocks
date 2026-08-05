import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

List<AppWorkspaceTabItem> _tabs(int count) => [
  for (var i = 0; i < count; i++)
    AppWorkspaceTabItem(id: 't$i', title: 'Aba número $i', icon: AppIcons.car),
];

Future<void> _pumpTabs(
  WidgetTester tester, {
  required int count,
  double width = 1280,
  AppWorkspaceTabsVariant variant = AppWorkspaceTabsVariant.attached,
}) async {
  tester.view
    ..physicalSize = Size(width, 400)
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    AppTheme(
      data: AppThemeData.light,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: width,
          child: AppWorkspaceTabs(
            tabs: _tabs(count),
            activeId: 't0',
            variant: variant,
            onSelect: (_) {},
            onClose: (_) {},
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('AppWorkspaceTabs — piso de largura e scroll', () {
    testWidgets('poucas abas dividem o espaço sem rolar', (tester) async {
      await _pumpTabs(tester, count: 3);

      expect(find.byType(SingleChildScrollView), findsNothing);
    });

    testWidgets('muitas abas passam a rolar em vez de espremer', (
      tester,
    ) async {
      // 10 abas em 1280px davam ~90px cada — largura em que a aba vira um
      // borrão. Agora a barra rola e cada aba mantém o piso.
      await _pumpTabs(tester, count: 10);

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('a aba nunca fica abaixo do piso', (tester) async {
      await _pumpTabs(tester, count: 10);

      final chip = tester
          .getRect(
            find
                .ancestor(
                  of: find.text('Aba número 0'),
                  matching: find.byType(SizedBox),
                )
                .first,
          )
          .width;

      expect(chip, greaterThanOrEqualTo(kAppWorkspaceTabMinWidth - 1));
    });

    testWidgets('janela estreita também rola', (tester) async {
      await _pumpTabs(tester, count: 6, width: 700);

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });

  group('AppWorkspaceTabs — variantes', () {
    testWidgets('attached deixa a aba ativa encostada na base', (tester) async {
      await _pumpTabs(tester, count: 3);

      final chip = tester.widget<AnimatedContainer>(
        find
            .ancestor(
              of: find.text('Aba número 0'),
              matching: find.byType(AnimatedContainer),
            )
            .first,
      );
      final margin = chip.margin! as EdgeInsets;

      // Base colada no conteúdo (estilo navegador).
      expect(margin.bottom, 0);
    });

    testWidgets('inset descola a aba ativa da base', (tester) async {
      await _pumpTabs(tester, count: 3, variant: AppWorkspaceTabsVariant.inset);

      final chip = tester.widget<AnimatedContainer>(
        find
            .ancestor(
              of: find.text('Aba número 0'),
              matching: find.byType(AnimatedContainer),
            )
            .first,
      );
      final margin = chip.margin! as EdgeInsets;
      final decoration = chip.decoration! as BoxDecoration;

      // Dentro de um cartão arredondado não há nada para encostar: a aba vira
      // pílula, sem borda e sem base aberta.
      expect(margin.bottom, greaterThan(0));
      expect(decoration.border, isNull);
      final radius = decoration.borderRadius! as BorderRadius;
      expect(radius.bottomLeft.x, greaterThan(0));
    });

    testWidgets('inset ainda distingue a aba ativa', (tester) async {
      await _pumpTabs(tester, count: 3, variant: AppWorkspaceTabsVariant.inset);

      BoxDecoration decorationOf(String title) =>
          tester
                  .widget<AnimatedContainer>(
                    find
                        .ancestor(
                          of: find.text(title),
                          matching: find.byType(AnimatedContainer),
                        )
                        .first,
                  )
                  .decoration!
              as BoxDecoration;

      // A ativa precisa se destacar do cartão sob ela, não sumir nele.
      expect(
        decorationOf('Aba número 0').color,
        isNot(const Color(0x00000000)),
      );
      expect(decorationOf('Aba número 1').color, const Color(0x00000000));
    });
  });
}
