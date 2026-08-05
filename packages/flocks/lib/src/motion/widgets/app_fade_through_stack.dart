import 'package:flutter/widgets.dart';

import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../app_motion.dart';

/// Fração da animação gasta apagando o filho que sai.
///
/// A saída termina **antes** de a entrada começar: nunca há dois filhos
/// visíveis ao mesmo tempo. Um cross-fade puro sobreporia duas tabelas
/// semitransparentes e o resultado é ilegível — este é o "fade through".
const double _fadeOutFraction = 0.45;

/// Um [IndexedStack] que **troca com fade** em vez de corte seco.
///
/// ## Por que não um `AnimatedSwitcher`
///
/// O switcher troca o widget, e aqui os filhos são abas vivas: cada uma guarda
/// cubits, scroll e formulários que não podem ser reconstruídos a cada troca.
/// Então todos continuam montados — como no [IndexedStack] — e o que anima é
/// só a opacidade.
///
/// Custo zero em repouso: `Opacity(0)` não pinta o filho (o render object
/// desiste antes), e `Opacity(1)` pinta direto, sem camada. Fora da transição
/// isto se comporta exatamente como um [IndexedStack].
final class AppFadeThroughStack extends StatefulWidget {
  const AppFadeThroughStack({
    required this.index,
    required this.children,
    this.duration = AppDurations.fast,
    super.key,
  });

  /// Índice do filho visível.
  final int index;

  /// Todos os filhos ficam montados; só um aparece.
  final List<Widget> children;

  final Duration duration;

  @override
  State<AppFadeThroughStack> createState() => _AppFadeThroughStackState();
}

class _AppFadeThroughStackState extends State<AppFadeThroughStack>
    with SingleTickerProviderStateMixin {
  /// Criado no `initState`, não como `late final`: com reduce-motion o `build`
  /// nunca toca no controller, e aí o `dispose()` seria quem dispararia a
  /// inicialização preguiçosa — pedindo um ticker com a árvore já desmontada.
  late final AnimationController _controller;

  /// Quem está saindo. `null` quando não há transição em curso.
  int? _outgoing;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: 1,
    );
  }

  @override
  void didUpdateWidget(AppFadeThroughStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index == widget.index) return;
    _outgoing = oldWidget.index;
    _controller
      ..duration = widget.duration
      ..forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _opacityFor(int childIndex, double t) {
    if (childIndex == widget.index) {
      if (t <= _fadeOutFraction) return 0;
      return Curves.easeOut.transform(
        (t - _fadeOutFraction) / (1 - _fadeOutFraction),
      );
    }
    if (childIndex == _outgoing && t < _fadeOutFraction) {
      return 1 - AppCurves.standard.transform(t / _fadeOutFraction);
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    // Reduce-motion: troca instantânea, sem tween nenhum.
    if (!AppMotion.enabled(context)) {
      return IndexedStack(index: widget.index, children: widget.children);
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? _) {
        final double t = _controller.value;
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            for (int i = 0; i < widget.children.length; i++)
              // O ponteiro segue a aba ATIVA desde o primeiro frame: durante o
              // fade o clique já pertence a quem está chegando, mesmo que ela
              // ainda não esteja opaca.
              IgnorePointer(
                ignoring: i != widget.index,
                child: Opacity(
                  opacity: _opacityFor(i, t),
                  child: widget.children[i],
                ),
              ),
          ],
        );
      },
    );
  }
}
