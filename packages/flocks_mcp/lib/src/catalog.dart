// A camada de consulta do catálogo, em Dart puro — sem MCP, sem JSON-RPC.
//
// A separação não é estética. Os testes de contrato (131 componentes, o `pt`
// de `app_badge`, a sugestão de id) exercitam ESTAS funções diretamente, sem
// subir processo, e o `test/protocol_e2e_test.dart` cuida da outra pergunta —
// se o binário fala o protocolo. Uma suíte responde "a resposta está certa?",
// a outra "a resposta chega?", e nenhuma das duas paga o custo da outra.
import 'dart:convert';

import 'catalog_data.g.dart';

/// Os dois idiomas em que o catálogo é escrito.
///
/// Bilíngue NA FONTE, campo a campo — não é tradução automática nem fallback:
/// cada componente tem prosa inglesa e prosa portuguesa escritas à mão. Por
/// isso não existe "idioma faltando" a compensar.
enum CatalogLang {
  en,
  pt;

  /// O idioma padrão de todas as tools.
  static const CatalogLang fallback = CatalogLang.en;

  /// Os valores válidos, para as mensagens de erro.
  static String get valid =>
      CatalogLang.values.map((CatalogLang l) => '"${l.name}"').join(', ');
}

/// A taxonomia do design system.
enum ComponentCategory {
  atom,
  molecule,
  organism;

  /// Os valores válidos, para as mensagens de erro.
  static String get valid => ComponentCategory.values
      .map((ComponentCategory c) => '"${c.name}"')
      .join(', ');
}

/// Uma pergunta que o catálogo não pode responder, com o motivo escrito para
/// quem vai lê-lo.
///
/// O consumidor deste servidor é um MODELO, e um modelo se corrige a partir do
/// texto do erro — mas só se o texto disser o que era válido. Daí a regra
/// desta classe: nenhuma mensagem apenas recusa; toda mensagem aponta a saída
/// (os valores aceitos, os ids parecidos, a tool que lista tudo).
class CatalogQueryError implements Exception {
  /// Cria o erro com a [message] que o chamador vai ler.
  const CatalogQueryError(this.message);

  /// O texto exibido — já escrito para o consumidor, não para um log.
  final String message;

  @override
  String toString() => message;
}

/// Colapsa a prosa bilíngue de [node] para [lang].
///
/// Caminha o JSON e, em todo `Map` cujas chaves são exatamente `{en, pt}`,
/// devolve só o lado pedido. Genérico de propósito: o mesmo passe resolve
/// `summary`, `description`, `a11y`, as listas (`whenToUse`, `do`, `dont`…),
/// `props[].description` e `examples[].title` — e resolve sozinho qualquer
/// campo bilíngue que o schema do catálogo ganhe depois, sem virar uma lista
/// de nomes de campo para manter em dia com o pacote irmão.
Object? resolveLang(Object? node, CatalogLang lang) {
  if (node is Map<String, Object?>) {
    if (node.length == 2 && node.containsKey('en') && node.containsKey('pt')) {
      return node[lang.name];
    }
    return <String, Object?>{
      for (final MapEntry<String, Object?> e in node.entries)
        e.key: resolveLang(e.value, lang),
    };
  }
  if (node is List<Object?>) {
    return <Object?>[for (final Object? item in node) resolveLang(item, lang)];
  }
  return node;
}

/// Dobra caixa e acentos, para a busca casar `"seleção"` com `"selecao"`.
///
/// Metade da prosa do catálogo é portuguesa, e sem a dobra `search_components`
/// devolveria resultados diferentes conforme o teclado de quem pergunta — o
/// tipo de comportamento que faz um consumidor concluir que a busca não
/// funciona.
String foldForSearch(String input) {
  const Map<String, String> accents = <String, String>{
    'á': 'a',
    'à': 'a',
    'â': 'a',
    'ã': 'a',
    'ä': 'a',
    'é': 'e',
    'è': 'e',
    'ê': 'e',
    'ë': 'e',
    'í': 'i',
    'ì': 'i',
    'î': 'i',
    'ï': 'i',
    'ó': 'o',
    'ò': 'o',
    'ô': 'o',
    'õ': 'o',
    'ö': 'o',
    'ú': 'u',
    'ù': 'u',
    'û': 'u',
    'ü': 'u',
    'ç': 'c',
    'ñ': 'n',
  };
  final StringBuffer out = StringBuffer();
  for (final String ch in input.toLowerCase().split('')) {
    out.write(accents[ch] ?? ch);
  }
  return out.toString();
}

