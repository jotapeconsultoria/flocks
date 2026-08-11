// Os controles que dependem da camada flutuante, e que morriam calados.
//
// O Flocks não monta `Overlay` em nenhum lugar — é decisão dele: quem hospeda
// escolhe onde a camada vive. Os componentes que precisam dela chamam
// `Overlay.of(context).insert(...)`, e num app sem `MaterialApp` — como esta
// demo, de propósito — não havia quem a fornecesse.
//
// O sintoma era o pior tipo: SILENCIOSO. Tocar "Container style", "Corner shape"
// ou "Typeface" no painel de marca não abria nada. Sem erro na tela, sem erro no
// console do navegador, sem nada. Dois dos três eixos que a demo existe para o
// visitante mexer estavam mortos em produção, e nenhum teste percebia — porque
// `layout_test.dart` só media o primeiro frame e `no_network_test.dart` mexia nos
// eixos pelo CÓDIGO, chamando o `onChanged` direto em vez de tocar o controle.
//
// Este arquivo é a diferença entre "renderiza" e "funciona". Cada teste abre um
// controle de verdade, com um toque, e exige que a camada apareça. Um `Overlay`
// que saia da árvore de novo reprova aqui, e não em produção.
import 'package:flocks/flocks.dart';
import 'package:flocks_demo/src/data/demo_data.dart';
import 'package:flocks_demo/src/demo_app.dart';
import 'package:flocks_demo/src/state/demo_config.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Uri uriFor(DemoConfig config) =>
    config.toUri(base: Uri.parse('https://flocks.live/demo/'));

Future<void> pumpDemo(
  WidgetTester tester, {
  DemoConfig config = const DemoConfig(),
}) async {
  tester.view.physicalSize = const Size(1440, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(DemoApp(initialUri: uriFor(config)));
  await tester.pump(const Duration(milliseconds: 400));
}

/// Abre [control] e exige que a opção [option] apareça — isto é, que a camada
/// flutuante tenha sido inserida de fato.
Future<void> expectOpens(
  WidgetTester tester, {
  required Finder control,
  required String option,
}) async {
  expect(control, findsOneWidget, reason: 'o controle não está na tela');
  await tester.tap(control);
  await tester.pump(const Duration(milliseconds: 400));
  expect(
    tester.takeException(),
    isNull,
    reason: 'abrir o controle lançou — provavelmente falta `Overlay`',
  );
  expect(
    find.text(option),
    findsWidgets,
    reason:
        'o controle abriu sem lançar, mas "$option" não apareceu: a camada '
        'flutuante não foi inserida',
  );
}

void main() {
  testWidgets('a demo tem um Overlay na árvore', (WidgetTester tester) async {
    // A asserção mais barata do arquivo, e a que aponta direto para a causa
    // quando as de baixo caírem juntas.
    await pumpDemo(tester);
    expect(
      find.byType(Overlay),
      findsWidgets,
      reason:
          'Sem `Overlay` ancestral, todo componente do Flocks que usa camada '
          'flutuante morre calado: dropdown, seletor de data, seleção de texto.',
    );
  });

  group('os eixos do painel de marca abrem', () {
    testWidgets('Container style', (WidgetTester tester) async {
      await pumpDemo(tester);
      await expectOpens(
        tester,
        control: find.byType(AppDropdown<AppStyle>),
        option: AppStyle.outlined.name,
      );
    });

    testWidgets('Corner shape', (WidgetTester tester) async {
      await pumpDemo(tester);
      await expectOpens(
        tester,
        control: find.byType(AppDropdown<AppRadiusMode>),
        option: AppRadiusMode.circular.name,
      );
    });

    testWidgets('Typeface', (WidgetTester tester) async {
      await pumpDemo(tester);
      await expectOpens(
        tester,
        control: find.byType(AppDropdown<DemoFont>),
        // O rótulo é o nome humano da fonte, não o do enum.
        option: 'Space Grotesk',
      );
    });

    testWidgets('e escolher no dropdown muda o eixo de verdade', (
      WidgetTester tester,
    ) async {
      // O teste que fecha o laço: não basta a camada aparecer, a escolha tem de
      // chegar ao tema. É o caminho inteiro que o visitante percorre.
      await pumpDemo(tester);
      await tester.tap(find.byType(AppDropdown<AppStyle>));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.tap(find.text(AppStyle.outlined.name).last);
      await tester.pump(const Duration(milliseconds: 400));

      final AppThemeData theme = AppTheme.of(
        tester.element(find.byType(AppShell)),
      );
      expect(theme.styleTheme.style, AppStyle.outlined);
      expect(tester.takeException(), isNull);
    });
  });

  group('os controles do formulário abrem', () {
    Future<void> openForm(WidgetTester tester) async {
      await pumpDemo(tester, config: const DemoConfig(screen: DemoScreen.crud));
      await tester.tap(find.widgetWithText(AppButton, 'New account'));
      await tester.pump(const Duration(milliseconds: 400));
    }

    testWidgets('o dropdown de Plan', (WidgetTester tester) async {
      await openForm(tester);
      await expectOpens(
        tester,
        control: find.byType(AppDropdown<AccountPlan>),
        option: 'Scale',
      );
    });

    testWidgets('o dropdown de Status', (WidgetTester tester) async {
      await openForm(tester);
      await expectOpens(
        tester,
        control: find.byType(AppDropdown<AccountStatus>),
        option: 'Churned',
      );
    });

    testWidgets('focar um campo de texto não lança', (
      WidgetTester tester,
    ) async {
      // A seleção de texto do `EditableText` também pede `Overlay`, e é o
      // caminho por onde o defeito apareceu: sem ele, focar o campo lançava e o
      // `onChanged` nunca corria — o visitante digitava e nada era gravado.
      await openForm(tester);
      await tester.tap(find.text('Account name'));
      await tester.pump(const Duration(milliseconds: 400));
      expect(tester.takeException(), isNull);
    });
  });
}
