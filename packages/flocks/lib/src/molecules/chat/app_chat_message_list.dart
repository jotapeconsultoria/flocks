import 'package:flutter/widgets.dart';

import '../../motion/motion.dart';
import '../../tokens/tokens.dart';

/// Lista rolável de mensagens — o "chão" da conversa.
///
/// Encapsula três comportamentos chatos de acertar à mão: (1) **gruda no fim**
/// (quando há poucas mensagens, elas ficam ancoradas na base, não no topo);
/// (2) **auto-scroll** para o fim quando chega mensagem nova; (3) **espaçamento**
/// uniforme entre os itens.
///
/// É agnóstica de domínio: **não** agrupa por autor nem insere divisores de dia
/// (não conhece as mensagens). O consumidor expressa isso no [itemBuilder] —
/// escolhendo, item a item, uma `AppChatBubble` (com `tail`/agrupamento) ou um
/// `AppChatDayDivider`.
///
/// ```dart
/// AppChatMessageList(
///   itemCount: messages.length,
///   itemBuilder: (context, i) => _buildRow(messages[i]),
/// )
/// ```
final class AppChatMessageList extends StatefulWidget {
  /// Cria uma [AppChatMessageList].
  const AppChatMessageList({
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.spacing = AppSpacings.s16,
    this.padding = EdgeInsets.zero,
    this.stickToBottom = true,
    this.autoScroll = true,
    super.key,
  });

  /// Quantidade de itens.
  final int itemCount;

  /// Constrói o item de índice `i` (uma bolha, divisor, etc.).
  final IndexedWidgetBuilder itemBuilder;

  /// Controlador de scroll externo (opcional). `null` = a lista cria o seu.
  final ScrollController? controller;

  /// Espaço vertical entre itens. Default [AppSpacings.s16].
  final double spacing;

  /// Espaço em volta do conteúdo.
  final EdgeInsetsGeometry padding;

  /// Se ancora o conteúdo na base quando ele é menor que a viewport.
  final bool stickToBottom;

  /// Se rola para o fim ao aumentar [itemCount].
  final bool autoScroll;

  @override
  State<AppChatMessageList> createState() => _AppChatMessageListState();
}

class _AppChatMessageListState extends State<AppChatMessageList> {
  late ScrollController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _bindController();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollToBottom(animate: false),
    );
  }

  void _bindController() {
    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = ScrollController();
      _ownsController = true;
    }
  }

  @override
  void didUpdateWidget(covariant AppChatMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (_ownsController) _controller.dispose();
      _bindController();
    }
    if (widget.autoScroll && widget.itemCount > oldWidget.itemCount) {
      _scrollToBottom(animate: true);
    }
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _scrollToBottom({required bool animate}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controller.hasClients) return;
      final double target = _controller.position.maxScrollExtent;
      if (animate && AppMotion.enabled(context)) {
        _controller.animateTo(
          target,
          duration: AppDurations.normal,
          curve: AppCurves.standard,
        );
      } else {
        _controller.jumpTo(target);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double vInsets = widget.padding
            .resolve(Directionality.of(context))
            .vertical;
        final double minHeight = widget.stickToBottom
            ? (constraints.maxHeight - vInsets).clamp(0, double.infinity)
            : 0;
        return SingleChildScrollView(
          controller: _controller,
          padding: widget.padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Column(
              mainAxisAlignment: widget.stickToBottom
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int i = 0; i < widget.itemCount; i++) ...<Widget>[
                  if (i > 0) SizedBox(height: widget.spacing),
                  widget.itemBuilder(context, i),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
