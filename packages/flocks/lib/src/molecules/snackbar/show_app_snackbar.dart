import 'package:flutter/widgets.dart';

import '../alert/show_app_overlay.dart';
import 'app_snackbar.dart';
import 'app_snackbar_type.dart';

/// Dispensa da snackbar atualmente visível (instância única).
VoidCallback? _dismissCurrent;

/// Exibe um [AppSnackbar] com auto-dismiss, no canto inferior direito por
/// padrão ([position]).
///
/// Instância **única**: se já houver uma snackbar visível, ela é dispensada
/// (com animação de saída) antes de mostrar a nova. Delega ao helper de overlay
/// do DS ([showAppOverlay]) — slide-in sem Material, respeitando reduce-motion.
///
/// [title] é opcional: sem ele o card mostra só [description] — o toast de uma
/// frase, que é o formato que a maioria das telas quer. [type] default para
/// [AppSnackbarType.info]; mensagem de erro DEVE passar
/// `type: AppSnackbarType.error` (a cor e o ícone são o único sinal da falha).
///
/// [duration] controla o tempo até o auto-dismiss (padrão 3 s).
///
/// ```dart
/// showAppSnackbar(context: context, description: 'Link copiado.');
/// ```
void showAppSnackbar({
  required BuildContext context,
  required String description,
  String? title,
  AppSnackbarType type = AppSnackbarType.info,
  AppOverlayPosition position = AppOverlayPosition.bottomRight,
  Duration duration = const Duration(seconds: 3),
  VoidCallback? onDismiss,
}) {
  _dismissCurrent?.call();
  _dismissCurrent = showAppOverlay(
    context: context,
    position: position,
    animation: AppOverlayAnimation.slide,
    maxWidth: 384,
    duration: duration,
    onDismiss: () {
      _dismissCurrent = null;
      onDismiss?.call();
    },
    child: AppSnackbar(title: title, description: description, type: type),
  );
}
