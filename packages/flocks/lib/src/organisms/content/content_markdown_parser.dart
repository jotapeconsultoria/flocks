import 'package:markdown/markdown.dart' as md;

import 'content_node.dart';

/// Converte Markdown (GitHub-Flavored) para a árvore normalizada
/// [ContentNode].
///
/// Lê a **AST** do `package:markdown` diretamente. A implementação anterior
/// convertia Markdown → string HTML só para um renderer de HTML re-parsear;
/// o caminho por HTML é desnecessário e perdia informação de estrutura.
sealed class ContentMarkdownParser {
  /// Parseia [data] e devolve os nós de topo.
  ///
  /// Nunca lança: entrada malformada ou parcial (o caso do chat em streaming,
  /// com cercas de código e tabelas ainda não fechadas) degrada para o melhor
  /// resultado possível, no pior caso um parágrafo com o texto cru.
  static List<ContentNode> parse(String data) {
    if (data.trim().isEmpty) {
      return const <ContentNode>[];
    }

    try {
      final md.Document document = md.Document(
        extensionSet: md.ExtensionSet.gitHubWeb,
        // Renderizamos para widgets, não para HTML. Com o default (`true`) o
        // parser escaparia o texto e `<`, `&` e aspas apareceriam na tela como
        // `&lt;`, `&amp;`, `&quot;`.
        encodeHtml: false,
      );
      final List<md.Node> nodes = document.parseLines(splitContentLines(data));
      return _convertAll(nodes);
    } on Object {
      // Blindagem: o parser é tolerante, mas um documento adversário não pode
      // derrubar a tela que o exibe.
      return <ContentNode>[
        ContentElement(tag: 'p', children: <ContentNode>[ContentText(data)]),
      ];
    }
  }

  static List<ContentNode> _convertAll(List<md.Node> nodes) => <ContentNode>[
    for (final md.Node node in nodes) ?_convert(node),
  ];

  static ContentNode? _convert(md.Node node) {
    if (node is md.Text) {
      return ContentText(_decodeEntities(node.text));
    }
    if (node is md.UnparsedContent) {
      return ContentText(_decodeEntities(node.textContent));
    }
    if (node is! md.Element) {
      return null;
    }

    final String tag = node.tag.toLowerCase();

    // O parser emite tag vazia para HTML cru embutido. Tratamos como texto
    // literal: Markdown de fonte não confiável não deve virar markup ativo.
    if (tag.isEmpty) {
      final String raw = node.textContent;
      return raw.isEmpty ? null : ContentText(raw);
    }

    if (ContentTags.isDropped(tag)) {
      return null;
    }

    return ContentElement(
      tag: tag,
      attributes: Map<String, String>.unmodifiable(node.attributes),
      children: _convertAll(node.children ?? const <md.Node>[]),
    );
  }

  /// Decodifica as referências de caractere que o parser deixa passar quando
  /// `encodeHtml` está desligado (`&amp;` precisa virar `&` na tela).
  static String _decodeEntities(String input) {
    if (!input.contains('&')) {
      return input;
    }
    return input.replaceAllMapped(_entityPattern, (Match match) {
      final String body = match.group(1)!;
      if (body.startsWith('#')) {
        final bool isHex =
            body.length > 1 && (body[1] == 'x' || body[1] == 'X');
        final int? code = int.tryParse(
          isHex ? body.substring(2) : body.substring(1),
          radix: isHex ? 16 : 10,
        );
        if (code == null || code < 0 || code > 0x10FFFF) {
          return match.group(0)!;
        }
        return String.fromCharCode(code);
      }
      return _namedEntities[body] ?? match.group(0)!;
    });
  }

  static final RegExp _entityPattern = RegExp(r'&(#[xX]?[0-9a-fA-F]+|\w+);');

  static const Map<String, String> _namedEntities = <String, String>{
    'amp': '&',
    'lt': '<',
    'gt': '>',
    'quot': '"',
    'apos': "'",
    'nbsp': ' ',
    'hellip': '…',
    'mdash': '—',
    'ndash': '–',
    'lsquo': '‘',
    'rsquo': '’',
    'ldquo': '“',
    'rdquo': '”',
    'copy': '©',
    'reg': '®',
    'trade': '™',
    'deg': '°',
    'middot': '·',
    'bull': '•',
    'eacute': 'é',
    'ccedil': 'ç',
    'atilde': 'ã',
    'otilde': 'õ',
  };
}

/// Quebra o texto em linhas aceitando `\n`, `\r\n` e `\r`.
///
/// `String.split('\n')` deixaria um `\r` residual no fim de cada linha em
/// conteúdo vindo de backends Windows, o que quebra o casamento de cercas de
/// código e de separadores de tabela.
List<String> splitContentLines(String input) => input.split(_lineBreakPattern);

final RegExp _lineBreakPattern = RegExp(r'\r\n|\r|\n');
