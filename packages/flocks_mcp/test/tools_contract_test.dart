// O contrato das três tools, contra o catálogo REAL embarcado.
//
// Nada de fixture: se o teste rodasse sobre dois componentes inventados, ele
// provaria que o código compila e nada sobre o que o servidor entrega. Os
// números aqui (132 componentes, 24·72·36 por categoria) são os do catálogo de
// verdade, e é de propósito que envelheçam junto com ele — quando o `flocks`
// ganhar o 133º, este arquivo fica vermelho e alguém decide conscientemente se
// o contrato mudou. É o mesmo princípio dos gates de contagem do pacote irmão.
//
// A camada exercitada é `runTool`, não o processo: argumentos entrando,
// `CallToolResult` saindo. Se o binário fala MCP é a pergunta do
// `protocol_e2e_test.dart`, e as duas não se sobrepõem.
import 'dart:convert';

import 'package:dart_mcp/server.dart';
import 'package:flocks_mcp/flocks_mcp.dart';
import 'package:test/test.dart';

/// O catálogo embarcado — o mesmo objeto que o servidor serve.
final FlocksCatalog catalog = FlocksCatalog.embedded;

/// Chama uma tool e devolve o JSON já decodificado, falhando se veio erro.
Map<String, Object?> call(String tool, [Map<String, Object?> args = const {}]) {
  final CallToolResult result = runTool(tool, args, catalog);
  expect(
    result.isError ?? false,
    isFalse,
    reason: 'Esperava sucesso, veio erro: ${text(result)}',
  );
  return jsonDecode(text(result)) as Map<String, Object?>;
}

/// Chama uma tool esperando recusa, e devolve a mensagem que o modelo leria.
String callExpectingError(String tool, Map<String, Object?> args) {
  final CallToolResult result = runTool(tool, args, catalog);
  expect(
    result.isError,
    isTrue,
    reason: 'Esperava erro, veio sucesso: ${text(result)}',
  );
  return text(result);
}

/// O texto de um resultado — as três tools só devolvem [TextContent].
String text(CallToolResult result) =>
    (result.content.single as TextContent).text;

