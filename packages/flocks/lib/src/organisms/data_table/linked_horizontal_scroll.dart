import 'package:flutter/widgets.dart';

/// Dois scrolls horizontais que andam juntos.
///
/// ## Por que não um controller só
///
/// Um `ScrollController` se liga a **uma** posição por vez — anexá-lo a duas
/// listas estoura. E aqui são duas de propósito: o cabeçalho precisa ser um
/// scrollable próprio para o arraste de reordenação ganhar o auto-scroll de
/// borda; o corpo precisa do seu para rolar as linhas. Rolando um, o outro tem
/// de acompanhar, senão a coluna e o seu título se separam.
///
/// A trava de reentrância é o que evita o pingue-pongue: sem ela, sincronizar A
/// dispara o listener de B, que sincroniza A de volta, em laço.
final class LinkedHorizontalScroll {
  LinkedHorizontalScroll() {
    header.addListener(_syncFromHeader);
    body.addListener(_syncFromBody);
  }

  /// Do cabeçalho — é este que o arraste de reordenação move sozinho.
  final ScrollController header = ScrollController();

  /// Do corpo da tabela.
  final ScrollController body = ScrollController();

  bool _syncing = false;

  void _syncFromHeader() => _sync(header, body);

  void _syncFromBody() => _sync(body, header);

  void _sync(ScrollController from, ScrollController to) {
    if (_syncing || !from.hasClients || !to.hasClients) return;
    final double target = from.offset.clamp(
      to.position.minScrollExtent,
      to.position.maxScrollExtent,
    );
    if (target == to.offset) return;
    _syncing = true;
    to.jumpTo(target);
    _syncing = false;
  }

  void dispose() {
    header
      ..removeListener(_syncFromHeader)
      ..dispose();
    body
      ..removeListener(_syncFromBody)
      ..dispose();
  }
}
