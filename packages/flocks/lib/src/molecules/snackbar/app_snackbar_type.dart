import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_icon_token.dart';

/// Tipo semântico de um [AppSnackbar] (cor + ícone).
enum AppSnackbarType {
  /// Erro (vermelho).
  error,

  /// Informativo (azul).
  info,

  /// Sucesso (verde).
  success;

  /// Resolve o papel para o seu swatch semântico em [t].
  ColorSwatch<int> resolve(AppColorTheme t) => switch (this) {
    AppSnackbarType.error => t.danger,
    AppSnackbarType.info => t.info,
    AppSnackbarType.success => t.success,
  };

  /// Ícone do papel.
  String get icon => switch (this) {
    AppSnackbarType.error => AppIconToken.errorCircle,
    AppSnackbarType.info => AppIconToken.infoCircle,
    AppSnackbarType.success => AppIconToken.checkCircle,
  };
}
