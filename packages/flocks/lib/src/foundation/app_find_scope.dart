import 'package:flutter/widgets.dart';

/// Registro dos campos "buscar **nesta** tela".
///
/// ## Por que um registro, e não a árvore
///
/// `⌘F` quer dizer "procurar aqui". Num shell de abas, "aqui" é a aba ativa —
/// mas todas as abas ficam **montadas ao mesmo tempo** (`IndexedStack`, para o
/// estado sobreviver à troca). Então não dá para descobrir o alvo caminhando a
/// árvore: as outras abas estão lá, com campos de busca igualmente válidos, só
/// que invisíveis. Focar o campo errado seria pior que não fazer nada.
///
/// Daí o registro ser por **token**: cada tela se registra sob a sua identidade
/// e o shell — o único que sabe qual está visível — pede o foco por token.
final class AppFindController {
  final Map<Object, FocusNode> _targets = <Object, FocusNode>{};

  /// Quantos alvos estão registrados. Só para teste e depuração.
  @visibleForTesting
  int get targetCount => _targets.length;

  void register(Object token, FocusNode node) => _targets[token] = node;

  /// Remove o registro de [token] — mas só se ainda for [node].
  ///
  /// A checagem de identidade importa porque `dispose` do widget antigo pode
  /// rodar **depois** do `register` do novo quando uma aba é substituída; sem
  /// ela, o alvo recém-registrado seria apagado.
  void unregister(Object token, FocusNode node) {
    if (identical(_targets[token], node)) _targets.remove(token);
  }

  /// Foca o campo de [token].
  ///
  /// Devolve `false` quando não há alvo — quem chama decide o fallback (o shell
  /// manda o foco para a busca global).
  ///
  /// Só **sem** token é que cai no alvo único (o caso do mobile, que não tem
  /// abas). Com um token que não casa, a resposta é `false`: aquela tela não
  /// tem campo de busca, e focar o de outra aba — invisível — seria pior que
  /// não fazer nada.
  bool focus(Object? token) {
    final FocusNode? resolved = token != null
        ? _targets[token]
        : (_targets.length == 1 ? _targets.values.first : null);
    if (resolved == null || !resolved.canRequestFocus) return false;
    resolved.requestFocus();
    return true;
  }
}

/// Disponibiliza o [AppFindController] para a subárvore.
final class AppFindScope extends InheritedWidget {
  const AppFindScope({
    required this.controller,
    required super.child,
    super.key,
  });

  final AppFindController controller;

  /// `null` fora de um shell que ofereça "buscar nesta tela".
  static AppFindController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppFindScope>()?.controller;

  @override
  bool updateShouldNotify(AppFindScope oldWidget) =>
      controller != oldWidget.controller;
}

/// Identidade da tela para o registro do [AppFindScope].
///
/// Quem monta as abas embrulha cada uma com o seu token; o campo de busca lá
/// dentro se registra sozinho. Sem este marcador (mobile, telas fora do shell)
/// o campo ainda se registra, só que como alvo único.
final class AppFindTarget extends InheritedWidget {
  const AppFindTarget({required this.token, required super.child, super.key});

  final Object token;

  static Object? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppFindTarget>()?.token;

  @override
  bool updateShouldNotify(AppFindTarget oldWidget) => token != oldWidget.token;
}
