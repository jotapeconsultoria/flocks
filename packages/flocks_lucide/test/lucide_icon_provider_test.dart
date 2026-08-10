// O adaptador precisa cobrir o contrato inteiro, e precisa NÃO alcançar mais
// que isso — é a segunda metade que segura o tree-shaking.
import 'package:flocks/flocks.dart';
import 'package:flocks_lucide/flocks_lucide.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('contrato', () {
    test('todo AppIconToken resolve num glifo', () {
      const LucideIconProvider provider = LucideIconProvider();
      final List<String> missing = <String>[
        for (final AppIconToken token in AppIconToken.values)
          if (provider.resolve(token.slug) == null) token.slug,
      ];
      expect(
        missing,
        isEmpty,
        reason:
            'Um adaptador que não cobre os 55 deixa buracos no design system.',
      );
    });

    test('o provider NÃO alcança um nome fora do contrato', () {
      // Não é limitação, é o mecanismo: tudo alcançável pelo provider conta
      // como escrito para o `--tree-shake-icons`. Se `storefront` resolvesse
      // por slug, os 2.025 resolveriam, e a fonte inteira iria para o bundle.
      expect(const LucideIconProvider().resolve('storefront'), isNull);
    });

    test('extraIcons devolve o acesso, e tem precedência sobre o contrato', () {
      const LucideIconProvider provider = LucideIconProvider(
        extraIcons: <String, IconData>{
          'check': FlocksLucide.circleCheckBig,
          'storefront': FlocksLucide.store,
        },
      );
      expect(provider.resolve('storefront'), FlocksLucide.store);
      expect(provider.resolve('check'), FlocksLucide.circleCheckBig);
    });
  });

  group('tradução', () {
    test('o slug do Flocks chega ao desenho do Lucide', () {
      const LucideIconProvider provider = LucideIconProvider();
      expect(provider.resolve(AppIconToken.close.slug), FlocksLucide.x);
      expect(
        provider.resolve(AppIconToken.errorCircle.slug),
        FlocksLucide.circleAlert,
      );
      expect(provider.resolve(AppIconToken.filter.slug), FlocksLucide.funnel);
    });

    test('slug e nome do Lucide coincidindo dispensa tradução', () {
      expect(kFlocksToLucide.containsKey('calendar'), isFalse);
      expect(
        const LucideIconProvider().resolve('calendar'),
        FlocksLucide.calendar,
      );
    });
  });

  group('desenho', () {
    testWidgets('honra a cor e o tamanho que o Flocks resolveu', (
      tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (BuildContext context) => const LucideIconProvider().build(
              context,
              AppIconToken.check.slug,
              size: 32,
              color: const Color(0xFF00FF00),
            ),
          ),
        ),
      );
      final RichText text = tester.widget<RichText>(find.byType(RichText));
      final TextStyle style = (text.text as TextSpan).style!;
      expect(style.fontSize, 32);
      expect(style.color, const Color(0xFF00FF00));
      expect(style.fontFamily, 'packages/flocks_lucide/Lucide');
    });

    testWidgets('nome fora do contrato desenha o interrogação, e não branco', (
      tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (BuildContext context) => const LucideIconProvider().build(
              context,
              'nao-existe',
              size: 24,
            ),
          ),
        ),
      );
      final RichText text = tester.widget<RichText>(find.byType(RichText));
      expect(
        (text.text as TextSpan).text,
        String.fromCharCode(FlocksLucide.circleHelp.codePoint),
        reason:
            'Ícone que não resolveu é bug de integração; um espaço em branco '
            'esconde isso até a revisão de layout.',
      );
    });

    testWidgets('o LucideIcon é a porta para os ícones fora do contrato', (
      tester,
    ) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: LucideIcon(FlocksLucide.store, size: 24),
        ),
      );
      expect(find.byType(RichText), findsOneWidget);
    });
  });
}
