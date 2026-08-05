import 'package:flutter/widgets.dart';

/// Tokens de curva de animação do Flocks.
sealed class AppCurves {
  /// Curva padrão: entrada e saída suaves.
  static const Curve standard = Curves.easeInOutCubic;

  /// Ênfase: saída acentuada (elementos que chegam com destaque).
  static const Curve emphasized = Curves.easeOutCubic;

  /// Desaceleração: para elementos que entram na tela.
  static const Curve decelerate = Curves.easeOut;

  /// Aceleração: para elementos que saem da tela.
  static const Curve accelerate = Curves.easeInCubic;

  /// Ênfase com **overshoot contido** (back-out sutil): passa levemente do alvo
  /// e assenta. Dá o "pop"/bounce das micro-interações (checkbox, radio,
  /// tooltip) sem o exagero de uma curva elástica. Fiel à filosofia minimalista.
  static const Curve emphasizedOvershoot = Cubic(0.34, 1.56, 0.64, 1.0);

  /// **Portadora**: sem easing próprio. Só para a animação cuja forma é dada
  /// adiante, por [Interval]s encadeados — o `t` tem de chegar linear para que
  /// cada fase aplique a sua curva sobre a fatia certa. É o caso do
  /// `AppRadio`, onde fundo e ponto ocupam metades distintas do mesmo `t`.
  ///
  /// Não use como "curva padrão": movimento linear é o que o olho lê como
  /// mecânico. Para isso existe [standard].
  static const Curve linear = Curves.linear;
}
