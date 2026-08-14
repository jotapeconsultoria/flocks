import 'package:flutter/widgets.dart';

import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../app_motion.dart';

/// Pulso em laço — a "respiração" de opacidade (e, opcionalmente, escala) de
/// um indicador AO VIVO: a bolinha de gravação, o dot de transmissão.
///
/// - **Reduce-motion:** o laço PARA e congela no estado **cheio** (opacidade e
///   escala plenas). É deliberadamente diferente do resto do eixo de motion,
///   que colapsa a transição para o estado-alvo: um laço não tem alvo, e o
///   quadro informativo de um indicador ao vivo é o ACESO — congelar apagado
///   (ou no vale) leria como "desligado", que é exatamente a informação
///   errada.
/// - **Decorativo:** não emite semântica. Quem indica "gravando" rotula no
///   ponto de uso (`AppSemantics.label`/`liveRegion`) — o mesmo contrato do
///   [AppTypingIndicator], onde o rótulo mora no componente, não no motion.
/// - **Fora de tela:** o ticker é mutado pelo [TickerMode] ancestral, como no
///   [AppSpin] — sem consumo de frames em abas keep-alive.
class AppPulse extends StatefulWidget {
  /// Cria um [AppPulse].
  const AppPulse({
    required this.child,
    this.period = AppDurations.loop,
    this.minOpacity = 0.45,
    this.minScale = 1.0,
    super.key,
  }) : assert(
         minOpacity >= 0.0 && minOpacity <= 1.0,
         'minOpacity deve estar em [0, 1]',
       ),
       assert(
         minScale > 0.0 && minScale <= 1.0,
         'minScale deve estar em (0, 1]',
       );

  /// Conteúdo pulsado (ex.: um dot de gravação).
  final Widget child;

  /// Período de UMA respiração completa (cheio → mínimo → cheio).
  /// Default [AppDurations.loop], o período dos laços do DS.
  final Duration period;

  /// Piso da opacidade no vale do pulso. `1.0` desliga o eixo de opacidade.
  ///
  /// Default `0.45` — visível o bastante para o vale não ler como "sumiu".
  /// Amplitude em vez de flag: o mesmo parâmetro que liga o eixo diz o quanto.
  final double minOpacity;

  /// Piso da escala no vale do pulso. Default `1.0` = eixo de escala
  /// DESLIGADO — opacidade-só é o pulso canônico do indicador ao vivo; escala
  /// é opcional (ex.: `0.85` para um "batimento").
  final double minScale;

  @override
  State<AppPulse> createState() => _AppPulseState();
}

class _AppPulseState extends State<AppPulse>
    with SingleTickerProviderStateMixin {
  // Meia respiração por perna: o `repeat(reverse: true)` faz ida e volta, e o
  // par fecha o `period` inteiro.
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.period ~/ 2,
  );

  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _controller,
    curve: AppCurves.standard,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(AppPulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.period != oldWidget.period) {
      _controller.duration = widget.period ~/ 2;
      // `duration` não alcança um repeat EM VOO: a simulação já nasceu com o
      // período velho. Rearmar aplica o novo sem saltar o quadro atual (o
      // repeat parte do value corrente).
      if (_controller.isAnimating) {
        _controller
          ..stop()
          ..repeat(reverse: true);
      }
    }
    _sync();
  }

  @override
  void dispose() {
    _curve.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _sync() {
    if (AppMotion.enabled(context)) {
      if (!_controller.isAnimating) _controller.repeat(reverse: true);
    } else {
      _controller
        ..stop()
        ..value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Os tweens nascem INVERTIDOS (begin = cheio, end = vale) de propósito:
    // é o que faz o congelamento em `value = 0` do `_sync` cair no estado
    // cheio de graça. Com `begin: minOpacity` o reduce-motion congelaria no
    // vale — o widget inteiro passando a informação errada.
    final Animation<double> opacity = _curve.drive(
      Tween<double>(begin: 1.0, end: widget.minOpacity),
    );
    Widget result = FadeTransition(opacity: opacity, child: widget.child);
    if (widget.minScale < 1.0) {
      result = ScaleTransition(
        scale: _curve.drive(Tween<double>(begin: 1.0, end: widget.minScale)),
        child: result,
      );
    }
    return result;
  }
}
