// Um adaptador precisa cobrir o contrato inteiro, senão não é adaptador.
import 'package:flocks/flocks.dart';
import 'package:flocks_cupertino/flocks_cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('todo AppIconToken tem glifo — o contrato inteiro', () {
    const CupertinoIconProvider provider = CupertinoIconProvider();
    final List<String> missing = <String>[
      for (final AppIconToken token in AppIconToken.values)
        if (provider.resolve(token.slug) == null) token.slug,
    ];
    expect(
      missing,
      isEmpty,
      reason:
          'Um adaptador que não cobre os 55 deixa buracos no design system. '
          'Acrescente em kFlocksToCupertino.',
    );
  });

  test('a tabela não tem entrada fora do contrato', () {
    final Set<String> contract = AppIconToken.values
        .map((AppIconToken t) => t.slug)
        .toSet();
    expect(
      kFlocksToCupertino.keys.where((String k) => !contract.contains(k)),
      isEmpty,
      reason: 'Entrada fora do contrato é ruído: o Flocks nunca vai pedi-la.',
    );
  });

  test('os glifos vêm da fonte do cupertino_icons, e não do framework', () {
    // A distinção que o pacote inteiro sustenta: o `IconData` mora no Flutter,
    // a FONTE mora no pacote MIT declarado no pubspec. Se um glifo aparecer
    // apontando para outro pacote, a dependência do pubspec deixou de ser a
    // que serve os desenhos — e a prosa sobre licença deixa de valer.
    final Set<String?> packages = kFlocksToCupertino.values
        .map((IconData glyph) => glyph.fontPackage)
        .toSet();
    expect(
      packages,
      <String>{'cupertino_icons'},
      reason:
          'Todo glifo do contrato tem de vir da fonte do `cupertino_icons`, '
          'que é o asset MIT que este pacote declara.',
    );
  });

  testWidgets('desenha o glifo com a cor e o tamanho que o Flocks resolveu', (
    tester,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (BuildContext context) =>
              const CupertinoIconProvider().build(
                context,
                AppIconToken.check.slug,
                size: 32,
                color: const Color(0xFF00FF00),
              ),
        ),
      ),
    );
    final Text text = tester.widget<Text>(find.byType(Text));
    expect(text.style?.fontSize, 32);
    expect(text.style?.color, const Color(0xFF00FF00));
  });

  testWidgets('nome fora do contrato cai no fallback, e não some', (
    tester,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (BuildContext context) => const CupertinoIconProvider()
              .build(context, 'nao-existe', size: 24),
        ),
      ),
    );
    expect(find.byType(Text), findsOneWidget);
  });
}
