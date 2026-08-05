import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(size: Size(800, 200)),
    child: AppTheme(
      data: AppThemeData.light,
      child: SizedBox(height: 56, width: 600, child: child),
    ),
  ),
);

List<AppWorkspaceTabItem> _tabs() => <AppWorkspaceTabItem>[
  const AppWorkspaceTabItem(
    id: 'a',
    title: 'Veículos',
    icon: AppIcons.infoCircle,
  ),
  const AppWorkspaceTabItem(id: 'b', title: 'Alertas', icon: AppIcons.alert),
];

void _ignore(String _) {}

/// A barra `attached` é o topo do próprio cartão: sem recuo e com uma linha
/// que a ativa interrompe.
void _flushGroup() {
  group('AppWorkspaceTabs — attached encosta no topo', () {
    testWidgets('primeira aba nasce na borda esquerda', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 300));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _host(
          const AppWorkspaceTabs(
            tabs: [
              AppWorkspaceTabItem(
                id: 'a',
                title: 'A',
                icon: AppIcons.infoCircle,
              ),
              AppWorkspaceTabItem(id: 'b', title: 'B', icon: AppIcons.alert),
            ],
            activeId: 'a',
            onSelect: _ignore,
            onClose: _ignore,
          ),
        ),
      );

      final bar = tester.getRect(find.byType(AppWorkspaceTabs));
      final first = tester.getRect(
        find
            .ancestor(
              of: find.text('A'),
              matching: find.byType(AnimatedContainer),
            )
            .first,
      );
      // Medido na ABA, não no título: o padding interno dela cresceu com as
      // asas, e mediria recuo onde não há.
      expect(first.left, bar.left);
    });

    testWidgets('o slot leading é PINTADO à esquerda da primeira aba', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1200, 300));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _host(
          const AppWorkspaceTabs(
            tabs: [
              AppWorkspaceTabItem(
                id: 'a',
                title: 'A',
                icon: AppIcons.infoCircle,
              ),
            ],
            activeId: 'a',
            onSelect: _ignore,
            onClose: _ignore,
            leading: Text('HIST', textDirection: TextDirection.ltr),
          ),
        ),
      );

      // Aceitar o slot e não desenhá-lo não quebra análise nem tipos — só some
      // da tela. Por isso o teste mira o PIXEL, não a propriedade.
      expect(find.text('HIST'), findsOneWidget);
      expect(
        tester.getRect(find.text('HIST')).left,
        lessThan(tester.getRect(find.text('A')).left),
      );
      // E o slot NÃO estica o conteúdo: a largura firme do SizedBox chegava ao
      // filho e a área clicável ficava maior que o desenho.
      expect(tester.getSize(find.text('HIST')).width, lessThan(60));
    });

    testWidgets('selecionar não muda o tamanho da aba nem do conteúdo', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1200, 300));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      Widget build(String active) => _host(
        AppWorkspaceTabs(
          tabs: const [
            AppWorkspaceTabItem(id: 'a', title: 'A', icon: AppIcons.infoCircle),
            AppWorkspaceTabItem(id: 'b', title: 'B', icon: AppIcons.alert),
          ],
          activeId: active,
          onSelect: _ignore,
          onClose: _ignore,
        ),
      );

      await tester.pumpWidget(build('b'));
      await tester.pumpAndSettle();
      final inactive = tester.getRect(find.text('A'));

      await tester.pumpWidget(build('a'));
      await tester.pumpAndSettle();
      final active = tester.getRect(find.text('A'));

      // O título não pode andar nem encolher ao ser selecionado: quando o
      // padding dependia do estado, a aba parecia diminuir no clique.
      expect(active, inactive);
    });

    testWidgets('aba ativa encosta na base da barra', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 300));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _host(
          const AppWorkspaceTabs(
            tabs: [
              AppWorkspaceTabItem(
                id: 'a',
                title: 'A',
                icon: AppIcons.infoCircle,
              ),
              AppWorkspaceTabItem(id: 'b', title: 'B', icon: AppIcons.alert),
            ],
            activeId: 'a',
            onSelect: _ignore,
            onClose: _ignore,
          ),
        ),
      );

      final bar = tester.getRect(find.byType(AppWorkspaceTabs));
      // A caixa PINTADA, não o AnimatedContainer: este último inclui a própria
      // margem, e mediria zero de folga onde há 4px.
      final active = tester.getRect(
        find
            .descendant(
              of: find
                  .ancestor(
                    of: find.text('A'),
                    matching: find.byType(AnimatedContainer),
                  )
                  .first,
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      // Encostar na base é o que faz o fundo opaco da aba cobrir a linha
      // divisória — é daí que vem a continuidade com a página.
      expect(active.bottom, bar.bottom);
      // Em cima, a folga de 4px que descola a aba do canto do cartão.
      expect(active.top - bar.top, AppSpacings.s4);
    });
  });
}

