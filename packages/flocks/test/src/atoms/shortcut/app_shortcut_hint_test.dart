import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, List<AppShortcut> shortcuts) async {
  await tester.pumpWidget(
    AppTheme(
      data: AppThemeData.light,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final (int index, AppShortcut shortcut) in shortcuts.indexed)
              AppShortcutHint(shortcut, key: ValueKey(index)),
          ],
        ),
      ),
    ),
  );
}

void main() {
  group('AppShortcutHint — tamanho', () {
    testWidgets('teclas estreitas e largas ocupam a mesma caixa', (
      tester,
    ) async {
      // `1` é bem mais estreito que `3` na fonte: sem um piso, cada aba
      // mostraria um selo de largura diferente.
      await _pump(tester, const [
        AppShortcut('1'),
        AppShortcut('3'),
        AppShortcut('5'),
      ]);

      final sizes = [
        for (int index = 0; index < 3; index++)
          tester.getSize(find.byKey(ValueKey(index))),
      ];

      expect(sizes[1], sizes[0]);
      expect(sizes[2], sizes[0]);
    });

    testWidgets('altura não muda com o número de teclas', (tester) async {
      await _pump(tester, const [
        AppShortcut('K'),
        AppShortcut.primary('K'),
        AppShortcut.primary('P', shift: true),
      ]);

      final heights = {
        for (int index = 0; index < 3; index++)
          tester.getSize(find.byKey(ValueKey(index))).height,
      };

      // O `⌘` sobe mais que uma letra; a caixa não pode acompanhar.
      expect(heights.length, 1);
    });

    testWidgets('um atalho com modificador é mais largo que a tecla sozinha', (
      tester,
    ) async {
      await _pump(tester, const [AppShortcut('K')]);
      final soloWidth = tester.getSize(find.byType(AppShortcutHint)).width;

      await _pump(tester, const [AppShortcut.primary('K')]);
      final comboWidth = tester.getSize(find.byType(AppShortcutHint)).width;

      expect(comboWidth, greaterThan(soloWidth));
    });
  });

  group('AppShortcutHint — conteúdo', () {
    testWidgets('cada tecla é um texto próprio, com respiro entre elas', (
      tester,
    ) async {
      await _pump(tester, const [AppShortcut.primary('K')]);

      // Duas teclas separadas, não uma string colada: é o que abre o espaço
      // entre o modificador e a letra.
      expect(find.text('K'), findsOneWidget);
      expect(find.textContaining('K'), findsOneWidget);

      final modifier = tester.getRect(find.byType(AppText).first);
      final key = tester.getRect(find.byType(AppText).last);
      expect(key.left, greaterThan(modifier.right));
    });

    testWidgets('anuncia o atalho por extenso para leitor de tela', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await _pump(tester, const [AppShortcut.primary('K')]);

      expect(find.bySemanticsLabel(RegExp('Atalho:')), findsOneWidget);
      handle.dispose();
    });
  });
}
