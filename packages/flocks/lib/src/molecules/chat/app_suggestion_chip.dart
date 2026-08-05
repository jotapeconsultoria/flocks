import 'package:flutter/widgets.dart';

import '../../atoms/icons/icons.dart';
import '../../atoms/surface/surface.dart';
import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import '../interactive/interactive.dart';

/// Chip de **sugestão** — um prompt inicial (chat com LLM) ou resposta rápida
/// (WhatsApp) tocável, para entrar num `Wrap`.
///
/// Delineado por padrão ([AppStyle.outlined]), com ícone opcional + texto de até
/// [maxLines] linhas. Reusa [AppSurface] (a casca) + [AppInteraction] (toque/
/// hover/foco + semântica de botão).
///
/// ```dart
/// Wrap(spacing: 8, runSpacing: 8, children: <Widget>[
///   AppSuggestionChip(label: 'Quais veículos estão parados?', onTap: _ask),
///   AppSuggestionChip(icon: AppIconToken.chat, label: 'Resumo do dia', onTap: _ask),
/// ])
/// ```
final class AppSuggestionChip extends StatelessWidget {
  /// Cria um [AppSuggestionChip].
  const AppSuggestionChip({
    required this.label,
    this.icon,
    this.onTap,
    this.style,
    this.radiusMode,
    this.radius,
    this.maxLines = 2,
    super.key,
  });

  /// Texto da sugestão.
  final String label;

  /// Ícone opcional à esquerda (`AppIconToken.*`).
  final String? icon;

  /// Ação ao tocar.
  final VoidCallback? onTap;

  /// Estilo de container. Default [AppStyle.outlined].
  final AppStyle? style;

  /// Override local do modo de forma. Vence o global.
  final AppRadiusMode? radiusMode;

  /// Override cru do raio (px). Vence [radiusMode] e o global.
  final double? radius;

  /// Máximo de linhas do texto. Default 2.
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final BorderRadius br = radius != null
        ? BorderRadius.circular(radius!)
        : theme.radiusTheme.resolve(override: radiusMode);

    return AppInteraction(
      onTap: onTap,
      semanticLabel: label,
      radius: br,
      child: AppSurface(
        variant: AppSurfaceVariant.flat,
        style: style ?? AppStyle.outlined,
        radius: br,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacings.s12,
          vertical: AppSpacings.s8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              AppIcon(
                icon!,
                color: readableStopOn(colors.primary, colors.surface),
                size: AppIconSize.s,
              ),
              const SizedBox(width: AppSpacings.s8),
            ],
            Flexible(
              child: AppText(
                label,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium.withColor(colors.onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
