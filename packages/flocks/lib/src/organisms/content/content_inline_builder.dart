import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../tokens/tokens.dart';
import 'app_content_style.dart';
import 'content_link_handler.dart';
import 'content_node.dart';

/// Constrói a árvore de [InlineSpan] de um bloco.
///
/// Cada bloco vira **um** `Text.rich`, e não um span por palavra: é o que
/// permite ao motor de texto quebrar linha corretamente entre trechos de
/// estilos diferentes (negrito no meio da frase, link colado na pontuação).
final class ContentInlineBuilder {
  ContentInlineBuilder({
    required this.style,
    required this.registry,
    required this.onTapLink,
  });

  /// Folha de estilo do documento.
  final AppContentStyle style;

  /// Dono dos recognizers criados para os links deste build.
  final ContentLinkRegistry registry;

  /// Ação de toque nos links.
  final AppContentLinkTap onTapLink;

  /// Converte [nodes] em spans, herdando [parentStyle].
  List<InlineSpan> build(List<ContentNode> nodes, TextStyle parentStyle) {
    final List<InlineSpan> spans = <InlineSpan>[];
    for (final ContentNode node in nodes) {
      _appendNode(node, parentStyle, spans);
    }
    return spans;
  }

  void _appendNode(
    ContentNode node,
    TextStyle parentStyle,
    List<InlineSpan> out,
  ) {
    switch (node) {
      case ContentText(:final String text):
        final String normalized = _collapseWhitespace(text);
        if (normalized.isEmpty) {
          return;
        }
        out.add(TextSpan(text: normalized, style: parentStyle));

      case ContentElement(:final String tag):
        _appendElement(node, tag, parentStyle, out);
    }
  }

  void _appendElement(
    ContentElement element,
    String tag,
    TextStyle parentStyle,
    List<InlineSpan> out,
  ) {
    switch (tag) {
      case 'strong' || 'b':
        out.addAll(build(element.children, parentStyle.bold));

      case 'em' || 'i':
        out.addAll(
          build(
            element.children,
            parentStyle.copyWith(fontStyle: FontStyle.italic),
          ),
        );

      case 'u':
        out.addAll(
          build(
            element.children,
            parentStyle.copyWith(decoration: TextDecoration.underline),
          ),
        );

      case 's' || 'del' || 'strike':
        out.addAll(
          build(
            element.children,
            parentStyle.copyWith(decoration: TextDecoration.lineThrough),
          ),
        );

      case 'small':
        out.addAll(
          build(
            element.children,
            parentStyle.copyWith(fontSize: (parentStyle.fontSize ?? 16) * 0.85),
          ),
        );

      // Sobrescrito/subscrito reais exigem deslocamento de baseline, que
      // `TextSpan` não expõe. Reduzir o corpo é a aproximação honesta.
      case 'sup' || 'sub':
        out.addAll(
          build(
            element.children,
            parentStyle.copyWith(fontSize: (parentStyle.fontSize ?? 16) * 0.75),
          ),
        );

      case 'code':
        out.add(
          TextSpan(
            text: _collapseWhitespace(element.textContent),
            style: style.code.copyWith(
              backgroundColor: style.inlineCodeBackground,
              fontSize: (parentStyle.fontSize ?? 16) * 0.92,
            ),
          ),
        );

      case 'a':
        _appendLink(element, parentStyle, out);

      case 'br':
        out.add(const TextSpan(text: '\n'));

      case 'img':
        _appendImage(element, out);

      // Contêineres inline sem estilo próprio: seguem em frente.
      case 'span' || 'mark':
        out.addAll(build(element.children, parentStyle));

      default:
        // Degradação: tag desconhecida (ou de bloco aparecendo dentro de um
        // fluxo inline) não pode engolir o conteúdo. Renderiza os filhos.
        out.addAll(build(element.children, parentStyle));
    }
  }

  void _appendLink(
    ContentElement element,
    TextStyle parentStyle,
    List<InlineSpan> out,
  ) {
    final String? href = element.attributes['href'];

    if (href == null || href.isEmpty) {
      // Âncora sem destino: mantém o texto, sem afetar interação.
      out.addAll(build(element.children, parentStyle));
      return;
    }

    final List<InlineSpan> children = build(
      element.children,
      parentStyle.merge(style.link),
    );

    // O recognizer precisa estar nos spans-FOLHA, não num span pai: o hit-test
    // do parágrafo resolve a posição tocada para o span que efetivamente
    // contém aquele caractere, e um pai sem `text` próprio nunca é atingido.
    // Um mesmo recognizer serve todas as folhas do link.
    out.addAll(_withRecognizer(children, registry.create(href, onTapLink)));
  }

  /// Propaga [recognizer] para todo span-folha de [spans].
  List<InlineSpan> _withRecognizer(
    List<InlineSpan> spans,
    GestureRecognizer recognizer,
  ) => <InlineSpan>[
    for (final InlineSpan span in spans)
      if (span is TextSpan)
        TextSpan(
          text: span.text,
          style: span.style,
          recognizer: span.text == null ? null : recognizer,
          children: span.children == null
              ? null
              : _withRecognizer(span.children!, recognizer),
        )
      else
        // `WidgetSpan` (imagem dentro do link) não carrega recognizer; o toque
        // nela é responsabilidade do próprio widget.
        span,
  ];

  void _appendImage(ContentElement element, List<InlineSpan> out) {
    final String? src = element.attributes['src'];
    if (src == null || src.isEmpty) {
      return;
    }
    final String? alt = element.attributes['alt'];

    out.add(
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: style.inlineImageMaxHeight,
            maxWidth: style.inlineImageMaxHeight * 2,
          ),
          child: AppImage.network(
            src,
            fit: BoxFit.contain,
            height: style.inlineImageMaxHeight,
            semanticLabel: (alt == null || alt.isEmpty) ? null : alt,
          ),
        ),
      ),
    );
  }

  /// Colapsa sequências de espaço/quebra num único espaço.
  ///
  /// É a regra de espaço em branco do HTML, e também o que o Markdown espera:
  /// uma quebra "leve" dentro do parágrafo é um espaço, não uma nova linha.
  /// Blocos `pre` não passam por aqui — lá o texto é preservado byte a byte.
  static String _collapseWhitespace(String input) =>
      input.replaceAll(_whitespaceRun, ' ');

  static final RegExp _whitespaceRun = RegExp(r'\s+');
}
