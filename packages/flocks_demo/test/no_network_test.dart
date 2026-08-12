// O gate que prende a fronteira do logo.
//
// A demo promete, na própria tela, que o logo do visitante nunca sai da aba
// dele. Uma promessa dessas escrita só na copy é uma promessa que a próxima
// refatoração quebra em silêncio — basta alguém achar conveniente mandar a
// imagem para um serviço de redimensionamento, e nada fica vermelho.
//
// Este teste é o que impede isso. Ele monta a demo INTEIRA com um logo
// carregado, mexe em tudo que muda estado, e falha se qualquer requisição HTTP
// tiver sido feita.
//
// A asserção pode ser absoluta — ZERO requisições, não "nenhuma com a imagem" —
// porque o código da demo não tem caminho de rede nenhum: os providers padrão de
// ícone e ilustração do `flocks` leem assets locais, as fontes vêm empacotadas, e
// o logo é renderizado dos bytes, sem nunca virar URL. Não há requisição legítima
// da qual distinguir uma ilegítima, e é isso que torna o gate difícil de burlar
// por acidente: qualquer rede nova acende aqui.
//
// LIMITE DESTE GATE, declarado para não ser confundido com uma promessa maior do
// que ele cumpre. São três furos, e o primeiro é o maior:
//
// 1. **O ramo web da demo nunca é COMPILADO aqui, quanto mais executado.**
//    `flutter test` roda na VM, onde `dart.library.io` é verdadeiro, então o
//    export condicional de `lib/src/state/browser.dart` escolhe
//    `browser_stub.dart` — e `browser_web.dart`, o ÚNICO arquivo da demo que
//    fala com o navegador (`history.replaceState`, o `<input type=file>` e o
//    `FileReader` que leem o logo), fica fora do build. Não há registro dele no
//    `coverage/lcov.info`, e não haveria: o compilador não o viu. Um
//    `sendBeacon` ou um `WebSocket` plantado lá passaria por este arquivo
//    intocado. Quem o fiscaliza é o `architecture_test.dart`, que varre `lib/`
//    inteiro como TEXTO justamente porque nenhum teste de execução o alcança —
//    e é por isso que a lista de proibidos de lá é longa e específica em vez de
//    confiar neste gate.
// 2. O bootstrap JavaScript e a fila de fontes do engine rodam antes e fora
//    daqui. São TRÊS requisições, e este inventário conhecia duas até a
//    medição de 2026-08-11 (`TODO.md`, e o método que enxerga terceiros é
//    `performance.getEntriesByType('resource')`, não a aba de rede):
//    o CanvasKit de `www.gstatic.com`, **corrigido** com `--no-web-resources-cdn`
//    e com gate estático para a flag; a **Roboto** de `fonts.gstatic.com`
//    (63.464 B), que o CanvasKit exige como fallback registrado e AGUARDA antes
//    do primeiro frame, mesmo a demo não a usando; e a **Noto Sans Symbols** do
//    mesmo host (69.116 B), que nasce no primeiro layout porque o bloco de código
//    do painel pede uma pilha mono que o CanvasKit não conhece, e aí cada acento
//    do comentário em português do snippet vira codepoint órfão. As duas de fonte
//    seguem não corrigidas — ver README e TODO. Nenhuma das três toca o logo (são
//    download, não upload), mas nenhuma das três seria vista por este arquivo.
// 3. `HttpOverrides` intercepta o `dart:io` do Dart. Rede aberta por JS pelo
//    lado de fora, sem passar pelo `HttpClient`, não acenderia aqui — o que é a
//    mesma lacuna do item 1, vista pelo outro lado.
//
// Os dois gates são complementares e nenhum dos dois basta: este prova que o
// caminho EXECUTADO não faz rede; o estático prova que o caminho NÃO EXECUTADO
// não tem como fazer.
//
// E dentro do que É executado, "executado" só valia para o que este arquivo
// mesmo disparava. Até os testes de gesto lá embaixo, não havia uma única
// `tester.tap` aqui: os eixos andavam por `updateForTest` e o logo era um PNG,
// então metade da demo — o `_FormSheet` do CRUD, o seletor de data, os
// dropdowns, o botão de remover o logo, e o ramo `DemoLogoFormat.vector`
// inteiro — nascia só depois de um toque que ninguém dava, e portanto rodava
// com o `HttpOverrides` instalado e olhando para o lado. Não é hipótese: foi
// por gesto que a demo quebrou em produção uma vez (ver
// `overlay_dependent_test.dart`).
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flocks/flocks.dart';
import 'package:flocks_demo/src/data/demo_data.dart';
import 'package:flocks_demo/src/demo_app.dart';
import 'package:flocks_demo/src/screens/crud_screen.dart';
import 'package:flocks_demo/src/state/demo_config.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

