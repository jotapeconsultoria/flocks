import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';

/// Onde o painel flutuante ancora em relação ao trigger.
///
/// `start`/`end` alinham a borda do painel à borda do trigger (menus);
/// `center` centraliza (popover com seta). `bottom*` abrem abaixo; `top*` acima.
enum AppOverlayPlacement {
  /// Abaixo, alinhado à esquerda.
  bottomStart,

  /// Abaixo, centralizado.
  bottomCenter,

  /// Abaixo, alinhado à direita.
  bottomEnd,

  /// Acima, alinhado à esquerda.
  topStart,

  /// Acima, centralizado.
  topCenter,

  /// Acima, alinhado à direita.
  topEnd,
}

/// Âncoras (alvo, seguidor, offset do gap) de um [AppOverlayPlacement].
(Alignment, Alignment, Offset) _anchorsFor(AppOverlayPlacement p, double gap) =>
    switch (p) {
      AppOverlayPlacement.bottomStart => (
        Alignment.bottomLeft,
        Alignment.topLeft,
        Offset(0, gap),
      ),
      AppOverlayPlacement.bottomCenter => (
        Alignment.bottomCenter,
        Alignment.topCenter,
        Offset(0, gap),
      ),
      AppOverlayPlacement.bottomEnd => (
        Alignment.bottomRight,
        Alignment.topRight,
        Offset(0, gap),
      ),
      AppOverlayPlacement.topStart => (
        Alignment.topLeft,
        Alignment.bottomLeft,
        Offset(0, -gap),
      ),
      AppOverlayPlacement.topCenter => (
        Alignment.topCenter,
        Alignment.bottomCenter,
        Offset(0, -gap),
      ),
      AppOverlayPlacement.topEnd => (
        Alignment.topRight,
        Alignment.bottomRight,
        Offset(0, -gap),
      ),
    };

/// Controlador de um overlay ancorado (menu/popover). Não é público.
///
/// Dono do [link] (ancoragem transform-safe) e do [groupId] (o [TapRegion] do
/// trigger e o do painel compartilham o mesmo grupo — assim tocar no trigger
/// **não** conta como "clique fora"). [open] captura o [AppTheme] do contexto do
/// trigger e o **reprovê** dentro da entry (o Overlay costuma ficar acima do
/// provider de tema), montando um [AnchoredOverlay] em volta do painel.
class AnchoredOverlayController extends ChangeNotifier {
  /// Link entre o trigger ([CompositedTransformTarget]) e o painel
  /// ([CompositedTransformFollower]).
  final LayerLink link = LayerLink();

  /// Grupo de [TapRegion] compartilhado entre trigger e painel.
  final Object groupId = Object();

  OverlayEntry? _entry;

  /// Se o overlay está aberto.
  bool get isOpen => _entry != null;

  /// Abre o overlay ancorado ao trigger, com o painel construído por [builder].
  void open(
    BuildContext context, {
    required AppOverlayPlacement placement,
    required WidgetBuilder builder,
    double gap = AppSpacings.s4,
    bool autofocus = true,
  }) {
    if (_entry != null) return;
    // Captura AQUI (contexto do trigger, sob os providers) e reprovê dentro da
    // entry via [AppOverlayScope] — o Overlay raiz costuma ficar ACIMA do tema,
    // do text scale e do DefaultTextStyle. Sem isto: "No AppTheme found", texto
    // sem escala e fallback do Flutter (sublinhado amarelo duplo).
    final AppThemeData theme = AppTheme.of(context);
    final TextScaler textScaler = MediaQuery.textScalerOf(context);
    _entry = OverlayEntry(
      builder: (BuildContext _) => AppOverlayScope(
        theme: theme,
        textScaler: textScaler,
        child: AnchoredOverlay(
          link: link,
          groupId: groupId,
          placement: placement,
          gap: gap,
          autofocus: autofocus,
          onDismiss: close,
          child: Builder(builder: builder),
        ),
      ),
    );
    Overlay.of(context).insert(_entry!);
    notifyListeners();
  }

  /// Reconstrói o painel aberto (idempotente se fechado) — para painéis que
  /// atualizam ao vivo a partir do estado do trigger.
  void rebuild() => _entry?.markNeedsBuild();

  /// Fecha o overlay (idempotente).
  void close() {
    if (_entry == null) return;
    _entry!.remove();
    _entry!.dispose();
    _entry = null;
    notifyListeners();
  }

  /// Abre se fechado; fecha se aberto.
  void toggle(
    BuildContext context, {
    required AppOverlayPlacement placement,
    required WidgetBuilder builder,
    double gap = AppSpacings.s4,
    bool autofocus = true,
  }) => isOpen
      ? close()
      : open(
          context,
          placement: placement,
          builder: builder,
          gap: gap,
          autofocus: autofocus,
        );

  @override
  void dispose() {
    close();
    super.dispose();
  }
}

