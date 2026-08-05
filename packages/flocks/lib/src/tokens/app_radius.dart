/// A class that defines the radius values used in the App.
sealed class AppRadius {
  /// The radius value for no radius. (0.0)
  static const double none = 0.0;

  /// The radius value for the extra small radius. (1.0)
  static const double xs = 1.0;

  /// The radius value for the small radius. (2.0)
  static const double s = 2.0;

  /// The radius value for the medium radius. (4.0)
  static const double m = 4.0;

  /// The radius value for the large radius. (8.0)
  static const double l = 8.0;

  /// The radius value for the extra large radius. (16.0)
  static const double xl = 16.0;
}

/// Eixo global de **forma dos cantos** do Flocks.
///
/// Diferente de uma escala de pixels: descreve a INTENÇÃO de forma, resolvida
/// por componente contra o próprio tamanho (ver `appResolveRadius`). É temável
/// globalmente (`AppThemeData.radiusTheme`) e sobrescrevível por componente
/// (parâmetros `radiusMode:` / `radius:`), espelhando o eixo de estilo
/// ([AppStyle]).
///
/// - [reto]: sem arredondamento (0) — cantos retos.
/// - [redondo]: cantos arredondados **proporcionais** ao tamanho (uma fração do
///   lado menor, com teto) — o arredondamento "padrão", consistente entre
///   componentes de tamanhos diferentes.
/// - [circular]: metade do lado menor → círculo/pílula (depende da altura do
///   componente).
/// - [padrao]: cada componente segue o SEU próprio default (ex.: checkbox →
///   [redondo], radio → [circular]). Não força uma forma única — apenas deixa
///   cada componente com a sua aparência natural.
enum AppRadiusMode {
  /// Cantos retos (raio 0).
  reto,

  /// Arredondamento proporcional ao tamanho (fração do lado menor, com teto).
  redondo,

  /// Círculo/pílula (metade do lado menor).
  circular,

  /// Cada componente usa o seu próprio default de forma.
  padrao,
}
