import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: AppThemeData.light,
      // Overlay: a seleção nativa do EditableText (handles/toolbar) precisa de
      // um Overlay ancestral — que um MaterialApp normalmente fornece.
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(builder: (_) => Center(child: child)),
        ],
      ),
    ),
  ),
);

/// Como [_host], mas com um text scale explícito (acessibilidade).
Widget _hostScaled(Widget child, double scale) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: MediaQueryData(textScaler: TextScaler.linear(scale)),
    child: AppTheme(
      data: AppThemeData.light,
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(builder: (_) => Center(child: child)),
        ],
      ),
    ),
  ),
);

/// Como [_host], mas com um [AppStyle] global explícito no tema — para provar
/// que o campo segue `theme.styleTheme.style` quando o `style` não é passado.
Widget _hostStyled(Widget child, AppStyle style) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: AppThemeData.light.copyWith(
        styleTheme: AppStyleTheme(style: style),
      ),
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(builder: (_) => Center(child: child)),
        ],
      ),
    ),
  ),
);

/// O container-campo do [AppInput] é o único com `clipBehavior: antiAlias`.
Container _fieldContainer(WidgetTester tester) {
  return tester
      .widgetList<Container>(
        find.descendant(
          of: find.byType(AppInput),
          matching: find.byType(Container),
        ),
      )
      .firstWhere((Container c) => c.clipBehavior == Clip.antiAlias);
}

/// Fundo do campo (fill + sombra) — a borda NÃO vive aqui.
BoxDecoration _fieldDeco(WidgetTester tester) =>
    _fieldContainer(tester).decoration! as BoxDecoration;

/// A borda (outlined) vive em `foregroundDecoration` para não afetar o layout.
BoxBorder? _fieldBorder(WidgetTester tester) {
  final BoxDecoration? deco =
      _fieldContainer(tester).foregroundDecoration as BoxDecoration?;
  return deco?.border;
}

/// O fundo de erro esperado — derivado, como o componente faz.
Color _expectedErrorFill(AppColorTheme colors) => mostSeparatedStop(
  colors.danger,
  surfaces: <Color>[colors.surface, colors.surfaceContainer],
  content: colors.onSurface,
);

