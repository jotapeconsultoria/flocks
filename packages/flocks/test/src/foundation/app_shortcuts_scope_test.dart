import 'package:flocks/flocks.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Campo de texto cru — o suficiente para o escopo enxergar um `EditableText`
/// em foco, sem arrastar as dependências dos inputs do DS.
class _Field extends StatelessWidget {
  const _Field({required this.controller, required this.focusNode});

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return EditableText(
      controller: controller,
      focusNode: focusNode,
      style: const TextStyle(fontSize: 14, color: Color(0xFF000000)),
      cursorColor: const Color(0xFF000000),
      backgroundCursorColor: const Color(0xFF888888),
    );
  }
}

void main() {
  late List<String> fired;
  late TextEditingController controller;
  late FocusNode fieldFocus;

  setUp(() {
    fired = <String>[];
    controller = TextEditingController();
    fieldFocus = FocusNode();
  });

  tearDown(() {
    controller.dispose();
    fieldFocus.dispose();
  });

  Future<void> pumpScope(WidgetTester tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: AppShortcutsScope(
            onFocusSearch: () => fired.add('search'),
            onFocusAssistant: () => fired.add('assistant'),
            onOpenProfile: () => fired.add('profile'),
            onDismissFocus: () {
              fired.add('dismiss');
              return true;
            },
            onToggleNavigation: () => fired.add('nav'),
            onSelectTab: (index) => fired.add('tab:$index'),
            onFindInPage: () => fired.add('find'),
            child: _Field(controller: controller, focusNode: fieldFocus),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  group('AppShortcutsScope — tecla /', () {
    testWidgets('dispara a busca quando NÃO se está digitando', (tester) async {
      await pumpScope(tester);
      // Nada focado: a barra é atalho.
      expect(AppShortcutsScope.isEditingText(), isFalse);

      await tester.sendKeyEvent(LogicalKeyboardKey.slash);
      await tester.pump();

      expect(fired, ['search']);
    });

    testWidgets('NÃO dispara com um campo de texto em foco', (tester) async {
      await pumpScope(tester);
      fieldFocus.requestFocus();
      await tester.pump();
      expect(AppShortcutsScope.isEditingText(), isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.slash);
      await tester.pump();

      // A barra tem de chegar ao campo como caractere — é o que permite
      // digitar datas e o próprio /comando do chat.
      expect(fired, isEmpty);
    });
  });

  group('AppShortcutsScope — atalhos com modificador', () {
    testWidgets('Ctrl+K foca a busca', (tester) async {
      await pumpScope(tester);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();

      expect(fired, ['search']);
    });

    testWidgets('Ctrl+J foca o assistente', (tester) async {
      await pumpScope(tester);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyJ);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();

      expect(fired, ['assistant']);
    });

    testWidgets('Ctrl+F busca na tela, não no navegador', (tester) async {
      await pumpScope(tester);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyF);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();

      expect(fired, ['find']);
    });

    testWidgets('Ctrl+B alterna a navegação', (tester) async {
      await pumpScope(tester);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyB);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();

      expect(fired, ['nav']);
    });

    testWidgets('Ctrl+Shift+P abre o perfil', (tester) async {
      await pumpScope(tester);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyP);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();

      expect(fired, ['profile']);
    });

    testWidgets('Esc devolve o foco ao conteúdo', (tester) async {
      await pumpScope(tester);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();

      expect(fired, ['dismiss']);
    });

    testWidgets('modificadores funcionam mesmo digitando', (tester) async {
      // Diferente do `/`, Cmd/Ctrl+K não colide com digitação.
      await pumpScope(tester);
      fieldFocus.requestFocus();
      await tester.pump();

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();

      expect(fired, ['search']);
    });
  });

  testWidgets('callback ausente não estoura', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: AppShortcutsScope(child: SizedBox.shrink()),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.slash);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  group('AppShortcutsScope — abas por número', () {
    // Dígito SOZINHO: `Cmd/Ctrl+1..9` é troca de aba do navegador em Chrome,
    // Firefox, Safari e Edge, resolvida antes de a página ver a tecla.
    testWidgets('1..5 escolhem a aba pelo índice base zero', (tester) async {
      await pumpScope(tester);

      const keys = [
        LogicalKeyboardKey.digit1,
        LogicalKeyboardKey.digit2,
        LogicalKeyboardKey.digit3,
        LogicalKeyboardKey.digit4,
        LogicalKeyboardKey.digit5,
      ];
      for (final key in keys) {
        await tester.sendKeyEvent(key);
        await tester.pump();
      }

      expect(fired, ['tab:0', 'tab:1', 'tab:2', 'tab:3', 'tab:4']);
    });

    testWidgets('o teclado numérico funciona igual', (tester) async {
      // Quem usa teclado cheio espera que o numpad valha o mesmo.
      await pumpScope(tester);

      await tester.sendKeyEvent(LogicalKeyboardKey.numpad3);
      await tester.pump();

      expect(fired, ['tab:2']);
    });

    testWidgets('6 não faz nada', (tester) async {
      // O alcance para em 5 — o mesmo teto de abas.
      await pumpScope(tester);

      await tester.sendKeyEvent(LogicalKeyboardKey.digit6);
      await tester.pump();

      expect(fired, isEmpty);
    });

    testWidgets('DIGITAR número num campo não troca de aba', (tester) async {
      // O ponto crítico do dígito sozinho: dentro de um campo ele é conteúdo.
      await pumpScope(tester);
      fieldFocus.requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
      await tester.pump();

      expect(fired, isEmpty);
    });

    testWidgets('com modificador não troca de aba', (tester) async {
      // Cmd/Ctrl+1 pertence ao navegador; não duplicamos o comportamento.
      await pumpScope(tester);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();

      expect(fired, isEmpty);
    });
  });
}
