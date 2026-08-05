import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flocks/src/organisms/api_docs/app_api_flow_step_tile.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'api_docs_fixtures.dart';

/// Host de largura fixa: o filho recebe uma largura **tight**, como dentro de
/// um sheet. É o que os componentes de bloco (painel, cartão, tabela) esperam.
Widget _host(Widget child, {double width = 780}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(size: Size(800, 600)),
    child: AppTheme(
      data: AppThemeData.light,
      // Overlay: a seleção nativa do EditableText (handles/toolbar) do campo de
      // busca precisa de um Overlay ancestral — que um MaterialApp daria.
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(
            builder: (_) => Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: width,
                child: SingleChildScrollView(child: child),
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);

/// Host sem constraint de largura — para medir o tamanho **natural** de um
/// componente. Com o [_host] a largura tight do pai venceria qualquer SizedBox
/// interno e toda medição daria a largura do host.
Widget _loose(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(size: Size(800, 600)),
    child: AppTheme(
      data: AppThemeData.light,
      child: Align(alignment: Alignment.topLeft, child: child),
    ),
  ),
);

/// Texto simples do que foi renderizado — os paths viram `Text.rich`, cujo
/// `data` é nulo, então `find.text` sozinho não os acha.
String _rendered(WidgetTester tester) => tester
    .widgetList<Text>(find.byType(Text))
    .map((Text t) => t.data ?? t.textSpan?.toPlainText() ?? '')
    .join('\n');

void main() {
  group('AppApiMethod', () {
    test('mapeia o verbo para o papel de cor esperado', () {
      expect(AppApiMethod.get.badgeColor, AppBadgeColor.info);
      expect(AppApiMethod.post.badgeColor, AppBadgeColor.success);
      expect(AppApiMethod.put.badgeColor, AppBadgeColor.warning);
      expect(AppApiMethod.patch.badgeColor, AppBadgeColor.warning);
      expect(AppApiMethod.delete.badgeColor, AppBadgeColor.danger);
      expect(AppApiMethod.head.badgeColor, AppBadgeColor.neutral);
      expect(AppApiMethod.options.badgeColor, AppBadgeColor.neutral);
    });

    test('só GET/HEAD/OPTIONS não são mutação', () {
      expect(AppApiMethod.get.isMutation, isFalse);
      expect(AppApiMethod.head.isMutation, isFalse);
      expect(AppApiMethod.options.isMutation, isFalse);
      expect(AppApiMethod.post.isMutation, isTrue);
      expect(AppApiMethod.delete.isMutation, isTrue);
    });

    test('tryParse aceita caixa alta e devolve null no desconhecido', () {
      expect(AppApiMethod.tryParse('POST'), AppApiMethod.post);
      expect(AppApiMethod.tryParse(' get '), AppApiMethod.get);
      expect(AppApiMethod.tryParse('trace'), isNull);
    });
  });

  group('AppApiResponse', () {
    test('classifica o status pela faixa', () {
      expect(
        const AppApiResponse(status: 201).badgeColor,
        AppBadgeColor.success,
      );
      expect(
        const AppApiResponse(status: 409).badgeColor,
        AppBadgeColor.warning,
      );
      expect(
        const AppApiResponse(status: 500).badgeColor,
        AppBadgeColor.danger,
      );
      expect(
        const AppApiResponse(status: 302).badgeColor,
        AppBadgeColor.neutral,
      );
    });
  });

  group('AppApiEndpoint', () {
    test('id é MÉTODO + path', () {
      expect(kListDevices.id, 'GET /devices');
      expect(kCreateSimAssociation.id, 'POST /associations/device-sim-card');
    });

    test('paramsIn filtra por onde o parâmetro viaja', () {
      expect(
        kListDevices.paramsIn(AppApiParamLocation.query).map((p) => p.name),
        <String>['filter', 'page'],
      );
      expect(kListDevices.paramsIn(AppApiParamLocation.path), isEmpty);
    });
  });

  group('splitApiPathSpans', () {
    const TextStyle base = TextStyle(fontSize: 12);
    const TextStyle ph = TextStyle(fontSize: 12, fontWeight: FontWeight.w600);

    test('separa literais de placeholders', () {
      final List<TextSpan> spans = splitApiPathSpans(
        '/devices/{id}/commands',
        base: base,
        placeholder: ph,
      );
      expect(spans.map((TextSpan s) => s.text), <String>[
        '/devices/',
        '{id}',
        '/commands',
      ]);
      expect(spans[1].style, ph);
    });

    test('chave sem fechamento vira literal, não engole o resto', () {
      final List<TextSpan> spans = splitApiPathSpans(
        '/devices/{id',
        base: base,
        placeholder: ph,
      );
      expect(spans.single.text, '/devices/{id');
      expect(spans.single.style, base);
    });
  });

  group('AppApiMethodBadge', () {
    testWidgets('reserva a coluna por padrão e some com width: null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _loose(const AppApiMethodBadge(AppApiMethod.options)),
      );
      expect(
        tester.getSize(find.byType(AppApiMethodBadge)).width,
        kAppApiMethodBadgeWidth,
      );

      await tester.pumpWidget(
        _loose(const AppApiMethodBadge(AppApiMethod.options, width: null)),
      );
      expect(
        tester.getSize(find.byType(AppApiMethodBadge)).width,
        lessThan(kAppApiMethodBadgeWidth),
      );
    });
  });

  group('AppApiSchemaTree', () {
    testWidgets('abre até initiallyExpandedDepth e o resto sob demanda', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_host(const AppApiSchemaTree(kNestedFields)));
      await tester.pumpAndSettle();

      // Raiz aberta (depth 0 < 1): o filho direto aparece.
      expect(_rendered(tester), contains('items'));
      // Neto fechado.
      expect(_rendered(tester), isNot(contains('imei')));

      await tester.tap(find.text('items'));
      await tester.pumpAndSettle();

      expect(_rendered(tester), contains('imei'));
    });

    testWidgets('lista vazia não renderiza nada', (WidgetTester tester) async {
      await tester.pumpWidget(_host(const AppApiSchemaTree(<AppApiField>[])));
      expect(find.byType(Text), findsNothing);
    });
  });

  group('AppApiParamTable', () {
    testWidgets('vazia não renderiza nada', (WidgetTester tester) async {
      await tester.pumpWidget(_host(const AppApiParamTable(<AppApiParam>[])));
      expect(find.byType(AppSimpleDataTable), findsNothing);
    });

    testWidgets('mostra nome, tipo e obrigatoriedade', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(AppApiParamTable(kCreateSimAssociation.params)),
      );

      final String text = _rendered(tester);
      expect(text.toLowerCase(), contains('request'));
      expect(text.toLowerCase(), contains('dados da associação'));
      // O badge pinta em caixa-alta; a asserção é sobre o CONTEÚDO.
      expect(text.toLowerCase(), contains('obrigatório'));
      expect(text.toLowerCase(), contains('body'));
    });
  });

  group('AppApiEndpointTile', () {
    testWidgets('nasce fechado e abre no toque do cabeçalho', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(const AppApiEndpointTile(endpoint: kListDevices)),
      );
      await tester.pumpAndSettle();

      expect(_rendered(tester), contains('Listar devices'));
      expect(_rendered(tester), isNot(contains('Respostas')));

      await tester.tap(find.text('Listar devices'));
      await tester.pumpAndSettle();

      final String text = _rendered(tester);
      expect(text.toLowerCase(), contains('respostas'));
      expect(text.toLowerCase(), contains('parâmetros'));
      expect(text.toLowerCase(), contains('bearer token'));
    });

    testWidgets('copiar path escreve baseUrl + path', (
      WidgetTester tester,
    ) async {
      final List<String> written = <String>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall call) async {
          if (call.method == 'Clipboard.setData') {
            written.add(
              (call.arguments as Map<Object?, Object?>)['text']! as String,
            );
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );

      await tester.pumpWidget(
        _host(
          const AppApiEndpointTile(
            endpoint: kListDevices,
            baseUrl: 'https://api.local',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(AppInteraction));
      await tester.pump();

      expect(written, <String>['https://api.local/devices']);
    });

    testWidgets('só o 1º sucesso e o 1º erro mostram exemplo', (
      WidgetTester tester,
    ) async {
      const AppApiEndpoint many = AppApiEndpoint(
        method: AppApiMethod.post,
        path: '/x',
        responses: <AppApiResponse>[
          AppApiResponse(status: 200, exampleJson: '{"ok":1}'),
          AppApiResponse(status: 201, exampleJson: '{"ok":2}'),
          AppApiResponse(status: 400, exampleJson: '{"err":1}'),
          AppApiResponse(status: 409, exampleJson: '{"err":2}'),
          AppApiResponse(status: 500, exampleJson: '{"err":3}'),
        ],
      );

      await tester.pumpWidget(
        _host(
          const AppApiEndpointTile(endpoint: many, initiallyExpanded: true),
        ),
      );
      await tester.pumpAndSettle();

      final String text = _rendered(tester);
      // Um de cada lado — os envelopes de erro são quase idênticos, repetir
      // cinco blocos empurraria a página para baixo sem ensinar nada.
      expect(text.toLowerCase(), contains('{"ok":1}'));
      expect(text.toLowerCase(), contains('{"err":1}'));
      expect(text, isNot(contains('{"ok":2}')));
      expect(text, isNot(contains('{"err":2}')));
      expect(text, isNot(contains('{"err":3}')));
      // Mas TODOS os status continuam listados.
      for (final String s in <String>['200', '201', '400', '409', '500']) {
        expect(text, contains(s), reason: 'status $s sumiu da lista');
      }
    });

    testWidgets('showAllResponseExamples mostra todos', (
      WidgetTester tester,
    ) async {
      const AppApiEndpoint many = AppApiEndpoint(
        method: AppApiMethod.post,
        path: '/x',
        responses: <AppApiResponse>[
          AppApiResponse(status: 200, exampleJson: '{"ok":1}'),
          AppApiResponse(status: 400, exampleJson: '{"err":1}'),
          AppApiResponse(status: 409, exampleJson: '{"err":2}'),
        ],
      );

      await tester.pumpWidget(
        _host(
          const AppApiEndpointTile(
            endpoint: many,
            initiallyExpanded: true,
            showAllResponseExamples: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(_rendered(tester), contains('{"err":2}'));
    });

    testWidgets('expand() abre de fora, via GlobalKey', (
      WidgetTester tester,
    ) async {
      final GlobalKey<AppApiEndpointTileState> key =
          GlobalKey<AppApiEndpointTileState>();

      await tester.pumpWidget(
        _host(AppApiEndpointTile(key: key, endpoint: kListDevices)),
      );
      await tester.pumpAndSettle();
      expect(_rendered(tester), isNot(contains('Respostas')));

      key.currentState!.expand();
      await tester.pumpAndSettle();

      expect(_rendered(tester), contains('Respostas'));
    });
  });

  group('AppApiFlow', () {
    testWidgets('numera os passos e chama onStepTap', (
      WidgetTester tester,
    ) async {
      AppApiFlowStep? tapped;

      await tester.pumpWidget(
        _host(
          AppApiFlow(
            flow: kDeviceFlow,
            onStepTap: (AppApiFlowStep s) => tapped = s,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);

      await tester.tap(
        find.descendant(
          of: find.byType(AppApiFlowStepTile).first,
          matching: find.byType(AppInteraction),
        ),
      );
      await tester.pump();

      expect(tapped?.endpointId, 'POST /devices');
    });

    testWidgets('o conector tem altura de verdade entre os passos', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_host(const AppApiFlow(flow: kDeviceFlow)));
      await tester.pumpAndSettle();

      // Regressão: com constraints frouxas o ColoredBox do trilho encolhia para
      // altura ZERO — a linha existia na árvore e não aparecia na tela.
      final Color divider = AppThemeData.light.colorTheme.divider;
      final Iterable<Element> connectors = find
          .byWidgetPredicate(
            (Widget w) => w is ColoredBox && w.color == divider,
          )
          .evaluate();

      // Um conector por passo, menos o último.
      expect(connectors, hasLength(kDeviceFlow.steps.length - 1));
      for (final Element e in connectors) {
        final Size size = (e.renderObject! as RenderBox).size;
        expect(size.height, greaterThan(0));
        expect(size.width, AppStrokes.s);
      }
    });

    testWidgets('passo sem chamada não desenha a linha de endpoint', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppApiFlow(
            flow: AppApiFlowData(
              title: 'Só narrativa',
              steps: <AppApiFlowStep>[AppApiFlowStep(title: 'Aguarde')],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppApiFlowStepTile), findsNothing);
    });
  });

  group('AppApiDocsPanel', () {
    testWidgets('lista os grupos e o fluxo', (WidgetTester tester) async {
      await tester.pumpWidget(_host(const AppApiDocsPanel(doc: kDevicesDoc)));
      await tester.pumpAndSettle();

      final String text = _rendered(tester);
      expect(text.toLowerCase(), contains('dispositivos'));
      expect(text.toLowerCase(), contains('crud de dispositivos'));
      expect(text.toLowerCase(), contains('associação de chip'));
      expect(
        text.toLowerCase(),
        contains('colocar um dispositivo em operação'),
      );
    });

    testWidgets('a busca filtra os endpoints e mostra o vazio', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_host(const AppApiDocsPanel(doc: kDevicesDoc)));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EditableText), 'sim-card');
      await tester.pumpAndSettle();

      String text = _rendered(tester);
      expect(text.toLowerCase(), contains('associação de chip'));
      expect(text, isNot(contains('CRUD de dispositivos')));

      await tester.enterText(find.byType(EditableText), 'nao-existe');
      // `pump` e não `pumpAndSettle`: o estado vazio traz um AppIllustration,
      // que busca o SVG na CDN e nunca "assenta" no sandbox de teste.
      await tester.pump();
      await tester.pump();

      text = _rendered(tester);
      expect(
        text.toLowerCase(),
        contains('nenhum endpoint casa com o filtro.'),
      );
    });

    testWidgets('tocar um passo do fluxo limpa a busca e abre o endpoint', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_host(const AppApiDocsPanel(doc: kDevicesDoc)));
      await tester.pumpAndSettle();

      // Filtra para fora o alvo, para provar que o reveal limpa a busca.
      await tester.enterText(find.byType(EditableText), 'sim-card');
      await tester.pumpAndSettle();
      expect(_rendered(tester), isNot(contains('Listar devices')));

      await tester.tap(
        find.descendant(
          of: find.byType(AppApiFlowStepTile).at(1),
          matching: find.byType(AppInteraction),
        ),
      );
      await tester.pumpAndSettle();

      final String text = _rendered(tester);
      // Busca limpa: os dois grupos voltaram.
      expect(text.toLowerCase(), contains('listar devices'));
      // E o cartão do passo (POST /associations/device-sim-card) está aberto.
      expect(text.toLowerCase(), contains('corpo da requisição'));
    });
  });

  group('catálogo', () {
    test('todos os componentes do grupo estão registrados como migrados', () {
      for (final String id in <String>[
        'app_api_method_badge',
        'app_api_path',
        'app_api_param_table',
        'app_api_schema_tree',
        'app_api_endpoint_tile',
        'app_api_flow',
        'app_api_docs_panel',
      ]) {
        expect(
          flocksCatalog.any(
            (AppComponentMeta m) =>
                m.id == id && m.status == ComponentStatus.migrated,
          ),
          isTrue,
          reason: '$id fora do flocksCatalog',
        );
      }
    });
  });
}
