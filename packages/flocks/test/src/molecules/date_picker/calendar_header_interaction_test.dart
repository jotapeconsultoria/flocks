import 'package:flocks/flocks.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Regra 1 + Regra 8 — o que o header do calendário GANHOU ao trocar três
/// `bool` de hover paralelos por [FlocksInteraction].
///
/// Antes: `MouseRegion` + `GestureDetector` × 3. Só mouse. Os chevrons e o
/// rótulo de mês/ano não eram alcançáveis por Tab, não respondiam a
/// Enter/Space e chegavam mudos ao leitor de tela.
Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: AppThemeData.light,
      child: Center(child: child),
    ),
  ),
);

Widget _picker({required void Function(DateTime) onDateSelected}) => SizedBox(
  width: 320,
  child: AppDatePicker(
    initialDate: DateTime(2027, 9, 10),
    today: DateTime(2027, 9, 23),
    firstDate: DateTime(2020),
    lastDate: DateTime(2030),
    onDateSelected: onDateSelected,
  ),
);

void main() {
  testWidgets('os três alvos do header são focáveis', (tester) async {
    await tester.pumpWidget(_host(_picker(onDateSelected: (_) {})));

    // ‹ , rótulo de mês/ano, › — cada um com nó de foco próprio, que é o que
    // o `MouseRegion` + `GestureDetector` anterior nunca teve.
    final Iterable<FlocksInteraction> targets = tester
        .widgetList<FlocksInteraction>(find.byType(FlocksInteraction));
    expect(targets.length, 3);

    final Iterable<FocusNode> nodes = tester
        .widgetList<Focus>(find.byType(Focus))
        .map((Focus f) => f.focusNode)
        .whereType<FocusNode>()
        .where((FocusNode n) => n.canRequestFocus);
    expect(nodes.length, greaterThanOrEqualTo(3));
  });

  testWidgets('o chevron navega o mês por Enter, não só por clique', (
    tester,
  ) async {
    await tester.pumpWidget(_host(_picker(onDateSelected: (_) {})));
    expect(find.text('SETEMBRO, 2027'), findsOneWidget);

    // Foca o primeiro alvo do header (o chevron "mês anterior") e ativa pelo
    // teclado. Sem `WidgetsApp` no host não há política de traversal, então o
    // foco é pedido direto — o que se afirma aqui é a ATIVAÇÃO por Enter, que
    // é o que o primitivo trouxe.
    final FocusNode chevron = tester
        .widgetList<Focus>(find.byType(Focus))
        .map((Focus f) => f.focusNode)
        .whereType<FocusNode>()
        .firstWhere((FocusNode n) => n.canRequestFocus);
    chevron.requestFocus();
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(
      find.text('AGOSTO, 2027'),
      findsOneWidget,
      reason: 'Enter no chevron focado tem de voltar um mês',
    );
  });

  testWidgets('o header não chega mudo ao leitor de tela', (tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(_host(_picker(onDateSelected: (_) {})));

    // Os chevrons são só-ícone: sem rótulo explícito o leitor anuncia um botão
    // sem nome, e "voltar um mês" não se descobre tateando.
    expect(find.bySemanticsLabel('Mês anterior'), findsOneWidget);
    expect(find.bySemanticsLabel('Próximo mês'), findsOneWidget);

    handle.dispose();
  });
}
