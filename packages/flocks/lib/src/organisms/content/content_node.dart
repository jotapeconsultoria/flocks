import 'package:flutter/widgets.dart';

/// Árvore normalizada de conteúdo rico — a fronteira entre *parsear* e
/// *renderizar*.
///
/// Markdown e HTML chegam por parsers diferentes (`package:markdown` e
/// `package:html`), mas as duas ASTs têm a mesma forma: uma árvore de tags. Os
/// adapters convertem ambas para [ContentNode], e daí um único renderer atende
/// os dois — é isso que garante que um mesmo documento fique **visualmente
/// idêntico** vindo de Markdown ou de HTML.
///
/// Os nomes de tag seguem a convenção HTML (`p`, `strong`, `ul`…) porque o
/// GitHub-Flavored Markdown já emite exatamente esse vocabulário.
@immutable
sealed class ContentNode {
  const ContentNode();
}

/// Folha de texto puro.
@immutable
final class ContentText extends ContentNode {
  const ContentText(this.text);

  /// O texto já decodificado (sem entidades HTML pendentes).
  final String text;

  @override
  String toString() => 'ContentText("$text")';
}

/// Elemento nomeado, com atributos e filhos.
@immutable
final class ContentElement extends ContentNode {
  const ContentElement({
    required this.tag,
    this.attributes = const <String, String>{},
    this.children = const <ContentNode>[],
  });

  /// Nome da tag em minúsculas (`p`, `h1`, `strong`, `a`…).
  final String tag;

  /// Atributos relevantes ao render (`href`, `src`, `alt`, `start`, `class`…).
  final Map<String, String> attributes;

  /// Filhos na ordem do documento.
  final List<ContentNode> children;

  /// Concatenação recursiva do texto dos descendentes.
  ///
  /// É o fallback usado quando um nó não pode ser renderizado com fidelidade:
  /// perde-se a formatação, nunca o conteúdo.
  String get textContent => children.map(contentTextOf).join();

  @override
  String toString() => 'ContentElement(<$tag>, ${children.length} filhos)';
}

/// Texto de um [ContentNode] qualquer (recursivo para elementos).
String contentTextOf(ContentNode node) => switch (node) {
  ContentText(:final String text) => text,
  ContentElement(:final String textContent) => textContent,
};

/// Taxonomia de tags: decide o que é bloco, o que é inline, o que passa direto
/// e o que é descartado.
///
/// A allow-list existe para o [AppHtml], cuja entrada vem do backend e não é
/// confiável. O Markdown emite um conjunto fechado que já cabe aqui.
sealed class ContentTags {
  /// Tags de bloco com render próprio.
  static const Set<String> blocks = <String>{
    'p',
    'h1',
    'h2',
    'h3',
    'h4',
    'h5',
    'h6',
    'ul',
    'ol',
    'li',
    'blockquote',
    'pre',
    'hr',
    'table',
    'thead',
    'tbody',
    'tfoot',
    'tr',
    'th',
    'td',
  };

  /// Containers sem semântica visual própria: renderizam os filhos como blocos.
  ///
  /// É o que torna o renderer robusto a markup de CMS — um `<div>` aninhado
  /// dez vezes não muda o resultado.
  static const Set<String> passthroughBlocks = <String>{
    'html',
    'body',
    'main',
    'div',
    'section',
    'article',
    'aside',
    'header',
    'footer',
    'figure',
    'figcaption',
    'nav',
    'dl',
    'dt',
    'dd',
  };

  /// Tags inline com render próprio.
  static const Set<String> inlines = <String>{
    'strong',
    'b',
    'em',
    'i',
    'u',
    's',
    'del',
    'strike',
    'code',
    'a',
    'span',
    'sup',
    'sub',
    'img',
    'br',
    'mark',
    'small',
  };

  /// Tags cujo **nó e subárvore inteira** são descartados.
  ///
  /// Conteúdo executável ou de metadados: nunca deve virar texto visível, ao
  /// contrário das tags desconhecidas (que degradam preservando o texto).
  static const Set<String> dropped = <String>{
    'script',
    'style',
    'iframe',
    'object',
    'embed',
    'applet',
    'svg',
    'canvas',
    'form',
    'input',
    'select',
    'option',
    'textarea',
    'button',
    'link',
    'meta',
    'head',
    'title',
    'noscript',
    'template',
  };

  /// Se [tag] participa do fluxo de blocos.
  static bool isBlock(String tag) =>
      blocks.contains(tag) || passthroughBlocks.contains(tag);

  /// Se [tag] participa do fluxo inline.
  static bool isInline(String tag) => inlines.contains(tag);

  /// Se [tag] deve ser descartada junto com os filhos.
  static bool isDropped(String tag) => dropped.contains(tag);

  /// Nível (1–6) de uma tag de heading, ou `null` se não for heading.
  static int? headingLevel(String tag) {
    if (tag.length != 2 || tag[0] != 'h') {
      return null;
    }
    final int? level = int.tryParse(tag[1]);
    return (level != null && level >= 1 && level <= 6) ? level : null;
  }
}

/// Se [nodes] contém ao menos um elemento de bloco (direto).
///
/// Usado para decidir se um container vira `Column` de blocos ou um único
/// parágrafo inline — a distinção que evita `<div>Olá</div>` virar um bloco
/// vazio.
bool contentHasBlockChild(List<ContentNode> nodes) => nodes.any(
  (ContentNode n) => n is ContentElement && ContentTags.isBlock(n.tag),
);