/// Um `HttpOverrides` que não deixa NENHUMA requisição sair, e anota todas.
///
/// Sobrescrever em vez de espionar é deliberado: se algum código tentar rede,
/// o teste registra a URL E a requisição falha, então nem um endpoint que por
/// acaso exista em CI poderia fazer o teste passar por engano.
class _RecordingHttpOverrides extends HttpOverrides {
  final List<Uri> requests = <Uri>[];

  @override
  HttpClient createHttpClient(SecurityContext? context) =>
      _RecordingHttpClient(requests);
}

class _RecordingHttpClient implements HttpClient {
  _RecordingHttpClient(this.requests);

  final List<Uri> requests;

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) {
    requests.add(url);
    return Future<HttpClientRequest>.error(
      StateError('A demo não faz rede. Tentou: $method $url'),
    );
  }

  @override
  Future<HttpClientRequest> open(
    String method,
    String host,
    int port,
    String path,
  ) => openUrl(method, Uri(host: host, port: port, path: path));

  @override
  Future<HttpClientRequest> getUrl(Uri url) => openUrl('GET', url);

  @override
  Future<HttpClientRequest> postUrl(Uri url) => openUrl('POST', url);

  @override
  Future<HttpClientRequest> putUrl(Uri url) => openUrl('PUT', url);

  @override
  Future<HttpClientRequest> patchUrl(Uri url) => openUrl('PATCH', url);

  @override
  Future<HttpClientRequest> deleteUrl(Uri url) => openUrl('DELETE', url);

  @override
  Future<HttpClientRequest> headUrl(Uri url) => openUrl('HEAD', url);

  @override
  void close({bool force = false}) {}

  // A ÚNICA concessão ao "falhar alto" de baixo, e ela existe para que o gate
  // ACUSE em vez de só morrer. `NetworkImage._sharedHttpClient` faz
  // `client.autoUncompress = false` ANTES de chamar `openUrl`: sem este setter,
  // um `Image.network` plantado na demo batia no `noSuchMethod`, levantava, e a
  // requisição nunca chegava a ser registrada — o teste reprovava, mas pelo
  // motivo errado e sem a URL no relatório. Com ele, o caminho segue até
  // `openUrl` e o relatório passa a dizer QUAL endereço a demo tentou.
  @override
  bool autoUncompress = true;

  // Todo o resto da superfície do HttpClient. Nenhum caminho da demo chega
  // aqui; se algum chegasse, o `noSuchMethod` levantaria em vez de devolver um
  // valor plausível — falhar alto é o ponto deste dublê.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Um PNG 1×1 válido — o "logo" que o visitante teria enviado.
Uint8List logoBytes() => Uint8List.fromList(<int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, //
  0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
  0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
  0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
  0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
  0x42, 0x60, 0x82,
]);

/// O mesmo logo no OUTRO ramo: um SVG, desenhado por `SvgPicture.memory`.
///
/// Existe porque o PNG acima só alcança `DemoLogoFormat.raster`, e o gate
/// precisava valer para os dois — um SVG é a única entrada da demo que PODE
/// carregar um endereço dentro de si (`<image href>`, `xlink:href`), então é
/// justamente o ramo que mais precisa rodar sob o `HttpOverrides`.
///
/// Este é inerte de propósito: um retângulo, sem `<image>`, sem `href`.
Uint8List svgLogoBytes() => Uint8List.fromList(
  utf8.encode(
    '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" '
    'viewBox="0 0 16 16"><rect width="16" height="16" fill="#4F46E5"/></svg>',
  ),
);

