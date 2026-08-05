import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../tokens/tokens.dart';
import '../data_table/app_simple_data_table.dart';
import 'app_content_style.dart';
import 'content_inline_builder.dart';
import 'content_link_handler.dart';
import 'content_node.dart';

/// Constrói o fluxo de blocos de um documento.
///
/// Cada bloco é um `Widget` numa `Column`; o conteúdo inline de cada bloco vira
/// um único `Text.rich`. Nós inline soltos entre blocos são agrupados num
/// parágrafo sintético, para que markup solto (`<div>texto</div>`) não perca o
/// texto nem gere um bloco vazio.
final class ContentBlockBuilder {
  ContentBlockBuilder({
    required this.style,
    required ContentLinkRegistry registry,
    required AppContentLinkTap onTapLink,
  }) : _inline = ContentInlineBuilder(
         style: style,
         registry: registry,
         onTapLink: onTapLink,
       );

  /// Folha de estilo do documento.
  final AppContentStyle style;

  final ContentInlineBuilder _inline;

  /// Converte [nodes] na lista de blocos, a [depth] níveis de lista.
  List<Widget> build(List<ContentNode> nodes, {int depth = 0}) {
    final List<Widget> widgets = <Widget>[];
    final List<ContentNode> pendingInline = <ContentNode>[];

    void flushInline() {
      if (pendingInline.isEmpty) {
        return;
      }
      final List<InlineSpan> spans = _inline.build(
        List<ContentNode>.of(pendingInline),
        style.base,
      );
      pendingInline.clear();
      final Widget? paragraph = _paragraph(spans, style.base);
      if (paragraph != null) {
        widgets.add(paragraph);
      }
    }

    for (final ContentNode node in nodes) {
      if (node is ContentElement && ContentTags.isBlock(node.tag)) {
        flushInline();
        widgets.addAll(_buildBlock(node, depth: depth));
      } else {
        pendingInline.add(node);
      }
    }
    flushInline();

    return widgets;
  }

  List<Widget> _buildBlock(ContentElement element, {required int depth}) {
    final String tag = element.tag;

    if (ContentTags.passthroughBlocks.contains(tag)) {
      return build(element.children, depth: depth);
    }

    final int? heading = ContentTags.headingLevel(tag);
    if (heading != null) {
      final TextStyle headingStyle = style.headingFor(heading);
      final Widget? widget = _paragraph(
        _inline.build(element.children, headingStyle),
        headingStyle,
      );
      return widget == null ? const <Widget>[] : <Widget>[widget];
    }

    switch (tag) {
      case 'p':
        // Imagem sozinha num parágrafo é conteúdo de bloco, não um glifo no
        // meio de uma frase — renderiza em tamanho cheio.
        final ContentElement? loneImage = _loneImageOf(element);
        if (loneImage != null) {
          return <Widget>[_blockImage(loneImage)];
        }
        final Widget? paragraph = _paragraph(
          _inline.build(element.children, style.base),
          style.base,
        );
        return paragraph == null ? const <Widget>[] : <Widget>[paragraph];

      case 'ul':
        return <Widget>[_list(element, ordered: false, depth: depth)];

      case 'ol':
        return <Widget>[_list(element, ordered: true, depth: depth)];

      // Um `li` fora de lista (markup quebrado): renderiza o conteúdo.
      case 'li':
        return build(element.children, depth: depth);

      case 'blockquote':
        return <Widget>[_blockquote(element, depth: depth)];

      case 'pre':
        return <Widget>[_codeBlock(element)];

      case 'hr':
        return <Widget>[AppDivider(color: style.dividerColor)];

      case 'table':
        final Widget? table = _table(element);
        return table == null ? const <Widget>[] : <Widget>[table];

      // Partes de tabela soltas: já são consumidas por `_table`. Chegando aqui,
      // o markup está quebrado — preserva o texto.
      case 'thead' || 'tbody' || 'tfoot' || 'tr' || 'th' || 'td':
        return build(element.children, depth: depth);

      default:
        return build(element.children, depth: depth);
    }
  }

  /// Envolve [spans] num parágrafo, ou devolve `null` se não houver conteúdo
  /// visível (evita blocos vazios ocupando espaçamento).
  Widget? _paragraph(List<InlineSpan> spans, TextStyle style) {
    if (spans.isEmpty) {
      return null;
    }
    if (spans.length == 1 && spans.first is TextSpan) {
      final TextSpan only = spans.first as TextSpan;
      if ((only.text ?? '').trim().isEmpty &&
          (only.children ?? const <InlineSpan>[]).isEmpty) {
        return null;
      }
    }
    // O estilo vai no widget, não no span raiz: é a base que os spans filhos
    // herdam, e deixa o estilo do bloco inspecionável.
    return Text.rich(TextSpan(children: spans), style: style);
  }

  /// A única imagem de um parágrafo, se ele não tiver mais nada visível.
  ContentElement? _loneImageOf(ContentElement paragraph) {
    ContentElement? image;
    for (final ContentNode child in paragraph.children) {
      switch (child) {
        case ContentText(:final String text):
          if (text.trim().isNotEmpty) {
            return null;
          }
        case ContentElement(tag: 'img'):
          if (image != null) {
            return null;
          }
          image = child;
        case ContentElement():
          return null;
      }
    }
    return image;
  }

