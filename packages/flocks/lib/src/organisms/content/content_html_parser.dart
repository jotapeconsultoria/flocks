import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

import 'content_node.dart';

/// Converte HTML para a árvore normalizada [ContentNode], aplicando uma
/// allow-list.
///
/// Ao contrário do Markdown (que vem da nossa própria IA), o HTML aqui é
/// **servido pelo backend** — política de privacidade, termos de uso. É tratado
/// como não confiável: tags executáveis são descartadas com a subárvore, e
/// `href`/`src` passam por validação de esquema.
///
/// A regra de degradação é deliberada: *nunca perder texto*. Uma tag
/// desconhecida não some — vira os próprios filhos. Isso torna o renderer
/// robusto ao markup que um CMS venha a emitir sem exigir uma allow-list
/// exaustiva.
sealed class ContentHtmlParser {
  /// Parseia [data] e devolve os nós de topo.
  ///
  /// Aceita tanto documento completo quanto fragmento: `parse` normaliza os
  /// dois para `html > body`. Nunca lança.
  static List<ContentNode> parse(String data) {
    if (data.trim().isEmpty) {
      return const <ContentNode>[];
    }

    try {
      final dom.Document document = html_parser.parse(data);
      final List<dom.Node> roots = document.body?.nodes ?? document.nodes;
      return _convertAll(roots);
    } on Object {
      return <ContentNode>[
        ContentElement(tag: 'p', children: <ContentNode>[ContentText(data)]),
      ];
    }
  }

  static List<ContentNode> _convertAll(List<dom.Node> nodes) => <ContentNode>[
    for (final dom.Node node in nodes) ?_convert(node),
  ];

  static ContentNode? _convert(dom.Node node) {
    if (node is dom.Text) {
      final String text = node.data;
      return text.isEmpty ? null : ContentText(text);
    }
    if (node is! dom.Element) {
      // Comentários, doctype e afins não têm representação visual.
      return null;
    }

    final String tag = (node.localName ?? '').toLowerCase();
    if (tag.isEmpty || ContentTags.isDropped(tag)) {
      return null;
    }

    return ContentElement(
      tag: tag,
      attributes: _sanitizeAttributes(tag, node.attributes),
      children: _convertAll(node.nodes),
    );
  }

  /// Copia só os atributos que o renderer usa, validando URLs.
  static Map<String, String> _sanitizeAttributes(
    String tag,
    Map<Object, String> raw,
  ) {
    final Map<String, String> result = <String, String>{};
    for (final MapEntry<Object, String> entry in raw.entries) {
      final String key = entry.key.toString().toLowerCase();
      if (!_keptAttributes.contains(key)) {
        continue;
      }
      if (key == 'href' || key == 'src') {
        final String? safe = sanitizeContentUrl(entry.value);
        if (safe == null) {
          continue;
        }
        result[key] = safe;
        continue;
      }
      result[key] = entry.value;
    }
    return Map<String, String>.unmodifiable(result);
  }

  static const Set<String> _keptAttributes = <String>{
    'href',
    'src',
    'alt',
    'title',
    'start',
    'class',
    'colspan',
    'rowspan',
  };
}

/// Esquemas de URL aceitos para links e imagens.
///
/// Bloqueia `javascript:`, `data:` e `file:` — vetores clássicos em HTML de
/// terceiros. URLs relativas e protocol-relative são aceitas (não carregam
/// esquema executável).
const Set<String> kContentSafeUrlSchemes = <String>{
  'http',
  'https',
  'mailto',
  'tel',
  'sms',
};

/// Devolve [url] se for segura para abrir/carregar, ou `null` se não for.
String? sanitizeContentUrl(String url) {
  final String trimmed = url.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  final Uri? parsed = Uri.tryParse(trimmed);
  if (parsed == null) {
    return null;
  }
  if (!parsed.hasScheme) {
    // Relativa ("/termos", "#secao", "img/logo.png") — sem esquema executável.
    return trimmed;
  }
  return kContentSafeUrlSchemes.contains(parsed.scheme.toLowerCase())
      ? trimmed
      : null;
}