/// Monta a demo na configuração pedida, no viewport que o `AppShell` aceita.
Future<void> pumpDemo(
  WidgetTester tester, {
  DemoConfig config = const DemoConfig(),
}) async {
  tester.view.physicalSize = const Size(1600, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    DemoApp(
      initialUri: config.toUri(base: Uri.parse('https://flocks.live/demo/')),
    ),
  );
  await tester.pump(const Duration(milliseconds: 300));
}

/// O estado da demo já montada.
DemoAppState appOf(WidgetTester tester) =>
    tester.state<DemoAppState>(find.byType(DemoApp));

/// O campo de texto de um [AppInput] identificado pelo rótulo.
///
/// Copiado de `layout_test.dart` — `enterText` mira o `EditableText`, nunca o
/// `AppInput`, e com vários campos na tela o rótulo é o que desambigua.
Finder inputByLabel(String label) => find.descendant(
  of: find.widgetWithText(AppInput, label),
  matching: find.byType(EditableText),
);

/// Abre [control] e escolhe [option] — o caminho inteiro, e não o `onChanged`.
Future<void> chooseInDropdown(
  WidgetTester tester,
  Finder control,
  String option,
) async {
  await tester.tap(control);
  await tester.pump(const Duration(milliseconds: 400));
  // `.last` porque o rótulo do valor selecionado e a opção recém-aberta na
  // camada flutuante coexistem na árvore — a de baixo é a do overlay.
  await tester.tap(find.text(option).last);
  await tester.pump(const Duration(milliseconds: 400));
}

/// A asserção do arquivo: zero requisições, e [onde] no relatório.
void expectNoRequests(List<Uri> requests, String onde) {
  expect(
    requests,
    isEmpty,
    reason:
        'A demo fez ${requests.length} requisição(ões) $onde: $requests. Ela '
        'não pode fazer NENHUMA — é o que garante que o logo do visitante não '
        'sai da aba dele, e é a tese "funciona offline" que a demo existe para '
        'demonstrar.',
  );
}

