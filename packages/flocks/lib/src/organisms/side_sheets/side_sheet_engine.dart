import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../molecules/headers/app_close_side.dart';
import '../../motion/app_motion.dart';
import '../../tokens/app_curves.dart';
import '../../tokens/app_device.dart';
import '../../tokens/app_durations.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_style.dart';
import '../bottom_sheets/bottom_sheet_surface.dart'
    show kBottomSheetDetachedMargin;
import 'app_sheet_side.dart';
import 'side_sheet_surface.dart';

/// Motor do side sheet: seleciona os snaps por largura, ancora o painel à borda
/// [side], e — quando [draggable] — redimensiona via um `AnimationController` +
/// gutter `GestureDetector` na borda interna (não há `DraggableScrollableSheet`
/// horizontal). Resize é horizontal e o scroll do conteúdo é vertical, então não
/// há conflito de eixo. Interno a [AppSideSheet].
class SideSheetEngine extends StatefulWidget {
  /// Cria um [SideSheetEngine].
  const SideSheetEngine({
    required this.side,
    required this.child,
    this.draggable = false,
    this.alwaysClose = false,
    this.showHandle = false,
    this.showCloseButton = true,
    this.closeSide,
    this.onCloseButton,
    this.title,
    this.titleWidget,
    this.footer,
    this.mediumFraction = kSideSheetMediumFraction,
    this.largeFraction = kSideSheetLargeFraction,
    this.edgePeek = kSideSheetEdgePeek,
    this.initialSnap = AppSideSheetSnap.rest,
    this.style,
    this.glass,
    this.radiusMode,
    super.key,
  });

  /// Borda ancorada.
  final AppSheetSide side;

  /// Corpo (rola sozinho na vertical).
  final Widget child;

  /// Habilita o resize por arraste (repouso ⇄ full).
  final bool draggable;

  /// Da full, arrastar pra borda **fecha** (não volta ao snap menor).
  final bool alwaysClose;

  /// Mostra a grabber vertical na borda interna.
  final bool showHandle;

  /// Mostra o botão de fechar. Default `true`.
  final bool showCloseButton;

  /// Lado do botão de fechar. `null` → canto interno conforme [side].
  final AppSheetCloseSide? closeSide;

  /// Ação do botão de fechar. `null` → pop.
  final VoidCallback? onCloseButton;

  /// Título opcional.
  final String? title;

  /// Escape hatch para o título que NÃO é só texto (ícone ao lado, título
  /// reativo). Aqui a tipografia é de quem passa — a barra não a impõe.
  final Widget? titleWidget;

  /// Rodapé fixo opcional.
  final Widget? footer;

  /// 1º snap em telas largas. Default 0.40.
  final double mediumFraction;

  /// 1º snap em telas estreitas / 2º em largas. Default 0.70.
  final double largeFraction;

  /// Respiro na borda oposta no full.
  final double edgePeek;

  /// Snap em que a sheet abre. Default [AppSideSheetSnap.rest].
  final AppSideSheetSnap initialSnap;

  /// Tratamento de container ([AppStyle]) do render **não-glass**.
  final AppStyle? style;

  /// Override do eixo glass. `null` segue o global (`theme.glassTheme.enabled`).
  final bool? glass;

  /// Override do modo de forma.
  final AppRadiusMode? radiusMode;

  @override
  State<SideSheetEngine> createState() => _SideSheetEngineState();
}

