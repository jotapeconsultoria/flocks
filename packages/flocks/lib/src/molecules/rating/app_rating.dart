import 'dart:math' as math;

import 'package:flutter/services.dart'
    show KeyEvent, KeyUpEvent, LogicalKeyboardKey;
import 'package:flutter/widgets.dart';

import '../../foundation/a11y/app_semantics.dart';
import '../../theme/theme.dart';
import '../../tokens/app_sizes.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/swatch_generator.dart';

/// Avaliação por **estrelas** (display e input), com meio-passo opcional.
///
/// A estrela é **pintada** (`CustomPainter`) — determinística, sem depender de
/// ícone de rede. Quando [onChanged] é `null`, é somente-leitura; senão, clicar
/// (ou usar as setas do teclado) define o valor. Com [allowHalf], clicar na
/// metade esquerda de uma estrela vale meia.
///
/// ```dart
/// AppRating(value: 3.5, allowHalf: true, onChanged: (v) => setState(() => rating = v))
/// ```
final class AppRating extends StatefulWidget {
  /// Cria um [AppRating].
  const AppRating({
    required this.value,
    this.onChanged,
    this.count = 5,
    this.allowHalf = false,
    this.iconSize = AppSizes.s24,
    this.spacing = AppSpacings.s2,
    this.color,
    super.key,
  }) : assert(count > 0, 'count deve ser > 0'),
       assert(value >= 0, 'value deve ser >= 0');

  /// Valor atual (0..count), aceita `.5` quando [allowHalf].
  final double value;

  /// Notifica a mudança. `null` = somente-leitura.
  final ValueChanged<double>? onChanged;

  /// Número de estrelas.
  final int count;

  /// Se permite meia-estrela.
  final bool allowHalf;

  /// Tamanho de cada estrela.
  final double iconSize;

  /// Espaço entre estrelas.
  final double spacing;

  /// Cor do preenchimento. Default: acento âmbar (`warning` legível na surface).
  final Color? color;

  @override
  State<AppRating> createState() => _AppRatingState();
}

class _AppRatingState extends State<AppRating> {
  double? _hover;

  bool get _interactive => widget.onChanged != null;
  double get _display => _hover ?? widget.value;
  double get _step => widget.allowHalf ? 0.5 : 1.0;

  double _valueAt(int index, double localDx) {
    if (widget.allowHalf && localDx < widget.iconSize / 2) return index + 0.5;
    return index + 1.0;
  }

  void _set(double v) =>
      widget.onChanged?.call(v.clamp(0.0, widget.count.toDouble()));

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (!_interactive || event is KeyUpEvent) return KeyEventResult.ignored;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowRight:
      case LogicalKeyboardKey.arrowUp:
        _set(_display + _step);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowLeft:
      case LogicalKeyboardKey.arrowDown:
        _set(_display - _step);
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppColorTheme colors = AppTheme.of(context).colorTheme;
    final Color accent =
        widget.color ?? readableStopOn(colors.warning, colors.surface);
    final Color track = accent.withValues(alpha: 0.18);

    final Widget stars = Row(
      mainAxisSize: MainAxisSize.min,
      spacing: widget.spacing,
      children: <Widget>[
        for (int i = 0; i < widget.count; i++) _star(i, accent, track),
      ],
    );

    if (!_interactive) {
      return AppSemantics.label(label: _semLabel(widget.value), child: stars);
    }

    final double max = widget.count.toDouble();
    return Semantics(
      container: true,
      slider: true,
      value: _semLabel(widget.value),
      increasedValue: _semLabel((widget.value + _step).clamp(0.0, max)),
      decreasedValue: _semLabel((widget.value - _step).clamp(0.0, max)),
      onIncrease: () => _set(widget.value + _step),
      onDecrease: () => _set(widget.value - _step),
      child: Focus(onKeyEvent: _onKey, child: stars),
    );
  }

  Widget _star(int index, Color accent, Color track) {
    final double fraction = (_display - index).clamp(0.0, 1.0);
    final Widget star = SizedBox(
      width: widget.iconSize,
      height: widget.iconSize,
      child: CustomPaint(
        painter: _StarPainter(fraction: fraction, color: accent, track: track),
      ),
    );

    if (!_interactive) return star;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (e) =>
          setState(() => _hover = _valueAt(index, e.localPosition.dx)),
      onExit: (_) => setState(() => _hover = null),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (TapUpDetails d) => _set(_valueAt(index, d.localPosition.dx)),
        child: star,
      ),
    );
  }

  String _semLabel(double v) => '${_fmt(v)} de ${widget.count} estrelas';

  static String _fmt(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
}

/// Pinta uma estrela de 5 pontas: um "trilho" (estrela apagada) + o
/// preenchimento até [fraction] (recortado da esquerda) + contorno de acento.
class _StarPainter extends CustomPainter {
  _StarPainter({
    required this.fraction,
    required this.color,
    required this.track,
  });

  final double fraction;
  final Color color;
  final Color track;

  static const int _points = 5;

  Path _starPath(Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double outer = math.min(size.width, size.height) / 2;
    final double inner = outer * 0.42;
    final Path path = Path();
    const double step = math.pi / _points;
    double angle = -math.pi / 2; // começa no topo
    for (int i = 0; i < _points * 2; i++) {
      final double r = i.isEven ? outer : inner;
      final double x = cx + r * math.cos(angle);
      final double y = cy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      angle += step;
    }
    return path..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = _starPath(size);

    // Trilho (estrela apagada).
    canvas.drawPath(path, Paint()..color = track);

    // Preenchimento até fraction (recorte da esquerda).
    if (fraction > 0) {
      canvas.save();
      canvas.clipRect(Rect.fromLTWH(0, 0, size.width * fraction, size.height));
      canvas.drawPath(path, Paint()..color = color);
      canvas.restore();
    }

    // Contorno de acento (sempre visível).
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_StarPainter old) =>
      old.fraction != fraction || old.color != color || old.track != track;
}