void main() {
  late _RecordingHttpOverrides overrides;

  setUp(() {
    overrides = _RecordingHttpOverrides();
    HttpOverrides.global = overrides;
  });

  tearDown(() => HttpOverrides.global = null);

  // Os dois primeiros testes mexem nos eixos POR CÓDIGO, e continuam assim de
  // propósito: é o que varre TODO valor de cada enum a custo baixo, o que o
  // gesto não faz — um dropdown escolhe uma opção, não as quatro. Os testes de
  // gesto lá embaixo cobrem o outro eixo do problema, o do código que só nasce
  // depois do toque. Nenhum dos dois substitui o outro.
  testWidgets('a demo não faz uma única requisição — nem com um logo carregado', (
    WidgetTester tester,
  ) async {
    await pumpDemo(tester);

    // O logo entra pelo mesmo caminho do visitante: os bytes, e só eles.
    final DemoAppState app = appOf(tester);
    app.setLogoForTest(logoBytes());
    expect(app.hasLogo, isTrue, reason: 'o logo precisa estar carregado');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Mexe em tudo que muda estado, para que nenhum caminho fique sem exercer.
    for (final AppStyle style in AppStyle.values) {
      app.updateForTest((DemoConfig c) => c.copyWith(style: style));
      await tester.pump();
    }
    for (final AppRadiusMode radius in AppRadiusMode.values) {
      app.updateForTest((DemoConfig c) => c.copyWith(radius: radius));
      await tester.pump();
    }
    for (final DemoFont font in DemoFont.values) {
      app.updateForTest((DemoConfig c) => c.copyWith(font: font));
      await tester.pump();
    }
    app.updateForTest(
      (DemoConfig c) => c.copyWith(dark: true, seed: const Color(0xFF16A34A)),
    );
    await tester.pump(const Duration(milliseconds: 300));
    app.updateForTest((DemoConfig c) => c.copyWith(screen: DemoScreen.crud));
    await tester.pump(const Duration(milliseconds: 300));
    app.updateForTest(
      (DemoConfig c) => c.copyWith(screen: DemoScreen.dashboard),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      overrides.requests,
      isEmpty,
      reason:
          'A demo fez ${overrides.requests.length} requisição(ões): '
          '${overrides.requests}. Ela não pode fazer NENHUMA — é o que garante '
          'que o logo do visitante não sai da aba dele, e é a tese "funciona '
          'offline" que a demo existe para demonstrar.',
    );
  });

  testWidgets('o link compartilhável não carrega o logo', (
    WidgetTester tester,
  ) async {
    await pumpDemo(tester);

    final DemoAppState app = appOf(tester);
    app.setLogoForTest(logoBytes());
    expect(app.hasLogo, isTrue);
    await tester.pump(const Duration(milliseconds: 300));

    final String url = app.shareUrl;

    // Nem os bytes, nem um resquício deles, nem um endereço que os alcance.
    expect(url, isNot(contains('logo')));
    expect(url, isNot(contains('blob:')));
    expect(url, isNot(contains('data:')));
    expect(url.length, lessThan(200));
    // E os parâmetros são exatamente os seis do contrato — nada a mais.
    expect(Uri.parse(url).queryParameters.keys.toSet(), <String>{
      'seed',
      'style',
      'radius',
      'font',
      'dark',
      'screen',
    });
  });

  testWidgets(
    'o painel dirigido por gesto não faz requisição — nem com um logo vetorial',
    (WidgetTester tester) async {
      await pumpDemo(tester);

      // O ramo que o PNG dos testes de cima nunca alcança.
      final DemoAppState app = appOf(tester);
      app.setLogoForTest(svgLogoBytes());
      await tester.pump(const Duration(milliseconds: 400));
      expect(
        app.hasLogo,
        isTrue,
        reason: 'o SVG precisa ter passado pelo `sniffFormat` de produção',
      );
      expect(
        find.byType(SvgPicture),
        findsWidgets,
        reason:
            '`DemoLogoFormat.vector` precisa ter MONTADO, e não só sido '
            'escolhido: é o `SvgPicture.memory` de `demo_logo.dart` que este '
            'gate passa a cobrir, e um `SvgPicture.network` no lugar dele '
            'passaria despercebido por todos os outros testes daqui.',
      );

      // Os três eixos pelo controle de verdade. Abrir a camada flutuante e
      // escolher nela é código que só existe depois do toque — pelo
      // `updateForTest` dos testes de cima, nada disso roda.
      await chooseInDropdown(
        tester,
        find.byType(AppDropdown<AppStyle>),
        AppStyle.outlined.name,
      );
      await chooseInDropdown(
        tester,
        find.byType(AppDropdown<AppRadiusMode>),
        AppRadiusMode.circular.name,
      );
      await chooseInDropdown(
        tester,
        find.byType(AppDropdown<DemoFont>),
        // O rótulo é o nome humano da fonte, não o do enum.
        'Space Grotesk',
      );

      // O brilho, que é um `AppSwitch` e não um dropdown.
      await tester.tap(find.byType(AppSwitch));
      await tester.pump(const Duration(milliseconds: 400));

      // O logo sai pelo botão do painel, que só existe enquanto há logo...
      await tester.tap(find.widgetWithText(AppButton, 'Remove'));
      await tester.pump(const Duration(milliseconds: 400));
      expect(app.hasLogo, isFalse, reason: 'o botão Remove precisa ter agido');

      // ...e o caminho de upload roda inteiro, com o `browser_stub` da VM
      // devolvendo `null`, que é o mesmo que fechar o diálogo sem escolher.
      await tester.tap(find.widgetWithText(AppButton, 'Upload a logo'));
      await tester.pump(const Duration(milliseconds: 400));

      expectNoRequests(overrides.requests, 'com o painel dirigido por gesto');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('o CRUD dirigido por gesto não faz requisição', (
    WidgetTester tester,
  ) async {
    await pumpDemo(tester, config: const DemoConfig(screen: DemoScreen.crud));

    final DemoAppState app = appOf(tester);
    app.setLogoForTest(svgLogoBytes());
    await tester.pump(const Duration(milliseconds: 400));
    expect(app.hasLogo, isTrue);

    // Os quatro estados da lista, pelo seletor, como o visitante faz.
    for (final String state in <String>[
      'Loading',
      'Empty',
      'Error',
      'Loaded',
    ]) {
      await tester.tap(find.text(state));
      await tester.pump(const Duration(milliseconds: 400));
    }

    // A busca da toolbar. O rótulo dela é `hintText`, não `label`, então o
    // desambiguador aqui é a tela: é o único campo dela antes do formulário.
    final Finder search = find
        .descendant(
          of: find.byType(CrudScreen),
          matching: find.byType(EditableText),
        )
        .first;
    await tester.enterText(search, 'hooli');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.enterText(search, '');
    await tester.pump(const Duration(milliseconds: 400));

    // O formulário: metade da tela de escrita só nasce a partir daqui.
    await tester.tap(find.widgetWithText(AppButton, 'New account'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.enterText(inputByLabel('Account name'), 'Aviato');
    await tester.enterText(inputByLabel('Owner e-mail'), 'erlich@aviato.com');
    await tester.pump(const Duration(milliseconds: 400));
    await chooseInDropdown(
      tester,
      find.byType(AppDropdown<AccountPlan>),
      'Scale',
    );
    await chooseInDropdown(
      tester,
      find.byType(AppDropdown<AccountStatus>),
      'Trial',
    );

    // O seletor de data abre pelo ícone de sufixo, e não pelo campo — e é uma
    // camada flutuante inteira, com um calendário dentro, que nenhum teste
    // deste arquivo tinha montado antes.
    final Finder calendarIcon = find
        .descendant(
          of: find.byType(AppDatePickerInput),
          matching: find.byType(AppIcon),
        )
        .last;
    await tester.tap(calendarIcon);
    await tester.pump(const Duration(milliseconds: 400));
    expect(
      find.byType(AppDatePicker),
      findsOneWidget,
      reason: 'o calendário precisa ter aberto para valer como gesto',
    );
    // Abrir o calendário aqui estoura 10 px à direita — defeito de LAYOUT, não
    // deste gate, e fora do escopo do PR que trouxe estes testes (está anotado
    // no corpo dele). É TRANSITÓRIO: acontece durante a abertura e não sobra no
    // frame assentado — varrer a árvore inteira depois do `pump` não acha um
    // único `Flex` maior que a própria restrição. É por isso que o
    // `layout_test.dart`, que mede frames assentados, nunca o viu.
    //
    // Consumido aqui de propósito, e PINADO em vez de engolido: deixá-lo
    // pendente reprovaria o gate de rede por um motivo que não é o dele, e
    // engoli-lo calado apagaria o achado. No dia em que o layout for corrigido,
    // esta linha fica vermelha e diz à próxima pessoa para apagá-la.
    //
    // A ordem importa: a asserção de rede vem ANTES. Uma requisição plantada
    // aqui empilha uma segunda exceção, e sem esta linha o pino abaixo relataria
    // "o estouro sumiu" em vez do que de fato aconteceu.
    expectNoRequests(overrides.requests, 'ao abrir o seletor de data');
    expect(
      tester.takeException().toString(),
      contains('overflowed'),
      reason:
          'o estouro conhecido do calendário sumiu — ótimo: apague este '
          '`expect` e deixe a asserção de exceção do fim do teste cobrir este '
          'trecho',
    );
    await tester.tap(calendarIcon);
    await tester.pump(const Duration(milliseconds: 400));

    // Salvar. O `_save` do CRUD espera 600 ms de propósito.
    await tester.tap(find.widgetWithText(AppButton, 'Create'));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 400));

    // E o formulário de edição, que abre com os campos cheios.
    await tester.tap(find.byType(AppListTileAction).first);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.widgetWithText(AppButton, 'Cancel'));
    await tester.pump(const Duration(milliseconds: 400));

    // É o caminho por onde uma chamada de rede entraria sem nenhum outro teste
    // deste arquivo ver.
    expectNoRequests(overrides.requests, 'com o CRUD dirigido por gesto');
    expect(tester.takeException(), isNull);
  });
}
