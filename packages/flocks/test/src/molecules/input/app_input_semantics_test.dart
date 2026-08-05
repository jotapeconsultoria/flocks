import 'package:flocks/flocks.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Regra 8 — o campo de texto do design system tem NOME, e o erro é anunciado.
///
/// O `AppInput` publicava quatro nós irmãos soltos: rótulo, dica e erro como
/// texto avulso, e o `EditableText` — o único marcado como `textField` — **sem
/// rótulo nenhum**. Quem chegava ao campo por leitor de tela ouvia "campo de
/// texto" e mais nada. É o componente de maior tráfego do pacote.
Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: AppThemeData.light,
      child: Center(child: SizedBox(width: 300, child: child)),
    ),
  ),
);

/// Percorre a árvore de semântica juntando os nós que satisfazem [test].
List<SemanticsData> _collect(
  WidgetTester tester,
  bool Function(SemanticsData) test,
) {
  final List<SemanticsData> out = <SemanticsData>[];
  void walk(SemanticsNode n) {
    final SemanticsData d = n.getSemanticsData();
    if (test(d)) out.add(d);
    n.visitChildren((SemanticsNode c) {
      walk(c);
      return true;
    });
  }

  walk(tester.binding.rootElement!.renderObject!.debugSemantics!);
  return out;
}

void main() {
  testWidgets('o campo carrega o rótulo, não só o EditableText mudo', (
    tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(const AppInput(label: 'E-mail', hintText: 'nome@empresa.com')),
    );

    final List<SemanticsData> named = _collect(
      tester,
      (SemanticsData d) => d.flagsCollection.isTextField && d.label.isNotEmpty,
    );
    expect(
      named,
      hasLength(1),
      reason: 'exatamente um nó textField nomeado — nem zero, nem duplicado',
    );
    expect(named.single.label, 'E-mail');
    expect(named.single.hint, 'nome@empresa.com');

    handle.dispose();
  });

  testWidgets('a dica não é anunciada duas vezes', (tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(const AppInput(label: 'E-mail', hintText: 'nome@empresa.com')),
    );

    // O placeholder desenhado dentro do campo é o MESMO texto que já viaja em
    // `hint:`. Deixá-lo na árvore fazia o usuário ouvir o placeholder duas
    // vezes — e, pior, ele era absorvido pelo rótulo do container.
    final List<SemanticsData> hintNodes = _collect(
      tester,
      (SemanticsData d) => d.label == 'nome@empresa.com',
    );
    expect(hintNodes, isEmpty);

    handle.dispose();
  });

  testWidgets('o rótulo visual não é lido em dobro', (tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(_host(const AppInput(label: 'E-mail')));

    // Um nó só com "E-mail": o do campo. O rótulo desenhado acima sai da
    // árvore — a mesma duplicação que fez o AppButton anunciar "Salvar Salvar".
    final List<SemanticsData> withLabel = _collect(
      tester,
      (SemanticsData d) => d.label == 'E-mail',
    );
    expect(withLabel, hasLength(1));
    expect(withLabel.single.flagsCollection.isTextField, isTrue);

    handle.dispose();
  });

  testWidgets('o erro é live region; o texto de apoio não', (tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();

    await tester.pumpWidget(
      _host(
        const AppInput(label: 'E-mail', helperText: 'Nunca compartilhamos'),
      ),
    );
    expect(
      _collect(tester, (SemanticsData d) => d.flagsCollection.isLiveRegion),
      isEmpty,
      reason: 'texto de apoio é estático — interromper a leitura seria ruído',
    );

    // A mensagem de erro aparece DEPOIS que o usuário agiu (validação no blur,
    // resposta do servidor), num ponto que o foco não visita. Sem live region
    // ela entra na tela em silêncio.
    await tester.pumpWidget(
      _host(const AppInput(label: 'E-mail', errorText: 'E-mail inválido')),
    );
    final List<SemanticsData> live = _collect(
      tester,
      (SemanticsData d) => d.flagsCollection.isLiveRegion,
    );
    expect(live, hasLength(1));
    expect(live.single.label, 'E-mail inválido');

    handle.dispose();
  });

  testWidgets('desabilitado e obscurecido chegam ao leitor', (tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(const AppInput(label: 'Senha', obscureText: true, enabled: false)),
    );

    final SemanticsData field = _collect(
      tester,
      (SemanticsData d) => d.flagsCollection.isTextField && d.label.isNotEmpty,
    ).single;
    expect(field.flagsCollection.isObscured, isTrue);
    // `isEnabled` é TRI-state: "desabilitado" e "não informado" são coisas
    // diferentes, e comparar direto com `isFalse` casa contra o enum, não
    // contra o booleano.
    expect(field.flagsCollection.isEnabled.toBoolOrNull(), isFalse);

    handle.dispose();
  });
}
