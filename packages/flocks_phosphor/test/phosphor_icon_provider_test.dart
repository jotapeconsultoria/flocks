// O contrato do pacote irmão: servir tudo que o Flocks pede, em todo peso.
//
// O `flocks` garante os 55 de `AppIconToken` porque os embute. Aqui a garantia
// é maior e precisa ser provada: **todo** token resolve em **todos** os 6
// pesos. Um adotante que troque de `regular` para `bold` não pode descobrir por
// interrogação na tela que faltou um.
import 'package:flocks/flocks.dart';
import 'package:flocks_phosphor/flocks_phosphor.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) =>
    Directionality(textDirection: TextDirection.ltr, child: child);

/// O glifo que [provider] serve para [slug], em qualquer peso.
IconData _glyph(PhosphorIconProvider provider, String slug) =>
    provider.resolve(slug) ?? provider.resolveDuotone(slug)!.figure;

void main() {
  group('contrato — o Flocks inteiro desenha, em todo peso', () {
    for (final PhosphorWeight weight in PhosphorWeight.values) {
      test('${weight.name}: todo AppIconToken resolve num glifo', () {
        final PhosphorIconProvider provider = PhosphorIconProvider(
          weight: weight,
        );
        final List<String> missing = <String>[
          for (final AppIconToken token in AppIconToken.values)
            if (provider.resolve(token.slug) == null &&
                provider.resolveDuotone(token.slug) == null)
              token.slug,
        ];
        expect(
          missing,
          isEmpty,
          reason:
              'Sem glifo, o ícone vira interrogação em produção. Corrija a '
              'tradução em `flocks_to_phosphor.dart` e regenere.',
        );
      });
    }

    test('cada peso serve o glifo da SUA família, não a de outro', () {
      // O mapa certo com a família errada desenharia o peso errado sem nada
      // ficar vermelho — os codepoints são os mesmos nos seis arquivos.
      for (final PhosphorWeight weight in PhosphorWeight.values) {
        final IconData glyph = _glyph(
          PhosphorIconProvider(weight: weight),
          'check',
        );
        expect(glyph.fontFamily, weight.fontFamily);
        expect(glyph.fontPackage, 'flocks_phosphor');
      }
    });

    test('trocar o peso troca o glifo servido', () {
      // Alcance, e não só ausência de ofensor: se os seis mapas apontassem
      // para a mesma família, os testes acima passariam e o eixo seria
      // decoração.
      expect(<String?>{
        for (final PhosphorWeight w in PhosphorWeight.values)
          _glyph(PhosphorIconProvider(weight: w), 'check').fontFamily,
      }, hasLength(PhosphorWeight.values.length));
    });
  });

  group('tradução — dois vocabulários, um provider', () {
    const PhosphorIconProvider provider = PhosphorIconProvider();

    test('o slug do Flocks chega no desenho do Phosphor', () {
      expect(provider.resolve('chevron-down'), FlocksPhosphorRegular.caretDown);
      expect(
        provider.resolve('error-circle'),
        FlocksPhosphorRegular.warningCircle,
      );
      expect(provider.resolve('search'), FlocksPhosphorRegular.magnifyingGlass);
    });

    test('nome fora do contrato NÃO resolve — é o preço do tree-shaking', () {
      // Mudança de comportamento em relação à versão em SVG, e deliberada:
      // resolver nome arbitrário exigiria um mapa dos 1.512, e um mapa dos
      // 1.512 é alcançável, logo retido, logo a fonte inteira no bundle.
      expect(provider.resolve('airplane-tilt'), isNull);
    });

    test('extraIcons devolve o acesso, com o custo em quem escolhe', () {
      const PhosphorIconProvider withExtra = PhosphorIconProvider(
        extraIcons: <String, IconData>{
          'airplane-tilt': FlocksPhosphorRegular.airplaneTilt,
        },
      );
      expect(
        withExtra.resolve('airplane-tilt'),
        FlocksPhosphorRegular.airplaneTilt,
      );
    });

    test('extraIcons tem precedência sobre o contrato', () {
      const PhosphorIconProvider override = PhosphorIconProvider(
        extraIcons: <String, IconData>{
          'search': FlocksPhosphorRegular.binoculars,
        },
      );
      expect(override.resolve('search'), FlocksPhosphorRegular.binoculars);
    });
  });

  group('duotone — dois glifos, e os dois aparecem', () {
    const PhosphorIconProvider provider = PhosphorIconProvider(
      weight: PhosphorWeight.duotone,
    );

    test('resolve devolve null; quem responde é resolveDuotone', () {
      // O tipo é o que impede meio ícone. Se `resolve` respondesse com o
      // codepoint base, o provider desenharia a mancha sem o contorno.
      expect(provider.resolve('check'), isNull);
      expect(provider.resolveDuotone('check'), isNotNull);
    });

    test('os cinco pesos de glifo único não respondem a resolveDuotone', () {
      for (final PhosphorWeight w in PhosphorWeight.values) {
        if (w == PhosphorWeight.duotone) {
          continue;
        }
        expect(PhosphorIconProvider(weight: w).resolveDuotone('check'), isNull);
      }
    });

    testWidgets('desenha as DUAS camadas, na ordem certa', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(const PhosphorDuotoneIcon(FlocksPhosphorDuotone.acorn, size: 24)),
      );
      final List<RichText> layers = tester
          .widgetList<RichText>(find.byType(RichText))
          .toList();
      expect(layers, hasLength(2), reason: 'meio ícone é o defeito clássico');
      expect(
        layers.map((RichText t) => (t.text as TextSpan).text),
        <String>[
          String.fromCharCode(FlocksPhosphorDuotone.acorn.ground!.codePoint),
          String.fromCharCode(FlocksPhosphorDuotone.acorn.figure.codePoint),
        ],
        reason: 'a mancha vai por baixo, o contorno por cima',
      );
    });

    testWidgets('um ícone de camada única desenha UMA camada, opaca', (
      WidgetTester tester,
    ) async {
      // `cell-signal-none` e `wifi-none` não têm mancha — o desenho é um traço
      // só. Empilhar uma cópia a 20% engrossaria o traço; desenhar só a mancha
      // deixaria o ícone apagado. Os dois erros são invisíveis num teste que
      // não conte as camadas.
      await tester.pumpWidget(
        _host(
          const PhosphorDuotoneIcon(
            FlocksPhosphorDuotone.wifiNone,
            color: Color(0xFF102030),
            size: 24,
          ),
        ),
      );
      final List<RichText> layers = tester
          .widgetList<RichText>(find.byType(RichText))
          .toList();
      expect(layers, hasLength(1));
      expect(
        (layers.single.text as TextSpan).style!.color,
        const Color(0xFF102030),
        reason: 'a única camada é o desenho, e vai em opacidade cheia',
      );
    });

    testWidgets('a camada de baixo sai a 20% do alfa', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const PhosphorDuotoneIcon(
            FlocksPhosphorDuotone.acorn,
            color: Color(0xFF102030),
            size: 24,
          ),
        ),
      );
      final List<RichText> layers = tester
          .widgetList<RichText>(find.byType(RichText))
          .toList();
      expect(
        (layers.first.text as TextSpan).style!.color!.a,
        closeTo(kPhosphorDuotoneGroundOpacity, 0.001),
      );
      expect(
        (layers.last.text as TextSpan).style!.color,
        const Color(0xFF102030),
      );
    });
  });

  group('o peso é o eixo', () {
    test('o default é regular — o peso com que o DS foi desenhado', () {
      expect(const PhosphorIconProvider().weight, PhosphorWeight.regular);
    });

    testWidgets('o AppIcon do tema desenha pelo provider', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          AppTheme(
            data: AppThemeData.light.copyWith(
              iconTheme: const AppIconTheme(
                provider: PhosphorIconProvider(weight: PhosphorWeight.bold),
              ),
            ),
            child: const AppIcon(AppIconToken.check),
          ),
        ),
      );
      expect(
        (tester.widget<RichText>(find.byType(RichText)).text as TextSpan)
            .style!
            .fontFamily,
        'packages/flocks_phosphor/Phosphor-Bold',
        reason:
            'O `package:` do TextStyle prefixa a família — é isso que faz o '
            'Flutter achar a fonte embutida no pacote irmão.',
      );
    });

    testWidgets('slug desconhecido desenha interrogação, não vazio', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          AppTheme(
            data: AppThemeData.light.copyWith(
              iconTheme: const AppIconTheme(provider: PhosphorIconProvider()),
            ),
            child: const AppIcon('nao-existe'),
          ),
        ),
      );
      expect(
        (tester.widget<RichText>(find.byType(RichText)).text as TextSpan).text,
        String.fromCharCode(FlocksPhosphorRegular.question.codePoint),
        reason:
            'Ícone que não resolve é bug de integração; espaço em branco '
            'esconde isso até a revisão de layout.',
      );
    });
  });
}
