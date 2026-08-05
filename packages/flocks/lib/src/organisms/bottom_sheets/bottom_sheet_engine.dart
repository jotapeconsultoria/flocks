import 'dart:math' as math;

import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../molecules/headers/app_close_side.dart';
import '../../motion/app_motion.dart';
import '../../tokens/app_durations.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_style.dart';
import 'bottom_sheet_surface.dart';

/// Modo do [BottomSheetEngine].
enum BottomSheetMode {
  /// Page cheia — um snap (page ⇄ fechada), swipe-to-dismiss.
  page,

  /// Card arrastável — dois snaps (repouso ⇄ page) e fechamento por arraste.
  draggable,
}

/// Motor de arraste dos bottom sheets, sobre [DraggableScrollableSheet] (do
/// `package:flutter/widgets.dart`, **não** Material). O DSS resolve a
/// coordenação gesto↔scroll num único gesto vertical; aqui em volta ficam: a
/// medição do repouso (content-fit), o morph (via [BottomSheetSurface] dirigida
/// pelo controller), os snaps e o fechamento por over-drag.
///
/// Não é exportado no baril — é interno a [AppBottomSheet]/[AppBottomSheetPage].
class BottomSheetEngine extends StatefulWidget {
  /// Cria um [BottomSheetEngine].
  const BottomSheetEngine({
    required this.mode,
    required this.child,
    this.footer,
    this.title,
    this.titleWidget,
    this.showHandle = false,
    this.showCloseButton = true,
    this.closeSide = AppSheetCloseSide.end,
    this.onCloseButton,
    this.alwaysClose = false,
    this.maxHeightFraction = kBottomSheetRestMaxFraction,
    this.topPeek = kBottomSheetTopPeek,
    this.style,
    this.glass,
    this.radiusMode,
    super.key,
  });

  /// Modo (page ou arrastável).
  final BottomSheetMode mode;

  /// Corpo (não-rolável; a sheet cuida da rolagem).
  final Widget child;

  /// Rodapé fixo opcional.
  final Widget? footer;

  /// Título opcional na barra de topo.
  final String? title;

  /// Escape hatch para o título que NÃO é só texto (ícone ao lado, título
  /// reativo). Aqui a tipografia é de quem passa — a barra não a impõe.
  final Widget? titleWidget;

  /// Mostra a handle no topo.
  final bool showHandle;

  /// Mostra o botão de fechar. Default `true`.
  final bool showCloseButton;

  /// Lado do botão de fechar. Default `end`.
  final AppSheetCloseSide closeSide;

  /// Ação do botão de fechar. `null` → pop.
  final VoidCallback? onCloseButton;

  /// Quando `true`, arrastar para baixo a partir da page **fecha** (não volta ao
  /// repouso).
  final bool alwaysClose;

  /// Teto do repouso (fração da tela). Default 0.65.
  final double maxHeightFraction;

  /// Respiro no topo da page (abaixo do safe-area).
  final double topPeek;

  /// Tratamento de container ([AppStyle]) do render **não-glass**. `null` →
  /// `elevated`.
  final AppStyle? style;

  /// Override do eixo glass. `null` segue o global (`theme.glassTheme.enabled`).
  final bool? glass;

  /// Override do modo de forma. `null` segue o global.
  final AppRadiusMode? radiusMode;

  @override
  State<BottomSheetEngine> createState() => _BottomSheetEngineState();
}

class _BottomSheetEngineState extends State<BottomSheetEngine> {
  /// Eixo glass efetivo: no modo **page** a sheet é uma PÁGINA (edge-to-edge),
  /// não uma superfície flutuante — nunca leva vidro, nem herda o global. Só o
  /// modo arrastável (que nasce como card flutuante) participa do eixo.
  bool? get _effectiveGlass =>
      widget.mode == BottomSheetMode.page ? false : widget.glass;

  final DraggableScrollableController _dsc = DraggableScrollableController();

  /// Fração de repouso medida (content-fit) — só no modo arrastável.
  double? _rest;

  /// Altura disponível da última medição (re-mede em rotação/resize).
  double? _measuredAvail;

  bool _closing = false;

  /// alwaysClose: marca que a sheet já atingiu a page; ao voltar a assentar no
  /// repouso, fecha (page→baixo fecha, não volta ao repouso).
  bool _reachedPage = false;

