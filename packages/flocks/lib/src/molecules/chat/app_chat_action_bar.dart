import 'package:flutter/widgets.dart';

import '../../atoms/icons/icons.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import '../interactive/interactive.dart';

/// Uma ação-ícone de uma [AppChatActionBar] (copiar, regenerar, gostei…).
class AppChatAction {
  /// Cria uma [AppChatAction].
  const AppChatAction({
    required this.icon,
    required this.label,
    this.onPressed,
    this.active = false,
    this.activeColor,
  });

  /// Ícone (`AppIconToken.*`).
  final String icon;

  /// Rótulo — vira tooltip e semântica de botão.
  final String label;

  /// Ação. `null` = desabilitada.
  final VoidCallback? onPressed;

  /// Se está no estado ativo/selecionado (ex.: "gostei" marcado).
  final bool active;

  /// Cor quando [active]. Default: papel `secondary` da barra.
  final Color? activeColor;
}

/// Barra de ações de uma mensagem — a linha de ícones abaixo da resposta do
/// assistente (copiar, regenerar, gostei/não gostei).
///
/// Cada ação reusa [AppInteraction] (hover/press/foco, tooltip e semântica de
/// botão). Estado ativo tinge o ícone pelo papel `secondary` (ou
/// [AppChatAction.activeColor]); ícones inativos usam um neutro esmaecido.
///
/// ```dart
/// AppChatActionBar(actions: <AppChatAction>[
///   AppChatAction(icon: AppIconToken.copy, label: 'Copiar', onPressed: _copy),
///   AppChatAction(icon: AppIconToken.thumbsUp, label: 'Gostei', active: liked, onPressed: _like),
/// ])
/// ```
final class AppChatActionBar extends StatelessWidget {
  /// Cria uma [AppChatActionBar].
  const AppChatActionBar({
    required this.actions,
    this.color,
    this.iconSize = AppIconSize.s,
    this.spacing = AppSpacings.s8,
    super.key,
  });

  /// As ações, na ordem de exibição.
  final List<AppChatAction> actions;

  /// Cor dos ícones inativos. Default: `onSurface` esmaecido.
  final Color? color;

  /// Tamanho dos ícones. Default [AppIconSize.s].
  final AppIconSize iconSize;

  /// Espaço entre as ações. Default [AppSpacings.s8].
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final Color idle = color ?? colors.onSurface.customOpacity(0.6);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < actions.length; i++) ...<Widget>[
          if (i > 0) SizedBox(width: spacing),
          _buildAction(colors, idle, actions[i]),
        ],
      ],
    );
  }

  Widget _buildAction(AppColorTheme colors, Color idle, AppChatAction action) {
    final Color iconColor = action.active
        ? (action.activeColor ??
              readableStopOn(colors.secondary, colors.surface))
        : idle;
    return AppInteraction(
      onTap: action.onPressed,
      tooltip: action.label,
      semanticLabel: action.label,
      padding: const EdgeInsets.all(AppSpacings.s4),
      child: AppIcon(action.icon, color: iconColor, size: iconSize),
    );
  }
}
