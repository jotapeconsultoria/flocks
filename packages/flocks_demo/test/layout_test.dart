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
}