  @override
  void dispose() {
    _dsc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double avail = constraints.maxHeight;
        final MediaQueryData mq = MediaQuery.of(context);
        final double topSafe = mq.viewPadding.top;
        final double pageExtent = ((avail - topSafe - widget.topPeek) / avail)
            .clamp(0.1, 1.0);

        if (widget.mode == BottomSheetMode.page) {
          return _buildSheet(
            rest: pageExtent,
            pageExtent: pageExtent,
            pageMode: true,
          );
        }

        // Arrastável: mede o repouso (content-fit) uma vez por tamanho de tela.
        if (_rest == null || _measuredAvail != avail) {
          return _measure(constraints, avail, pageExtent);
        }
        final double rest = _rest!.clamp(
          math.min(0.15, pageExtent),
          pageExtent,
        );
        return _buildSheet(rest: rest, pageExtent: pageExtent, pageMode: false);
      },
    );
  }

  /// Renderiza a superfície content-fit fora da tela só para medir a altura
  /// natural do conteúdo e derivar o repouso `_rest`.
  Widget _measure(BoxConstraints constraints, double avail, double pageExtent) {
    return Offstage(
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: constraints.maxWidth,
          child: _MeasureSize(
            onChange: (Size size) {
              if (!mounted) return;
              final double measuredFrac = avail <= 0
                  ? pageExtent
                  : size.height / avail;
              final double upper = math.min(
                widget.maxHeightFraction,
                pageExtent,
              );
              final double frac = measuredFrac.clamp(
                math.min(0.15, upper),
                upper,
              );
              if (_measuredAvail != avail ||
                  _rest == null ||
                  (_rest! - frac).abs() > 0.001) {
                setState(() {
                  _rest = frac;
                  _measuredAvail = avail;
                });
              }
            },
            child: BottomSheetSurface(
              pageProgress: 0,
              contentMaxHeightFraction: 1,
              title: widget.title,
              titleWidget: widget.titleWidget,
              footer: widget.footer,
              showHandle: widget.showHandle,
              showCloseButton: widget.showCloseButton,
              closeSide: widget.closeSide,
              onCloseButton: widget.onCloseButton,
              style: widget.style,
              glass: _effectiveGlass,
              radiusMode: widget.radiusMode,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSheet({
    required double rest,
    required double pageExtent,
    required bool pageMode,
  }) {
    final double initial = pageMode ? pageExtent : rest;
    final List<double>? snaps = _snapSizes(
      rest: rest,
      pageExtent: pageExtent,
      pageMode: pageMode,
    );
    final bool motion = AppMotion.enabled(context);
    // animateTo/snap exigem duração > 0; reduce-motion usa ~instantâneo.
    final Duration snapDur = motion
        ? AppDurations.medium
        : const Duration(milliseconds: 1);

    return NotificationListener<Notification>(
      onNotification: (Notification n) => _onNotification(
        n,
        rest: rest,
        pageExtent: pageExtent,
        pageMode: pageMode,
      ),
      // Habilita arraste por mouse/trackpad (o Scrollable padrão só arrasta com
      // toque) — senão a sheet não arrasta no desktop/web (ex.: widgetbook,
      // backoffice).
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(
          context,
        ).copyWith(dragDevices: PointerDeviceKind.values.toSet()),
        child: DraggableScrollableSheet(
          controller: _dsc,
          initialChildSize: initial,
          minChildSize: 0,
          maxChildSize: pageExtent,
          snap: true,
          snapSizes: snaps,
          snapAnimationDuration: snapDur,
          builder: (BuildContext context, ScrollController sc) {
            return AnimatedBuilder(
              animation: _dsc,
              builder: (BuildContext context, Widget? _) {
                final double p = _pageProgress(
                  rest: rest,
                  pageExtent: pageExtent,
                  pageMode: pageMode,
                  initial: initial,
                );
                return BottomSheetSurface(
                  pageProgress: p,
                  scrollController: sc,
                  title: widget.title,
                  titleWidget: widget.titleWidget,
                  footer: widget.footer,
                  showHandle: widget.showHandle,
                  showCloseButton: widget.showCloseButton,
                  closeSide: widget.closeSide,
                  onCloseButton: widget.onCloseButton,
                  style: widget.style,
                  glass: _effectiveGlass,
                  radiusMode: widget.radiusMode,
                  child: widget.child,
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// Snaps intermediários (o DSS injeta min=0 e max=page automaticamente):
  /// - page → `null` ⇒ {0, page}
  /// - arrastável → `[rest]` ⇒ {0, rest, page}
  ///
  /// `alwaysClose` não muda os snaps (evita `setState` no meio do gesto, que não
  /// aplica a tempo do mesmo fling) — é tratado no `ScrollEndNotification`.
  List<double>? _snapSizes({
    required double rest,
    required double pageExtent,
    required bool pageMode,
  }) {
    if (pageMode) return null;
    if ((pageExtent - rest).abs() < 0.01) return null;
    return <double>[rest];
  }

  double _pageProgress({
    required double rest,
    required double pageExtent,
    required bool pageMode,
    required double initial,
  }) {
    if (pageMode) return 1;
    final double size = _dsc.isAttached ? _dsc.size : initial;
    if (pageExtent <= rest) return size >= pageExtent ? 1 : 0;
    return ((size - rest) / (pageExtent - rest)).clamp(0.0, 1.0);
  }

  bool _onNotification(
    Notification n, {
    required double rest,
    required double pageExtent,
    required bool pageMode,
  }) {
    if (n is DraggableScrollableNotification) {
      if (!pageMode && n.extent >= pageExtent - 0.01) {
        _reachedPage = true;
      }
      if (!_closing &&
          n.shouldCloseOnMinExtent &&
          n.extent <= n.minExtent + 0.001) {
        _closing = true;
        Navigator.of(context).maybePop();
      }
    } else if (n is ScrollEndNotification) {
      // alwaysClose: voltou a assentar no repouso depois de ter ido à page → fecha.
      if (!_closing &&
          widget.alwaysClose &&
          !pageMode &&
          _reachedPage &&
          _dsc.isAttached) {
        final double sz = _dsc.size;
        if (sz > 0.001 && sz <= rest + 0.02) {
          _closing = true;
          Navigator.of(context).maybePop();
        }
      }
    }
    return false;
  }
}

/// Reporta o tamanho do filho (via post-frame callback) para medir o content-fit.
class _MeasureSize extends SingleChildRenderObjectWidget {
  const _MeasureSize({required this.onChange, required Widget super.child});

  final ValueChanged<Size> onChange;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMeasureSize(onChange);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderMeasureSize renderObject,
  ) {
    renderObject.onChange = onChange;
  }
}

class _RenderMeasureSize extends RenderProxyBox {
  _RenderMeasureSize(this.onChange);

  ValueChanged<Size> onChange;
  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    final Size s = child?.size ?? Size.zero;
    if (s != _oldSize) {
      _oldSize = s;
      WidgetsBinding.instance.addPostFrameCallback((_) => onChange(s));
    }
  }
}
