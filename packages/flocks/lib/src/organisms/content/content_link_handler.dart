import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'content_html_parser.dart' show sanitizeContentUrl;

/// Callback de toque num link do documento. Recebe o `href` já sanitizado.
typedef AppContentLinkTap = void Function(String href);

/// Dono do ciclo de vida dos [TapGestureRecognizer] de um documento.
///
/// `TextSpan` não descarta o próprio recognizer: quem o cria precisa chamar
/// `dispose`. Como a árvore inline é reconstruída a cada `build`, os
/// recognizers da árvore anterior vazariam sem este registry. Os componentes
/// mantêm um por instância e o esvaziam a cada rebuild e no `dispose`.
final class ContentLinkRegistry {
  final List<TapGestureRecognizer> _recognizers = <TapGestureRecognizer>[];

  /// Quantos recognizers estão vivos. Existe para os testes provarem que o
  /// rebuild não acumula.
  @visibleForTesting
  int get length => _recognizers.length;

  /// Cria um recognizer para [href] e assume a posse dele.
  TapGestureRecognizer create(String href, AppContentLinkTap onTap) {
    final TapGestureRecognizer recognizer = TapGestureRecognizer()
      ..onTap = () => onTap(href);
    _recognizers.add(recognizer);
    return recognizer;
  }

  /// Descarta todos os recognizers criados até aqui.
  void disposeAll() {
    for (final TapGestureRecognizer recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();
  }
}

/// Abertura de links do conteúdo, com ponto de injeção para teste.
sealed class ContentLinkLauncher {
  /// Substitui o abridor real durante os testes.
  ///
  /// Espelha o `AppIcon.debugIconBuilder`: sem isto, um teste que toca num link
  /// tentaria falar com o plugin de plataforma e quebraria no sandbox.
  @visibleForTesting
  static Future<bool> Function(Uri uri)? debugLauncher;

  /// Abre [href] no navegador externo, se o esquema for seguro.
  ///
  /// Silenciosamente ignora URLs inseguras ou inválidas — o documento pode vir
  /// do backend, e um link malformado não deve estourar na cara do usuário.
  static Future<void> open(String href) async {
    final String? safe = sanitizeContentUrl(href);
    if (safe == null) {
      return;
    }
    final Uri? uri = Uri.tryParse(safe);
    if (uri == null) {
      return;
    }

    final Future<bool> Function(Uri uri) launcher =
        debugLauncher ??
        (Uri u) => launchUrl(u, mode: LaunchMode.externalApplication);

    try {
      await launcher(uri);
    } on Object {
      // Sem plugin, sem app capaz de abrir o esquema, offline… nada disso
      // justifica derrubar a tela.
    }
  }
}
