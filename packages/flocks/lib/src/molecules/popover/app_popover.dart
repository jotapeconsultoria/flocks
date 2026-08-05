import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../foundation/flocks_interaction.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/app_glass.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_strokes.dart';
import '../../tokens/app_style.dart';
import '../card/anchored_overlay.dart';

/// Como o [AppPopover] é acionado.
enum AppPopoverTrigger {
  /// Abre/fecha ao clicar (ou Enter/Space com o trigger focado).
  click,

  /// Abre ao passar o mouse; fecha ao sair do trigger e do painel.
  hover,
}

/// Controla um [AppPopover] de forma programática (abrir/fechar de fora).
///
/// ```dart
/// final controller = AppPopoverController();
/// // ...
/// AppPopover(controller: controller, trigger: ..., child: ...);
/// controller.open();
/// ```
final class AppPopoverController {
  VoidCallback? _open;
  VoidCallback? _close;
  bool Function()? _isOpen;

  /// Se o popover está aberto.
  bool get isOpen => _isOpen?.call() ?? false;

  /// Abre o popover.
  void open() => _open?.call();

  /// Fecha o popover.
  void close() => _close?.call();

  /// Abre se fechado; fecha se aberto.
  void toggle() => isOpen ? close() : open();

  void _attach({
    required VoidCallback open,
    required VoidCallback close,
    required bool Function() isOpen,
  }) {
    _open = open;
    _close = close;
    _isOpen = isOpen;
  }

  void _detach() {
    _open = null;
    _close = null;
    _isOpen = null;
  }
}

/// Popover: overlay de **conteúdo rico** ancorado a um [trigger].
///
/// Mais que o [AppTooltip] (só texto) e mais específico que o [AppCard]
/// (card genérico): abre no clique ou no hover, exibe um [child] arbitrário (com
/// [title] e [actions] opcionais), desenha uma [showArrow] apontando para o
/// alvo e fecha ao clicar fora / `Esc`. Renderiza via [Overlay] ancorado por
/// [LayerLink] (transform-safe) e reprovê o tema dentro da entry.
///
/// O [trigger] deve ser **conteúdo passivo** (ícone/texto/box) — o popover é quem
/// o torna acionável. Para abrir/fechar de fora, passe um [controller].
///
/// ```dart
/// AppPopover(
///   trigger: AppIcon(AppIconToken.info, semanticLabel: 'Ajuda'),
///   title: 'Sobre o score',
///   child: AppText('O score combina frenagens, curvas e velocidade.'),
///   actions: <Widget>[AppInteraction(onTap: () {}, child: AppText('Entendi'))],
/// )
/// ```
final class AppPopover extends StatefulWidget {
  /// Cria um [AppPopover].
  const AppPopover({
    required this.trigger,
    required this.child,
    this.title,
    this.actions,
    this.placement = AppOverlayPlacement.bottomCenter,
    this.showArrow = true,
    this.triggerMode = AppPopoverTrigger.click,
    this.style,
    this.glass,
    this.radiusMode,
    this.radius,
    this.maxWidth,
    this.controller,
    super.key,
  });

  /// Conteúdo passivo que ancora o popover (o popover o torna acionável).
  final Widget trigger;

  /// Conteúdo rico exibido dentro do painel.
  final Widget child;

  /// Título opcional (cabeçalho do painel).
  final String? title;

  /// Ações opcionais no rodapé do painel (ex.: botões do DS).
  final List<Widget>? actions;

  /// Posição do painel em relação ao trigger.
  final AppOverlayPlacement placement;

  /// Se desenha a seta apontando para o trigger.
  final bool showArrow;

  /// Como o popover é acionado (clique ou hover).
  final AppPopoverTrigger triggerMode;

  /// Tratamento de container do balão no eixo [AppStyle], no render **não-glass**.
  /// `null` (default) = [AppStyle.elevated] (sombra) — o overlay não segue o
  /// global `styleTheme`.
  final AppStyle? style;

