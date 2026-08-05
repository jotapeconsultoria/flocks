import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(size: Size(600, 500)),
    child: AppTheme(
      data: AppThemeData.light,
      child: SizedBox(height: 260, child: child),
    ),
  ),
);

List<AppTabViewItem> _items(void Function(int) onTap) => <AppTabViewItem>[
  AppTabViewItem(
    label: 'Resumo',
    builder: (BuildContext _) => const AppText('painel-resumo'),
  ),
  AppTabViewItem(
    label: 'Detalhes',
    builder: (BuildContext _) => const AppText('painel-detalhes'),
  ),
];

/// Folha com estado PRÓPRIO dentro da aba: se o rebuild do pai recriasse os
/// elementos, este contador voltaria a zero.
class _StatefulLeaf extends StatefulWidget {
  const _StatefulLeaf();

  @override
  State<_StatefulLeaf> createState() => _StatefulLeafState();
}

class _StatefulLeafState extends State<_StatefulLeaf> {
  int _clicks = 0;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => setState(() => _clicks++),
    child: AppText('cliques: $_clicks'),
  );
}

/// Pai com estado próprio + uma aba que depende dele e contém uma folha com
/// estado interno, para separar "props chegam" de "State sobrevive".
class _CounterHost extends StatefulWidget {
  const _CounterHost();

  @override
  State<_CounterHost> createState() => _CounterHostState();
}

class _CounterHostState extends State<_CounterHost> {
  int _value = 0;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      GestureDetector(
        onTap: () => setState(() => _value++),
        child: const AppText('incrementar'),
      ),
      Expanded(
        child: AppTabView(
          items: <AppTabViewItem>[
            AppTabViewItem(
              label: 'Resumo',
              builder: (BuildContext _) => Column(
                children: <Widget>[
                  AppText('valor: $_value'),
                  const _StatefulLeaf(),
                ],
              ),
            ),
            AppTabViewItem(
              label: 'Detalhes',
              builder: (BuildContext _) => const AppText('painel-detalhes'),
            ),
          ],
        ),
      ),
    ],
  );
}

