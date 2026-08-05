import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _surface = Size(400, 400);

Widget _host({
  ScrollController? controller,
  bool insideOuterFade = false,
  EdgeInsets published = EdgeInsets.zero,
  void Function(EdgeInsets)? onBodyPadding,
}) {
  // Sem `contentPadding`: o recuo default é o que precisa estar de pé.
  final Widget tabs = AppTabView(
    items: <AppTabViewItem>[
      AppTabViewItem(
        label: 'Cadastro',
        // O `Builder` é essencial: o `AppTabView` passa ao `builder` o context
        // DELE, e o que interessa aqui é o que a rolagem (e a barra dela) vê
        // depois de montada — um degrau abaixo.
        builder: (BuildContext _) => Builder(
          builder: (BuildContext context) {
            onBodyPadding?.call(MediaQuery.paddingOf(context));
            return SingleChildScrollView(
              controller: controller,
              child: const SizedBox(
                key: ValueKey<String>('corpo'),
                height: 2000,
                width: double.infinity,
                child: AppText('corpo'),
              ),
            );
          },
        ),
      ),
      AppTabViewItem(
        label: 'Status',
        builder: (BuildContext _) => const AppText('status'),
      ),
    ],
  );

  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      // `published` imita o respiro que a side sheet publica ao conteúdo.
      data: MediaQueryData(size: _surface, padding: published),
      child: AppTheme(
        data: AppThemeData.light,
        child: Center(
          child: SizedBox(
            width: _surface.width,
            height: _surface.height,
            // A sheet que hospeda as abas também esmaece o conteúdo dela.
            child: insideOuterFade ? AppScrollEdgeFade(child: tabs) : tabs,
          ),
        ),
      ),
    ),
  );
}

/// Véus pintados por [fade] — cada um é um `DecoratedBox` com degradê.
Iterable<Rect> _veilRects(WidgetTester tester, Finder fade) => tester
    .widgetList<DecoratedBox>(
      find.descendant(of: fade, matching: find.byType(DecoratedBox)),
    )
    .where(
      (DecoratedBox box) => (box.decoration as BoxDecoration).gradient != null,
    )
    .map((DecoratedBox box) => tester.getRect(find.byWidget(box)));

void main() {
  testWidgets('o corpo da aba recua na horizontal — a faixa de arraste da '
      'sheet mora na borda e não pode cair sobre o conteúdo', (tester) async {
    await tester.binding.setSurfaceSize(_surface);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    final Rect tabs = tester.getRect(find.byType(AppTabView));
    final Rect body = tester.getRect(
      find.byKey(const ValueKey<String>('corpo')),
    );

    expect(body.left - tabs.left, AppSpacings.s8);
    expect(tabs.right - body.right, AppSpacings.s8);
  });

  testWidgets('o corpo CONSOME o respiro publicado pela superfície — é o que '
      'devolve a barra de rolagem para a borda', (tester) async {
    await tester.binding.setSurfaceSize(_surface);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    EdgeInsets? seen;

    await tester.pumpWidget(
      _host(
        // O que a side sheet arrastável publica: a faixa da gutter dos dois
        // lados. A barra de rolagem se posiciona por ele — deixá-lo de pé
        // desenhava a barra 24px para dentro, em cima do conteúdo.
        published: const EdgeInsets.symmetric(horizontal: AppSpacings.s24),
        onBodyPadding: (EdgeInsets p) => seen = p,
      ),
    );
    await tester.pumpAndSettle();

    expect(seen?.left, 0);
    expect(seen?.right, 0);

    // E o recuo não dobra: o corpo fica só com o `contentPadding`, não com
    // 24 + 8.
    final Rect tabs = tester.getRect(find.byType(AppTabView));
    final Rect body = tester.getRect(
      find.byKey(const ValueKey<String>('corpo')),
    );
    expect(body.left - tabs.left, AppSpacings.s8);
    expect(tabs.right - body.right, AppSpacings.s8);
  });

  testWidgets('o véu da rolagem nasce ABAIXO da barra de abas', (tester) async {
    await tester.binding.setSurfaceSize(_surface);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    final Rect bar = tester.getRect(
      find.byKey(const ValueKey<String>('app_tab_view_tab_0')),
    );
    for (final Rect veil in _veilRects(tester, find.byType(AppTabView))) {
      expect(
        veil.top,
        greaterThanOrEqualTo(bar.bottom),
        reason: 'degradê por cima do rótulo da aba',
      );
    }
  });

  testWidgets('dentro de uma superfície que também esmaece, só o véu das abas '
      'pinta — o de fora cairia sobre a barra', (tester) async {
    await tester.binding.setSurfaceSize(_surface);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _host(controller: controller, insideOuterFade: true),
    );
    await tester.pumpAndSettle();

    controller.jumpTo(400);
    await tester.pumpAndSettle();

    // O véu de FORA (o da sheet) tem a barra de abas dentro dele; o de dentro,
    // não. Contar os dois e comparar denuncia se o ancestral voltou a pintar.
    final int inner = _veilRects(
      tester,
      find.descendant(
        of: find.byType(AppTabView),
        matching: find.byType(AppScrollEdgeFade),
      ),
    ).length;
    final int total = _veilRects(
      tester,
      find.byType(AppScrollEdgeFade).first,
    ).length;

    expect(inner, 2, reason: 'rolagem no meio: véu em cima e embaixo');
    expect(
      total,
      inner,
      reason: 'a sheet não pode pintar véu por cima das abas',
    );
  });
}