  /// Override do eixo glass só deste popover. `null` segue o global
  /// (`theme.glassTheme.enabled`); quando ligado, o balão vira vidro real (o
  /// blur é clipado à forma do balão, seta inclusa). Cai para opaco sob
  /// transparência reduzida (`AppTransparency`).
  final bool? glass;

  /// Sobrescreve o modo de forma do balão — vence o global
  /// `theme.radiusTheme.mode`.
  final AppRadiusMode? radiusMode;

  /// Override cru do raio do balão (usa `topLeft.x`) — vence [radiusMode] e o
  /// global.
  final BorderRadius? radius;

  /// Largura máxima do painel. Quando `null`, dimensiona pelo conteúdo.
  final double? maxWidth;

  /// Controlador programático (opcional).
  final AppPopoverController? controller;

  @override
  State<AppPopover> createState() => _AppPopoverState();
}

class _AppPopoverState extends State<AppPopover> {
  final AnchoredOverlayController _overlay = AnchoredOverlayController();
  Timer? _closeTimer;

  static const double _arrowW = 16;
  static const double _arrowH = 8;

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(
      open: _open,
      close: _close,
      isOpen: () => _overlay.isOpen,
    );
  }

  @override
  void dispose() {
    _closeTimer?.cancel();
    widget.controller?._detach();
    _overlay.dispose();
    super.dispose();
  }

  double get _gap => widget.showArrow ? _arrowH : AppSpacings.s4;

  void _open() {
    _closeTimer?.cancel();
    if (_overlay.isOpen) return;
    _overlay.open(
      context,
      placement: widget.placement,
      gap: _gap,
      // Popover não rouba foco: o conteúdo (campo/botão) recebe foco naturalmente.
      autofocus: false,
      builder: _panel,
    );
  }

  void _close() {
    _closeTimer?.cancel();
    _overlay.close();
  }

  void _toggle() => _overlay.isOpen ? _close() : _open();

  void _scheduleClose() {
    _closeTimer?.cancel();
    _closeTimer = Timer(const Duration(milliseconds: 120), _close);
  }

  void _cancelClose() => _closeTimer?.cancel();

  bool get _pointsUp => switch (widget.placement) {
    AppOverlayPlacement.bottomStart ||
    AppOverlayPlacement.bottomCenter ||
    AppOverlayPlacement.bottomEnd => true,
    AppOverlayPlacement.topStart ||
    AppOverlayPlacement.topCenter ||
    AppOverlayPlacement.topEnd => false,
  };

  Alignment get _arrowAlign => switch (widget.placement) {
    AppOverlayPlacement.bottomStart ||
    AppOverlayPlacement.topStart => Alignment.centerLeft,
    AppOverlayPlacement.bottomCenter ||
    AppOverlayPlacement.topCenter => Alignment.center,
    AppOverlayPlacement.bottomEnd ||
    AppOverlayPlacement.topEnd => Alignment.centerRight,
  };

  Widget _panel(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;

    // Eixo global de estilo (filled/outlined/elevated). Como toda superfície
    // flutuante, o balão tem default próprio `elevated` (não segue o global
    // `styleTheme`); a forma, sim, segue o `radiusTheme`.
    final bool isDark = theme.brightness == AppBrightness.dark;
    final AppStyle style = widget.style ?? AppStyle.elevated;
    // Eixo glass (aditivo): override por instância ou global; cai para opaco sob
    // transparência reduzida (paridade com o AppGlassSurface).
    final bool glassOn = widget.glass ?? theme.glassTheme.enabled;
    final bool renderGlass = glassOn && AppTransparency.enabled(context);
    final StyleDecoration deco = resolveStyleDecoration(
      style: style,
      isDark: isDark,
      outline: colors.outline,
      surfaceContainer: colors.surfaceContainer,
      // Balão sempre opaco (mesmo no `outlined`): fill `surfaceContainer`.
      ownFill: colors.surfaceContainer,
    );
    // Escala de superfície (24/48), NÃO o resolver genérico: o balão é
    // content-sized, então `circular` cairia no sentinela 9999 e saturaria em
    // metade do lado menor — o Path do balão degenera, o desenho some e o
    // ClipPath quebrado deixa o BackdropFilter vazar sobre a tela inteira.
    final double radius =
        widget.radius?.topLeft.x ??
        theme.radiusTheme.surfaceCornerRadius(widget.radiusMode);

    final bool up = _pointsUp;
    final double arrowH = widget.showArrow ? _arrowH : 0.0;
    final double arrowW = widget.showArrow ? _arrowW : 0.0;

    final Widget content = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.title != null) ...<Widget>[
            AppSemantics.header(
              AppText(
                widget.title!,
                style: theme.textTheme.titleMedium.copyWith(
                  color: colors.onSurface,
                ),
              ),
            ),
            const SizedBox(height: AppSpacings.s8),
          ],
          widget.child,
          if (widget.actions != null && widget.actions!.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacings.s16),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacings.s8,
              children: widget.actions!,
            ),
          ],
        ],
      ),
    );

    final Widget paddedContent = Padding(
      padding: EdgeInsets.only(
        top: (up ? arrowH : 0) + AppSpacings.s16,
        bottom: (up ? 0 : arrowH) + AppSpacings.s16,
        left: AppSpacings.s16,
        right: AppSpacings.s16,
      ),
      child: content,
    );

    // Balão inteiro (retângulo + seta) num único path → a seta alinha com a
    // borda e sombreia junto (drawShadow). O padding reserva a protrusão da seta
    // no lado ancorado.
    Widget bubble;
    if (renderGlass) {
      // Vidro: blur do fundo clipado à forma do balão (seta inclusa), com tint
      // translúcido + rim hairline por cima. AppGlassSurface não serve aqui (não
      // desenha a seta), então reaproveita-se o painter do balão em camadas.
      final Color tint = colors.glassTint(isDark: isDark);
      final Color rim = colors.glassBorder(isDark: isDark);
      bubble = Stack(
        children: <Widget>[
          // (A) sombra do balão, atrás de tudo (fill transparente → só a sombra).
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _PopoverBubblePainter(
                  fill: colors.transparent,
                  border: rim,
                  hasShadow: true,
                  hasBorder: false,
                  isDark: isDark,
                  radius: radius,
                  pointsUp: up,
                  arrowW: arrowW,
                  arrowH: arrowH,
                  arrowAlign: _arrowAlign,
                ),
              ),
            ),
          ),
          // (B) blur do fundo, clipado à forma do balão.
          Positioned.fill(
            child: IgnorePointer(
              child: ClipPath(
                clipper: _PopoverBubbleClipper(
                  radius: radius,
                  pointsUp: up,
                  arrowW: arrowW,
                  arrowH: arrowH,
                  arrowAlign: _arrowAlign,
                ),
                child: BackdropFilter(
                  // Desfoca E re-satura o fundo (ver AppGlass.backdropFilter).
                  filter: AppGlass.backdropFilter(),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
          // (C) tint translúcido + rim hairline + conteúdo, por cima do blur.
          CustomPaint(
            painter: _PopoverBubblePainter(
              fill: tint,
              border: rim,
              hasShadow: false,
              hasBorder: true,
              isDark: isDark,
              radius: radius,
              pointsUp: up,
              arrowW: arrowW,
              arrowH: arrowH,
              arrowAlign: _arrowAlign,
              strokeWidth: AppStrokes.xs,
            ),
            child: paddedContent,
          ),
        ],
      );
    } else {
      bubble = CustomPaint(
        painter: _PopoverBubblePainter(
          fill: deco.color ?? colors.surfaceContainer,
          border: colors.outline,
          hasShadow: deco.boxShadow != null,
          hasBorder: deco.border != null,
          isDark: isDark,
          radius: radius,
          pointsUp: up,
          arrowW: arrowW,
          arrowH: arrowH,
          arrowAlign: _arrowAlign,
        ),
        child: paddedContent,
      );
    }

    final viewportSize = MediaQuery.sizeOf(context);
    final viewportMaxHeight = viewportSize.height > AppSpacings.s48
        ? viewportSize.height - AppSpacings.s48
        : double.infinity;
    final viewportMaxWidth = viewportSize.width > AppSpacings.s48
        ? viewportSize.width - AppSpacings.s48
        : double.infinity;
    final panelMaxWidth = widget.maxWidth == null
        ? viewportMaxWidth
        : math.min(widget.maxWidth!, viewportMaxWidth);
    bubble = ConstrainedBox(
      key: const ValueKey<String>('app-popover-viewport-bounds'),
      constraints: BoxConstraints(
        maxHeight: viewportMaxHeight,
        maxWidth: panelMaxWidth,
      ),
      child: bubble,
    );

    Widget panel = AppAppear(child: bubble);

    if (widget.triggerMode == AppPopoverTrigger.hover) {
      panel = MouseRegion(
        onEnter: (_) => _cancelClose(),
        onExit: (_) => _scheduleClose(),
        child: panel,
      );
    }
    return panel;
  }

  @override
  Widget build(BuildContext context) {
    final Widget anchored = CompositedTransformTarget(
      link: _overlay.link,
      child: widget.triggerMode == AppPopoverTrigger.hover
          ? MouseRegion(
              onEnter: (_) => _open(),
              onExit: (_) => _scheduleClose(),
              child: widget.trigger,
            )
          : FlocksInteraction(
              onPressed: _toggle,
              builder: (BuildContext context, Set<WidgetState> _) =>
                  widget.trigger,
            ),
    );
    return TapRegion(groupId: _overlay.groupId, child: anchored);
  }
}

