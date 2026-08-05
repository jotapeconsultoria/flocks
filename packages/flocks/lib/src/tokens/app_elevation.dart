import 'package:flutter/widgets.dart';

/// Sombras de elevação do Flocks — **simétricas** (offset zero): puro efeito de
/// elevação, distribuído igualmente em todos os lados.
///
/// Theme-aware: mais fortes no escuro, onde a sombra aparece menos sobre
/// superfícies escuras. É a receita canônica usada pelo estilo
/// [AppStyle.elevated] e pelos overlays (ex.: `AppCard`). Não há token de
/// **cor** de sombra — é preto puro com alpha, calculado por brilho.
sealed class AppElevation {
  /// Sombra simétrica de elevação (2 camadas). [isDark] intensifica.
  static List<BoxShadow> symmetricShadows(bool isDark) {
    const Color base = Color(0xFF000000);
    return <BoxShadow>[
      BoxShadow(
        color: base.withValues(alpha: isDark ? 0.55 : 0.18),
        blurRadius: 24,
        spreadRadius: -4,
      ),
      BoxShadow(
        color: base.withValues(alpha: isDark ? 0.35 : 0.10),
        blurRadius: 8,
        spreadRadius: -2,
      ),
    ];
  }
}
