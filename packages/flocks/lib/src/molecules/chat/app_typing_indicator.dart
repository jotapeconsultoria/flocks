import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// Indicador "digitando…" — três pontinhos que sobem e descem em sequência.
///
/// Serve tanto para o WhatsApp ("fulano está digitando") quanto para o
/// assistente pensando. **Motion-aware**: sob reduce-motion / global off, os
/// pontos ficam estáticos (sem quicar), e o [semanticLabel] é sempre exposto.
///
/// ```dart
/// AppTypingIndicator()
/// ```
final class AppTypingIndicator extends StatefulWidget {
  /// Cria um [AppTypingIndicator].
  const AppTypingIndicator({
    this.color,
    this.dotSize = 7,
    this.spacing = AppSpacings.s4,
    this.semanticLabel = 'Digitando',
    super.key,
  });

  /// Cor dos pontos. Default: `onSurface` esmaecido.
  final Color? color;

  /// Diâmetro de cada ponto (px). Default 7.
  final double dotSize;

  /// Espaço entre os pontos. Default [AppSpacings.s4].
  final double spacing;

  /// Rótulo lido por leitores de tela.
  final String semanticLabel;

  @override
  State<AppTypingIndicator> createState() => _AppTypingIndicatorState();
}

class _AppTypingIndicatorState extends State<AppTypingIndicator>
    with SingleTickerProviderStateMixin {
  static const int _dotCount = 3;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.loop,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.enabled(context)) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final Color color =
        widget.color ?? theme.colorTheme.onSurface.customOpacity(0.5);
    final bool animate = AppMotion.enabled(context);
    final double amplitude = widget.dotSize * 0.7;

    return Semantics(
      label: widget.semanticLabel,
      liveRegion: true,
      child: SizedBox(
        height: widget.dotSize + amplitude,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                for (int i = 0; i < _dotCount; i++) ...<Widget>[
                  if (i > 0) SizedBox(width: widget.spacing),
                  _dot(color, animate ? _lift(i, amplitude) : 0),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  double _lift(int index, double amplitude) {
    final double phase = index * 0.18;
    final double v = math.sin((_controller.value - phase) * 2 * math.pi);
    return math.max(0, v) * amplitude;
  }

  Widget _dot(Color color, double lift) => Padding(
    padding: EdgeInsets.only(bottom: lift),
    child: Container(
      width: widget.dotSize,
      height: widget.dotSize,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    ),
  );
}
