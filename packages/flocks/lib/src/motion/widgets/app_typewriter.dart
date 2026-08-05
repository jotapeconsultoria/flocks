import 'package:flutter/widgets.dart';

import '../app_motion.dart';

/// Revela um texto **caractere a caractere** (efeito "sendo escrito").
///
/// Acessibilidade: o texto completo é sempre exposto via `Semantics(label:)` —
/// o leitor de tela NÃO espera a digitação. Sob reduce-motion / global off,
/// mostra o texto inteiro instantaneamente. Renderiza `Text` cru (camada
/// widgets) com o [style] informado, para o primitivo não depender dos atoms.
class AppTypewriter extends StatefulWidget {
  /// Cria um [AppTypewriter].
  const AppTypewriter({
    required this.text,
    this.style,
    this.textAlign = TextAlign.start,
    this.charDuration = const Duration(milliseconds: 26),
    super.key,
  });

  /// Texto a revelar.
  final String text;

  /// Estilo do texto.
  final TextStyle? style;

  /// Alinhamento do texto.
  final TextAlign textAlign;

  /// Tempo por caractere (duração total = [charDuration] × comprimento).
  final Duration charDuration;

  @override
  State<AppTypewriter> createState() => _AppTypewriterState();
}

class _AppTypewriterState extends State<AppTypewriter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.charDuration * widget.text.length,
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!AppMotion.enabled(context)) {
      _controller.value = 1; // texto completo, instantâneo
      return;
    }
    if (!_started) {
      _started = true;
      _controller.forward(from: 0);
    }
  }

  @override
  void didUpdateWidget(covariant AppTypewriter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _controller.duration = widget.charDuration * widget.text.length;
      if (AppMotion.enabled(context)) {
        _controller.forward(from: 0);
      } else {
        _controller.value = 1;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.text,
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final int count = (_controller.value * widget.text.length)
                .round()
                .clamp(0, widget.text.length);
            return Text(
              widget.text.substring(0, count),
              style: widget.style,
              textAlign: widget.textAlign,
            );
          },
        ),
      ),
    );
  }
}
