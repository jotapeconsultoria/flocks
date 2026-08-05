import 'package:flutter/widgets.dart';

/// Este [context] está na rota do TOPO da pilha?
///
/// ## Por que existe
///
/// Um atalho registrado em `HardwareKeyboard.instance.addHandler` é GLOBAL: ele
/// não passa pela árvore de foco, então continua disparando mesmo com um diálogo
/// ou uma sheet por cima. Foi assim que o Esc do formulário abriu um segundo
/// diálogo de descarte enquanto o primeiro já estava na tela (revisão P1r10).
///
/// Handler global só pode agir quando a rota que o registrou é a de cima. Foco
/// pertence a quem está por cima — inclusive o teclado.
///
/// `null` (fora de qualquer rota modal, como num teste isolado) conta como topo:
/// não há nada acima para roubar o teclado.
bool appRouteIsTopmost(BuildContext context) {
  final ModalRoute<Object?>? route = ModalRoute.of(context);
  return route == null || route.isCurrent;
}
