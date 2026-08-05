import 'package:flutter/widgets.dart';

import '../../motion/app_motion.dart';
import '../../theme/theme.dart';
import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';

/// Realce de hover **puramente visual**, sem gesto nem foco próprios.
///
/// Existe para os gatilhos de overlay (`AppMenu`, `AppPopover`): eles já
/// instalam o clique e o foco em volta do trigger, então embrulhar o conteúdo
/// num `AppInteraction` criaria **dois** alvos — um segundo parada de Tab e o
/// duplo-toggle clássico, em que o overlay abre no gesto de dentro e fecha no
/// de fora.
///
/// Este pinta o mesmo realce translúcido do `AppInteraction` e nada mais, o que
/// dá ao gatilho a mesma afordância dos outros itens clicáveis sem disputar o
/// gesto com quem já o tem.
final class AppHoverHighlight extends StatefulWidget {
  const AppHoverHighlight({
    required this.child,
    this.padding = EdgeInsets.zero,
    this.borderRadius,
    super.key,
  });

  final Widget child;

  /// Respiro entre o realce e o conteúdo — é ele que dá corpo à área pintada.
  final EdgeInsetsGeometry padding;

  /// Forma do realce. Por padrão, o raio do tema.
  final BorderRadius? borderRadius;

  @override
  State<AppHoverHighlight> createState() => _AppHoverHighlightState();
}

class _AppHoverHighlightState extends State<AppHoverHighlight> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: AppMotion.resolve(context, AppDurations.fast),
        curve: AppCurves.standard,
        decoration: BoxDecoration(
          color: _hovered
              ? theme.colorTheme.onSurface.withValues(alpha: 0.08)
              : const Color(0x00000000),
          borderRadius: widget.borderRadius ?? theme.radiusTheme.resolve(),
        ),
        child: Padding(padding: widget.padding, child: widget.child),
      ),
    );
  }
}
