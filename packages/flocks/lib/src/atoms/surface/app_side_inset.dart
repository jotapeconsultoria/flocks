import 'package:flutter/widgets.dart';

/// Aplica o respiro lateral que a superfície hospedeira publicou em
/// `MediaQuery.padding` — e o CONSOME, para ninguém abaixo aplicar de novo.
///
/// ## Por que a superfície publica em vez de recuar
///
/// O side sheet reserva uma faixa lateral (a gutter de arraste mora ali, e sem
/// reserva ela rouba o clique do conteúdo). Recuando a faixa inteira com um
/// `Padding`, recuava junto o VIEWPORT de qualquer rolagem lá dentro — e a barra
/// de rolagem, que mora na borda do viewport, aparecia flutuando longe da
/// lateral da sheet, como se sobrasse margem à direita dela (revisão P1r10).
///
/// Publicado, quem rola soma o recuo ao `padding` do próprio scrollable: o
/// conteúdo respira, o viewport vai até a borda e a barra encosta na lateral.
///
/// Este widget é o atalho para o conteúdo que **não** rola: ele aplica o mesmo
/// recuo como padding comum. Quem rola não deve usá-lo — deve somar
/// `MediaQuery.paddingOf(context)` ao padding do scrollable.
final class AppSideInset extends StatelessWidget {
  const AppSideInset({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = MediaQuery.paddingOf(context);
    if (padding.left == 0 && padding.right == 0) return child;
    return Padding(
      padding: EdgeInsets.only(left: padding.left, right: padding.right),
      child: MediaQuery.removePadding(
        context: context,
        removeLeft: true,
        removeRight: true,
        child: child,
      ),
    );
  }
}
