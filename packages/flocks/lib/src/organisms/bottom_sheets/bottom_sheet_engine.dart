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

  /// Altura natural do conteúdo (content-fit) em PIXELS — só no modo
  /// arrastável. A fração de repouso é derivada dela a cada build
  /// (`_restPx / avail`): mudança de ALTURA disponível (teclado subindo, por
  /// exemplo) é aritmética por frame, nunca re-medição.
  double? _restPx;

  /// Largura da última medição. A altura natural do conteúdo depende da
  /// largura (o text scale é capturado no push) — re-mede só em rotação ou
  /// resize de largura.
  double? _measuredWidth;

  /// Última altura disponível — detecta a mudança (teclado abrindo/fechando)
  /// que pede o re-assento de [_reseat].
  double? _lastAvail;

  /// Ponteiros em contato com a sheet — com gesto ativo o [_reseat] não roda
  /// (não se rouba o arraste do dedo).
  int _activePointers = 0;

  /// Cache dos snaps por CONTEÚDO: o `DraggableScrollableSheet` compara a
  /// lista por IDENTIDADE e re-dispara a balística de snap a cada lista nova —
  /// uma lista nova por build seria uma balística por frame.
  List<double>? _snapsCache;

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

        // Arrastável: mede o repouso (content-fit) uma vez por LARGURA.
        final double upper = math.min(widget.maxHeightFraction, pageExtent);
        final double lower = math.min(0.15, upper);
        final double? rest = _restPx == null
            ? null
            : (avail <= 0 ? upper : _restPx! / avail).clamp(lower, upper);
        final bool needsMeasure =
            rest == null || _measuredWidth != constraints.maxWidth;
        if (rest != null &&
            _lastAvail != null &&
            (_lastAvail! - avail).abs() > 0.5) {
          // Snaps da GEOMETRIA ANTIGA: o re-assento só age sobre sheet que
          // estava ASSENTADA num deles — balística em voo (um fling de fechar
          // com o dedo já solto) não é cancelada.
          final double oldAvail = _lastAvail!;
          final double oldPage =
              ((oldAvail - topSafe - widget.topPeek) / oldAvail).clamp(
                0.1,
                1.0,
              );
          final double oldUpper = math.min(widget.maxHeightFraction, oldPage);
          final double oldLower = math.min(0.15, oldUpper);
          final double oldRest =
              (oldAvail <= 0 ? oldUpper : _restPx! / oldAvail).clamp(
                oldLower,
                oldUpper,
              );
          _reseat(rest, pageExtent, oldRest: oldRest, oldPage: oldPage);
        }
        // Com gesto ativo o re-assento é ADIADO, não descartado: manter o
        // _lastAvail antigo faz o rebuild do descongelamento (_pointerFreed)
        // re-detectar a mudança e re-agendar o _reseat contra a geometria
        // pré-gesto — senão um toque PARADO na sheet durante a janela do
        // teclado consumiria o re-assento e a sheet ficaria presa fora do
        // content-fit.
        if (_activePointers == 0) _lastAvail = avail;
        // A forma da árvore é SEMPRE a mesma (Stack): alternar Stack ⇄ filho
        // direto no re-medir descartaria o State do DSS (posição de arraste) —
        // e o DSS novo anexaria o controller antes de o velho soltá-lo
        // (assert em debug). Na re-medição (primeira exibição, rotação, resize
        // de largura) a sheet com o repouso ANTIGO continua na tela enquanto o
        // medidor roda offstage — sem o frame de "sheet sumida".
        return Stack(
          children: <Widget>[
            if (rest != null)
              _buildSheet(rest: rest, pageExtent: pageExtent, pageMode: false),
            if (needsMeasure) _measure(constraints),
          ],
        );
      },
    );
  }

  /// Mudança de altura disponível (teclado abrindo/fechando): o DSS preserva a
  /// FRAÇÃO de quem já arrastou — que na altura nova pode cair abaixo do
  /// repouso (a balística de snap FECHARIA a sheet sem gesto nenhum, via
  /// `shouldCloseOnMinExtent`) ou ficar presa ACIMA do content-fit (o teclado
  /// fecha e nada a devolve: o `jumpTo` anterior apagou o `hasDragged` que o
  /// snap do DSS exige). Re-assenta no snap legítimo mais PRÓXIMO (repouso ou
  /// page) da geometria NOVA; o `jumpTo` também zera o `hasDragged`,
  /// desarmando o snap espúrio.
  ///
  /// Dois vetos protegem o movimento legítimo:
  /// - ponteiro na tela ([_activePointers]): o `jumpTo` descartaria o
  ///   ScrollDragController e o resto do gesto viraria no-op;
  /// - sheet FORA dos snaps antigos ([oldRest]/[oldPage]): estava em voo (um
  ///   fling de fechar ou de abrir com o dedo já solto) — balística legítima
  ///   termina; só sheet ASSENTADA é re-assentada.
  void _reseat(
    double rest,
    double pageExtent, {
    required double oldRest,
    required double oldPage,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _closing || !_dsc.isAttached) return;
      if (_activePointers > 0) return;
      final double size = _dsc.size;
      final bool wasSettled =
          (size - oldRest).abs() <= 0.02 || (size - oldPage).abs() <= 0.02;
      if (!wasSettled) return;
      final double target = (size - rest).abs() <= (pageExtent - size).abs()
          ? rest
          : pageExtent;
      if ((size - target).abs() > 0.01) _dsc.jumpTo(target);
    });
  }

  /// Renderiza a superfície content-fit fora da tela só para medir a altura
  /// natural do conteúdo (em pixels) e guardar `_restPx`.
  Widget _measure(BoxConstraints constraints) {
    return Offstage(
      child: OverflowBox(
        alignment: Alignment.topCenter,
        minHeight: 0,
        // Altura LIVRE na medição: com o teclado aberto as constraints da rota
        // chegam encolhidas pelo AnimatedPadding e a altura natural sairia
        // capada — e ficaria capada para sempre, porque a re-medição é por
        // LARGURA. O teto real é o ConstrainedBox interno da superfície
        // (mq.size.height, que não encolhe com teclado).
        maxHeight: double.infinity,
        child: SizedBox(
          width: constraints.maxWidth,
          child: _MeasureSize(
            onChange: (Size size) {
              if (!mounted) return;
              final double width = constraints.maxWidth;
              // Tolerância de meio pixel: o medidor re-reporta em cada layout
              // e um eco idêntico não merece setState.
              if (_measuredWidth != width ||
                  _restPx == null ||
                  (_restPx! - size.height).abs() > 0.5) {
                setState(() {
                  _restPx = size.height;
                  _measuredWidth = width;
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
    final List<double>? snaps = _stableSnaps(
      _snapSizes(rest: rest, pageExtent: pageExtent, pageMode: pageMode),
    );
    final bool motion = AppMotion.enabled(context);
    // animateTo/snap exigem duração > 0; reduce-motion usa ~instantâneo.
    final Duration snapDur = motion
        ? AppDurations.medium
        : const Duration(milliseconds: 1);

    return Listener(
      // Censo de ponteiros para o _reseat não roubar gesto ativo. deferToChild:
      // só conta toque que acerta a sheet (acima dela o hit cai no barrier).
      // Trackpad arrasta por eventos de PAN-ZOOM (o dragDevices abaixo o
      // habilita), que não passam por onPointerDown/Up — o censo os soma.
      onPointerDown: (_) => _activePointers++,
      onPointerUp: (_) => _pointerFreed(),
      onPointerCancel: (_) => _pointerFreed(),
      onPointerPanZoomStart: (_) => _activePointers++,
      onPointerPanZoomEnd: (_) => _pointerFreed(),
      child: NotificationListener<Notification>(
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
      ),
    );
  }

  /// Devolve a lista CACHEADA quando o conteúdo não mudou (tolerância de
  /// 0.001): o DSS re-dispara a balística de snap para toda lista de
  /// identidade nova, mesmo com os mesmos valores.
  ///
  /// Com gesto ATIVO os snaps ficam CONGELADOS no cache: a balística que uma
  /// lista nova dispara substitui a activity do drag — o resto do gesto
  /// viraria no-op. O descongelamento é o rebuild de [_pointerFreed].
  List<double>? _stableSnaps(List<double>? fresh) {
    if (_activePointers > 0 && _snapsCache != null) return _snapsCache;
    if (fresh == null) return _snapsCache = null;
    final List<double>? cached = _snapsCache;
    if (cached != null && cached.length == fresh.length) {
      bool same = true;
      for (int k = 0; k < fresh.length; k++) {
        if ((cached[k] - fresh[k]).abs() > 0.001) {
          same = false;
          break;
        }
      }
      if (same) return cached;
    }
    return _snapsCache = fresh;
  }

  /// Fim de um ponteiro. Zerado o censo, rebuilda para descongelar os snaps
  /// ([_stableSnaps]) — o snap do próprio DSS re-assenta nos valores frescos.
  void _pointerFreed() {
    _activePointers = math.max(0, _activePointers - 1);
    if (_activePointers == 0 && mounted) setState(() {});
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
