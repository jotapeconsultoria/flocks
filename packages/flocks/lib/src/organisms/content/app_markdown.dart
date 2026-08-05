import 'package:flutter/widgets.dart';

import '../../foundation/foundation.dart';
import 'app_content_style.dart';
import 'content_block_builder.dart';
import 'content_link_handler.dart';
import 'content_markdown_parser.dart';
import 'content_node.dart';

/// Renderiza Markdown (GitHub-Flavored) com os tokens do Flocks.
///
/// Sobre `widgets.dart` puro — sem Material, sem Cupertino. O texto é lido da
/// AST do `package:markdown` e desenhado com `Text.rich`, headings da escala
/// tipográfica do tema, tabelas no [AppSimpleDataTable] e imagens no
/// [AppImage]. O documento inteiro fica dentro de uma única região de seleção,
/// então o usuário seleciona atravessando blocos.
///
/// Suporta: parágrafos, `h1`–`h6`, negrito, itálico, tachado, código inline e
/// em bloco, links, listas ordenadas/não-ordenadas aninhadas, citações, réguas,
/// tabelas e imagens. HTML cru embutido no Markdown é renderizado como texto
/// literal, nunca interpretado.
///
/// ```dart
/// AppMarkdown(
///   data: '# Relatório\n\nVelocidade **92 km/h** — [ver rota](https://…)',
///   onTapLink: (String href) => context.go(href),
/// )
/// ```
///
/// Para HTML servido pelo backend (termos, política de privacidade), use
/// [AppHtml], que aplica allow-list e sanitização.
final class AppMarkdown extends StatefulWidget {
  const AppMarkdown({
    required this.data,
    super.key,
    this.style,
    this.textColor,
    this.styleSheet,
    this.onTapLink,
    this.selectable = true,
  });

  /// Conteúdo Markdown a renderizar.
  final String data;

  /// Estilo do texto corrido. Default: `textTheme.bodyLarge` do tema.
  final TextStyle? style;

  /// Cor do texto do documento. Default: `colorTheme.onSurface`.
  final Color? textColor;

  /// Folha completa. Quando informada, vence [style] e [textColor].
  final AppContentStyle? styleSheet;

  /// Toque num link. Default: abre no navegador externo.
  ///
  /// Informe para rotear internamente ou instrumentar cliques.
  final AppContentLinkTap? onTapLink;

  /// Se o texto pode ser selecionado. Default `true`.
  final bool selectable;

  @override
  State<AppMarkdown> createState() => _AppMarkdownState();
}

class _AppMarkdownState extends State<AppMarkdown> {
  final ContentLinkRegistry _registry = ContentLinkRegistry();
  List<ContentNode> _nodes = const <ContentNode>[];

  @override
  void initState() {
    super.initState();
    _nodes = ContentMarkdownParser.parse(widget.data);
  }

  @override
  void didUpdateWidget(AppMarkdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Só reparseia quando o texto muda: no chat em streaming o widget
    // reconstrói a cada frame, e reparsear à toa custaria caro em mensagens
    // longas.
    if (oldWidget.data != widget.data) {
      _nodes = ContentMarkdownParser.parse(widget.data);
    }
  }

  @override
  void dispose() {
    _registry.disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Os recognizers da árvore anterior morrem aqui: a árvore inline é
    // reconstruída inteira a cada build.
    _registry.disposeAll();

    final AppContentStyle style =
        widget.styleSheet ??
        AppContentStyle.resolve(
          context,
          base: widget.style,
          color: widget.textColor,
        );

    final Widget document = ContentBlockBuilder(
      style: style,
      registry: _registry,
      onTapLink: widget.onTapLink ?? ContentLinkLauncher.open,
    ).buildDocument(_nodes);

    return widget.selectable ? AppSelectionRegion(child: document) : document;
  }
}
