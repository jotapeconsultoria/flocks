import 'package:flutter/widgets.dart';

import '../../tokens/app_durations.dart';
import 'app_fade.dart';
import 'app_pop.dart';

/// Entrada canônica: **fade + pop** ao montar (compõe [AppFade] e [AppPop]).
///
/// Anima sozinho na primeira composição (útil para balões, diálogos, itens que
/// surgem). Respeita reduce-motion / o global do DS via os primitivos que
/// compõe — quando desligado, aparece instantâneo.
class AppAppear extends StatefulWidget {
  /// Cria um [AppAppear].
  const AppAppear({
    required this.child,
    this.duration = AppDurations.normal,
    this.fromScale = 0.85,
    super.key,
  });

  /// Conteúdo que entra.
  final Widget child;

  /// Duração da entrada.
  final Duration duration;

  /// Escala inicial (`1.0` = sem pop; `< 1` cresce com overshoot).
  final double fromScale;

  @override
  State<AppAppear> createState() => _AppAppearState();
}

class _AppAppearState extends State<AppAppear> {
  bool _shown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _shown = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppFade(
      visible: _shown,
      duration: widget.duration,
      child: AppPop(
        scale: _shown ? 1.0 : widget.fromScale,
        duration: widget.duration,
        child: widget.child,
      ),
    );
  }
}
