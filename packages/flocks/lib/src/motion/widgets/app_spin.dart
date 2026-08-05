import 'package:flutter/widgets.dart';

import '../../tokens/app_durations.dart';
import '../app_motion.dart';

/// Rotação contínua para indicadores de carregamento.
///
/// - **Reduce-motion:** colapsa para estático (não gira), evitando travar
///   `pumpAndSettle` e respeitando a preferência do usuário.
/// - **Fora de tela:** o ticker é mutado automaticamente pelo
///   [SingleTickerProviderStateMixin] quando o [TickerMode] ancestral está
///   desligado (ex.: abas keep-alive do backoffice) — sem consumo de frames.
class AppSpin extends StatefulWidget {
  /// Cria um [AppSpin].
  const AppSpin({
    required this.child,
    this.period = AppDurations.loop,
    super.key,
  });

  /// Conteúdo rotacionado (ex.: um ícone de loading).
  final Widget child;

  /// Período de uma volta completa.
  final Duration period;

  @override
  State<AppSpin> createState() => _AppSpinState();
}

class _AppSpinState extends State<AppSpin> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.period,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(AppSpin oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.period != oldWidget.period) {
      _controller.duration = widget.period;
    }
    _sync();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sync() {
    if (AppMotion.enabled(context)) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      _controller
        ..stop()
        ..value = 0;
    }
  }

  @override
  Widget build(BuildContext context) =>
      RotationTransition(turns: _controller, child: widget.child);
}
