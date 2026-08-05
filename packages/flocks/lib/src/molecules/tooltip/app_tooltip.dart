import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../foundation/a11y/app_semantics.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import '../card/anchored_overlay.dart';

const _longPressVisibleDuration = Duration(seconds: 2);
const _tooltipGap = 6.0;

/// Posição do tooltip em relação ao [AppTooltip.child].
enum AppTooltipPosition {
  /// Acima do child.
  top,

  /// Abaixo do child.
  bottom,

  /// À esquerda do child.
  left,

  /// À direita do child.
  right,
}

/// Tamanho do tooltip: controla o TAMANHO DA FONTE do balão. O padding é
/// constante (médio) nos três.
enum AppTooltipSize {
  /// Fonte compacta (`bodySmall`, 12).
  small,

  /// Fonte padrão (`bodyMedium`, 14).
  medium,

  /// Fonte ampla (`bodyLarge`, 16).
  large,
}

/// Tooltip customizado do design system (sem dependência do Material).
///
/// Exibe um balão com texto ao passar o mouse ou manter o toque pressionado
/// sobre o [child]. Renderiza via [Overlay] para nunca ser cortado por
/// containers pai, ancorado ao child por
/// [LayerLink]/[CompositedTransformFollower] — o que mantém a posição correta
/// mesmo sob transforms (ex.: zoom/centralização do Widgetbook). O tema é
/// capturado e reprovido dentro do overlay, então o balão funciona em qualquer
/// host (inclusive quando o `AppTheme` é injetado abaixo do Overlay).
///
/// Configurável: [position] (top/bottom/left/right), [size]
/// (small/medium/large), [maxWidth] (constraint — o texto quebra em várias
/// linhas). O radius do balão segue o radius global (modo redondo).
///
/// Exemplo:
/// ```dart
/// AppTooltip(
///   message: 'Mês anterior',
///   position: AppTooltipPosition.right,
///   size: AppTooltipSize.large,
///   maxWidth: 220,
///   child: AppIcon(AppIconToken.chevronLeft, size: AppIconSize.m),
/// )
/// ```
final class AppTooltip extends StatefulWidget {
  const AppTooltip({
    required this.child,
    required this.message,
    this.enabled = true,
    this.position = AppTooltipPosition.top,
    this.size = AppTooltipSize.medium,
    this.maxWidth,
    this.textStyle,
    super.key,
  });

  /// Conteúdo sobre o qual o tooltip aparece.
  final Widget child;

  /// Se o tooltip está habilitado.
  final bool enabled;

  /// Texto exibido no tooltip.
  final String message;

  /// Posição do tooltip em relação ao child.
  final AppTooltipPosition position;

  /// Tamanho da **fonte** do balão (o padding é constante).
  final AppTooltipSize size;

  /// Largura máxima do balão. Quando definida, o texto quebra em várias linhas;
  /// quando `null`, o balão dimensiona-se pela largura do texto (uma linha).
  final double? maxWidth;

  /// Estilo do texto. Quando nulo usa o estilo do [size]. A cor é sempre
  /// sobrescrita para o branco neutro.
  final TextStyle? textStyle;

  @override
  State<AppTooltip> createState() => _AppTooltipState();
}

class _AppTooltipState extends State<AppTooltip> {
  Timer? _hideTimer;
  final LayerLink _link = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    // O balão é pintado num OverlayEntry, fora desta árvore — então nada dele
    // chegava ao leitor de tela. `excludeFromSemantics` no detector só evita
    // anunciar o long-press; não publica a mensagem. Num controle só-ícone,
    // cuja dica É o nome dele (item do rail colapsado, alça de
    // redimensionar), o leitor anunciava um botão sem nome.
    return AppSemantics.tooltip(
      message: widget.enabled ? widget.message : '',
      child: CompositedTransformTarget(
        link: _link,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          excludeFromSemantics: true,
          onLongPress: _showFromLongPress,
          child: MouseRegion(
            onEnter: (_) => _show(),
            onExit: (_) => _hide(),
            child: widget.child,
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant AppTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.enabled && !widget.enabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _hide();
      });
    }

