import 'package:flocks/flocks.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Regra 8 nos quatro dropdowns: o gatilho é um controle EXPANSÍVEL. Sem
// `expanded` o leitor de tela anuncia "botão" e some a única pista de que há um
// painel do outro lado do toque — e de que ele está aberto agora.

const List<AppDropdownOption<String>> _opts = <AppDropdownOption<String>>[
  AppDropdownOption<String>(value: 'a', label: 'Banana'),
  AppDropdownOption<String>(value: 'b', label: 'Manga'),
];

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: AppThemeData.forBrand(jotapeBrand, dark: false),
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(
            builder: (_) => Center(child: SizedBox(width: 320, child: child)),
          ),
        ],
      ),
    ),
  ),
);

/// O nó do GATILHO — o único da árvore com estado de expansão.
///
/// Buscar por rótulo não serve: o `label` do campo é desenhado ACIMA do
/// trigger e vira um nó de texto próprio, que vem antes na ordem de leitura.
SemanticsNode _trigger(WidgetTester tester) {
  SemanticsNode? found;
  void visit(SemanticsNode node) {
    // Tri-estado: `null` = o nó não fala de expansão.
    if (node.getSemanticsData().flagsCollection.isExpanded.toBoolOrNull() !=
        null) {
      found ??= node;
      return;
    }
    node.visitChildren((SemanticsNode child) {
      visit(child);
      return true;
    });
  }

  visit(tester.binding.rootElement!.renderObject!.debugSemantics!);
  expect(found, isNotNull, reason: 'nenhum nó com hasExpandedState');
  return found!;
}

void main() {
  testWidgets('AppDropdown: fechado anuncia expanded=false e o valor', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        AppDropdown<String>(
          label: 'Fruta',
          options: _opts,
          selectedValue: 'a',
          onChanged: (_) {},
        ),
      ),
    );

    expect(
      _trigger(tester),
      matchesSemantics(
        label: 'Fruta',
        value: 'Banana',
        isButton: true,
        hasExpandedState: true,
        isExpanded: false,
        hasEnabledState: true,
        isEnabled: true,
        isFocusable: true,
        hasTapAction: true,
        hasFocusAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('AppDropdown: abrir vira expanded=true', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        AppDropdown<String>(
          label: 'Fruta',
          hintText: 'Selecione',
          options: _opts,
          onChanged: (_) {},
        ),
      ),
    );

    await tester.tap(find.text('Selecione'));
    await tester.pumpAndSettle();

    expect(
      _trigger(
        tester,
      ).getSemanticsData().flagsCollection.isExpanded.toBoolOrNull(),
      isTrue,
    );
    handle.dispose();
  });

  testWidgets('AppMultiSelect anuncia OS RÓTULOS marcados, não a contagem', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        AppMultiSelect<String>(
          label: 'Fruta',
          options: _opts,
          selectedValues: const <String>['a', 'b'],
          onChanged: (_) {},
        ),
      ),
    );

    // "2 selecionados" obrigaria a abrir o painel para saber quais.
    expect(_trigger(tester).getSemanticsData().value, 'Banana, Manga');
    handle.dispose();
  });

  testWidgets('sem seleção não inventa valor', (WidgetTester tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        AppMultiSelect<String>(
          label: 'Fruta',
          options: _opts,
          selectedValues: const <String>[],
          onChanged: (_) {},
        ),
      ),
    );

    expect(_trigger(tester).getSemanticsData().value, isEmpty);
    handle.dispose();
  });

  testWidgets('desabilitado anuncia o estado (não some)', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        AppDropdown<String>(
          label: 'Fruta',
          options: _opts,
          enabled: false,
          onChanged: (_) {},
        ),
      ),
    );

    expect(
      _trigger(tester),
      matchesSemantics(
        label: 'Fruta',
        isButton: true,
        hasExpandedState: true,
        isExpanded: false,
        hasEnabledState: true,
        isEnabled: false,
      ),
    );
    handle.dispose();
  });
}