void main() {
  group('conteúdo', () {
    testWidgets('renderiza label, hint (vazio), helper', (tester) async {
      await tester.pumpWidget(
        _host(
          const AppInput(
            label: 'E-mail',
            hintText: 'nome@dominio.com',
            helperText: 'Nunca compartilhamos',
          ),
        ),
      );
      expect(find.text('E-mail'), findsOneWidget);
      expect(find.text('nome@dominio.com'), findsOneWidget);
      expect(find.text('Nunca compartilhamos'), findsOneWidget);
    });

    testWidgets('errorText substitui helperText', (tester) async {
      await tester.pumpWidget(
        _host(
          const AppInput(
            helperText: 'ajuda',
            errorText: 'obrigatório',
            hasError: true,
          ),
        ),
      );
      expect(find.text('obrigatório'), findsOneWidget);
      expect(find.text('ajuda'), findsNothing);
    });

    testWidgets('showCounter mostra contador com maxLength', (tester) async {
      await tester.pumpWidget(
        _host(
          const AppInput(initialValue: 'abc', maxLength: 10, showCounter: true),
        ),
      );
      expect(find.text('3/10'), findsOneWidget);
    });
  });

  group('eixo AppStyle', () {
    testWidgets('default segue o global (filled) = sem borda, sem sombra', (
      tester,
    ) async {
      await tester.pumpWidget(_host(const AppInput()));
      expect(_fieldBorder(tester), isNull);
      expect(_fieldDeco(tester).boxShadow, isNull);
    });

    testWidgets('default segue o global quando outlined = borda', (
      tester,
    ) async {
      await tester.pumpWidget(_hostStyled(const AppInput(), AppStyle.outlined));
      expect(_fieldBorder(tester), isNotNull);
      expect(_fieldDeco(tester).boxShadow, isNull);
    });

    testWidgets('outlined explícito = borda (em foreground), sem sombra', (
      tester,
    ) async {
      await tester.pumpWidget(_host(const AppInput(style: AppStyle.outlined)));
      // A borda vive em foregroundDecoration (não afeta o layout); o fundo não
      // tem borda.
      expect(_fieldBorder(tester), isNotNull);
      expect(_fieldDeco(tester).border, isNull);
      expect(_fieldDeco(tester).boxShadow, isNull);
    });

    testWidgets('filled = sem borda', (tester) async {
      await tester.pumpWidget(_host(const AppInput(style: AppStyle.filled)));
      expect(_fieldBorder(tester), isNull);
      expect(_fieldDeco(tester).boxShadow, isNull);
    });

    testWidgets('elevated = sombra, sem borda', (tester) async {
      await tester.pumpWidget(_host(const AppInput(style: AppStyle.elevated)));
      expect(_fieldBorder(tester), isNull);
      expect(_fieldDeco(tester).boxShadow, isNotNull);
    });
  });

  group('estados de erro por estilo', () {
    testWidgets('filled + erro = fundo danger derivado da paleta', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(const AppInput(style: AppStyle.filled, hasError: true)),
      );
      final AppColorTheme colors = AppThemeData.light.colorTheme;

      // O stop não é fixo: `danger.s100` separava 2.0 tons da página numa marca
      // e 5.3 na outra. É escolhido medindo contra as duas superfícies.
      expect(_fieldDeco(tester).color, _expectedErrorFill(colors));
    });

    testWidgets('elevated + erro = fundo danger + sombra', (tester) async {
      await tester.pumpWidget(
        _host(const AppInput(style: AppStyle.elevated, hasError: true)),
      );
      final AppColorTheme colors = AppThemeData.light.colorTheme;
      expect(_fieldDeco(tester).color, _expectedErrorFill(colors));
      expect(_fieldDeco(tester).boxShadow, isNotNull);
    });

    testWidgets('outlined + erro = borda (sem fundo danger)', (tester) async {
      await tester.pumpWidget(
        _host(const AppInput(style: AppStyle.outlined, hasError: true)),
      );
      // No outlined o erro aparece na borda (foreground), não no fundo.
      expect(_fieldBorder(tester), isNotNull);
      expect(
        _fieldDeco(tester).color,
        isNot(AppThemeData.light.colorTheme.danger.s100),
      );
    });
  });

  group('eixo AppFieldSize', () {
    testWidgets('altura renderizada do campo = size.height', (tester) async {
      for (final AppFieldSize size in AppFieldSize.values) {
        // Largura fixa (como no uso real) — sem ela o Expanded do campo colapsa
        // a altura. KeyedSubtree por tamanho → subárvore (incl. Overlay) nova a
        // cada iteração (o `Overlay.initialEntries` só é lido na 1ª build).
        await tester.pumpWidget(
          KeyedSubtree(
            key: ValueKey<AppFieldSize>(size),
            child: _host(SizedBox(width: 320, child: AppInput(size: size))),
          ),
        );
        await tester.pumpAndSettle();
        // Sem label/helper, a altura do AppInput = a altura do campo.
        final double h = tester.getSize(find.byType(AppInput)).height;
        expect(h, size.height, reason: 'size $size deveria ter altura fixa');
      }
    });

    testWidgets('altura cresce com o text scale (não corta o texto)', (
      tester,
    ) async {
      Future<double> pumpAt(double scale) async {
        await tester.pumpWidget(
          KeyedSubtree(
            key: ValueKey<double>(scale),
            child: _hostScaled(
              const SizedBox(width: 320, child: AppInput(size: AppFieldSize.m)),
              scale,
            ),
          ),
        );
        await tester.pumpAndSettle();
        return tester.getSize(find.byType(AppInput)).height;
      }

      final double h1 = await pumpAt(1.0);
      final double h2 = await pumpAt(2.0);
      // No scale padrão a altura é exatamente size.height; ao escalar, o campo
      // CRESCE (não clipa o texto).
      expect(h1, AppFieldSize.m.height);
      expect(h2, greaterThan(h1));
    });
  });

  group('interação', () {
    testWidgets('digitar dispara onChanged', (tester) async {
      final List<String> changes = <String>[];
      await tester.pumpWidget(_host(AppInput(onChanged: changes.add)));
      await tester.enterText(find.byType(EditableText), 'oi');
      await tester.pump();
      expect(changes.last, 'oi');
    });

    testWidgets('maxLength limita a entrada', (tester) async {
      await tester.pumpWidget(_host(const AppInput(maxLength: 3)));
      await tester.enterText(find.byType(EditableText), 'abcdef');
      await tester.pump();
      final EditableText et = tester.widget<EditableText>(
        find.byType(EditableText),
      );
      expect(et.controller.text, 'abc');
    });

    testWidgets('disabled continua renderizando o campo', (tester) async {
      await tester.pumpWidget(
        _host(const AppInput(label: 'X', enabled: false)),
      );
      expect(find.byType(EditableText), findsOneWidget);
      expect(find.text('X'), findsOneWidget);
    });
  });

  group('erro preenchido: ✕ limpa', () {
    testWidgets('mostra ✕ e limpa + refoca o campo', (tester) async {
      final controller = TextEditingController(text: 'algo');
      final focusNode = FocusNode();
      final changes = <String>[];
      await tester.pumpWidget(
        _host(
          AppInput(
            controller: controller,
            focusNode: focusNode,
            hasError: true,
            onChanged: changes.add,
          ),
        ),
      );
      final closeFinder = find.byWidgetPredicate(
        (Widget w) => w is AppIcon && w.icon == AppIcons.close,
      );
      expect(closeFinder, findsOneWidget);
      await tester.tap(closeFinder, warnIfMissed: false);
      await tester.pump();
      expect(controller.text, isEmpty);
      expect(changes.last, '');
      expect(focusNode.hasFocus, isTrue);
    });

    testWidgets('sem erro não mostra ✕ mesmo preenchido', (tester) async {
      final controller = TextEditingController(text: 'algo');
      await tester.pumpWidget(_host(AppInput(controller: controller)));
      final bool hasClose = tester
          .widgetList<AppIcon>(find.byType(AppIcon))
          .any((AppIcon w) => w.icon == AppIcons.close);
      expect(hasClose, isFalse);
    });

    testWidgets('erro vazio não mostra ✕', (tester) async {
      await tester.pumpWidget(_host(const AppInput(hasError: true)));
      final bool hasClose = tester
          .widgetList<AppIcon>(find.byType(AppIcon))
          .any((AppIcon w) => w.icon == AppIcons.close);
      expect(hasClose, isFalse);
    });

    testWidgets('onClear vence o foco automático (ex.: picker)', (
      tester,
    ) async {
      final controller = TextEditingController(text: '10/10/2020');
      bool clearedCalled = false;
      await tester.pumpWidget(
        _host(
          AppInput(
            controller: controller,
            hasError: true,
            onClear: () => clearedCalled = true,
          ),
        ),
      );
      final closeFinder = find.byWidgetPredicate(
        (Widget w) => w is AppIcon && w.icon == AppIcons.close,
      );
      await tester.tap(closeFinder, warnIfMissed: false);
      await tester.pump();
      expect(controller.text, isEmpty);
      expect(clearedCalled, isTrue);
    });
  });

  group('info (popover)', () {
    testWidgets('sem info não mostra ícone de info', (tester) async {
      await tester.pumpWidget(_host(const AppInput(label: 'E-mail')));
      final bool hasInfo = tester
          .widgetList<AppIcon>(find.byType(AppIcon))
          .any((AppIcon w) => w.icon == AppIcons.infoCircle);
      expect(hasInfo, isFalse);
    });

    testWidgets('com info: ícone abre popover no clique', (tester) async {
      await tester.pumpWidget(
        _host(
          const AppInput(
            label: 'E-mail',
            info: Text(
              'Usamos só para login',
              textDirection: TextDirection.ltr,
            ),
          ),
        ),
      );
      final infoFinder = find.byWidgetPredicate(
        (Widget w) => w is AppIcon && w.icon == AppIcons.infoCircle,
      );
      expect(infoFinder, findsOneWidget);
      expect(find.text('Usamos só para login'), findsNothing);
      await tester.tap(infoFinder, warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('Usamos só para login'), findsOneWidget);
    });

    Finder infoIcon() => find.byWidgetPredicate(
      (Widget w) => w is AppIcon && w.icon == AppIcons.infoCircle,
    );

    testWidgets('com label: info fica alinhado à direita (borda do campo)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const SizedBox(
            width: 300,
            child: AppInput(
              label: 'E-mail',
              info: Text('Ajuda', textDirection: TextDirection.ltr),
            ),
          ),
        ),
      );
      final Rect fieldRect = tester.getRect(find.byType(AppInput));
      final Rect infoRect = tester.getRect(infoIcon());
      // A borda direita do info encosta na borda direita do campo (não fica
      // grudado no texto do label, que começa à esquerda).
      expect(infoRect.right, closeTo(fieldRect.right, 1.0));
      // E fica bem à direita do meio do campo (prova o alinhamento).
      expect(infoRect.left, greaterThan(fieldRect.center.dx));
    });

    testWidgets(
      'sem label e sem sufixo: info vira o sufixo (mesmo tamanho do sufixo)',
      (tester) async {
        await tester.pumpWidget(
          _host(
            const AppInput(
              hintText: 'Busca',
              size: AppFieldSize.l,
              info: Text('Ajuda', textDirection: TextDirection.ltr),
            ),
          ),
        );
        expect(infoIcon(), findsOneWidget);
        final AppIcon icon = tester.widget<AppIcon>(infoIcon());
        // Casa com o sufixo do campo (AppFieldSize.l → 24).
        expect(icon.customSize, AppFieldSize.l.iconSize);
        await tester.tap(infoIcon(), warnIfMissed: false);
        await tester.pumpAndSettle();
        expect(find.text('Ajuda'), findsOneWidget);
      },
    );

    testWidgets(
      'sem label e com sufixo: info fica ao lado do input (ambos visíveis)',
      (tester) async {
        await tester.pumpWidget(
          _host(
            const AppInput(
              hintText: 'Busca',
              suffixIcon: AppIcons.search,
              info: Text('Ajuda', textDirection: TextDirection.ltr),
            ),
          ),
        );
        // O sufixo (search) e o info coexistem.
        expect(infoIcon(), findsOneWidget);
        expect(
          find.byWidgetPredicate(
            (Widget w) => w is AppIcon && w.icon == AppIcons.search,
          ),
          findsOneWidget,
        );
        await tester.tap(infoIcon(), warnIfMissed: false);
        await tester.pumpAndSettle();
        expect(find.text('Ajuda'), findsOneWidget);
      },
    );
  });

  // A dica é decorativa, e na web um `SelectableRegion` não é só semântica: ele
  // monta um platform view DOM (`Positioned.fill` com `HtmlElementView`), e um
  // elemento do DOM não participa do hit-test do Flutter. O `IgnorePointer` que
  // envolve a dica desaparece para o framework e o div continua de pé para o
  // navegador, oferecendo seleção e menu de contexto por cima da área editável.
  // Medido em flocks.live/demo/?screen=crud em 2026-08-11: `elementsFromPoint`
  // no centro do campo devolvia `div.web-selectable-region-context-menu` no topo.
  //
  // O que este teste NÃO fiscaliza: a busca do CRUD que não filtra. Atribuir o
  // sintoma a este div foi hipótese, e ela foi refutada por medição em
  // 2026-08-12 — o Flutter hit-testa por baixo do div (aplica
  // `SystemMouseCursors.text`), o `input.flt-text-editing` só nasce depois do
  // clique (logo o clique chegou ao Dart), e o sintoma se repete clicando dentro
  // do campo e fora do rect do div. Detalhe em `flocks_demo/TODO.md`.
  //
  // Este grupo roda na VM, onde o platform view não existe (o ramo `_io` do SDK
  // é passa-direto). O que ele fiscaliza é a estrutura que a VM enxerga: se a
  // dica volta a ter um `SelectableRegion` ancestral, reprova aqui.
  group('a dica não vive numa região de seleção', () {
    testWidgets('campo com hintText: nenhum SelectableRegion sobre a dica', (
      tester,
    ) async {
      await tester.pumpWidget(_host(const AppInput(hintText: 'Buscar')));

      expect(find.text('Buscar'), findsOneWidget);
      expect(
        find.ancestor(
          of: find.text('Buscar'),
          matching: find.byType(SelectableRegion),
        ),
        findsNothing,
        reason:
            'a dica ganhou um SelectableRegion de novo: na web isso monta um '
            'platform view DOM sobre a área editável que cancela o mousedown, '
            'e o campo para de receber texto',
      );
    });

    // Controle positivo. Sem ele o teste acima passaria por vacuidade — bastaria
    // o `Overlay` sair do host para nenhum `SelectableRegion` existir em lugar
    // nenhum, e o gate não acusaria nada.
    testWidgets('controle: um AppText solto no mesmo host TEM região', (
      tester,
    ) async {
      await tester.pumpWidget(_host(const AppText('Buscar')));

      expect(
        find.ancestor(
          of: find.text('Buscar'),
          matching: find.byType(SelectableRegion),
        ),
        findsOneWidget,
        reason:
            'o host precisa de Overlay para AppSelectionRegion criar a região; '
            'sem isso o teste da dica não prova nada',
      );
    });
  });

  test('está no catálogo como migrado', () {
    expect(
      flocksCatalog.any(
        (m) => m.id == 'app_input' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