    if ((oldWidget.message != widget.message ||
            oldWidget.size != widget.size ||
            oldWidget.position != widget.position ||
            oldWidget.maxWidth != widget.maxWidth) &&
        _overlayEntry != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _overlayEntry?.markNeedsBuild();
      });
    }
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  void _hide() {
    _hideTimer?.cancel();
    _hideTimer = null;
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  // Padding constante (médio) — o [AppTooltipSize] varia apenas a fonte.
  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: AppSpacings.s8,
    vertical: AppSpacings.s4,
  );

  TextStyle _textStyleFor(AppTooltipSize size, AppTextTheme t) =>
      switch (size) {
        AppTooltipSize.small => t.bodySmall,
        AppTooltipSize.medium => t.bodyMedium,
        AppTooltipSize.large => t.bodyLarge,
      };

  void _show() {
    if (!widget.enabled || widget.message.trim().isEmpty) return;
    _hideTimer?.cancel();
    _hideTimer = null;
    if (_overlayEntry != null) return;

    // Captura o tema E o text scale AQUI (este `context` está sob os providers):
    // o overlay é inserido no `Overlay` raiz, que costuma ficar ACIMA do tema,
    // do text scale e do DefaultTextStyle → reprovê tudo na entry via
    // AppOverlayScope (senão: "No AppTheme found", texto sem escala e sublinhado
    // amarelo de fallback).
    final theme = AppTheme.of(context);
    final textScaler = MediaQuery.textScalerOf(context);

    // Ancoragem por posição (record: alvo, seguidor, offset do gap).
    final (
      Alignment target,
      Alignment follower,
      Offset offset,
    ) = switch (widget.position) {
      AppTooltipPosition.top => (
        Alignment.topCenter,
        Alignment.bottomCenter,
        const Offset(0, -_tooltipGap),
      ),
      AppTooltipPosition.bottom => (
        Alignment.bottomCenter,
        Alignment.topCenter,
        const Offset(0, _tooltipGap),
      ),
      AppTooltipPosition.left => (
        Alignment.centerLeft,
        Alignment.centerRight,
        const Offset(-_tooltipGap, 0),
      ),
      AppTooltipPosition.right => (
        Alignment.centerRight,
        Alignment.centerLeft,
        const Offset(_tooltipGap, 0),
      ),
    };

    final textStyle =
        (widget.textStyle ?? _textStyleFor(widget.size, theme.textTheme))
            .withColor(theme.colorTheme.neutralWhite);

    _overlayEntry = OverlayEntry(
      // Posicionado em (0,0) apenas para receber constraints LOOSE — assim o
      // balão dimensiona-se pelo conteúdo (um filho não-posicionado no Overlay
      // recebe constraints tight = tela inteira). O posicionamento real vem do
      // CompositedTransformFollower/LayerLink.
      builder: (_) {
        // Tooltips precisam nascer com o tamanho final para que a correção de
        // viewport seja calculada antes da primeira pintura visível.
        Widget balloon = DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: theme.radiusTheme.resolve(),
            color: theme.colorTheme.tertiary.s800,
          ),
          child: Padding(
            padding: _padding,
            // Troca de mensagem com o balão aberto entra em cross-fade (ex.:
            // "Copiar" → "Copiado!"). A `key` é obrigatória: sem ela
            // `Widget.canUpdate` é `true`, o switcher troca o texto no lugar e
            // nada anima.
            //
            // Nada de `AnimatedSize` para acompanhar a largura: ele anima por
            // LAYOUT, sem reconstruir a árvore, e o `AppViewportBoundedOverlay`
            // só reprograma o clamp a partir do `build` — o balão passaria a
            // ser corrigido pelo tamanho antigo e vazaria da viewport ao
            // crescer perto da borda. O `Stack` do cross-fade já reporta a
            // largura FINAL no primeiro frame da troca, que é o que mantém a
            // correção correta.
            child: AppCrossFade(
              child: Text(
                widget.message,
                key: ValueKey<String>(widget.message),
                style: textStyle,
              ),
            ),
          ),
        );
        final viewportSize = MediaQuery.sizeOf(context);
        final viewportMaxWidth = viewportSize.width > AppSpacings.s48
            ? viewportSize.width - AppSpacings.s48
            : double.infinity;
        final balloonMaxWidth = widget.maxWidth == null
            ? viewportMaxWidth
            : math.min(widget.maxWidth!, viewportMaxWidth);
        balloon = ConstrainedBox(
          key: const ValueKey<String>('app-tooltip-viewport-bounds'),
          constraints: BoxConstraints(maxWidth: balloonMaxWidth),
          child: balloon,
        );
        return Positioned(
          left: 0,
          top: 0,
          child: CompositedTransformFollower(
            link: _link,
            showWhenUnlinked: false,
            targetAnchor: target,
            followerAnchor: follower,
            offset: offset,
            child: AppViewportBoundedOverlay(
              child: IgnorePointer(
                child: AppOverlayScope(
                  theme: theme,
                  textScaler: textScaler,
                  // O balão usa o próprio estilo (texto branco) — vence o
                  // default do AppOverlayScope.
                  child: DefaultTextStyle(
                    style: textStyle,
                    child: AppAppear(fromScale: 1, child: balloon),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _showFromLongPress() {
    _show();
    if (_overlayEntry == null) return;
    _hideTimer = Timer(_longPressVisibleDuration, _hide);
  }
}
