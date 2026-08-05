import 'package:flutter/widgets.dart';

import '../../molecules/tooltip/tooltip.dart';
import '../../motion/app_motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// Comprimento padrão da alça (lado longo, ao longo da calha).
const double kResizeHandleLength = 64;

/// Espessura padrão da alça (lado curto, atravessando a calha).
const double kResizeHandleThickness = 8;

/// Espessura padrão da calha — também o alvo de hover/arraste.
const double kResizeGutterThickness = AppSpacings.s16;

/// A calha arrastável: cursor de resize, alça que acende no hover e no arraste,
/// e duplo-toque para resetar.
///
/// **Interna ao pacote** (não sai no barrel): existe para o
/// [AppResizableSplit] e o [AppResizablePanel] dividirem exatamente a mesma
/// afordância. Duas implementações da mesma alça divergiriam na primeira
/// mudança de token — e "arrastar para redimensionar" precisa ser reconhecível
/// como um gesto só em todo o app.
///
/// Não sabe o que está redimensionando: só reporta o delta do arraste no eixo
/// de [direction] e deixa a aritmética (fração, largura em px, limites) com
/// quem a monta.
final class ResizeGutter extends StatefulWidget {
  const ResizeGutter({
    required this.direction,
    required this.onDragDelta,
    this.onDragEnd,
    this.onReset,
    this.thickness = kResizeGutterThickness,
    this.handleLength = kResizeHandleLength,
    this.handleThickness = kResizeHandleThickness,
    this.tooltip = 'Redimensionar',
    super.key,
  });

  /// Eixo do arraste. [Axis.horizontal] = calha vertical, arrasta em x.
  final Axis direction;

  /// Delta do arraste no eixo de [direction] (px desde o último evento).
  final ValueChanged<double> onDragDelta;

  /// Fim do arraste.
  final VoidCallback? onDragEnd;

  /// Duplo-toque na calha.
  final VoidCallback? onReset;

  /// Lado curto da calha — sua largura no horizontal, sua altura no vertical.
  /// Também é a área de hover/hit.
  final double thickness;

  /// Comprimento da alça (ao longo da calha).
  final double handleLength;

  /// Espessura da alça (atravessando a calha).
  final double handleThickness;

  /// Tooltip no hover. `null` desliga.
  final String? tooltip;

  @override
  State<ResizeGutter> createState() => _ResizeGutterState();
}

class _ResizeGutterState extends State<ResizeGutter> {
  bool _hovered = false;
  bool _dragging = false;

  bool get _isHorizontal => widget.direction == Axis.horizontal;

  void _onDragStart() => setState(() => _dragging = true);

  void _onDragEnd() {
    setState(() => _dragging = false);
    widget.onDragEnd?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    // Acento do handle resolvido por contraste sobre a superfície: a base do
    // `primary` sumia no arrasto (dark-on-dark) e o `s50` sumia no hover
    // (light-on-light). `readableStopOn` contrasta ≥3:1 nos dois temas.
    final Color accent = readableStopOn(
      theme.colorTheme.primary,
      theme.colorTheme.surface,
    );

    // Hidden at rest, revealed on hover (accent 50%), lit on drag (accent full).
    final handleColor = _dragging
        ? accent
        : _hovered
        ? accent.customOpacity(.5)
        : theme.colorTheme.transparent;
    // Grows a touch while dragging to reinforce the "lit" state.
    final crossThickness = _dragging
        ? widget.handleThickness + AppSpacings.s2
        : widget.handleThickness;

    final handle = AnimatedContainer(
      duration: AppMotion.resolve(context, AppDurations.fast),
      curve: AppCurves.decelerate,
      width: _isHorizontal ? crossThickness : widget.handleLength,
      height: _isHorizontal ? widget.handleLength : crossThickness,
      decoration: BoxDecoration(
        color: handleColor,
        borderRadius: BorderRadius.circular(widget.handleThickness),
      ),
    );

    final visual = SizedBox(
      width: _isHorizontal ? widget.thickness : double.infinity,
      height: _isHorizontal ? double.infinity : widget.thickness,
      child: Center(child: handle),
    );

    Widget gutter = MouseRegion(
      cursor: _isHorizontal
          ? SystemMouseCursors.resizeColumn
          : SystemMouseCursors.resizeRow,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: SelectionContainer.disabled(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onDoubleTap: widget.onReset,
          onHorizontalDragStart: _isHorizontal ? (_) => _onDragStart() : null,
          onHorizontalDragUpdate: _isHorizontal
              ? (d) => widget.onDragDelta(d.delta.dx)
              : null,
          onHorizontalDragEnd: _isHorizontal ? (_) => _onDragEnd() : null,
          onVerticalDragStart: _isHorizontal ? null : (_) => _onDragStart(),
          onVerticalDragUpdate: _isHorizontal
              ? null
              : (d) => widget.onDragDelta(d.delta.dy),
          onVerticalDragEnd: _isHorizontal ? null : (_) => _onDragEnd(),
          child: visual,
        ),
      ),
    );

    final tooltip = widget.tooltip;
    if (tooltip != null) {
      gutter = AppTooltip(
        message: tooltip,
        textStyle: theme.textTheme.labelLarge,
        child: gutter,
      );
    }
    return gutter;
  }
}