class _SideSheetEngineState extends State<SideSheetEngine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: AppDurations.medium,
  );
  Animation<double>? _anim;

  /// Fração de largura atual (null → `firstSnap`).
  double? _fraction;
  bool _reachedFull = false;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() {
      final Animation<double>? a = _anim;
      if (a != null && mounted) setState(() => _fraction = a.value);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final MediaQueryData mq = MediaQuery.of(context);
        final bool end = widget.side == AppSheetSide.end;
        final bool anchoredRight =
            end == (Directionality.of(context) == TextDirection.ltr);
        final double openSafe = anchoredRight
            ? mq.viewPadding.left
            : mq.viewPadding.right;
        final double fullFraction =
            ((width - openSafe - widget.edgePeek) / width).clamp(0.1, 1.0);
        final bool wide = width > AppDevice.tablet.breakpoint;

        final List<double> snaps = _buildSnaps(wide: wide, full: fullFraction);
        final double firstSnap = snaps.first;
        final double morphStart = snaps.length >= 2
            ? snaps[snaps.length - 2]
            : snaps.first;

        // O snap inicial é resolvido AQUI, no layout: `fullFraction` depende da
        // largura disponível e do peek, que só existem depois do LayoutBuilder.
        // `medium` = o degrau ANTES do full (`morphStart`). Em tela estreita
        // não há degrau intermediário e ele coincide com o menor — que é o
        // comportamento certo: não existe "meio" para cair.
        final double initial = switch (widget.initialSnap) {
          AppSideSheetSnap.full => snaps.last,
          AppSideSheetSnap.medium => morphStart,
          AppSideSheetSnap.rest => firstSnap,
        };
        final double fraction = (_fraction ?? initial).clamp(0.0, fullFraction);
        final double p = _fullProgress(fraction, morphStart, fullFraction);

        final Widget panel = SizedBox(
          width: fraction * width,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: SideSheetSurface(
                  fullProgress: p,
                  side: widget.side,
                  showHandle: widget.showHandle,
                  showCloseButton: widget.showCloseButton,
                  closeSide: widget.closeSide,
                  onCloseButton: widget.onCloseButton,
                  title: widget.title,
                  titleWidget: widget.titleWidget,
                  footer: widget.footer,
                  style: widget.style,
                  glass: widget.glass,
                  radiusMode: widget.radiusMode,
                  // Só reserva a faixa quando a gutter EXISTE.
                  gutterInset: widget.draggable ? kSideSheetHandleHitWidth : 0,
                  child: widget.child,
                ),
              ),
              if (widget.draggable)
                // Gutter alinhada à borda interna do surface (offset pela margem
                // `m` do card, que interpola com o morph) — senão fica na margem,
                // desalinhada da handle. 48px de alvo de toque (acessibilidade).
                PositionedDirectional(
                  top: 0,
                  bottom: 0,
                  start: end
                      ? lerpDouble(kBottomSheetDetachedMargin, 0, p)!
                      : null,
                  end: end
                      ? null
                      : lerpDouble(kBottomSheetDetachedMargin, 0, p)!,
                  width: kSideSheetHandleHitWidth,
                  child: _gutter(
                    width: width,
                    snaps: snaps,
                    fullFraction: fullFraction,
                    anchoredRight: anchoredRight,
                    firstSnap: firstSnap,
                  ),
                ),
            ],
          ),
        );

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: end
              ? <Widget>[const Expanded(child: SizedBox()), panel]
              : <Widget>[panel, const Expanded(child: SizedBox())],
        );
      },
    );
  }

  List<double> _buildSnaps({required bool wide, required double full}) {
    final List<double> bases = wide
        ? <double>[widget.mediumFraction, widget.largeFraction]
        : <double>[widget.largeFraction];
    final List<double> out = <double>[
      for (final double s in bases)
        if (s < full - 0.001) s,
      full,
    ];
    return out.isEmpty ? <double>[full] : out;
  }

  double _fullProgress(double frac, double morphStart, double full) {
    if (full <= morphStart) return frac >= full ? 1.0 : 0.0;
    return ((frac - morphStart) / (full - morphStart)).clamp(0.0, 1.0);
  }

  Widget _gutter({
    required double width,
    required List<double> snaps,
    required double fullFraction,
    required bool anchoredRight,
    required double firstSnap,
  }) {
    final double sign = anchoredRight ? -1.0 : 1.0;
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragStart: (_) => _ctrl.stop(),
        onHorizontalDragUpdate: (DragUpdateDetails d) {
          if (width <= 0) return;
          final double currentPx = (_fraction ?? firstSnap) * width;
          final double newPx = (currentPx + sign * d.delta.dx).clamp(
            0.0,
            fullFraction * width,
          );
          final double frac = newPx / width;
          if (frac >= fullFraction - 0.001) _reachedFull = true;
          setState(() => _fraction = frac);
        },
        onHorizontalDragEnd: (DragEndDetails d) => _onDragEnd(
          velocityDx: d.velocity.pixelsPerSecond.dx,
          sign: sign,
          snaps: snaps,
          fullFraction: fullFraction,
        ),
      ),
    );
  }

  void _onDragEnd({
    required double velocityDx,
    required double sign,
    required List<double> snaps,
    required double fullFraction,
  }) {
    final double growV = sign * velocityDx;
    final double current = _fraction ?? snaps.first;
    final double smallest = snaps.first;
    const double vThresh = 400;

    double target;
    if (growV > vThresh) {
      target = _nextUp(current, snaps, fullFraction);
    } else if (growV < -vThresh) {
      target = _nextDown(current, snaps); // pode ser < smallest (fecha)
    } else {
      target = _nearest(current, snaps);
    }

    // Over-drag pra dentro além do menor snap → fecha.
    if (current < smallest * kSideSheetDismissFactor ||
        target < smallest - 0.001) {
      _close();
      return;
    }
    // alwaysClose: já chegou na full e vai assentar num snap menor → fecha.
    if (widget.alwaysClose && _reachedFull && target < fullFraction - 0.001) {
      _close();
      return;
    }
    _animateTo(target);
  }

  double _nearest(double v, List<double> snaps) {
    double best = snaps.first;
    double bd = (v - best).abs();
    for (final double s in snaps) {
      final double d = (v - s).abs();
      if (d < bd) {
        bd = d;
        best = s;
      }
    }
    return best;
  }

  double _nextUp(double v, List<double> snaps, double full) {
    for (final double s in snaps) {
      if (s > v + 0.001) return s;
    }
    return full;
  }

  double _nextDown(double v, List<double> snaps) {
    double below = 0;
    for (final double s in snaps) {
      if (s < v - 0.001) below = s;
    }
    return below; // 0 (< menor snap) sinaliza dismiss
  }

  void _animateTo(double target) {
    if (!AppMotion.enabled(context)) {
      setState(() => _fraction = target);
      return;
    }
    _anim = Tween<double>(
      begin: _fraction,
      end: target,
    ).animate(CurvedAnimation(parent: _ctrl, curve: AppCurves.emphasized));
    _ctrl
      ..reset()
      ..forward();
  }

  void _close() {
    if (_closing) return;
    _closing = true;
    Navigator.of(context).maybePop();
  }
}
