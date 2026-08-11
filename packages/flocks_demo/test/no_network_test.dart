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
// 2. O bootstrap JavaScript do Flutter Web roda antes e fora daqui, e ele busca
//    o CanvasKit (contornado com `--no-web-resources-cdn`, e há um gate estático
//    para a flag) e a fonte Roboto do Google (ainda não contornado — ver README
//    e TODO). Nenhum dos dois toca o logo, mas nenhum dos dois seria visto por
//    este arquivo.
// 3. `HttpOverrides` intercepta o `dart:io` do Dart. Rede aberta por JS pelo
//    lado de fora, sem passar pelo `HttpClient`, não acenderia aqui — o que é a
//    mesma lacuna do item 1, vista pelo outro lado.
//
// Os dois gates são complementares e nenhum dos dois basta: este prova que o
// caminho EXECUTADO não faz rede; o estático prova que o caminho NÃO EXECUTADO
// não tem como fazer.
import 'dart:io';
import 'dart:typed_data';

import 'package:flocks/flocks.dart';
import 'package:flocks_demo/src/demo_app.dart';
import 'package:flocks_demo/src/state/demo_config.dart';
import 'package:flutter/widgets.dart';
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

void main() {
  late _RecordingHttpOverrides overrides;

  setUp(() {
    overrides = _RecordingHttpOverrides();
    HttpOverrides.global = overrides;
  });

  tearDown(() => HttpOverrides.global = null);

  testWidgets('a demo não faz uma única requisição — nem com um logo carregado', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1600, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      DemoApp(initialUri: Uri.parse('https://flocks.live/demo/')),
    );
    await tester.pump(const Duration(milliseconds: 300));

    // O logo entra pelo mesmo caminho do visitante: os bytes, e só eles.
    final DemoAppState app = tester.state<DemoAppState>(find.byType(DemoApp));
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
    tester.view.physicalSize = const Size(1600, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      DemoApp(initialUri: Uri.parse('https://flocks.live/demo/')),
    );
    await tester.pump(const Duration(milliseconds: 300));

    final DemoAppState app = tester.state<DemoAppState>(find.byType(DemoApp));
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
}