/// Conteúdo de uma entry de overlay ancorado. Não é público.
///
/// Renderiza o [child] em `Positioned(0,0)` (constraints LOOSE, o painel
/// dimensiona pelo conteúdo), seguindo o trigger por [CompositedTransformFollower]
/// (transform-safe). Fecha ao clicar fora ([TapRegion] com [groupId]) e no `Esc`
/// ([Shortcuts]/[Actions] → [DismissIntent]); embrulha num [FocusScope] +
/// [FocusTraversalGroup] para navegação por teclado.
class AnchoredOverlay extends StatelessWidget {
  /// Cria um [AnchoredOverlay].
  const AnchoredOverlay({
    required this.link,
    required this.groupId,
    required this.placement,
    required this.onDismiss,
    required this.child,
    this.gap = AppSpacings.s4,
    this.autofocus = true,
    super.key,
  });

  /// Link para o trigger.
  final LayerLink link;

  /// Grupo de [TapRegion] (o mesmo do trigger).
  final Object groupId;

  /// Posição relativa ao trigger.
  final AppOverlayPlacement placement;

  /// Gap entre trigger e painel.
  final double gap;

  /// Fecha o overlay (clique fora / Esc).
  final VoidCallback onDismiss;

  /// Se deve tomar foco ao abrir (navegação por teclado). Menus = `true`;
  /// popovers com campo próprio = `false` (não roubar o foco do conteúdo).
  final bool autofocus;

  /// Painel.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final (Alignment target, Alignment follower, Offset offset) = _anchorsFor(
      placement,
      gap,
    );
    return Positioned(
      left: 0,
      top: 0,
      child: CompositedTransformFollower(
        link: link,
        showWhenUnlinked: false,
        targetAnchor: target,
        followerAnchor: follower,
        offset: offset,
        child: AppViewportBoundedOverlay(
          child: TapRegion(
            groupId: groupId,
            onTapOutside: (_) => onDismiss(),
            child: Shortcuts(
              shortcuts: const <ShortcutActivator, Intent>{
                SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
              },
              child: Actions(
                actions: <Type, Action<Intent>>{
                  DismissIntent: CallbackAction<DismissIntent>(
                    onInvoke: (DismissIntent _) {
                      onDismiss();
                      return null;
                    },
                  ),
                },
                child: FocusScope(
                  autofocus: autofocus,
                  child: FocusTraversalGroup(
                    policy: OrderedTraversalPolicy(),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Mantém um painel de overlay dentro da viewport, respeitando safe-area e uma
/// margem mínima nas bordas.
///
/// O posicionamento principal continua sendo feito pelo
/// [CompositedTransformFollower]. Após o layout, este widget mede a posição
/// global e aplica apenas a correção necessária para impedir overflow.
@internal
class AppViewportBoundedOverlay extends StatefulWidget {
  /// Cria um overlay limitado à viewport.
  const AppViewportBoundedOverlay({
    required this.child,
    this.edgePadding = AppSpacings.s24,
    super.key,
  });

  /// Conteúdo flutuante.
  final Widget child;

  /// Distância mínima das bordas, além da safe-area.
  final double edgePadding;

  @override
  State<AppViewportBoundedOverlay> createState() =>
      _AppViewportBoundedOverlayState();
}

class _AppViewportBoundedOverlayState extends State<AppViewportBoundedOverlay> {
  final GlobalKey _contentKey = GlobalKey();
  bool _correctionScheduled = false;
  Offset _translation = Offset.zero;

  @override
  Widget build(BuildContext context) {
    _scheduleCorrection();

    return Transform.translate(
      offset: _translation,
      child: KeyedSubtree(key: _contentKey, child: widget.child),
    );
  }

  void _scheduleCorrection() {
    if (_correctionScheduled) return;
    _correctionScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _correctionScheduled = false;
      if (!mounted) return;

      final renderObject = _contentKey.currentContext?.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.hasSize) return;

      final mediaQuery = MediaQuery.of(context);
      final rawTopLeft = renderObject.localToGlobal(Offset.zero) - _translation;
      final size = renderObject.size;
      final mediaQuerySize = mediaQuery.size;
      final view = View.of(context);
      // Widget tests can provide a MediaQuery without dimensions.
      final viewportSize = mediaQuerySize.isEmpty
          ? view.physicalSize / view.devicePixelRatio
          : mediaQuerySize;
      final safePadding = mediaQuery.viewPadding;
      final minX = safePadding.left + widget.edgePadding;
      final minY = safePadding.top + widget.edgePadding;
      final maxX = viewportSize.width - safePadding.right - widget.edgePadding;
      final maxY =
          viewportSize.height - safePadding.bottom - widget.edgePadding;

      double dx = 0;
      double dy = 0;
      if (rawTopLeft.dx < minX) {
        dx = minX - rawTopLeft.dx;
      } else if (rawTopLeft.dx + size.width > maxX) {
        dx = maxX - rawTopLeft.dx - size.width;
      }
      if (rawTopLeft.dy < minY) {
        dy = minY - rawTopLeft.dy;
      } else if (rawTopLeft.dy + size.height > maxY) {
        dy = maxY - rawTopLeft.dy - size.height;
      }

      final nextTranslation = Offset(dx, dy);
      if ((nextTranslation - _translation).distanceSquared < 0.01) return;
      setState(() => _translation = nextTranslation);
    });
  }
}
