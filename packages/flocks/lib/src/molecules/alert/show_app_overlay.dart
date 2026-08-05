import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../motion/app_motion.dart';
import '../../theme/theme.dart';
import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';

/// Posição de um overlay na tela — a grade 3×3 **sem o centro**: 4 cantos + 4
/// centros de aresta (8 pontos).
enum AppOverlayPosition {
  /// Canto superior esquerdo.
  topLeft,

  /// Centro do topo.
  topCenter,

  /// Canto superior direito.
  topRight,

  /// Centro da aresta esquerda.
  centerLeft,

  /// Centro da aresta direita.
  centerRight,

  /// Canto inferior esquerdo.
  bottomLeft,

  /// Centro da base.
  bottomCenter,

  /// Canto inferior direito.
  bottomRight;

  /// Alinhamento do ponto na tela.
  Alignment get alignment => switch (this) {
    AppOverlayPosition.topLeft => Alignment.topLeft,
    AppOverlayPosition.topCenter => Alignment.topCenter,
    AppOverlayPosition.topRight => Alignment.topRight,
    AppOverlayPosition.centerLeft => Alignment.centerLeft,
    AppOverlayPosition.centerRight => Alignment.centerRight,
    AppOverlayPosition.bottomLeft => Alignment.bottomLeft,
    AppOverlayPosition.bottomCenter => Alignment.bottomCenter,
    AppOverlayPosition.bottomRight => Alignment.bottomRight,
  };

  /// Offset inicial (fração do tamanho) do slide-in, vindo da aresta mais próxima.
  Offset get slideBegin => switch (this) {
    AppOverlayPosition.topLeft ||
    AppOverlayPosition.topCenter ||
    AppOverlayPosition.topRight => const Offset(0, -1),
    AppOverlayPosition.centerLeft => const Offset(-1, 0),
    AppOverlayPosition.centerRight => const Offset(1, 0),
    AppOverlayPosition.bottomLeft ||
    AppOverlayPosition.bottomCenter ||
    AppOverlayPosition.bottomRight => const Offset(0, 1),
  };
}

/// Animação de entrada/saída de um overlay.
enum AppOverlayAnimation {
  /// Fade.
  fade,

  /// Escala com fade (pop).
  scale,

  /// Desliza da aresta mais próxima com fade.
  slide,
}

/// Exibe [child] num ponto da tela ([position]) via [Overlay], com animação de
/// entrada/saída ([animation]) e largura máxima ([maxWidth]) opcionais. Sem
/// Material; respeita reduce-motion (via [AppMotion]).
///
/// Auto-dismiss após [duration] (`null` = permanece até dispensar). Retorna um
/// callback que **dispensa** o overlay (com a animação de saída). Não bloqueia o
/// ponteiro fora do [child].
///
/// ```dart
/// final dismiss = showAppOverlay(
///   context: context,
///   position: AppOverlayPosition.topRight,
///   animation: AppOverlayAnimation.slide,
///   maxWidth: 360,
///   child: AppAlert(title: 'Salvo', description: '...'),
/// );
/// ```
VoidCallback showAppOverlay({
  required BuildContext context,
  required Widget child,
  AppOverlayPosition position = AppOverlayPosition.topRight,
  AppOverlayAnimation animation = AppOverlayAnimation.slide,
  double? maxWidth,
  Duration? duration = const Duration(seconds: 4),
  double margin = 24,
  VoidCallback? onDismiss,
}) {
  final OverlayState overlay = Overlay.of(context);
  // Captura tema + text scale aqui (o Overlay fica acima dos providers) e
  // reprovê tudo na entry via AppOverlayScope (tema + text scale + DefaultText-
  // Style limpo, senão o texto cai no fallback amarelo do Flutter).
  final AppThemeData theme = AppTheme.of(context);
  final TextScaler textScaler = MediaQuery.textScalerOf(context);
  final GlobalKey<_OverlayHostState> hostKey = GlobalKey<_OverlayHostState>();

  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (BuildContext _) => AppOverlayScope(
      theme: theme,
      textScaler: textScaler,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(margin),
          child: Align(
            alignment: position.alignment,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth ?? double.infinity,
              ),
              child: _OverlayHost(
                key: hostKey,
                animation: animation,
                slideBegin: position.slideBegin,
                duration: duration,
                onRemove: () {
                  entry.remove();
                  onDismiss?.call();
                },
                child: child,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);
  return () => hostKey.currentState?.dismiss();
}

class _OverlayHost extends StatefulWidget {
  const _OverlayHost({
    required this.child,
    required this.animation,
    required this.slideBegin,
    required this.duration,
    required this.onRemove,
    super.key,
  });

  final Widget child;
  final AppOverlayAnimation animation;
  final Offset slideBegin;
  final Duration? duration;
  final VoidCallback onRemove;

  @override
  State<_OverlayHost> createState() => _OverlayHostState();
}

class _OverlayHostState extends State<_OverlayHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: AppDurations.medium,
    vsync: this,
  );
  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: AppCurves.decelerate,
  );
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: widget.slideBegin,
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: AppCurves.decelerate));
  late final Animation<double> _scale = Tween<double>(begin: 0.9, end: 1.0)
      .animate(
        CurvedAnimation(
          parent: _controller,
          curve: AppCurves.emphasizedOvershoot,
        ),
      );
  Timer? _timer;
  bool _started = false;
  bool _dismissing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (!AppMotion.enabled(context)) _controller.duration = Duration.zero;
    _controller.forward();
    final Duration? d = widget.duration;
    if (d != null) _timer = Timer(d, dismiss);
  }

  /// Dispensa com a animação de saída (reverse), depois remove.
  void dismiss() {
    if (_dismissing) return;
    _dismissing = true;
    _timer?.cancel();
    _controller.reverse().then((_) {
      if (mounted) widget.onRemove();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget faded = FadeTransition(opacity: _fade, child: widget.child);
    return switch (widget.animation) {
      AppOverlayAnimation.fade => faded,
      AppOverlayAnimation.scale => ScaleTransition(scale: _scale, child: faded),
      AppOverlayAnimation.slide => SlideTransition(
        position: _slide,
        child: faded,
      ),
    };
  }
}
