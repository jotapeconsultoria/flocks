import 'package:flutter/widgets.dart';

import 'app_themes.dart';

/// Reprovê, no conteúdo de um `OverlayEntry`, os providers que o Overlay do root
/// deixa para trás (ele vive ACIMA do tema/text-scale/DefaultTextStyle do app):
///
/// - **[AppTheme]** — senão `AppTheme.of` lança "No AppTheme found in context";
/// - **text scale** (via `MediaQuery`) — senão o overlay ignora o text scale
///   (ex.: o `TextScaleAddon` do Widgetbook, que embrulha abaixo do Overlay);
/// - **`DefaultTextStyle`** concreto — senão o texto cai no fallback do Flutter
///   (sublinhado amarelo duplo "faltou Material").
///
/// Capture [theme] e [textScaler] no contexto do **trigger** (que está abaixo
/// dos providers) e passe-os aqui dentro do `OverlayEntry`.
class AppOverlayScope extends StatelessWidget {
  /// Cria um [AppOverlayScope].
  const AppOverlayScope({
    required this.theme,
    required this.textScaler,
    required this.child,
    super.key,
  });

  /// Tema capturado no trigger.
  final AppThemeData theme;

  /// Text scaler capturado no trigger (reflete o do app/addon).
  final TextScaler textScaler;

  /// Conteúdo do overlay.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppTheme(
      data: theme,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),
        child: DefaultTextStyle(
          style: theme.textTheme.bodyMedium.copyWith(
            color: theme.colorTheme.onSurface,
            decoration: TextDecoration.none,
          ),
          child: child,
        ),
      ),
    );
  }
}
