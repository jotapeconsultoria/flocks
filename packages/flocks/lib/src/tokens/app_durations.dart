/// Tokens de duração de animação do Flocks.
///
/// Padroniza as durações usadas pelo design system, eliminando literais
/// `Duration(milliseconds: ...)` espalhados. Passar por aqui é o que permite a
/// todo componente migrado honrar `reducesMotion`, cobrado por
/// `tool/component_conformance.dart` (Regra 10).
sealed class AppDurations {
  /// 120ms — microinterações rápidas (press, hover).
  static const Duration fast = Duration(milliseconds: 120);

  /// 200ms — transições padrão (cor, opacidade, tamanho).
  static const Duration normal = Duration(milliseconds: 200);

  /// 260ms — transições médias (expand/collapse, reordenar).
  static const Duration medium = Duration(milliseconds: 260);

  /// 450ms — transições longas (overlays, bottom sheets, diálogos).
  static const Duration slow = Duration(milliseconds: 450);

  /// 1200ms — período de loops contínuos (spin/pulse).
  static const Duration loop = Duration(milliseconds: 1200);

  /// 1500ms — loop lento (ex.: barra linear indeterminada).
  static const Duration loopSlow = Duration(milliseconds: 1500);
}
