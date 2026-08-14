import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Host modal: Navigator real (o helper dá push numa PopupRoute) + reduce-motion
// para os pumps não dependerem de tween — molde do app_dialog_test.dart.
Widget _app(WidgetBuilder home) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(disableAnimations: true),
    child: AppTheme(
      data: AppThemeData.light.copyWith(
        glassTheme: const AppGlassTheme(enabled: false),
      ),
      child: Navigator(
        onGenerateRoute: (_) => PageRouteBuilder<void>(
          pageBuilder: (BuildContext context, _, _) =>
              Center(child: home(context)),
        ),
      ),
    ),
  ),
);

// Abre o confirm num toque e guarda o resultado quando o Future resolver.
Widget _trigger(
  ValueSetter<bool> onResult, {
  String title = 'Excluir empresa?',
  String? message = 'Não dá para desfazer.',
  Widget? content,
  String confirmLabel = 'Confirmar',
  String cancelLabel = 'Cancelar',
  bool destructive = false,
  AppButtonColor? confirmColor,
  bool barrierDismissible = true,
  BoxConstraints? constraints,
}) => Builder(
  builder: (BuildContext context) => GestureDetector(
    onTap: () async {
      final bool ok = await showAppConfirm(
        context: context,
        title: title,
        message: message,
        content: content,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        destructive: destructive,
        confirmColor: confirmColor,
        barrierDismissible: barrierDismissible,
        constraints: constraints,
      );
      onResult(ok);
    },
    // `Text` e não `AppText`: o texto do DS é selecionável e o reconhecedor
    // de seleção ganha a arena, engolindo o toque.
    child: const Text('Abrir'),
  ),
);

AppButton _buttonWithLabel(WidgetTester tester, String label) => tester
    .widgetList<AppButton>(find.byType(AppButton))
    .firstWhere((AppButton b) => b.label == label);

void main() {
  testWidgets('confirmar resolve true', (tester) async {
    bool? result;
    await tester.pumpWidget(_app((_) => _trigger((bool ok) => result = ok)));
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
  });

  testWidgets('cancelar resolve false', (tester) async {
    bool? result;
    await tester.pumpWidget(_app((_) => _trigger((bool ok) => result = ok)));
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(result, isFalse);
  });

  testWidgets('barrier resolve false — não null', (tester) async {
    bool? result;
    await tester.pumpWidget(_app((_) => _trigger((bool ok) => result = ok)));
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(result, isFalse);
  });

  testWidgets('o "X" da barra resolve false', (tester) async {
    bool? result;
    await tester.pumpWidget(_app((_) => _trigger((bool ok) => result = ok)));
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    // O barrier da rota TAMBÉM se chama "Fechar" — daí o escopo no card.
    await tester.tap(
      find.descendant(
        of: find.byType(AppDialog),
        matching: find.bySemanticsLabel('Fechar'),
      ),
    );
    await tester.pumpAndSettle();
    expect(result, isFalse);
  });

  testWidgets('barrierDismissible false: o barrier não fecha', (tester) async {
    bool? result;
    await tester.pumpWidget(
      _app(
        (_) => _trigger((bool ok) => result = ok, barrierDismissible: false),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(find.text('Confirmar'), findsOneWidget, reason: 'segue aberto');
    expect(result, isNull, reason: 'o Future segue pendente');
  });

  testWidgets('dois toques no mesmo botão dão UM pop', (tester) async {
    int resolved = 0;
    await tester.pumpWidget(_app((_) => _trigger((_) => resolved++)));
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    // Sem pump entre os toques: o segundo chega antes de a rota sair da
    // árvore. A guarda `appRouteIsTopmost` o transforma em no-op.
    await tester.tap(find.text('Confirmar'));
    await tester.tap(find.text('Confirmar'), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(resolved, 1);
    // A rota de baixo continua montada — o segundo pop não a derrubou.
    expect(find.text('Abrir'), findsOneWidget);
  });

  testWidgets('destructive pinta o confirmar de danger', (tester) async {
    await tester.pumpWidget(
      _app((_) => _trigger((_) {}, destructive: true, confirmLabel: 'Excluir')),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    expect(_buttonWithLabel(tester, 'Excluir').color, AppButtonColor.danger);
    final AppButton cancel = _buttonWithLabel(tester, 'Cancelar');
    expect(cancel.color, AppButtonColor.neutral);
    expect(cancel.style, AppStyle.outlined);
  });

  testWidgets('confirmColor vence destructive', (tester) async {
    await tester.pumpWidget(
      _app(
        (_) => _trigger(
          (_) {},
          destructive: true,
          confirmColor: AppButtonColor.secondary,
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    expect(
      _buttonWithLabel(tester, 'Confirmar').color,
      AppButtonColor.secondary,
    );
  });

  testWidgets('sem destructive e sem confirmColor o primário é primary', (
    tester,
  ) async {
    await tester.pumpWidget(_app((_) => _trigger((_) {})));
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    expect(_buttonWithLabel(tester, 'Confirmar').color, AppButtonColor.primary);
  });

  testWidgets('labels customizados chegam aos botões', (tester) async {
    await tester.pumpWidget(
      _app(
        (_) => _trigger(
          (_) {},
          confirmLabel: 'Apagar tudo',
          cancelLabel: 'Deixa pra lá',
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    expect(find.text('Apagar tudo'), findsOneWidget);
    expect(find.text('Deixa pra lá'), findsOneWidget);
  });

  testWidgets('message e content juntos (ou nenhum) é AssertionError', (
    tester,
  ) async {
    await tester.pumpWidget(_app((_) => const Text('host')));
    final BuildContext context = tester.element(find.text('host'));

    await expectLater(
      showAppConfirm(
        context: context,
        title: 'T',
        message: 'm',
        content: const Text('c'),
      ),
      throwsAssertionError,
    );
    await expectLater(
      showAppConfirm(context: context, title: 'T'),
      throwsAssertionError,
    );
  });

  testWidgets('content monta corpo próprio, sem AppDialogContent', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        (_) => _trigger(
          (_) {},
          message: null,
          content: const Text('CorpoProprio'),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    expect(find.text('CorpoProprio'), findsOneWidget);
    expect(find.byType(AppDialogContent), findsNothing);
  });

  testWidgets('viewport 360x640: sem overflow com o default de largura', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _app(
        (_) => _trigger(
          (_) {},
          message: 'Os usuários dela perdem o acesso. Não dá para desfazer.',
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    expect(find.byType(AppDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('constraints explícito vence o default de 480', (tester) async {
    await tester.pumpWidget(
      _app(
        (_) =>
            _trigger((_) {}, constraints: const BoxConstraints(maxWidth: 320)),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byType(AppDialog)).width,
      lessThanOrEqualTo(320),
    );
  });

  testWidgets('reduce-motion: o confirm aparece num pump só', (tester) async {
    await tester.pumpWidget(_app((_) => _trigger((_) {})));
    await tester.tap(find.text('Abrir'));
    await tester.pump();

    // Herdado da _AppDialogRoute: sem tween novo montado pelo helper.
    expect(find.text('Confirmar'), findsOneWidget);
  });
}