/// Centro X da seta (clampado às quinas arredondadas do balão) — compartilhado
/// pelo painter e pelo clipper do vidro, para o path e o clip coincidirem.
double _popoverArrowCenterX(
  double w, {
  required double radius,
  required double arrowW,
  required Alignment arrowAlign,
}) {
  final double lo = radius + arrowW / 2 + AppSpacings.s8;
  final double hi = w - radius - arrowW / 2 - AppSpacings.s8;
  if (hi < lo) return w / 2;
  if (arrowAlign.x < 0) return lo;
  if (arrowAlign.x > 0) return hi;
  return (w / 2).clamp(lo, hi);
}

/// Path do balão (retângulo arredondado + seta) como **um único path** — a seta
/// alinha com a borda. Fonte única para o painter (fill/rim/sombra) e o clipper
/// do vidro (recorte do `BackdropFilter`).
Path _popoverBubblePath(
  Size size, {
  required double radius,
  required double arrowW,
  required double arrowH,
  required bool pointsUp,
  required Alignment arrowAlign,
}) {
  final double w = size.width;
  final double h = size.height;
  final double r = radius;
  final Path p = Path();

  if (arrowW <= 0 || arrowH <= 0) {
    return p..addRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, h), Radius.circular(r)),
    );
  }

  final double acx = _popoverArrowCenterX(
    w,
    radius: radius,
    arrowW: arrowW,
    arrowAlign: arrowAlign,
  );
  final Radius rad = Radius.circular(r);

  if (pointsUp) {
    final double top = arrowH;
    p
      ..moveTo(r, top)
      ..lineTo(acx - arrowW / 2, top)
      ..lineTo(acx, 0)
      ..lineTo(acx + arrowW / 2, top)
      ..lineTo(w - r, top)
      ..arcToPoint(Offset(w, top + r), radius: rad)
      ..lineTo(w, h - r)
      ..arcToPoint(Offset(w - r, h), radius: rad)
      ..lineTo(r, h)
      ..arcToPoint(Offset(0, h - r), radius: rad)
      ..lineTo(0, top + r)
      ..arcToPoint(Offset(r, top), radius: rad)
      ..close();
  } else {
    final double bottom = h - arrowH;
    p
      ..moveTo(r, 0)
      ..lineTo(w - r, 0)
      ..arcToPoint(Offset(w, r), radius: rad)
      ..lineTo(w, bottom - r)
      ..arcToPoint(Offset(w - r, bottom), radius: rad)
      ..lineTo(acx + arrowW / 2, bottom)
      ..lineTo(acx, h)
      ..lineTo(acx - arrowW / 2, bottom)
      ..lineTo(r, bottom)
      ..arcToPoint(Offset(0, bottom - r), radius: rad)
      ..lineTo(0, r)
      ..arcToPoint(Offset(r, 0), radius: rad)
      ..close();
  }
  return p;
}

