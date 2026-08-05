/// Tamanho de um botão do Flocks (altura + métricas do loading).
enum AppButtonSize {
  /// Pequeno (altura 40).
  s,

  /// Médio (altura 48).
  m,

  /// Grande (altura 56).
  l;

  /// Altura do botão em pixels.
  double get height => switch (this) {
    AppButtonSize.s => 40.0,
    AppButtonSize.m => 48.0,
    AppButtonSize.l => 56.0,
  };

  /// Tamanho do indicador de loading.
  double get loadingSize => switch (this) {
    AppButtonSize.s => 16.0,
    AppButtonSize.m => 20.0,
    AppButtonSize.l => 24.0,
  };

  /// Espessura do traço do indicador de loading.
  double get loadingStroke => switch (this) {
    AppButtonSize.s => 2.0,
    AppButtonSize.m => 2.5,
    AppButtonSize.l => 3.0,
  };
}