/// Contraste mínimo de texto sobre a superfície que hospeda a barra.
void _contrastGroup() {
  group('AppWorkspaceTabs — legibilidade sobre o cartão', () {
    for (final brand in const <AppBrandConfig>[jotapeBrand, zxtrackBrand]) {
      for (final dark in [false, true]) {
        test('${brand.clientSlug}/${dark ? "escuro" : "claro"}', () {
          final colors = dark
              ? brand.toDarkColorTheme()
              : brand.toLightColorTheme();
          final host = colors.surfaceContainer;

          // A barra vive DENTRO do cartão: é ele que está atrás do título das
          // inativas e do fundo da ativa. Um stop fixo aqui dava 2.02 no
          // escuro — título de aba ilegível.
          final inativa = readableStopOn(
            colors.neutralPrimary,
            host,
            minRatio: kAaNormal,
          );
          final ativa = readableStopOn(
            colors.tertiary,
            host,
            minRatio: kAaNormal,
          );

          expect(contrastRatio(inativa, host), greaterThanOrEqualTo(kAaNormal));
          expect(contrastRatio(ativa, host), greaterThanOrEqualTo(kAaNormal));
          expect(
            contrastRatio(colors.onSurface, host),
            greaterThanOrEqualTo(kAaNormal),
          );
          // O hover tem de ser um passo ALÉM do repouso: quando era um stop
          // fixo, derivar o repouso o alcançou e o realce sumiu.
          expect(colors.onSurface, isNot(inativa));
        });
      }
    }
  });
}

Widget _reorderableTabs({
  required void Function(int, int) onReorder,
  void Function(String)? onSelect,
}) => AppWorkspaceTabs(
  tabs: const [
    AppWorkspaceTabItem(id: 'a', title: 'AAA', icon: AppIcons.infoCircle),
    AppWorkspaceTabItem(id: 'b', title: 'BBB', icon: AppIcons.alert),
    AppWorkspaceTabItem(id: 'c', title: 'CCC', icon: AppIcons.infoCircle),
  ],
  activeId: 'a',
  onSelect: onSelect ?? _ignore,
  onClose: _ignore,
  onReorder: onReorder,
);

/// Arraste para reordenar — e o clique que continua selecionando.
void _reorderGroup() {
  group('AppWorkspaceTabs — reordenar por arraste', () {
    // O `ReorderableList` exige um `Overlay` acima (é onde o proxy do arraste
    // é pintado). No app ele vem do Navigator; aqui é montado à mão.
    // `ReorderableList` exige `Overlay` (onde o proxy do arraste é pintado) e
    // `Localizations` (anúncios de acessibilidade do reordenar). Um
    // `WidgetsApp` entrega os dois — no app eles vêm do mesmo lugar.
    Widget host({
      required void Function(int, int) onReorder,
      void Function(String)? onSelect,
    }) => WidgetsApp(
      color: const Color(0xFF000000),
      // `onGenerateRoute` e não `builder`: só com rota o WidgetsApp monta o
      // Navigator — e é dele que vem o Overlay que o arraste precisa.
      onGenerateRoute: (RouteSettings settings) => PageRouteBuilder<void>(
        settings: settings,
        pageBuilder: (BuildContext context, _, _) => AppTheme(
          data: AppThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: _reorderableTabs(onReorder: onReorder, onSelect: onSelect),
          ),
        ),
      ),
    );

    testWidgets('arrastar a primeira sobre a segunda troca a ordem', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1200, 300));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final moves = <(int, int)>[];
      await tester.pumpWidget(host(onReorder: (o, n) => moves.add((o, n))));

      final start = tester.getCenter(find.text('AAA'));
      final gesture = await tester.startGesture(start);
      await tester.pump(const Duration(milliseconds: 200));
      await gesture.moveBy(const Offset(240, 0));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(moves, isNotEmpty);
      expect(moves.first.$1, 0);
      expect(moves.first.$2, greaterThan(0));
    });

    testWidgets('o cursor vira mão fechada durante o arraste', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 300));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(host(onReorder: (_, _) {}));
      await tester.pumpAndSettle();

      MouseCursor cursorOfStrip() => tester
          .widgetList<MouseRegion>(
            find.descendant(
              of: find.byType(AppWorkspaceTabs),
              matching: find.byType(MouseRegion),
            ),
          )
          .first
          .cursor;

      // Em repouso a região cede a vez: quem manda é a aba (mãozinha de
      // clique).
      expect(cursorOfStrip(), MouseCursor.defer);

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('AAA')),
      );
      await tester.pump(const Duration(milliseconds: 200));
      await gesture.moveBy(const Offset(120, 0));
      await tester.pump();

      expect(cursorOfStrip(), SystemMouseCursors.grabbing);

      await gesture.up();
      await tester.pumpAndSettle();
      expect(cursorOfStrip(), MouseCursor.defer);
    });

    testWidgets('um clique sem movimento ainda seleciona', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 300));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final selected = <String>[];
      final moves = <(int, int)>[];
      await tester.pumpWidget(
        host(onReorder: (o, n) => moves.add((o, n)), onSelect: selected.add),
      );

      await tester.tap(find.text('BBB'));
      await tester.pumpAndSettle();

      // O reconhecedor de arraste e o de toque disputam a mesma área. Um
      // toque parado tem de continuar chegando na aba — senão trocar de aba
      // com o mouse deixa de funcionar.
      expect(selected, ['b']);
      expect(moves, isEmpty);
    });
  });
}

void main() {
  _reorderGroup();
  _contrastGroup();
  _flushGroup();
  testWidgets('AppWorkspaceTabs mostra abas e dispara onSelect', (
    tester,
  ) async {
    String? selected;
    await tester.pumpWidget(
      _host(
        AppWorkspaceTabs(
          tabs: _tabs(),
          activeId: 'a',
          onSelect: (String id) => selected = id,
          onClose: (_) {},
        ),
      ),
    );
    expect(find.text('Veículos'), findsOneWidget);
    expect(find.text('Alertas'), findsOneWidget);

    await tester.tap(find.text('Alertas'));
    await tester.pump();
    expect(selected, 'b');
  });

  test('AppWorkspaceTabs no catálogo como migrated', () {
    expect(
      flocksCatalog.any(
        (AppComponentMeta m) =>
            m.id == 'app_workspace_tabs' &&
            m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
