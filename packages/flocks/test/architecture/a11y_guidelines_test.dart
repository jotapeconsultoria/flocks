// Gate 8 (acessibilidade) com os matchers que o framework oferece.
//
// A suíte tinha ZERO `matchesSemantics` e ZERO `meetsGuideline`, embora a §4.6
// exija ambos: o contraste era medido por asserção de cor e a semântica, por
// leitura de rótulo. Nenhum dos dois vê PAPEL errado nem alvo pequeno demais.
//
// O que fica de fora, e por quê: `androidTapTargetGuideline` (48×48) e
// `iOSTapTargetGuideline` (44×44) reprovam hoje os três seletores (24×24) e o
// `AppButton` de tamanho `s` (40). Corrigir muda a GEOMETRIA do DS — um
// checkbox passaria a reservar 48px em todo formulário —, então é decisão de
// dono, não de teste. A medida está registrada em `kTapTargetDebt` abaixo para
// não virar omissão silenciosa.
import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Achados de acessibilidade que este gate MEDIU e que exigem decisão de dono,
/// com o número medido. Não é allow-list de conveniência: é dívida com valor.
const Map<String, String> kA11yDebt = <String, String>{
  // Diretrizes de alvo de toque. Corrigir muda a GEOMETRIA do DS — um checkbox
  // passaria a reservar 48px em todo formulário, como o Material faz com
  // `MaterialTapTargetSize.padded`.
  'AppCheckbox (alvo)': '24×24 · mínimo 48×48 Android / 44×44 iOS',
  'AppSwitch (alvo)': '24×24',
  'AppRadio (alvo)': '24×24',
  'AppButton(size: s) (alvo)': 'altura 40',
};

Widget _host(Widget child, {bool dark = false, AppBrandConfig? brand}) {
  final AppThemeData theme = AppThemeData.forBrand(
    brand ?? jotapeBrand,
    dark: dark,
  );
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: AppTheme(
        data: theme,
        // Fundo OPACO: o `textContrastGuideline` amostra o pixel atrás do
        // texto. Sem isto ele encontra preto transparente e mede contra nada.
        child: ColoredBox(
          color: theme.colorTheme.surface,
          child: Center(child: child),
        ),
      ),
    ),
  );
}

