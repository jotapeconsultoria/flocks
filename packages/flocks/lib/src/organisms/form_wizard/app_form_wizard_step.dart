import 'package:flutter/widgets.dart';

/// Dados de um passo do [AppFormWizard].
final class AppFormWizardStep {
  const AppFormWizardStep({
    required this.builder,
    required this.title,
    this.icon,
    this.subtitle,
    this.validator,
  });

  /// Construtor do conteudo do passo.
  final WidgetBuilder builder;

  /// Icone opcional. Se nulo, exibe o numero do passo.
  final String? icon;

  /// Subtitulo opcional do passo.
  final String? subtitle;

  /// Titulo do passo.
  final String title;

  /// Validador do passo. Retorna `true` se o passo e valido.
  final bool Function()? validator;
}
