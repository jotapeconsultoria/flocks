// As três tools do contrato (ROADMAP, Fase C1), e o despacho que as executa.
//
// Separado de `server.dart` de propósito: aqui não há canal, processo nem
// handshake — só argumentos entrando e `CallToolResult` saindo. É o que deixa
// `test/tools_contract_test.dart` cobrar o contrato inteiro em milissegundos,
// e deixa o `test/protocol_e2e_test.dart` responder a outra pergunta (o
// binário fala MCP?) sem reprovar duas vezes pelo mesmo motivo.
//
// As descriptions são inglesas e escritas para um MODELO decidir QUANDO usar
// cada uma — não para uma pessoa entender o que cada uma faz. Daí dizerem, em
// vez de só nomear parâmetros, que o catálogo é o Flocks (Flutter, zero
// Material) e que `get_component` é a fonte de verdade de props: um modelo que
// não lê isso vai inventar API de Material sobre widget que não é Material.
import 'dart:convert';

import 'package:dart_mcp/server.dart';

import 'catalog.dart';

/// O nome de cada tool, fixado pelo contrato publicado no ROADMAP.
///
/// Sem o prefixo de serviço (`flocks_*`) que a convenção MCP sugeriria para
/// evitar colisão entre servidores: o contrato já circulou assim, e a
/// desambiguação está onde o modelo de fato lê — na primeira frase de cada
/// description.
const String kListComponents = 'list_components';
const String kGetComponent = 'get_component';
const String kSearchComponents = 'search_components';

/// O parâmetro de idioma, idêntico nas três tools.
final StringSchema _langSchema = StringSchema(
  description:
      'Language of the returned prose: "en" or "pt". The catalog is written in '
      'both at the source, field by field, so neither is a translation of the '
      'other and neither is more complete. Defaults to "en".',
);

/// As três tools, na ordem em que o contrato as lista.
///
/// As anotações dizem o que este servidor é: três leituras de um catálogo
/// embarcado. Nada aqui escreve, nada sai para a rede, e chamar duas vezes dá
/// a mesma resposta — `openWorldHint: false` em particular é literal, o dado
/// mora dentro do binário.
final List<Tool> flocksTools = <Tool>[
  Tool(
    name: kListComponents,
    description:
        'List the components of Flocks, the Flutter design system this server '
        'documents — a widgets-only system that uses no Material and no '
        'Cupertino. Returns the id, name and one-line summary of every '
        'component, optionally narrowed to one category. Use it to discover '
        'what exists before writing UI code, or to check whether Flocks '
        'already covers a need. It returns summaries on purpose, not full '
        'specs: once you have picked an id, call $kGetComponent for the props '
        'and the usage rules.',
    annotations: ToolAnnotations(
      readOnlyHint: true,
      destructiveHint: false,
      idempotentHint: true,
      openWorldHint: false,
    ),
    inputSchema: ObjectSchema(
      properties: <String, Schema>{
        'category': StringSchema(
          description:
              'Narrow the list to one category: "atom", "molecule" or '
              '"organism". Omit it to list every component.',
        ),
        'lang': _langSchema,
      },
    ),
  ),
  Tool(
    name: kGetComponent,
    description:
        'Return the full record of one Flocks component: every prop with its '
        'type, whether it is required and its default; when to use it and when '
        'not to; do and don\'t; accessibility behaviour; runnable code '
        'examples; and related component ids. This is the source of truth for '
        'props and usage — prefer it over inferring an API from the component '
        'name, because Flocks is not Material and its widgets do not share '
        "Material's parameter names. Needs a component id such as "
        '"app_badge"; call $kListComponents or $kSearchComponents if you do '
        'not have one.',
    annotations: ToolAnnotations(
      readOnlyHint: true,
      destructiveHint: false,
      idempotentHint: true,
      openWorldHint: false,
    ),
    inputSchema: ObjectSchema(
      properties: <String, Schema>{
        'id': StringSchema(
          description:
              'The component id, snake_case, as returned by $kListComponents '
              'or $kSearchComponents — for example "app_badge".',
        ),
        'lang': _langSchema,
      },
      required: <String>['id'],
    ),
  ),
  Tool(
    name: kSearchComponents,
    description:
        'Search the Flocks component catalog by free text, matching component '
        'names, one-line summaries and full descriptions. Use it when you know '
        'the need but not the name — "status pill", "empty state", "date '
        'field". Matching ignores case and accents, so Portuguese prose is '
        'reachable from an unaccented query. Returns id, name and summary of '
        'every match, name matches first; call $kGetComponent on a result for '
        'the props and the usage rules.',
    annotations: ToolAnnotations(
      readOnlyHint: true,
      destructiveHint: false,
      idempotentHint: true,
      openWorldHint: false,
    ),
    inputSchema: ObjectSchema(
      properties: <String, Schema>{
        'query': StringSchema(
          description: 'Free text to look for. Case- and accent-insensitive.',
        ),
        'lang': _langSchema,
      },
      required: <String>['query'],
    ),
  ),
];