void main() {
  testWidgets('AppTabView troca de conteúdo ao tocar numa aba', (tester) async {
    int? changed;
    await tester.pumpWidget(
      _host(
        AppTabView(
          items: _items((int i) => changed = i),
          onTabChanged: (int i) => changed = i,
        ),
      ),
    );
    expect(find.text('painel-resumo'), findsOneWidget);

    await tester.tap(find.text('Detalhes'));
    await tester.pumpAndSettle();
    expect(find.text('painel-detalhes'), findsOneWidget);
    expect(changed, 1);
  });

  testWidgets('conteúdo da aba acompanha o rebuild do pai (sem cache)', (
    tester,
  ) async {
    // Regressão: o conteúdo era construído UMA vez e guardado num cache de
    // Widget, então uma aba com conteúdo dinâmico ficava congelada nas props do
    // primeiro build. No detalhe de Account isso quebrava o "Editar": o botão
    // alternava o estado do pai e a aba seguia em modo leitura (revisão P1r6).
    await tester.pumpWidget(_host(const _CounterHost()));
    expect(find.text('valor: 0'), findsOneWidget);

    await tester.tap(find.text('incrementar'));
    await tester.pumpAndSettle();
    expect(
      find.text('valor: 1'),
      findsOneWidget,
      reason: 'a aba tem de refletir o novo estado do pai',
    );
  });

  testWidgets('estado interno da aba sobrevive ao rebuild do pai', (
    tester,
  ) async {
    // O outro lado da moeda: reconstruir o Widget não pode recriar o State
    // (a aba visitada continua montada na mesma posição/key).
    await tester.pumpWidget(_host(const _CounterHost()));

    await tester.tap(find.text('cliques: 0'));
    await tester.pumpAndSettle();
    expect(find.text('cliques: 1'), findsOneWidget);

    await tester.tap(find.text('incrementar'));
    await tester.pumpAndSettle();

    expect(find.text('valor: 1'), findsOneWidget);
    expect(
      find.text('cliques: 1'),
      findsOneWidget,
      reason: 'o rebuild não pode zerar o estado interno da aba',
    );
  });

  testWidgets('lazy load: aba nunca aberta não é construída', (tester) async {
    await tester.pumpWidget(
      _host(
        AppTabView(
          items: <AppTabViewItem>[
            AppTabViewItem(
              label: 'Resumo',
              builder: (BuildContext _) => const AppText('painel-resumo'),
            ),
            AppTabViewItem(
              label: 'Detalhes',
              builder: (BuildContext _) => const AppText('painel-detalhes'),
            ),
          ],
        ),
      ),
    );

    expect(find.text('painel-detalhes'), findsNothing);
    await tester.tap(find.text('Detalhes'));
    await tester.pumpAndSettle();
    expect(find.text('painel-detalhes'), findsOneWidget);
  });

  // O rótulo da aba INATIVA usava um stop fixo (`neutralPrimary.s400`), que
  // dentro de uma sheet escura caía para ~2:1 — o título sumia. O contrato aqui
  // é o mesmo do [AppWorkspaceTabs]: AA contra a superfície em que as abas
  // realmente pousam (default `surfaceContainer`), nos DOIS temas.
  for (final (String name, AppThemeData theme) in <(String, AppThemeData)>[
    ('claro', AppThemeData.light),
    ('escuro', AppThemeData.dark),
  ]) {
    testWidgets('aba inativa tem contraste AA no tema $name', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AppTheme(
            data: theme,
            child: SizedBox(
              height: 260,
              child: AppTabView(items: _items((_) {})),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final AppText inactive = tester.widget<AppText>(
        find.ancestor(
          of: find.text('Detalhes'),
          matching: find.byType(AppText),
        ),
      );
      final Color? foreground = inactive.style?.color;
      expect(foreground, isNotNull);
      expect(
        contrastRatio(foreground!, theme.colorTheme.surfaceContainer),
        greaterThanOrEqualTo(kAaNormal),
      );
    });
  }

  test('AppTabView no catálogo como migrated', () {
    expect(
      flocksCatalog.any(
        (AppComponentMeta m) =>
            m.id == 'app_tab_view' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });

  // --- Densidade e moldura (revisão visual de 2026-07-28) ----------------------

  /// A aba tem a largura do CONTEÚDO, não uma largura fixa.
  ///
  /// O indicador pedia `AppSpacings.infinity`, o que empurrava a Column para o
  /// teto do `ConstrainedBox` e fixava TODA aba em 192px, com o rótulo perdido no
  /// meio do bloco. O sintoma relatado foi "o padding parece menor" — e mexer no
  /// padding não movia nada, porque a largura nunca vinha dele.
  testWidgets('a aba tem a largura do conteúdo, não 192 fixos', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: AppTheme(
            data: AppThemeData.light,
            child: SizedBox(
              width: 900,
              height: 300,
              child: AppTabView(
                items: <AppTabViewItem>[
                  AppTabViewItem(
                    label: 'Resumo',
                    builder: (_) => const SizedBox.shrink(),
                  ),
                  AppTabViewItem(
                    label: 'Um rótulo bem mais longo',
                    builder: (_) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final Size curta = tester.getSize(find.text('Resumo'));
    final Size longa = tester.getSize(find.text('Um rótulo bem mais longo'));

    // Duas abas de rótulos diferentes não podem ter a mesma largura — se
    // tiverem, a largura voltou a ser fixa.
    expect(
      curta.width,
      lessThan(longa.width),
      reason: 'as abas voltaram a ter largura fixa',
    );
    // E a curta precisa caber MUITO abaixo do teto de 192.
    expect(curta.width, lessThan(AppSpacings.s192));
  });

  testWidgets('o conteúdo está sob o degradê de scroll', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: AppTheme(
            data: AppThemeData.light,
            child: SizedBox(
              width: 400,
              height: 200,
              child: AppTabView(
                items: <AppTabViewItem>[
                  AppTabViewItem(
                    label: 'A',
                    builder: (_) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    // O mesmo widget que o side sheet usa. Sem ele o conteúdo é cortado a seco
    // sob a barra, e nada indica que há mais coisa fora da vista.
    expect(find.byType(AppScrollEdgeFade), findsOneWidget);
  });
}