  Widget _blockImage(ContentElement element) {
    final String? src = element.attributes['src'];
    if (src == null || src.isEmpty) {
      return const SizedBox.shrink();
    }
    final String? alt = element.attributes['alt'];
    return AppImage.network(
      src,
      fit: BoxFit.contain,
      semanticLabel: (alt == null || alt.isEmpty) ? null : alt,
    );
  }

  Widget _list(
    ContentElement element, {
    required bool ordered,
    required int depth,
  }) {
    final List<ContentElement> items = <ContentElement>[
      for (final ContentNode child in element.children)
        if (child is ContentElement && child.tag == 'li') child,
    ];
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final int start = int.tryParse(element.attributes['start'] ?? '') ?? 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < items.length; i++)
          Padding(
            padding: EdgeInsets.only(
              bottom: i == items.length - 1 ? 0 : style.blockSpacing / 2,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: style.listIndent,
                  child: Text(
                    ordered ? '${start + i}.' : _bulletFor(depth),
                    style: style.base,
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: _spaced(
                      build(items[i].children, depth: depth + 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Marcador que alterna por profundidade, como num documento impresso.
  ///
  /// Restrito a glifos presentes nas fontes empacotadas (Poppins/Space
  /// Grotesk). O
  /// par "clássico" `◦`/`▪` (U+25E6/U+25AA) foi descartado: Poppins não os
  /// desenha e eles saíam como tofu (▯) no nível aninhado.
  static String _bulletFor(int depth) => switch (depth % 3) {
    0 => '•',
    1 => '–',
    _ => '·',
  };

  Widget _blockquote(ContentElement element, {required int depth}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: AppStrokes.l,
            decoration: BoxDecoration(
              color: style.blockquoteBar,
              borderRadius: style.blockquoteBarRadius,
            ),
          ),
          const SizedBox(width: AppSpacings.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: _spaced(
                ContentBlockBuilder(
                  style: style.copyWith(base: style.blockquote),
                  registry: _inline.registry,
                  onTapLink: _inline.onTapLink,
                ).build(element.children, depth: depth),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _codeBlock(ContentElement element) {
    // `pre > code` é o que o Markdown emite; `pre` cru também aparece em HTML.
    ContentElement? code;
    for (final ContentNode child in element.children) {
      if (child is ContentElement && child.tag == 'code') {
        code = child;
        break;
      }
    }

    String text = (code ?? element).textContent;
    // O parser encerra o bloco com uma quebra que renderizaria uma linha vazia.
    if (text.endsWith('\n')) {
      text = text.substring(0, text.length - 1);
    }

    return Container(
      width: double.infinity,
      padding: style.codePadding,
      decoration: BoxDecoration(
        color: style.codeBackground,
        borderRadius: style.codeBorderRadius,
      ),
      // Texto preservado byte a byte: nada de colapsar espaços aqui.
      child: Text(text, style: style.code),
    );
  }

  Widget? _table(ContentElement element) {
    final List<ContentElement> rows = <ContentElement>[];
    void collect(ContentElement parent) {
      for (final ContentNode child in parent.children) {
        if (child is! ContentElement) {
          continue;
        }
        if (child.tag == 'tr') {
          rows.add(child);
        } else if (child.tag == 'thead' ||
            child.tag == 'tbody' ||
            child.tag == 'tfoot') {
          collect(child);
        }
      }
    }

    collect(element);
    if (rows.isEmpty) {
      return null;
    }

    List<ContentElement> cellsOf(ContentElement row) => <ContentElement>[
      for (final ContentNode child in row.children)
        if (child is ContentElement && (child.tag == 'th' || child.tag == 'td'))
          child,
    ];

    // Sem `<th>` (comum em HTML de CMS), a primeira linha vira o cabeçalho:
    // nenhuma linha é perdida e a tabela lê como tabela.
    final ContentElement headerRow = rows.first;
    final List<String> headers = <String>[
      for (final ContentElement cell in cellsOf(headerRow))
        cell.textContent.trim(),
    ];
    if (headers.isEmpty) {
      return null;
    }

    final List<List<Widget>> body = <List<Widget>>[
      for (final ContentElement row in rows.skip(1))
        <Widget>[
          for (final ContentElement cell in cellsOf(row))
            Text.rich(
              TextSpan(
                children: _inline.build(cell.children, style.base),
                style: style.base,
              ),
            ),
        ],
    ];

    return AppSimpleDataTable(columnLabels: headers, rows: body);
  }

  /// Intercala [style.blockSpacing] entre blocos irmãos.
  List<Widget> _spaced(List<Widget> blocks) {
    if (blocks.length <= 1) {
      return blocks;
    }
    return <Widget>[
      for (int i = 0; i < blocks.length; i++) ...<Widget>[
        if (i > 0) SizedBox(height: style.blockSpacing),
        blocks[i],
      ],
    ];
  }

  /// Compõe [nodes] numa coluna de blocos já espaçados — o ponto de entrada dos
  /// componentes.
  Widget buildDocument(List<ContentNode> nodes) {
    final List<Widget> blocks = _spaced(build(nodes));
    if (blocks.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: blocks,
    );
  }
}
