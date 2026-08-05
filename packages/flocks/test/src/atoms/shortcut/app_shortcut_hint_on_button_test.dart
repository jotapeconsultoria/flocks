import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Cor efetiva do texto do selo dentro de [button].
Color _hintColor(WidgetTester tester) {
  final Text keyLabel = tester.widget<Text>(
    find.descendant(
      of: find.byType(AppShortcutHint),
      matching: find.text('Enter'),
    ),
  );
  return keyLabel.style!.color!;
}

void main() {
  for (final (String name, AppThemeData theme) in <(String, AppThemeData)>[
    ('claro', AppThemeData.light),
    ('escuro', AppThemeData.dark),
  ]) {
    testWidgets('selo dentro de botão preenchido tem contraste ($name)', (
      tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AppTheme(
            data: theme,
            child: Center(
              child: AppButton(
                label: 'Salvar',
                trailing: const AppShortcutHint(AppShortcut('Enter')),
                onPressed: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // O selo herda o FOREGROUND do botão. Sozinho ele escolheria a cor por
      // contraste contra a superfície do TEMA — e sobre o preenchimento
      // primário isso o fazia sumir (revisão P1r9).
      final Text label = tester.widget<Text>(
        find.descendant(
          of: find.byType(AppButton),
          matching: find.text('Salvar'),
        ),
      );
      expect(
        _hintColor(tester),
        label.style!.color,
        reason: 'o selo usa a mesma cor do rótulo do botão',
      );
      // O contraste do foreground contra o preenchimento é contrato do
      // próprio botão (e já tem teste): aqui basta garantir que o selo NÃO
      // escolhe uma cor por conta própria.
    });
  }

  testWidgets('fora de um botão, o selo mantém o stop do tema', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: AppTheme(
          data: AppThemeData.light,
          child: const Center(child: AppShortcutHint(AppShortcut('Enter'))),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      contrastRatio(
        _hintColor(tester),
        AppThemeData.light.colorTheme.surfaceContainer,
      ),
      greaterThanOrEqualTo(kAaNormal),
    );
  });
}