/// Executa a tool [name] com [arguments] contra [catalog].
///
/// Toda recusa sai como `CallToolResult(isError: true)`, dentro do resultado, e
/// nunca como erro de JSON-RPC. A diferença importa: erro de protocolo o
/// cliente trata como falha da conexão e o modelo nem vê; erro no resultado o
/// modelo LÊ — e é lendo que ele troca `"appbadge"` por `"app_badge"` e acerta
/// na segunda tentativa. É a razão de as mensagens do [CatalogQueryError]
/// citarem sempre os valores válidos ou os ids vizinhos.
CallToolResult runTool(
  String name,
  Map<String, Object?> arguments,
  FlocksCatalog catalog,
) {
  try {
    final CatalogLang lang = parseLang(arguments['lang']);
    switch (name) {
      case kListComponents:
        final ComponentCategory? category = parseCategory(
          arguments['category'],
        );
        final List<Map<String, Object?>> components = catalog.list(
          lang: lang,
          category: category,
        );
        return _json(<String, Object?>{
          'lang': lang.name,
          if (category != null) 'category': category.name,
          'count': components.length,
          'components': components,
        });

      case kGetComponent:
        final Object? id = arguments['id'];
        if (id is! String || id.isEmpty) {
          return _error(
            '$kGetComponent requires a non-empty "id", such as "app_badge". '
            'Call $kListComponents to see all ${catalog.entries.length} ids.',
          );
        }
        return _json(<String, Object?>{
          'lang': lang.name,
          'component': catalog.get(id, lang: lang),
        });

      case kSearchComponents:
        final Object? query = arguments['query'];
        if (query is! String) {
          return _error('$kSearchComponents requires a "query" string.');
        }
        final List<Map<String, Object?>> components = catalog.search(
          query,
          lang: lang,
        );
        return _json(<String, Object?>{
          'lang': lang.name,
          'query': query,
          'count': components.length,
          'components': components,
        });

      default:
        return _error(
          'Unknown tool "$name". This server exposes $kListComponents, '
          '$kGetComponent and $kSearchComponents.',
        );
    }
  } on CatalogQueryError catch (e) {
    return _error(e.message);
  }
}

/// Uma resposta de sucesso: o payload como JSON indentado.
///
/// JSON e não prosa porque o dado É estruturado — props com tipo, default e
/// obrigatoriedade — e porque quem lê é um modelo, que perde menos numa árvore
/// do que num parágrafo reconstruído a partir dela.
CallToolResult _json(Map<String, Object?> payload) => CallToolResult(
  content: <Content>[
    Content.text(text: const JsonEncoder.withIndent('  ').convert(payload)),
  ],
);

/// Uma recusa que ensina — ver a nota de [runTool].
CallToolResult _error(String message) => CallToolResult(
  isError: true,
  content: <Content>[Content.text(text: message)],
);
