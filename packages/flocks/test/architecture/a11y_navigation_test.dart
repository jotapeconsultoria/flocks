// Regra 8 nas duas estruturas que o leitor de tela precisa para NAVEGAR: a
// fronteira de rota dos modais e o estado de seleção das abas.
//
// São os dois casos em que a informação existe só no pixel: um modal que abre
// sem escopar a rota deixa o usuário navegando a tela de baixo sem saber que
// algo apareceu; uma barra de abas sem `selected` vira uma fileira de botões
// iguais, com a ativa distinguida só pelo acento e pelo sublinhado.
import 'package:flocks/flocks.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(WidgetBuilder body) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(size: Size(800, 600), disableAnimations: true),
    child: AppTheme(
      data: AppThemeData.forBrand(jotapeBrand, dark: false),
      child: Navigator(
        onGenerateRoute: (RouteSettings _) => PageRouteBuilder<void>(
          pageBuilder: (BuildContext c, _, _) => body(c),
        ),
      ),
    ),
  ),
);

/// Existe algum nó da árvore semântica que satisfaça [matches]?
bool _anyNode(WidgetTester tester, bool Function(SemanticsData d) matches) {
  bool found = false;
  void visit(SemanticsNode node) {
    if (matches(node.getSemanticsData())) {
      found = true;
      return;
    }
    node.visitChildren((SemanticsNode child) {
      visit(child);
      return true;
    });
  }

  visit(tester.binding.rootElement!.renderObject!.debugSemantics!);
  return found;
}

bool _scopesRoute(WidgetTester tester) =>
    _anyNode(tester, (SemanticsData d) => d.flagsCollection.scopesRoute);

bool _namesRoute(WidgetTester tester, String name) => _anyNode(
  tester,
  (SemanticsData d) => d.flagsCollection.namesRoute && d.label.contains(name),
);

void main() {
  group('modais escopam e NOMEIAM a rota', () {
    testWidgets('showAppDialog', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _app(
          (BuildContext context) => Center(
            child: GestureDetector(
              onTap: () => showAppDialog<void>(
                context: context,
                title: 'Excluir veículo?',
                child: const Text('Corpo'),
              ),
              // `Text` e não `AppText`: o texto do DS é selecionável e o
              // reconhecedor de seleção ganha a arena, engolindo o toque.
              child: const Text('Abrir'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(_scopesRoute(tester), isFalse, reason: 'sem modal aberto');

      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();

      expect(_scopesRoute(tester), isTrue);
      expect(_namesRoute(tester, 'Excluir veículo?'), isTrue);
      handle.dispose();
    });

    testWidgets('showAppConfirm', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _app(
          (BuildContext context) => Center(
            child: GestureDetector(
              onTap: () => showAppConfirm(
                context: context,
                title: 'Excluir empresa?',
                message: 'Corpo',
              ),
              // `Text` e não `AppText`: o texto do DS é selecionável e o
              // reconhecedor de seleção ganha a arena, engolindo o toque.
              child: const Text('Abrir'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();

      // O helper herda o AppSemantics.modalRoute da _AppDialogRoute — a prova
      // é a herança ter chegado, não uma rota nova.
      expect(_scopesRoute(tester), isTrue);
      expect(_namesRoute(tester, 'Excluir empresa?'), isTrue);
      handle.dispose();
    });

    testWidgets('showAppBottomSheet', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _app(
          (BuildContext context) => Center(
            child: GestureDetector(
              onTap: () => showAppBottomSheet<void>(
                context: context,
                title: 'Filtros',
                child: const Text('Corpo'),
              ),
              // `Text` e não `AppText`: o texto do DS é selecionável e o
              // reconhecedor de seleção ganha a arena, engolindo o toque.
              child: const Text('Abrir'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();

      expect(_scopesRoute(tester), isTrue);
      expect(_namesRoute(tester, 'Filtros'), isTrue);
      handle.dispose();
    });

    testWidgets('showAppSideSheet', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _app(
          (BuildContext context) => Center(
            child: GestureDetector(
              onTap: () => showAppSideSheet<void>(
                context: context,
                title: 'Veículo',
                child: const Text('Corpo'),
              ),
              // `Text` e não `AppText`: o texto do DS é selecionável e o
              // reconhecedor de seleção ganha a arena, engolindo o toque.
              child: const Text('Abrir'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();

      expect(_scopesRoute(tester), isTrue);
      expect(_namesRoute(tester, 'Veículo'), isTrue);
      handle.dispose();
    });
  });

  group('abas anunciam qual está ativa', () {
    /// Quantos nós selecionáveis estão marcados como selecionados.
    (int selected, int total) countTabs(WidgetTester tester) {
      int sel = 0;
      int total = 0;
      void visit(SemanticsNode node) {
        final SemanticsData d = node.getSemanticsData();
        final bool? isSelected = d.flagsCollection.isSelected.toBoolOrNull();
        if (isSelected != null) {
          total++;
          if (isSelected) sel++;
        }
        node.visitChildren((SemanticsNode child) {
          visit(child);
          return true;
        });
      }

      visit(tester.binding.rootElement!.renderObject!.debugSemantics!);
      return (sel, total);
    }

    testWidgets('AppTabView marca exatamente uma aba', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _app(
          (BuildContext context) => AppTabView(
            items: <AppTabViewItem>[
              AppTabViewItem(
                label: 'Resumo',
                builder: (_) => const AppText('a'),
              ),
              AppTabViewItem(
                label: 'Trajeto',
                builder: (_) => const AppText('b'),
              ),
              AppTabViewItem(
                label: 'Paradas',
                builder: (_) => const AppText('c'),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(countTabs(tester), (1, 3));
      handle.dispose();
    });

    testWidgets('AppWorkspaceTabs marca exatamente uma aba', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _app(
          (BuildContext context) => AppWorkspaceTabs(
            tabs: const <AppWorkspaceTabItem>[
              AppWorkspaceTabItem(
                id: 'a',
                title: 'Veículos',
                icon: AppIcons.car,
              ),
              AppWorkspaceTabItem(
                id: 'b',
                title: 'Alertas',
                icon: AppIcons.alert,
              ),
            ],
            activeId: 'b',
            onSelect: (_) {},
            onClose: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(countTabs(tester), (1, 2));
      handle.dispose();
    });
  });
}