void main() {
  group('meetsGuideline', () {
    // Alvos de tamanho confortável: os que JÁ cumprem as diretrizes de toque.
    final Map<String, Widget> comfortable = <String, Widget>{
      'AppButton (m)': AppButton(label: 'Salvar', onPressed: () {}),
      'AppButton (l)': AppButton(
        label: 'Salvar',
        size: AppButtonSize.l,
        onPressed: () {},
      ),
      'AppButton (ícone)': AppButton(
        icon: AppIcons.add,
        semanticsLabel: 'Novo',
        onPressed: () {},
      ),
      'AppFloatingButton': AppFloatingButton(
        icon: AppIcons.add,
        semanticsLabel: 'Novo',
        onPressed: () {},
      ),
    };

    for (final MapEntry<String, Widget> e in comfortable.entries) {
      testWidgets('${e.key} — alvo de toque Android (48×48)', (
        WidgetTester tester,
      ) async {
        final SemanticsHandle handle = tester.ensureSemantics();
        await tester.pumpWidget(_host(e.value));
        await tester.pumpAndSettle();
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        handle.dispose();
      });

      testWidgets('${e.key} — alvo de toque iOS (44×44)', (
        WidgetTester tester,
      ) async {
        final SemanticsHandle handle = tester.ensureSemantics();
        await tester.pumpWidget(_host(e.value));
        await tester.pumpAndSettle();
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        handle.dispose();
      });
    }

    // Todo alvo tocável precisa de NOME. Um ícone sem rótulo é um botão mudo
    // para quem usa leitor de tela — inclusive os seletores, que só têm nome
    // quando alguém passa `semanticLabel` (ou os embrulha num list tile).
    final Map<String, Widget> labelled = <String, Widget>{
      'AppButton (ícone)': AppButton(
        icon: AppIcons.add,
        semanticsLabel: 'Novo',
        onPressed: () {},
      ),
      'AppCheckbox': AppCheckbox(
        checked: false,
        semanticLabel: 'Receber alertas',
        onChanged: (_) {},
      ),
      'AppSwitch': AppSwitch(
        value: true,
        semanticLabel: 'Modo escuro',
        onChanged: (_) {},
      ),
      'AppRadio': AppRadio<int>(
        value: 1,
        groupValue: 1,
        semanticLabel: 'Diário',
        onChanged: (_) {},
      ),
      'AppFloatingButton': AppFloatingButton(
        icon: AppIcons.add,
        semanticsLabel: 'Novo',
        onPressed: () {},
      ),
    };

    for (final MapEntry<String, Widget> e in labelled.entries) {
      testWidgets('${e.key} — alvo tocável é rotulado', (
        WidgetTester tester,
      ) async {
        final SemanticsHandle handle = tester.ensureSemantics();
        await tester.pumpWidget(_host(e.value));
        await tester.pumpAndSettle();
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        handle.dispose();
      });
    }

    // Contraste de TEXTO renderizado, nas duas marcas × dois brilhos. O
    // contrato de cor mede tokens; isto mede o pixel que sai.
    for (final AppBrandConfig brand in <AppBrandConfig>[
      jotapeBrand,
      zxtrackBrand,
    ]) {
      for (final bool dark in <bool>[false, true]) {
        testWidgets('texto tem contraste suficiente · ${brand.clientSlug} '
            '${dark ? 'escuro' : 'claro'}', (WidgetTester tester) async {
          final SemanticsHandle handle = tester.ensureSemantics();
          await tester.pumpWidget(
            _host(
              brand: brand,
              dark: dark,
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AppButton(label: 'Salvar', onPressed: () {}),
                  const AppText('Corpo de texto sobre a superfície'),
                  const AppBadge('Ativo'),
                ],
              ),
            ),
          );
          await tester.pumpAndSettle();
          await expectLater(tester, meetsGuideline(textContrastGuideline));
          handle.dispose();
        });
      }
    }
  });

  group('matchesSemantics — o PAPEL, não só o rótulo', () {
    testWidgets('AppButton é botão habilitado e focável', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(AppButton(label: 'Salvar', onPressed: () {})),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Salvar').first),
        matchesSemantics(
          label: 'Salvar',
          isButton: true,
          isEnabled: true,
          isFocusable: true,
          hasEnabledState: true,
          hasTapAction: true,
          hasFocusAction: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('AppButton desabilitado ANUNCIA o estado (não some)', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      // `onPressed: null` é o que desabilita — o parâmetro é obrigatório.
      await tester.pumpWidget(
        _host(const AppButton(label: 'Salvar', onPressed: null)),
      );

      // `isEnabled: false` com `hasEnabledState: true` é a diferença entre
      // "está desligado" e "não existe" — sem isso o leitor de tela não explica
      // por que o toque não faz nada.
      expect(
        tester.getSemantics(find.bySemanticsLabel('Salvar').first),
        matchesSemantics(
          label: 'Salvar',
          isButton: true,
          hasEnabledState: true,
          isEnabled: false,
        ),
      );
      handle.dispose();
    });

    testWidgets('AppCheckbox expõe estado de marcação', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(
          AppCheckbox(
            checked: true,
            semanticLabel: 'Receber alertas',
            onChanged: (_) {},
          ),
        ),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Receber alertas')),
        // O seletor anuncia focabilidade E ação de foco — é o contraste com o
        // AppButton, que não anuncia (ver kA11yDebt).
        matchesSemantics(
          label: 'Receber alertas',
          hasCheckedState: true,
          isChecked: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
          hasFocusAction: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('AppSwitch expõe estado de alternância', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(
          AppSwitch(
            value: true,
            semanticLabel: 'Modo escuro',
            onChanged: (_) {},
          ),
        ),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Modo escuro')),
        // O seletor anuncia focabilidade E ação de foco — é o contraste com o
        // AppButton, que não anuncia (ver kA11yDebt).
        matchesSemantics(
          label: 'Modo escuro',
          hasCheckedState: true,
          isChecked: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
          hasFocusAction: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('AppInput é campo de texto rotulado', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(const SizedBox(width: 320, child: AppInput(label: 'E-mail'))),
      );

      expect(
        find.bySemanticsLabel('E-mail'),
        findsWidgets,
        reason: 'o label do campo tem de chegar à árvore semântica',
      );
      handle.dispose();
    });
  });

  test('o débito de acessibilidade está registrado, não esquecido', () {
    // A lista só encolhe junto com o teste que passa a cobrir o componente —
    // esvaziá-la sem isso é apagar a medição, não resolver o problema.
    expect(kA11yDebt, isNotEmpty);
  });
}
