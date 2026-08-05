import 'app_spacings.dart';

/// Tamanho de um campo de formulário do Flocks (`AppInput`, dropdowns, pickers,
/// color picker). Espelha a mecânica de `AppButtonSize`: uma **altura fixa** por
/// tamanho + métricas internas (padding/ícone), para os campos casarem com os
/// botões nas mesmas linhas de formulário.
enum AppFieldSize {
  /// Pequeno — altura 40.
  s,

  /// Médio — altura 48 (default dos campos).
  m,

  /// Grande — altura 56.
  l;

  /// Altura do campo: **fixa** no single-line, **mínima** no multiline.
  double get height => switch (this) {
    AppFieldSize.s => 40.0,
    AppFieldSize.m => 48.0,
    AppFieldSize.l => 56.0,
  };

  /// Padding horizontal interno (borda/superfície não somam a isto).
  double get horizontalPadding => switch (this) {
    AppFieldSize.s => AppSpacings.s8,
    AppFieldSize.m => AppSpacings.s12,
    AppFieldSize.l => AppSpacings.s16,
  };

  /// Padding vertical interno (dá respiro ao multiline; no single-line quem
  /// manda é [height]).
  double get verticalPadding => switch (this) {
    AppFieldSize.s => AppSpacings.s8,
    AppFieldSize.m => AppSpacings.s12,
    AppFieldSize.l => AppSpacings.s16,
  };

  /// Tamanho dos ícones de prefixo/sufixo/chevron do campo.
  double get iconSize => switch (this) {
    AppFieldSize.s => 16.0,
    AppFieldSize.m => 20.0,
    AppFieldSize.l => 24.0,
  };
}
