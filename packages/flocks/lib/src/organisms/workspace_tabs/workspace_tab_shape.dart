import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

/// A silhueta de aba de navegador: topo arredondado para fora, base alargando
/// em curvas **invertidas** que encostam na linha do conteúdo.
///
/// ```
///      ╭──────────╮
///     ╱            ╲        ← as "asas": curvas côncavas
/// ───╯              ╰───    ← linha do conteúdo, que a aba interrompe
/// ```
///
/// As asas são o que faz a aba parecer parte da página, e não uma pílula
/// pousada em cima dela: sem elas, o encontro entre a aba e a linha é um canto
/// reto e a leitura vira "caixa sobre superfície".
///
/// A base fica **aberta** de propósito — [side] pinta só o contorno de cima.
/// Uma linha fechando embaixo separaria de novo o que a forma acabou de unir.
@immutable
final class WorkspaceTabShape extends ShapeBorder {
  const WorkspaceTabShape({
    required this.radius,
    required this.wingRadius,
    this.side = BorderSide.none,
  });

  /// Raio dos cantos de cima (convexos).
  final double radius;

  /// Raio das asas de baixo (côncavas). `0` devolve uma aba de base reta.
  final double wingRadius;

  /// Contorno. Desenhado só na parte de cima.
  final BorderSide side;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  ShapeBorder scale(double t) => WorkspaceTabShape(
    radius: radius * t,
    wingRadius: wingRadius * t,
    side: side.scale(t),
  );

  /// O caminho de cima: asa esquerda → canto → topo → canto → asa direita.
  ///
  /// Compartilhado pelo preenchimento e pelo contorno; o preenchimento apenas
  /// fecha a base depois.
  Path _outline(Rect rect) {
    // Numa aba muito estreita os raios se atropelam; o teto mantém a forma
    // legível em vez de inverter as curvas.
    final double w = math.min(wingRadius, rect.width / 4);
    final double r = math.min(radius, math.max(0, rect.width / 2 - w));
    final double top = rect.top;
    final double bottom = rect.bottom;

    return Path()
      ..moveTo(rect.left, bottom)
      // Asa esquerda: sobe da base abrindo para dentro.
      ..quadraticBezierTo(rect.left + w, bottom, rect.left + w, bottom - w)
      ..lineTo(rect.left + w, top + r)
      // Canto superior esquerdo.
      ..quadraticBezierTo(rect.left + w, top, rect.left + w + r, top)
      ..lineTo(rect.right - w - r, top)
      // Canto superior direito.
      ..quadraticBezierTo(rect.right - w, top, rect.right - w, top + r)
      ..lineTo(rect.right - w, bottom - w)
      // Asa direita.
      ..quadraticBezierTo(rect.right - w, bottom, rect.right, bottom);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      _outline(rect)..close();

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect.deflate(side.width), textDirection: textDirection);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none || side.width <= 0) return;
    // Sem `close()`: o traço acompanha só o contorno de cima.
    canvas.drawPath(
      _outline(rect.deflate(side.width / 2)),
      side.toPaint()..style = PaintingStyle.stroke,
    );
  }

  /// Interpolação entre duas abas.
  ///
  /// Sem isto o `ShapeBorder.lerp` cairia no `t < 0.5 ? a : b` e a borda
  /// **piscaria** no meio da transição em vez de aparecer suavemente — que é
  /// justamente o que se quer animar quando a aba é selecionada.
  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is! WorkspaceTabShape) return super.lerpFrom(a, t);
    return WorkspaceTabShape(
      radius: lerpDouble(a.radius, radius, t)!,
      wingRadius: lerpDouble(a.wingRadius, wingRadius, t)!,
      side: BorderSide.lerp(a.side, side, t),
    );
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is! WorkspaceTabShape) return super.lerpTo(b, t);
    return b.lerpFrom(this, t);
  }

  @override
  bool operator ==(Object other) =>
      other is WorkspaceTabShape &&
      other.radius == radius &&
      other.wingRadius == wingRadius &&
      other.side == side;

  @override
  int get hashCode => Object.hash(radius, wingRadius, side);
}
