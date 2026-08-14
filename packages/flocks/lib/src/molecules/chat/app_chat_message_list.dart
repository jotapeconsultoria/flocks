import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:flutter/semantics.dart' show OrdinalSortKey;
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
/// Os itens são construídos **sob demanda** (viewport + cache): o [itemBuilder]
/// não é chamado para índices longe da área visível, então uma conversa de
/// milhares de mensagens custa o que a tela mostra. A virtualização exige
/// altura limitada — dentro de uma `Column`, envolva em `Expanded`. Sob altura
/// ILIMITADA (a lista embutida numa página rolável) ela degrada para
/// shrink-wrap: renderiza sem estourar, mas materializa todos os itens, como a
/// implementação antiga.
///
/// **Identidade dos itens**: com key própria no widget do item (uma `ValueKey`
/// do id da mensagem), o estado por item sobrevive à chegada de mensagem nova
/// (append) e NUNCA gruda na mensagem errada; na paginação de histórico (itens
/// entrando na FRENTE) o item re-monta — conteúdo certo, estado zerado. Sem
/// key, a identidade é o índice: append preserva; na paginação o índice muda
/// de dono (como na implementação antiga). Estado que precisa sobreviver à
/// paginação usa `GlobalKey` no item, que preserva em qualquer mutação.
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
  ///
  /// Não dependa de offsets crus — a origem do scroll depende do modo. Com
  /// [stickToBottom] (o default) a lista ancora pela base e a origem é o **fim
  /// da conversa**: topo do histórico = `position.extentAfter == 0`, fim =
  /// `position.extentBefore == 0`. Sem [stickToBottom] vale o clássico
  /// espelhado: topo = `extentBefore == 0`, fim = `extentAfter == 0`.
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

  /// Invalida correções pendentes do [_settleAtEnd]: um pedido novo de rolagem
  /// ou um gesto do usuário (o scroll é do dedo, não se disputa).
  int _settleToken = 0;

  /// Key do wrapper → índice cronológico do ÚLTIMO build. O
  /// `findChildIndexCallback` roda ANTES do build novo, então o mapa carrega a
  /// premissa de APPEND (o gesto quente do chat: mensagem nova no fim mantém
  /// os índices cronológicos dos vivos). Vale para as DUAS identidades —
  /// [_ChronoKey] e [_PromotedKey] — o que mantém o remap TOTAL: sem remap
  /// parcial, um item sem key não evicta o vizinho com key. Entradas
  /// re-escritas a cada build e podadas por geração (pós-frame): o mapa
  /// converge para o conjunto vivo.
  final Map<Key, ({int i, int gen})> _identity = <Key, ({int i, int gen})>{};
  int _identityGen = 0;

  void _scrollToBottom({required bool animate}) {
    final int token = ++_settleToken;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controller.hasClients || token != _settleToken) return;
      // Com stickToBottom a lista é reversa: o fim da conversa é a coordenada
      // EXATA minScrollExtent (0). Sem reverso, maxScrollExtent numa lista
      // lazy é ESTIMATIVA que se refina conforme os filhos são medidos — o
      // salto único abaixo pode parar aquém do fim, e o _settleAtEnd corrige.
      final ScrollPosition position = _controller.position;
      final double target = widget.stickToBottom
          ? position.minScrollExtent
          : position.maxScrollExtent;
      if (animate && AppMotion.enabled(context)) {
        _controller.animateTo(
          target,
          duration: AppDurations.normal,
          curve: AppCurves.standard,
        );
      } else {
        _controller.jumpTo(target);
      }
      // 24 correções, com paciência de 240 frames (~2s a 120Hz) para os
      // frames em que só se espera a animação.
      if (!widget.stickToBottom) _settleAtEnd(token, 24, 240);
    });
  }

  /// Re-corrige o "rolar para o fim" do modo não-reverso: enquanto a rolagem
  /// corre (a própria animação), só espera — SEM gastar tentativa, senão a
  /// animação de 200ms consumiria o orçamento inteiro num display de 120Hz e
  /// nenhuma correção rodaria. Parada e ainda aquém do fim (a estimativa
  /// cresceu), salta o resto em silêncio. Gesto do usuário invalida o [token]
  /// e aborta; [patience] é o teto absoluto de frames (garante término).
  void _settleAtEnd(int token, int attempts, int patience) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controller.hasClients) return;
      if (token != _settleToken || attempts <= 0 || patience <= 0) return;
      final ScrollPosition position = _controller.position;
      if (position.isScrollingNotifier.value) {
        _settleAtEnd(token, attempts, patience - 1);
        return;
      }
      if (position.extentAfter <= 0.5) return;
      _controller.jumpTo(position.maxScrollExtent);
      _settleAtEnd(token, attempts - 1, patience - 1);
    });
    // O poll acima é passivo — garante que o próximo frame exista.
    WidgetsBinding.instance.scheduleFrame();
  }

  @override
  Widget build(BuildContext context) {
    // stickToBottom = lista REVERSA (o padrão de chat): o filho 0 do sliver é a
    // mensagem mais recente, ancorada na base — o "gruda no fim" sai de graça e
    // virtualizado. O mapeamento de índice preserva a ordem visual (item 0 no
    // topo); filho de sliver recebe largura tight (≡ stretch). Itens nos
    // índices pares, separadores nos ímpares (a anatomia do ListView.separated,
    // aberta aqui para controlar identidade e semântica).
    final bool reverse = widget.stickToBottom;
    final int n = widget.itemCount;
    _identityGen++;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _identity.removeWhere((_, id) => id.gen != _identityGen);
    });
    return NotificationListener<UserScrollNotification>(
      onNotification: (UserScrollNotification notification) {
        // depth == 0 = ESTA lista (o idioma do Scrollbar): um swipe num
        // scrollable aninhado do itemBuilder (carrossel de anexos numa bolha)
        // borbulha até aqui e não pode cancelar o assentamento.
        if (notification.depth == 0 &&
            notification.direction != ScrollDirection.idle) {
          _settleToken++;
        }
        return false;
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return ListView.custom(
            controller: _controller,
            reverse: reverse,
            // Altura ILIMITADA (lista embutida em página rolável): shrink-wrap,
            // como o SingleChildScrollView antigo — materializa tudo, mas não
            // estoura. Virtualização plena pede altura limitada (Expanded).
            shrinkWrap: !constraints.hasBoundedHeight,
            // Sempre explícito: padding null injetaria MediaQuery.padding.
            padding: widget.padding,
            semanticChildCount: n,
            childrenDelegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index.isOdd) return SizedBox(height: widget.spacing);
                final int i = reverse ? n - 1 - (index ~/ 2) : index ~/ 2;
                final Widget item = widget.itemBuilder(context, i);
                final Key? itemKey = item.key;
                // Identidade do elemento no sliver — no append em lista
                // reversa TODO índice de sliver muda, e sem remap o State de
                // cada item vivo migraria para a mensagem vizinha (o áudio
                // tocando gruda na bolha errada):
                // - item COM LocalKey própria: a key é EMBRULHADA
                //   (_PromotedKey) para subir ao nível do sliver sem
                //   duplicá-la na árvore (find.byKey do consumidor segue
                //   achando um widget só);
                // - item sem key: identidade cronológica (_ChronoKey);
                // - GlobalKey fica no item: o reparenting dela já preserva o
                //   estado em qualquer mutação.
                // O sortKey desfaz a inversão na TRAVESSIA do leitor de tela
                // (sem ele, a leitura sairia do mais recente para o antigo).
                final Key wrapperKey = itemKey is LocalKey
                    ? _PromotedKey(itemKey)
                    : _ChronoKey(i);
                _identity[wrapperKey] = (i: i, gen: _identityGen);
                return KeyedSubtree(
                  key: wrapperKey,
                  child: Semantics(
                    sortKey: OrdinalSortKey(i.toDouble()),
                    child: item,
                  ),
                );
              },
              childCount: n == 0 ? 0 : 2 * n - 1,
              findChildIndexCallback: (Key key) {
                final ({int i, int gen})? id = _identity[key];
                if (id == null) return null;
                final int i = id.i;
                if (i < 0 || i >= n) return null;
                return 2 * (reverse ? n - 1 - i : i);
              },
              // Índice CRONOLÓGICO para os anúncios de posição ("item i de
              // n"); separador não conta.
              semanticIndexCallback: (Widget _, int index) {
                if (index.isOdd) return null;
                return reverse ? n - 1 - (index ~/ 2) : index ~/ 2;
              },
            ),
          );
        },
      ),
    );
  }
}

/// Identidade cronológica dos itens SEM key própria. Classe privada para nunca
/// colidir com um `ValueKey<int>` do consumidor no `findChildIndexCallback`.
class _ChronoKey extends ValueKey<int> {
  const _ChronoKey(super.value);
}

/// Embrulha a LocalKey do consumidor para o nível do sliver sem duplicá-la na
/// árvore (a key literal fica só no item — `find.byKey` do consumidor acha um
/// widget só) e sem colidir com as keys do próprio DS.
class _PromotedKey extends ValueKey<LocalKey> {
  const _PromotedKey(super.value);
}
