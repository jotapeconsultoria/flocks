import 'package:flutter/widgets.dart';

import '../../foundation/foundation.dart';
import 'app_content_style.dart';
import 'content_block_builder.dart';
import 'content_html_parser.dart';
import 'content_link_handler.dart';
import 'content_node.dart';

/// Renderiza HTML com os tokens do Flocks, sobre `widgets.dart` puro.
///
/// Pensado para o conteúdo longo servido pelo backend — termos de uso, política
/// de privacidade, avisos legais. Compartilha o renderer com [AppMarkdown], de
/// modo que o mesmo documento fica visualmente idêntico nos dois caminhos.
///
/// **Não é um navegador.** Renderiza um subconjunto deliberado de tags:
/// parágrafos, `h1`–`h6`, listas, citações, `pre`/`code`, réguas, tabelas,
/// links, imagens e a formatação inline usual. Não interpreta CSS nem layout.
///
/// A entrada é tratada como **não confiável**:
/// - `script`, `style`, `iframe`, `form` e afins são descartados com a
///   subárvore;
/// - `href`/`src` passam por validação de esquema (`javascript:` e `data:` são
///   bloqueados);
/// - tags desconhecidas degradam para os próprios filhos — perde-se a
///   formatação, nunca o texto.
///
/// ```dart
/// AppHtml(data: state.privacyPolicy)
/// ```
final class AppHtml extends StatefulWidget {
  const AppHtml({
    required this.data,
    super.key,
    this.style,
    this.textColor,
    this.styleSheet,
    this.onTapLink,
    this.selectable = true,
  });

  /// Conteúdo HTML a renderizar. Aceita documento completo ou fragmento.
  final String data;

  /// Estilo do texto corrido. Default: `textTheme.bodyLarge` do tema.
  final TextStyle? style;

  /// Cor do texto do documento. Default: `colorTheme.onSurface`.
  final Color? textColor;

  /// Folha completa. Quando informada, vence [style] e [textColor].
  final AppContentStyle? styleSheet;

  /// Toque num link. Default: abre no navegador externo.
  final AppContentLinkTap? onTapLink;

  /// Se o texto pode ser selecionado. Default `true`.
  final bool selectable;

  @override
  State<AppHtml> createState() => _AppHtmlState();
}

class _AppHtmlState extends State<AppHtml> {
  final ContentLinkRegistry _registry = ContentLinkRegistry();
  List<ContentNode> _nodes = const <ContentNode>[];

  @override
  void initState() {
    super.initState();
    _nodes = ContentHtmlParser.parse(widget.data);
  }

  @override
  void didUpdateWidget(AppHtml oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _nodes = ContentHtmlParser.parse(widget.data);
    }
  }

  @override
  void dispose() {
    _registry.disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
