/// Breakpoints de dispositivo do design system.
///
/// Token de responsividade: cada valor guarda o `breakpoint` (largura, em px)
/// que separa as faixas. Usado pelos organismos responsivos (ex.:
/// `AppAuthSplitLayout`, `AppFormWizard`, `AppNavigationRail`).
///
/// ```dart
/// final bool isMobile =
///     MediaQuery.sizeOf(context).width < AppDevice.mobile.breakpoint;
/// ```
enum AppDevice {
  /// Faixa mobile (largura < `768.0`).
  mobile(768.0),

  /// Faixa tablet (largura < `1024.0`).
  tablet(1024.0),

  /// Faixa desktop — tudo acima de tablet (breakpoint irrelevante).
  desktop(double.infinity);

  const AppDevice(this.breakpoint);

  /// Largura (px) que delimita a faixa.
  final double breakpoint;
}
