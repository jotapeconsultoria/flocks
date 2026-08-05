import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';

/// Papel de cor de um botão do Flocks. Cada papel resolve para um swatch do
/// tema (`role`) e o seu par on-color (`onRole`) — sempre do tema, nunca
/// `AppColors.*`.
enum AppButtonColor {
  /// Erro (vermelho).
  danger,

  /// Informativo (azul).
  info,

  /// Neutro (cinza da marca).
  neutral,

  /// Primária da marca.
  primary,

  /// Secundária da marca.
  secondary,

  /// Sucesso (verde).
  success,

  /// Terciária da marca.
  tertiary,

  /// Atenção (âmbar).
  warning;

  /// Swatch de fundo do papel em [theme].
  ColorSwatch<int> role(AppColorTheme theme) => switch (this) {
    AppButtonColor.danger => theme.danger,
    AppButtonColor.info => theme.info,
    AppButtonColor.neutral => theme.neutralPrimary,
    AppButtonColor.primary => theme.primary,
    AppButtonColor.secondary => theme.secondary,
    AppButtonColor.success => theme.success,
    AppButtonColor.tertiary => theme.tertiary,
    AppButtonColor.warning => theme.warning,
  };

  /// Swatch da cor de conteúdo (on-color) do papel em [theme].
  ColorSwatch<int> onRole(AppColorTheme theme) => switch (this) {
    AppButtonColor.danger => theme.onDanger,
    AppButtonColor.info => theme.onInfo,
    AppButtonColor.neutral => theme.onNeutralPrimary,
    AppButtonColor.primary => theme.onPrimary,
    AppButtonColor.secondary => theme.onSecondary,
    AppButtonColor.success => theme.onSuccess,
    AppButtonColor.tertiary => theme.onTertiary,
    AppButtonColor.warning => theme.onWarning,
  };
}
