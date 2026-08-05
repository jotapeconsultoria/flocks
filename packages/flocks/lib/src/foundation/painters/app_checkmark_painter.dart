import 'package:flutter/widgets.dart';

/// Desenha um "tique" (✓) com o traço revelado progressivamente.
///
/// O caminho é traçado em coordenadas relativas ao [Size] recebido, então o
/// mesmo painter serve a um checkbox de 24 px e a um ícone de 16 px. Com
/// [progress] < 1 apenas essa fração do comprimento do traço é desenhada — é o
/// que permite *animar o desenho* em vez de aparecer pronto.
///
/// É um `CustomPainter`, não um ícone de rede: usar isto num estado de
/// confirmação evita que uma falha de download vire um erro visual bem no
/// momento em que o usuário precisa da confirmação.
///
/// ```dart
/// AppValueBuilder(
///   value: checked ? 1.0 : 0.0,
///   builder: (context, t, _) => CustomPaint(
///     painter: AppCheckmarkPainter(color: colors.indicator, progress: t),
///   ),
/// )
/// ```
class AppCheckmarkPainter extends CustomPainter {
  /// Cria um [AppCheckmarkPainter].
  AppCheckmarkPainter({
    required this.color,
    this.progress = 1.0,
    this.strokeWidth = 2.0,
  });

  /// Cor do traço.
  final Color color;

  /// Fração do traço desenhada (0–1).
  final double progress;

  /// Espessura do traço.
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * 0.25, size.height * 0.50)
      ..lineTo(size.width * 0.42, size.height * 0.68)
      ..lineTo(size.width * 0.75, size.height * 0.32);

    if (progress >= 1) {
      canvas.drawPath(path, paint);
      return;
    }

    // Desenha só a fração [progress] do comprimento total do traço.
    final metrics = path.computeMetrics().toList();
    final double total = metrics.fold<double>(0, (sum, m) => sum + m.length);
    double remaining = total * progress;
    final Path partial = Path();
    for (final metric in metrics) {
      if (remaining <= 0) break;
      final double take = remaining < metric.length ? remaining : metric.length;
      partial.addPath(metric.extractPath(0, take), Offset.zero);
      remaining -= take;
    }
    canvas.drawPath(partial, paint);
  }

  @override
  bool shouldRepaint(AppCheckmarkPainter oldDelegate) =>
      color != oldDelegate.color ||
      progress != oldDelegate.progress ||
      strokeWidth != oldDelegate.strokeWidth;
}
