import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';

/// Estilo de plataforma de um [AppButtonsFooter] — define a superfície de fundo.
enum AppButtonsPlatformStyle {
  /// Desktop: superfície **elevada** (`surfaceContainer`), como um card.
  desktop,

  /// Mobile: superfície de página (`surface`).
  mobile;

  /// Cor de fundo do rodapé em [theme].
  Color background(AppColorTheme theme) => switch (this) {
    AppButtonsPlatformStyle.desktop => theme.surfaceContainer,
    AppButtonsPlatformStyle.mobile => theme.surface,
  };
}