/// Distância de edição entre [a] e [b], usada para sugerir ids próximos.
int editDistance(String a, String b) {
  if (a == b) {
    return 0;
  }
  List<int> previous = List<int>.generate(b.length + 1, (int i) => i);
  for (int i = 1; i <= a.length; i++) {
    final List<int> current = <int>[i, ...List<int>.filled(b.length, 0)];
    for (int j = 1; j <= b.length; j++) {
      final int cost = a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1) ? 0 : 1;
      current[j] = <int>[
        current[j - 1] + 1,
        previous[j] + 1,
        previous[j - 1] + cost,
      ].reduce((int x, int y) => x < y ? x : y);
    }
    previous = current;
  }
  return previous[b.length];
}

/// Lê o `lang` que chegou na chamada, ou [CatalogLang.fallback] se veio nulo.
///
/// Ausente é legítimo (o parâmetro é opcional e tem padrão); presente e
/// inválido é erro — e o erro diz o que valia.
CatalogLang parseLang(Object? raw) {
  if (raw == null) {
    return CatalogLang.fallback;
  }
  for (final CatalogLang lang in CatalogLang.values) {
    if (lang.name == raw) {
      return lang;
    }
  }
  throw CatalogQueryError(
    'Unknown lang "$raw". Valid values: ${CatalogLang.valid}. '
    'The catalog is written in both languages at the source, so there is no '
    'partial coverage to work around.',
  );
}

/// Lê o `category` que chegou na chamada. Nulo significa "todas".
ComponentCategory? parseCategory(Object? raw) {
  if (raw == null) {
    return null;
  }
  for (final ComponentCategory category in ComponentCategory.values) {
    if (category.name == raw) {
      return category;
    }
  }
  throw CatalogQueryError(
    'Unknown category "$raw". Valid values: ${ComponentCategory.valid}. '
    'Omit the parameter to list every component.',
  );
}

/// O catálogo de componentes do Flocks, consultável.
class FlocksCatalog {
  /// Constrói a partir do JSON serializado do `flocks`.
  FlocksCatalog.fromJson(String json)
    : entries = List<Map<String, Object?>>.unmodifiable(
        (jsonDecode(json) as List<Object?>).cast<Map<String, Object?>>().map(
          Map<String, Object?>.unmodifiable,
        ),
      );

  /// O catálogo embarcado — o que o servidor serve.
  ///
  /// `static final` é preguiçoso em Dart: os 490 KB só são decodificados se
  /// alguém perguntar, e uma vez só. Um `initialize` do MCP que não chame tool
  /// nenhuma não paga o parse.
  static final FlocksCatalog embedded = FlocksCatalog.fromJson(kCatalogJson);

  /// Todos os componentes, na ordem em que o `flocks` os serializa.
  final List<Map<String, Object?>> entries;

  /// Os ids conhecidos, na mesma ordem.
  List<String> get ids => <String>[
    for (final Map<String, Object?> e in entries) e['id']! as String,
  ];

  /// `{id, name, summary}` de cada componente, opcionalmente de uma categoria.
  ///
  /// O recorte é o do contrato (ROADMAP, Fase C1): o suficiente para o modelo
  /// escolher, e não a ficha inteira de 131 componentes — que seriam ~490 KB
  /// numa resposta só. A ficha vem por [get].
  List<Map<String, Object?>> list({
    required CatalogLang lang,
    ComponentCategory? category,
  }) => <Map<String, Object?>>[
    for (final Map<String, Object?> entry in entries)
      if (category == null || entry['category'] == category.name)
        _digest(entry, lang),
  ];

  /// A ficha completa de [id], resolvida em [lang].
  ///
  /// Lança [CatalogQueryError] com os ids mais próximos quando não conhece o
  /// pedido — o consumidor é um modelo, e um id vizinho é o que o faz acertar
  /// na segunda tentativa em vez de desistir.
  Map<String, Object?> get(String id, {required CatalogLang lang}) {
    for (final Map<String, Object?> entry in entries) {
      if (entry['id'] == id) {
        return resolveLang(entry, lang)! as Map<String, Object?>;
      }
    }
    final List<String> near = suggestIds(id);
    throw CatalogQueryError(
      'Unknown component id "$id". '
      '${near.isEmpty ? 'No known id looks close.' : 'Did you mean: ${near.map((String s) => '"$s"').join(', ')}?'} '
      'Call list_components to see all ${entries.length} ids.',
    );
  }

