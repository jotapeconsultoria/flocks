// O gate de layout.
//
// A demo tem uma sensibilidade que um app comum não tem: a TIPOGRAFIA é um dos
// eixos que o visitante controla, então a largura dos rótulos muda debaixo do
// layout em tempo de execução. Uma linha que cabia com Poppins estoura com Space
// Grotesk, e o estouro aparece como uma faixa listrada no meio da tela que o
// projeto existe para vender.
//
// O `flutter test` transforma um overflow em exceção, então basta montar a demo
// de verdade em cada combinação e exigir que nenhuma levante. A primeira versão
// deste arquivo pegou três: a barra do CRUD, a tabela do dashboard dentro de um
// scroll de altura infinita, e os seletores do painel de marca.
//
// As larguras vão de um laptop confortável até o ponto em que o `AppShell` ainda
// é o layout certo. Abaixo disso o alvo não é este shell, e forçar a barra aqui
// esconderia a decisão em vez de tomá-la.
//
// A segunda metade do arquivo dirige o CRUD pela INTERFACE — os quatro estados da
// lista e o formulário lateral. Ela existe porque a primeira metade só via o
// primeiro frame de cada combinação, e metade da tela de escrita só nasce depois
// de um toque: até aqui, `_startNew`, `_startEdit`, `_save`, `_validate` e o
// `_FormSheet` inteiro tinham ZERO linha coberta. E é justamente ali que o
// estouro se esconde — o painel lateral tem 420 px fixos, o erro de validação
// acrescenta uma linha embaixo do campo, e "That does not look like an e-mail."
// com Space Grotesk é mais largo que com Poppins.
import 'package:flocks/flocks.dart';
import 'package:flocks_demo/src/demo_app.dart';
import 'package:flocks_demo/src/state/demo_config.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Larguras representativas, do monitor grande até o piso do shell.
///
/// 1280 é o viewport de um laptop de 13", e 1220 é `kMinShellWidth` — abaixo
/// dele a demo troca o shell por uma mensagem em vez de se espremer, e o teste
/// de estreiteza cobre esse caminho.
const List<Size> kViewports = <Size>[
  Size(1680, 1050),
  Size(1440, 900),
  Size(1280, 720),
  Size(1220, 800),
];

Uri uriFor(DemoConfig config) =>
    config.toUri(base: Uri.parse('https://flocks.live/demo/'));

/// Os rótulos do seletor de estado da lista, na ordem em que ele os mostra.
///
/// Strings, e não os valores do enum: `_ListState` é privado da tela, e o que o
/// enum promete no próprio dartdoc é que os quatro são alcançáveis **pela
/// interface**. Um teste que importasse o enum provaria menos do que este.
const List<String> kListStates = <String>[
  'Loading',
  'Empty',
  'Error',
  'Loaded',
];