/// Recorta o `BackdropFilter` do vidro à forma do balão (seta inclusa).
class _PopoverBubbleClipper extends CustomClipper<Path> {
  _PopoverBubbleClipper({
    required this.radius,
    required this.pointsUp,
    required this.arrowW,
    required this.arrowH,
    required this.arrowAlign,
  });

  final double radius;
  final bool pointsUp;
  final double arrowW;
  final double arrowH;
  final Alignment arrowAlign;

  @override
  Path getClip(Size size) => _popoverBubblePath(
    size,
    radius: radius,
    arrowW: arrowW,
    arrowH: arrowH,
    pointsUp: pointsUp,
    arrowAlign: arrowAlign,
  );

  @override
  bool shouldReclip(_PopoverBubbleClipper old) =>
      old.radius != radius ||
      old.pointsUp != pointsUp ||
      old.arrowW != arrowW ||
      old.arrowH != arrowH ||
      old.arrowAlign != arrowAlign;
}

/// Desenha o balão do popover (retângulo arredondado + seta) como **um único
/// path** → a seta alinha com a borda e sombreia junto. Reflete o eixo
/// [AppStyle]: [hasShadow] (elevated) pinta a sombra simétrica no path (sem
/// Material); [hasBorder] (outlined) faz o stroke `border`; `filled` só o fill.
/// No eixo glass é reaproveitado em camadas (sombra / tint + rim hairline).
class _PopoverBubblePainter extends CustomPainter {
  _PopoverBubblePainter({
    required this.fill,
    required this.border,
    required this.hasShadow,
    required this.hasBorder,
    required this.isDark,
    required this.radius,
    required this.pointsUp,
    required this.arrowW,
    required this.arrowH,
    required this.arrowAlign,
    this.strokeWidth = AppStrokes.m,
  });