  /// Busca [query] em `name`, `summary` e `description` do idioma pedido.
  ///
  /// Ordenado por onde casou — nome antes de summary, summary antes de
  /// descrição —, porque quem busca "badge" quer o `AppBadge` primeiro e não
  /// os oito componentes cuja descrição menciona badges.
  List<Map<String, Object?>> search(String query, {required CatalogLang lang}) {
    // `trim` antes do teste de vazio: `query: "  "` é uma pergunta vazia com
    // outra roupa, e devolver "0 resultados" para ela mandaria o consumidor
    // concluir que o catálogo não tem nada — em vez de que ele não perguntou.
    final String needle = foldForSearch(query.trim());
    if (needle.isEmpty) {
      throw const CatalogQueryError(
        'search_components requires a non-empty "query". '
        'To browse instead of search, call list_components.',
      );
    }
    final List<Map<String, Object?>> byName = <Map<String, Object?>>[];
    final List<Map<String, Object?>> bySummary = <Map<String, Object?>>[];
    final List<Map<String, Object?>> byDescription = <Map<String, Object?>>[];
    for (final Map<String, Object?> entry in entries) {
      final bool inName =
          foldForSearch(entry['name']! as String).contains(needle) ||
          foldForSearch(entry['id']! as String).contains(needle);
      final bool inSummary = foldForSearch(
        _localized(entry, 'summary', lang),
      ).contains(needle);
      final bool inDescription = foldForSearch(
        _localized(entry, 'description', lang),
      ).contains(needle);
      if (inName) {
        byName.add(_digest(entry, lang));
      } else if (inSummary) {
        bySummary.add(_digest(entry, lang));
      } else if (inDescription) {
        byDescription.add(_digest(entry, lang));
      }
    }
    return <Map<String, Object?>>[...byName, ...bySummary, ...byDescription];
  }

  /// Até cinco ids próximos de [id], para a mensagem de erro de [get].
  ///
  /// Duas peneiras: substring nos dois sentidos (`"badge"` acha `"app_badge"`,
  /// e `"app_badge_large"` acha `"app_badge"`) e distância de edição até 3
  /// (`"appbadge"`, `"app_bagde"`). Ordenadas pela distância, que põe o
  /// palpite mais provável primeiro.
  List<String> suggestIds(String id) {
    final String needle = foldForSearch(id);
    final List<MapEntry<String, int>> scored = <MapEntry<String, int>>[];
    for (final String known in ids) {
      final String folded = foldForSearch(known);
      final int distance = editDistance(needle, folded);
      final bool overlaps = folded.contains(needle) || needle.contains(folded);
      if (overlaps || distance <= 3) {
        scored.add(MapEntry<String, int>(known, overlaps ? -1 : distance));
      }
    }
    scored.sort((MapEntry<String, int> a, MapEntry<String, int> b) {
      final int byScore = a.value.compareTo(b.value);
      return byScore != 0 ? byScore : a.key.compareTo(b.key);
    });
    return <String>[
      for (final MapEntry<String, int> e in scored.take(5)) e.key,
    ];
  }

  /// O `{id, name, summary}` de um componente, no idioma pedido.
  Map<String, Object?> _digest(Map<String, Object?> entry, CatalogLang lang) =>
      <String, Object?>{
        'id': entry['id'],
        'name': entry['name'],
        'summary': _localized(entry, 'summary', lang),
      };

  /// O campo [field] de [entry] no idioma pedido, ou vazio se ele não existe.
  ///
  /// Nem todo componente tem `description` (126 dos 131 têm), e busca em campo
  /// ausente é string vazia, não exceção.
  String _localized(
    Map<String, Object?> entry,
    String field,
    CatalogLang lang,
  ) {
    final Object? value = entry[field];
    if (value is Map<String, Object?>) {
      return value[lang.name] as String? ?? '';
    }
    return '';
  }
}
