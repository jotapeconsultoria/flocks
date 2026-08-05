import 'package:flutter/widgets.dart';

import '../alert/show_app_overlay.dart';
import 'app_snackbar.dart';
import 'app_snackbar_type.dart';

/// Dispensa da snackbar atualmente visível (instância única).
VoidCallback? _dismissCurrent;

/// Exibe um [AppSnackbar] no canto inferior direito, com auto-dismiss.
///
/// Instância **única**: se já houver uma snackbar visível, ela é dispensada
/// (com animação de saída) antes de mostrar a nova. Delega ao helper de overlay
/// do DS ([showAppOverlay]) — slide-in sem Material, respeitando reduce-motion.
///
/// [duration] controla o tempo até o auto-dismiss (padrão 3 s).
void showAppSnackbar({
  required BuildContext context,
  required String description,
  required String title,
  required AppSnackbarType type,
  Duration duration = const Duration(seconds: 3),
  VoidCallback? onDismiss,
}) {
  _dismissCurrent?.call();
  _dismissCurrent = showAppOverlay(
    context: context,
    position: AppOverlayPosition.bottomRight,
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