  final Color fill;
  final Color border;
  final bool hasShadow;
  final bool hasBorder;
  final bool isDark;
  final double radius;
  final bool pointsUp;
  final double arrowW;
  final double arrowH;
  final Alignment arrowAlign;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = _popoverBubblePath(
      size,
      radius: radius,
      arrowW: arrowW,
      arrowH: arrowH,
      pointsUp: pointsUp,
      arrowAlign: arrowAlign,
    );
    if (hasShadow) {
      // Sombra SIMÉTRICA (offset zero): blur do path nos dois lados. Espelha o
      // efeito de elevação do AppCard (BoxShadow simétrico de
      // AppElevation.symmetricShadows), incluindo a seta. Duas camadas p/ suavizar.
      const Color base = Color(0xFF000000);
      canvas.drawPath(
        path,
        Paint()
          ..color = base.withValues(alpha: isDark ? 0.42 : 0.14)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, isDark ? 9 : 7),
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = base.withValues(alpha: isDark ? 0.30 : 0.10)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, isDark ? 4 : 3),
      );
    }
    canvas.drawPath(path, Paint()..color = fill);
    if (hasBorder) {
      canvas.drawPath(
        path,
        Paint()
          ..color = border
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  @override
  bool shouldRepaint(_PopoverBubblePainter old) =>
      old.fill != fill ||
      old.border != border ||
      old.hasShadow != hasShadow ||
      old.hasBorder != hasBorder ||
      old.isDark != isDark ||
      old.radius != radius ||
      old.pointsUp != pointsUp ||
      old.arrowW != arrowW ||
      old.arrowH != arrowH ||
      old.arrowAlign != arrowAlign ||
      old.strokeWidth != strokeWidth;
}
