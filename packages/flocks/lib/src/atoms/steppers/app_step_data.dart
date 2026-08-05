/// Dados de um passo do [AppStepper].
final class AppStepData {
  const AppStepData({required this.title, this.subtitle, this.icon});

  /// Icone opcional do passo. Se nulo, exibe o numero do passo.
  final String? icon;

  /// Subtitulo opcional do passo.
  final String? subtitle;

  /// Titulo do passo.
  final String title;
}
