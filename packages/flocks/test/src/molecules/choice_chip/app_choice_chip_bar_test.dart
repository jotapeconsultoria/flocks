import 'package:flocks/flocks.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child, {double width = 300}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(disableAnimations: true),
    child: AppTheme(
      data: AppThemeData.light,
      child: Center(
        child: SizedBox(width: width, child: child),
      ),
    ),
  ),
);

const List<AppChoiceChipOption<String>> _six = <AppChoiceChipOption<String>>[
  AppChoiceChipOption(value: 'all', label: 'Todas'),
  AppChoiceChipOption(value: 'queue', label: 'Novas/abertas', count: 8),
  AppChoiceChipOption(value: 'mine', label: 'Minhas', count: 2),
  AppChoiceChipOption(value: 'waiting', label: 'Aguardando cliente'),
  AppChoiceChipOption(value: 'done', label: 'Resolvidas', count: 41),
  AppChoiceChipOption(value: 'archived', label: 'Arquivadas'),
];

void main() {
  testWidgets('6 opções em 300px ROLAM sem overflow — o caso do segmented', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        AppChoiceChipBar<String>(
          value: 'queue',
          onChanged: (_) {},
          options: _six,
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(AppScrollEdgeFade), findsOneWidget);
  });

  testWidgets('wrap troca a rolagem por Wrap', (tester) async {
    await tester.pumpWidget(
      _host(
        AppChoiceChipBar<String>(
          value: 'queue',
          onChanged: (_) {},
          options: _six,
          layout: AppChoiceChipLayout.wrap,
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsNothing);
    expect(find.byType(Wrap), findsOneWidget);
  });

  testWidgets('seleção única: tocar chama onChanged UMA vez com o valor', (
    tester,
  ) async {
    final List<String> received = <String>[];
    await tester.pumpWidget(
      _host(
        AppChoiceChipBar<String>(
          value: 'all',
          onChanged: received.add,
          options: _six,
        ),
      ),
    );
    await tester.tap(find.text('Minhas'));
    await tester.pump();
    expect(received, <String>['mine']);

    // Só o `value` do rebuild controla a seleção — um chip só selecionado.
    await tester.pumpWidget(
      _host(
        AppChoiceChipBar<String>(
          value: 'mine',
          onChanged: received.add,
          options: _six,
        ),
      ),
    );
    final Iterable<AppChoiceChip> chips = tester.widgetList<AppChoiceChip>(
      find.byType(AppChoiceChip),
    );
    expect(chips.where((AppChoiceChip c) => c.selected).length, 1);
    expect(chips.firstWhere((AppChoiceChip c) => c.selected).label, 'Minhas');
  });

  testWidgets('multi devolve Set NOVO, sem mutar o recebido', (tester) async {
    final Set<String> original = <String>{'queue'};
    Set<String>? received;
    await tester.pumpWidget(
      _host(
        AppChoiceChipBar<String>.multi(
          values: original,
          onChanged: (Set<String> next) => received = next,
          options: _six,
          layout: AppChoiceChipLayout.wrap,
        ),
        width: 600,
      ),
    );

    await tester.tap(find.text('Minhas'));
    await tester.pump();
    expect(received, <String>{'queue', 'mine'});
    expect(identical(received, original), isFalse);
    expect(original, <String>{'queue'}, reason: 'o Set do dono ficou intacto');

    // Tocar num já escolhido devolve um conjunto SEM ele.
    await tester.tap(find.text('Novas/abertas'));
    await tester.pump();
    expect(received, isNot(contains('queue')));
    expect(original, <String>{'queue'});
  });

  testWidgets('multi: os chips perdem o grupo exclusivo', (tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        AppChoiceChipBar<String>.multi(
          values: const <String>{'queue'},
          onChanged: (_) {},
          options: _six,
          layout: AppChoiceChipLayout.wrap,
        ),
        width: 600,
      ),
    );
    expect(
      tester.getSemantics(find.bySemanticsLabel('Todas')),
      isSemantics(
        label: 'Todas',
        hasCheckedState: true,
        isChecked: false,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('semanticLabel nomeia o GRUPO', (tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        AppChoiceChipBar<String>(
          value: 'queue',
          onChanged: (_) {},
          options: _six,
          semanticLabel: 'Filtrar por status',
        ),
      ),
    );
    expect(find.bySemanticsLabel('Filtrar por status'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('→ move o foco para o chip seguinte e o rola até aparecer', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        AppChoiceChipBar<String>(
          value: 'all',
          onChanged: (_) {},
          options: _six,
        ),
      ),
    );
    // Foca o primeiro chip pelo contexto de um descendente.
    Focus.of(tester.element(find.text('Todas'))).requestFocus();
    await tester.pumpAndSettle();

    final ScrollableState scrollable = tester.state<ScrollableState>(
      find.byType(Scrollable).first,
    );
    final double before = scrollable.position.pixels;

    // Anda até um chip fora da viewport: o ensureVisible precisa rolar.
    for (int i = 0; i < 4; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
    }
    expect(scrollable.position.pixels, greaterThan(before));
  });

  testWidgets('enabled false desliga a barra inteira', (tester) async {
    final List<String> received = <String>[];
    await tester.pumpWidget(
      _host(
        AppChoiceChipBar<String>(
          value: 'all',
          onChanged: received.add,
          options: _six,
          enabled: false,
        ),
      ),
    );
    await tester.tap(find.text('Todas'), warnIfMissed: false);
    await tester.pump();
    expect(received, isEmpty);
  });
}