/// Monta a demo no viewport e na tipografia dados, já na tela pedida.
Future<void> pumpDemo(
  WidgetTester tester, {
  required DemoConfig config,
  required Size size,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(DemoApp(initialUri: uriFor(config)));
  await tester.pump(const Duration(milliseconds: 400));
}

/// O campo de texto de um [AppInput] identificado pelo rótulo.
Finder inputByLabel(String label) => find.descendant(
  of: find.widgetWithText(AppInput, label),
  matching: find.byType(EditableText),
);

void main() {
  for (final Size size in kViewports) {
    for (final DemoScreen screen in DemoScreen.values) {
      for (final DemoFont font in DemoFont.values) {
        testWidgets(
          '${size.width.toInt()}x${size.height.toInt()} · ${screen.name} · '
          '${font.family} não estoura',
          (WidgetTester tester) async {
            tester.view.physicalSize = size;
            tester.view.devicePixelRatio = 1;
            addTearDown(tester.view.reset);

            await tester.pumpWidget(
              DemoApp(
                initialUri: uriFor(DemoConfig(screen: screen, font: font)),
              ),
            );
            await tester.pump(const Duration(milliseconds: 400));

            // `pumpWidget` já teria propagado uma exceção de layout; esta
            // asserção é a rede para o que só aparece depois do primeiro frame.
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  }

  testWidgets('o escuro e um estilo com borda também cabem', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      DemoApp(
        initialUri: uriFor(
          const DemoConfig(
            dark: true,
            font: DemoFont.spaceGrotesk,
            radius: AppRadiusMode.circular,
            screen: DemoScreen.crud,
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);
  });

  testWidgets('abaixo do piso a demo troca o shell por uma mensagem', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(900, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(DemoApp(initialUri: uriFor(const DemoConfig())));
    await tester.pump(const Duration(milliseconds: 400));

    // Sem overflow, e sem shell: é a mensagem que aparece.
    expect(tester.takeException(), isNull);
    expect(find.text('This demo needs a wider window'), findsOneWidget);
    expect(find.byType(AppShell), findsNothing);
  });

  // A metade de escrita, nos mesmos eixos da de leitura.
  for (final Size size in kViewports) {
    for (final DemoFont font in DemoFont.values) {
      testWidgets(
        '${size.width.toInt()}x${size.height.toInt()} · ${font.family} — os '
        'quatro estados e o formulário não estouram',
        (WidgetTester tester) async {
          await pumpDemo(
            tester,
            config: DemoConfig(screen: DemoScreen.crud, font: font),
            size: size,
          );

          // Os quatro estados, pelo seletor, como o visitante faz.
          for (final String label in kListStates) {
            await tester.tap(find.text(label));
            await tester.pump(const Duration(milliseconds: 400));
            expect(
              tester.takeException(),
              isNull,
              reason: 'estado "$label" estourou',
            );
          }

          // O formulário de criação. `widgetWithText` em vez de `find.text`
          // porque "New account" é o rótulo do botão E o título do painel: com o
          // painel aberto, `find.text` acharia dois.
          await tester.tap(find.widgetWithText(AppButton, 'New account'));
          await tester.pump(const Duration(milliseconds: 400));
          expect(find.text('Account name'), findsOneWidget);
          expect(tester.takeException(), isNull, reason: 'o painel estourou');

          // Salvar vazio: é aqui que os erros de validação nascem e o layout
          // ganha uma linha embaixo de dois campos.
          await tester.tap(find.widgetWithText(AppButton, 'Create'));
          await tester.pump(const Duration(milliseconds: 400));
          expect(
            tester.takeException(),
            isNull,
            reason: 'o painel com erros de validação estourou',
          );

          await tester.tap(find.widgetWithText(AppButton, 'Cancel'));
          await tester.pump(const Duration(milliseconds: 400));

          // E o de edição, que abre com os campos cheios — outra largura de
          // conteúdo, e o título carrega o id em vez de um rótulo fixo.
          await tester.tap(find.byType(AppListTileAction).first);
          await tester.pump(const Duration(milliseconds: 400));
          expect(find.widgetWithText(AppButton, 'Save'), findsOneWidget);
          expect(
            tester.takeException(),
            isNull,
            reason: 'o painel de edição estourou',
          );
        },
      );
    }
  }

  // As asserções de COMPORTAMENTO do formulário. Num viewport só: o que varia
  // com a largura já está coberto acima, e o que se checa aqui são as strings e
  // o efeito na lista, que não mudam com o eixo.
  group('o formulário valida antes de escrever', () {
    testWidgets('criar vazio reprova nos dois campos obrigatórios', (
      WidgetTester tester,
    ) async {
      await pumpDemo(
        tester,
        config: const DemoConfig(screen: DemoScreen.crud),
        size: const Size(1440, 900),
      );
      await tester.tap(find.widgetWithText(AppButton, 'New account'));
      await tester.pump(const Duration(milliseconds: 400));

      // Antes de tentar salvar, nada de vermelho: marcar o formulário inteiro
      // antes da primeira tentativa é hostil, e o código diz isso num
      // comentário — aqui vira asserção.
      expect(find.text('An account needs a name.'), findsNothing);

      await tester.tap(find.widgetWithText(AppButton, 'Create'));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('An account needs a name.'), findsOneWidget);
      expect(find.text('An account needs an owner.'), findsOneWidget);
      // Um formulário novo nasce com 1 assento e status `trial`, então estes
      // dois NÃO devem acusar — é o que separa "validou" de "pintou tudo".
      expect(find.text('At least one seat.'), findsNothing);
      expect(find.text('An active account bills something.'), findsNothing);
    });

    testWidgets('nome curto e e-mail torto têm mensagens próprias', (
      WidgetTester tester,
    ) async {
      await pumpDemo(
        tester,
        config: const DemoConfig(screen: DemoScreen.crud),
        size: const Size(1440, 900),
      );
      await tester.tap(find.widgetWithText(AppButton, 'New account'));
      await tester.pump(const Duration(milliseconds: 400));

      await tester.enterText(inputByLabel('Account name'), 'ab');
      await tester.enterText(inputByLabel('Owner e-mail'), 'quem@onde');
      await tester.tap(find.widgetWithText(AppButton, 'Create'));
      await tester.pump(const Duration(milliseconds: 400));

      // Os dois campos passaram do "vazio" para o segundo ramo de cada
      // validação, e é o ramo que a primeira asserção do teste anterior não vê.
      expect(find.text('At least 3 characters.'), findsOneWidget);
      expect(find.text('That does not look like an e-mail.'), findsOneWidget);
      expect(find.text('An account needs a name.'), findsNothing);
    });

    testWidgets('válido: cria, avisa e a conta entra na lista', (
      WidgetTester tester,
    ) async {
      await pumpDemo(
        tester,
        config: const DemoConfig(screen: DemoScreen.crud),
        size: const Size(1440, 900),
      );
      final int antes = find.byType(AppListTileAction).evaluate().length;

      await tester.tap(find.widgetWithText(AppButton, 'New account'));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.enterText(inputByLabel('Account name'), 'Aviato');
      await tester.enterText(inputByLabel('Owner e-mail'), 'erlich@aviato.com');
      await tester.tap(find.widgetWithText(AppButton, 'Create'));

      // O `_save` espera 600 ms de propósito, para o botão em carregamento e o
      // campo desabilitado terem onde aparecer. Sem passar por eles o teste
      // afirmaria sobre um estado intermediário.
      await tester.pump();
      expect(
        find.widgetWithText(AppButton, 'Cancel'),
        findsOneWidget,
        reason: 'durante o salvamento o painel continua na tela',
      );
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Account name'), findsNothing, reason: 'o painel fecha');
      expect(find.text('Saved'), findsOneWidget);
      expect(find.text('Aviato was created.'), findsOneWidget);
      expect(find.byType(AppListTileAction).evaluate().length, antes + 1);
      expect(tester.takeException(), isNull);
    });

    testWidgets('editar renomeia a conta existente, sem criar outra', (
      WidgetTester tester,
    ) async {
      await pumpDemo(
        tester,
        config: const DemoConfig(screen: DemoScreen.crud),
        size: const Size(1440, 900),
      );
      final int antes = find.byType(AppListTileAction).evaluate().length;

      await tester.tap(find.byType(AppListTileAction).first);
      await tester.pump(const Duration(milliseconds: 400));
      await tester.enterText(inputByLabel('Account name'), 'Hooli');
      await tester.tap(find.widgetWithText(AppButton, 'Save'));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Hooli was updated.'), findsOneWidget);
      expect(
        find.byType(AppListTileAction).evaluate().length,
        antes,
        reason: 'edição substitui no lugar; se somar, o `indexWhere` errou',
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('cancelar descarta o rascunho e não toca a lista', (
      WidgetTester tester,
    ) async {
      await pumpDemo(
        tester,
        config: const DemoConfig(screen: DemoScreen.crud),
        size: const Size(1440, 900),
      );
      await tester.tap(find.byType(AppListTileAction).first);
      await tester.pump(const Duration(milliseconds: 400));

      final String original = tester
          .widget<EditableText>(inputByLabel('Account name'))
          .controller
          .text;
      await tester.enterText(inputByLabel('Account name'), 'Nao salvar isto');
      await tester.tap(find.widgetWithText(AppButton, 'Cancel'));
      await tester.pump(const Duration(milliseconds: 400));

      // É o que a cópia de `_startEdit` existe para garantir: sem ela, cada
      // tecla já teria alterado a lista por baixo e "Cancel" não significaria
      // nada.
      expect(find.text('Nao salvar isto'), findsNothing);
      expect(find.text(original), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