void main() {
  group('list_components', () {
    test('devolve os 132 componentes do catálogo', () {
      final Map<String, Object?> out = call('list_components');
      expect(out['count'], 132);
      expect((out['components']! as List<Object?>).length, 132);
      expect(out['lang'], 'en');
    });

    test('cada item traz id, name e summary — e nada além', () {
      // O contrato do ROADMAP diz "id, nome e summary de cada componente". O
      // recorte é a razão de a tool existir separada de `get_component`:
      // devolver as 132 fichas inteiras seriam ~490 KB numa resposta só.
      final Map<String, Object?> first =
          (call('list_components')['components']! as List<Object?>).first
              as Map<String, Object?>;
      expect(first.keys, <String>['id', 'name', 'summary']);
      expect(first['summary'], isA<String>());
    });

    test('as três categorias particionam o catálogo', () {
      final int atoms =
          call('list_components', <String, Object?>{
                'category': 'atom',
              })['count']!
              as int;
      final int molecules =
          call('list_components', <String, Object?>{
                'category': 'molecule',
              })['count']!
              as int;
      final int organisms =
          call('list_components', <String, Object?>{
                'category': 'organism',
              })['count']!
              as int;
      expect(<int>[atoms, molecules, organisms], <int>[24, 72, 36]);
      expect(atoms + molecules + organisms, 132);
    });

    test('categoria inválida erra dizendo as válidas', () {
      final String message = callExpectingError(
        'list_components',
        <String, Object?>{'category': 'widget'},
      );
      expect(message, contains('"widget"'));
      expect(message, contains('"atom", "molecule", "organism"'));
    });
  });

  group('get_component', () {
    test('app_badge vem em inglês por padrão', () {
      final Map<String, Object?> component =
          call('get_component', <String, Object?>{
                'id': 'app_badge',
              })['component']!
              as Map<String, Object?>;
      expect(component['name'], 'AppBadge');
      expect(
        component['summary'],
        'Compact status pill, tinted by a semantic color role.',
      );
    });

    test('app_badge vem em português quando lang é pt', () {
      final Map<String, Object?> component =
          call('get_component', <String, Object?>{
                'id': 'app_badge',
                'lang': 'pt',
              })['component']!
              as Map<String, Object?>;
      expect(
        component['summary'],
        'Pill compacta de status, tingida por papel de cor semântico.',
      );
      expect(
        (component['whenToUse']! as List<Object?>).first,
        startsWith('Rótulo de estado/categoria'),
      );
    });

    test('a ficha traz props, uso, do/dont, a11y, exemplos e relacionados', () {
      // A promessa da coluna "Devolve" do contrato, item a item. Sem isto o
      // teste acima passaria com uma ficha pela metade.
      final Map<String, Object?> component =
          call('get_component', <String, Object?>{
                'id': 'app_badge',
              })['component']!
              as Map<String, Object?>;
      for (final String field in <String>[
        'props',
        'whenToUse',
        'whenNotToUse',
        'do',
        'dont',
        'a11y',
        'examples',
        'related',
      ]) {
        expect(
          component[field],
          isNotNull,
          reason: 'A ficha perdeu o campo `$field`.',
        );
      }
      final Map<String, Object?> label =
          (component['props']! as List<Object?>).first as Map<String, Object?>;
      expect(label['name'], 'label');
      expect(label['type'], 'String');
      expect(label['required'], isTrue);
      expect(label['description'], isA<String>());
    });

    test('nenhum {en, pt} sobrevive na resposta', () {
      // A resolução de idioma é recursiva de propósito — se ela parasse na
      // superfície, `props[].description` e `examples[].title` chegariam ao
      // modelo como objetos bilíngues, e ele teria que adivinhar qual ler.
      bool hasBilingual(Object? node) {
        if (node is Map<String, Object?>) {
          if (node.length == 2 &&
              node.containsKey('en') &&
              node.containsKey('pt')) {
            return true;
          }
          return node.values.any(hasBilingual);
        }
        if (node is List<Object?>) {
          return node.any(hasBilingual);
        }
        return false;
      }

      for (final String lang in <String>['en', 'pt']) {
        for (final String id in <String>[
          'app_badge',
          'app_text',
          'app_data_table',
        ]) {
          expect(
            hasBilingual(
              call('get_component', <String, Object?>{'id': id, 'lang': lang}),
            ),
            isFalse,
            reason: 'Sobrou prosa bilíngue em $id ($lang).',
          );
        }
      }
    });

    test('id inexistente sugere os vizinhos', () {
      final String message = callExpectingError(
        'get_component',
        <String, Object?>{'id': 'appbadge'},
      );
      expect(message, contains('Unknown component id "appbadge"'));
      expect(message, contains('"app_badge"'));
      expect(message, contains('list_components'));
      expect(message, contains('132'));
    });

    test('id sem nenhum vizinho ainda aponta a saída', () {
      final String message = callExpectingError(
        'get_component',
        <String, Object?>{'id': 'zzzzzzzzzzzzzzzz'},
      );
      expect(message, contains('No known id looks close'));
      expect(message, contains('list_components'));
    });

    test('id ausente diz qual parâmetro falta', () {
      final String message = callExpectingError(
        'get_component',
        const <String, Object?>{},
      );
      expect(message, contains('requires a non-empty "id"'));
      expect(message, contains('"app_badge"'));
    });
  });

  group('search_components', () {
    test('acha por termo do summary', () {
      final Map<String, Object?> out = call(
        'search_components',
        <String, Object?>{'query': 'status pill'},
      );
      expect(out['count'], greaterThan(0));
      expect(<String>[
        for (final Object? c in out['components']! as List<Object?>)
          (c! as Map<String, Object?>)['id']! as String,
      ], contains('app_badge'));
    });

    test('casa por nome antes de casar por prosa', () {
      final Map<String, Object?> out = call(
        'search_components',
        <String, Object?>{'query': 'badge'},
      );
      final List<Object?> components = out['components']! as List<Object?>;
      expect(
        (components.first! as Map<String, Object?>)['id'],
        'app_badge',
        reason:
            'Quem busca "badge" quer o AppBadge primeiro, não os componentes '
            'cuja descrição menciona badges.',
      );
    });

    test('query de várias palavras atravessa o snake_case do id', () {
      // O caso que motivou a busca por termos: `"data table"` tem que achar o
      // `app_data_table`. Com substring da frase inteira ele não achava — a
      // fronteira cai num underscore —, e "data table" é literalmente como um
      // modelo formula a pergunta.
      final Map<String, Object?> out = call(
        'search_components',
        <String, Object?>{'query': 'data table'},
      );
      final List<String> ids = <String>[
        for (final Object? c in out['components']! as List<Object?>)
          (c! as Map<String, Object?>)['id']! as String,
      ];
      expect(ids, contains('app_data_table'));
      expect(ids, contains('app_simple_data_table'));
    });

    test('ignora acento, para a prosa portuguesa ser alcançável', () {
      final Map<String, Object?> comAcento = call(
        'search_components',
        <String, Object?>{'query': 'seleção', 'lang': 'pt'},
      );
      final Map<String, Object?> semAcento = call(
        'search_components',
        <String, Object?>{'query': 'selecao', 'lang': 'pt'},
      );
      expect(comAcento['count'], greaterThan(0));
      expect(semAcento['count'], comAcento['count']);
    });

    test('query vazia erra apontando o list_components', () {
      final String message = callExpectingError(
        'search_components',
        <String, Object?>{'query': '  '},
      );
      expect(message, contains('non-empty "query"'));
      expect(message, contains('list_components'));
    });
  });

  group('lang', () {
    test('o padrão é en nas três tools', () {
      for (final Map<String, Object?> out in <Map<String, Object?>>[
        call('list_components'),
        call('get_component', <String, Object?>{'id': 'app_badge'}),
        call('search_components', <String, Object?>{'query': 'badge'}),
      ]) {
        expect(out['lang'], 'en');
      }
    });

    test('valor inválido erra dizendo os válidos, nas três tools', () {
      for (final MapEntry<String, Map<String, Object?>> entry
          in <String, Map<String, Object?>>{
            'list_components': <String, Object?>{'lang': 'fr'},
            'get_component': <String, Object?>{'id': 'app_badge', 'lang': 'fr'},
            'search_components': <String, Object?>{
              'query': 'badge',
              'lang': 'fr',
            },
          }.entries) {
        final String message = callExpectingError(entry.key, entry.value);
        expect(message, contains('Unknown lang "fr"'));
        expect(message, contains('"en", "pt"'));
      }
    });
  });

  group('as tools declaradas', () {
    test('são as três do contrato, com description e schema', () {
      expect(
        <String>[for (final Tool t in flocksTools) t.name],
        <String>['list_components', 'get_component', 'search_components'],
      );
      for (final Tool tool in flocksTools) {
        expect(tool.description, isNotNull);
        expect(tool.description!.length, greaterThan(120));
        expect(
          tool.description,
          contains('Flocks'),
          reason:
              'A description é onde o modelo descobre de que catálogo se trata '
              '— as tools não têm prefixo de serviço no nome.',
        );
        expect(tool.inputSchema.properties!.keys, contains('lang'));
        expect(tool.toolAnnotations!.readOnlyHint, isTrue);
        expect(tool.toolAnnotations!.openWorldHint, isFalse);
      }
    });

    test('id e query são obrigatórios no schema', () {
      Tool byName(String name) =>
          flocksTools.firstWhere((Tool t) => t.name == name);
      expect(byName('get_component').inputSchema.required, <String>['id']);
      expect(byName('search_components').inputSchema.required, <String>[
        'query',
      ]);
      expect(byName('list_components').inputSchema.required, isNull);
    });
  });

  test('tool desconhecida erra listando as que existem', () {
    final String message = callExpectingError(
      'delete_component',
      const <String, Object?>{},
    );
    expect(message, contains('Unknown tool "delete_component"'));
    expect(message, contains('list_components'));
  });
}
