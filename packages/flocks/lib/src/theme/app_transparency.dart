import 'package:flutter/widgets.dart';

import 'app_themes.dart';

/// Ponto único de decisão de "reduzir transparência" do Flocks (espelha
/// `AppMotion`).
///
/// Toda superfície translúcida do design system (o eixo glass, [AppGlassTheme],
/// via `AppGlassSurface`) deve consultar [enabled] antes de instanciar um
/// `BackdropFilter` — se desligado, cai para o caminho **opaco**.
sealed class AppTransparency {
  const AppTransparency._();

  /// Se os tratamentos translúcidos (glass) estão habilitados para [context].
  ///
  /// É um **AND** de duas fontes:
  /// 1. **Global do DS** — [AppTransparencyTheme.enabled] do tema ativo (o
  ///    liga/desliga do usuário/marca; default ligado). Lido de forma defensiva:
  ///    sem `AppTheme` ancestral (ex.: testes de unidade) assume ligado.
  /// 2. **Proxy de "reduzir transparência" do SO** (sempre vence). O Flutter
  ///    ainda **não expõe** reduce-transparency (nem `MediaQuery` nem
  ///    `AccessibilityFeatures`), então usamos `highContrast` (no iOS, "Aumentar
  ///    contraste" também reduz a transparência) e `invertColors` como proxies —
  ///    ambos reativos via `MediaQuery`.
  static bool enabled(BuildContext context) {
    // 1. Global do design system (respeita rebuild via dependOn…).
    final AppTheme? appTheme = context
        .dependOnInheritedWidgetOfExactType<AppTheme>();
    if (appTheme != null && !appTheme.data.transparencyTheme.enabled) {
      return false;
    }

    // 2. Proxies de reduce-transparency do SO.
    final MediaQueryData? mq = MediaQuery.maybeOf(context);
    if (mq != null && (mq.highContrast || mq.invertColors)) return false;
    return true;
  }
}
