import 'package:flocks/flocks.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Regra 8 no pior caso do gate: uma GRADE de células desenhadas. O dia "15"
// chega ao leitor como o texto "15" — sem dizer que é acionável, de que mês é,
// se está escolhido ou se está fora do intervalo permitido.

final DateTime _today = DateTime(2026, 7, 15);

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: AppThemeData.forBrand(jotapeBrand, dark: false),
      child: Center(child: child),
    ),
  ),
);

/// Todos os nós de célula (os que têm estado de seleção), por rótulo.
Map<String, SemanticsData> _cells(WidgetTester tester) {
  final Map<String, SemanticsData> out = <String, SemanticsData>{};
  void visit(SemanticsNode node) {
    final SemanticsData d = node.getSemanticsData();
    if (d.flagsCollection.isSelected.toBoolOrNull() != null &&
        d.label.contains(' de ')) {
      out[d.label] = d;
    }
    node.visitChildren((SemanticsNode child) {
      visit(child);
      return true;
    });
  }

  visit(tester.binding.rootElement!.renderObject!.debugSemantics!);
  return out;
}

void main() {
  testWidgets('cada dia é um alvo rotulado com a data por extenso', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        AppDatePicker(
          initialDate: _today,
          today: _today,
          onDateSelected: (DateTime _) {},
        ),
      ),
    );

    final Map<String, SemanticsData> cells = _cells(tester);
    // Julho tem 31 dias — a grade inteira precisa estar na árvore.
    expect(cells.length, 31);
    expect(cells.containsKey('15 de julho de 2026'), isTrue);
    expect(cells['15 de julho de 2026']!.flagsCollection.isButton, isTrue);
    handle.dispose();
  });

  testWidgets('o dia escolhido anuncia seleção, e só ele', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        AppDatePicker(
          initialDate: _today,
          today: _today,
          onDateSelected: (DateTime _) {},
        ),
      ),
    );

    final Iterable<String> selected = _cells(tester).entries
        .where(
          (MapEntry<String, SemanticsData> e) =>
              e.value.flagsCollection.isSelected.toBoolOrNull() ?? false,
        )
        .map((MapEntry<String, SemanticsData> e) => e.key);

    expect(selected, <String>['15 de julho de 2026']);
    handle.dispose();
  });

  testWidgets('dia fora do intervalo continua LEGÍVEL, só não acionável', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        AppDatePicker(
          initialDate: _today,
          today: _today,
          firstDate: DateTime(2026, 7, 10),
          onDateSelected: (DateTime _) {},
        ),
      ),
    );

    final Map<String, SemanticsData> cells = _cells(tester);
    // Sumir com a célula faria o leitor pular o dia, e o usuário concluiria
    // que o mês tem menos dias — em vez de entender que aquele está bloqueado.
    expect(cells.length, 31);
    final SemanticsData blocked = cells['5 de julho de 2026']!;
    expect(blocked.flagsCollection.isEnabled.toBoolOrNull(), isFalse);
    expect(
      cells['20 de julho de 2026']!.flagsCollection.isEnabled.toBoolOrNull(),
      isTrue,
    );
    handle.dispose();
  });

  testWidgets(
    'no intervalo, só as EXTREMIDADES são anunciadas como escolhidas',
    (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(
          AppDateRangePicker(
            today: _today,
            initialRange: AppDateRange(
              DateTime(2026, 7, 8),
              DateTime(2026, 7, 21),
            ),
            onRangeSelected: (AppDateRange _) {},
          ),
        ),
      );

      final Iterable<String> selected = _cells(tester).entries
          .where(
            (MapEntry<String, SemanticsData> e) =>
                e.value.flagsCollection.isSelected.toBoolOrNull() ?? false,
          )
          .map((MapEntry<String, SemanticsData> e) => e.key);

      // 14 dias cobertos pela banda, 2 escolhidos: marcar os 14 faria o leitor
      // anunciar "selecionado" catorze vezes seguidas.
      expect(selected.toSet(), <String>{
        '8 de julho de 2026',
        '21 de julho de 2026',
      });
      handle.dispose();
    },
  );
}
