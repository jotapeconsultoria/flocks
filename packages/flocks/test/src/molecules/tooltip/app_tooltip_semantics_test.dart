import 'package:flocks/flocks.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Regra 8 — a dica existe fora do pixel.
///
/// O balão do `AppTooltip` é pintado num `OverlayEntry`, fora da árvore do
/// gatilho: nada dele chegava à camada de acessibilidade. Num controle
/// só-ícone a dica É o nome dele — o item do rail colapsado, a alça de
/// redimensionar —, então o leitor de tela anunciava um alvo sem nome, e a
/// única informação que o distinguia dos vizinhos era visível só no hover.
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

List<SemanticsData> _nodes(WidgetTester tester) {
  final List<SemanticsData> out = <SemanticsData>[];
  void walk(SemanticsNode n) {
    out.add(n.getSemanticsData());
    n.visitChildren((SemanticsNode c) {
      walk(c);
      return true;
    });
  }

  walk(tester.binding.rootElement!.renderObject!.debugSemantics!);
  return out;
}

void main() {
  testWidgets('a mensagem chega ao leitor de tela sem hover', (tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        const AppTooltip(
          message: 'Redimensionar',
          child: SizedBox.square(dimension: 24),
        ),
      ),
    );

    // Sem tocar o ponteiro: a dica tem de estar na árvore desde o começo.
    expect(
      _nodes(tester).where((SemanticsData d) => d.tooltip == 'Redimensionar'),
      hasLength(1),
    );

    handle.dispose();
  });

  testWidgets('a dica NÃO vira o rótulo — ela acompanha o que já existe', (
    tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        AppTooltip(
          message: 'Salva sem fechar o formulário',
          child: AppButton(label: 'Salvar', onPressed: () {}),
        ),
      ),
    );

    // O botão continua se chamando "Salvar"; a dica é informação ADICIONAL.
    // Se a dica substituísse o rótulo, o usuário perderia o nome da ação.
    final SemanticsData button = _nodes(
      tester,
    ).firstWhere((SemanticsData d) => d.label == 'Salvar');
    expect(button.flagsCollection.isButton, isTrue);
    expect(
      _nodes(tester).where(
        (SemanticsData d) => d.tooltip == 'Salva sem fechar o formulário',
      ),
      hasLength(1),
    );

    handle.dispose();
  });

  testWidgets('desabilitado, a dica some da árvore', (tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        const AppTooltip(
          message: 'Redimensionar',
          enabled: false,
          child: SizedBox.square(dimension: 24),
        ),
      ),
    );

    // Balão desligado não pode continuar anunciando: o leitor descreveria um
    // comportamento que a tela não tem.
    expect(
      _nodes(tester).where((SemanticsData d) => d.tooltip.isNotEmpty),
      isEmpty,
    );

    handle.dispose();
  });
}
