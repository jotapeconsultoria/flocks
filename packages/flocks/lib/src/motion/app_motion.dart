import 'package:flutter/widgets.dart';

import '../theme/app_themes.dart';

/// Ponto único de decisão de "reduce motion" do Flocks.
///
/// Toda animação do design system deve passar por [resolve] (ou consultar
/// [enabled]) para respeitar as preferências de acessibilidade do usuário.
sealed class AppMotion {
  const AppMotion._();

  /// Se animações estão habilitadas para [context].
  ///
  /// É um **AND** de duas fontes:
  /// 1. **Global do DS** — [AppAnimationTheme.enabled] do tema ativo (o
  ///    liga/desliga do usuário/marca; default ligado). Lido de forma defensiva:
  ///    sem `AppTheme` ancestral (ex.: testes de unidade) assume ligado.
  /// 2. **Reduce-motion do SO** (sempre vence) — [MediaQuery.disableAnimationsOf]
  ///    (reativo; cobre "Remover animações" no Android/desktop e
  ///    `prefers-reduced-motion` no web) e `accessibilityFeatures.reduceMotion`
  ///    (necessário no iOS, onde "Reduzir movimento" NÃO seta
  ///    `disableAnimations`). A leitura de `accessibilityFeatures` não é reativa
  ///    por si só — observe `WidgetsBindingObserver.didChangeAccessibilityFeatures`
  ///    num escopo alto (ex.: `AppThemeScope`) se precisar reagir no iOS.
  static bool enabled(BuildContext context) {
    // 1. Global do design system (respeita rebuild via dependOn…).
    final AppTheme? appTheme = context
        .dependOnInheritedWidgetOfExactType<AppTheme>();
    if (appTheme != null && !appTheme.data.animationTheme.enabled) return false;

    // 2. Reduce-motion do SO.
    final bool disabled = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (disabled) return false;
    return !WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .reduceMotion;
  }

  /// Retorna [duration] se animações estão habilitadas; senão [Duration.zero]
  /// (a animação colapsa para o estado final imediato).
  static Duration resolve(BuildContext context, Duration duration) =>
      enabled(context) ? duration : Duration.zero;
}
