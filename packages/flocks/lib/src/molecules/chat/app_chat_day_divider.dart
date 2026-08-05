import 'package:flutter/widgets.dart';

import '../../atoms/divider/divider.dart';
import '../../atoms/surface/surface.dart';
import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// Divisor de dia de uma conversa — a pílula central "Hoje" / "Ontem" / data,
/// assinatura do WhatsApp, que separa mensagens por dia.
///
/// O DS não formata datas: recebe o [label] já pronto. Com [withRules], desenha
/// filetes ([AppDivider]) dos dois lados da pílula.
///
/// ```dart
/// AppChatDayDivider(label: 'Hoje')
/// ```
final class AppChatDayDivider extends StatelessWidget {
  /// Cria um [AppChatDayDivider].
  const AppChatDayDivider({
    required this.label,
    this.withRules = false,
    super.key,
  });

  /// Texto já formatado (ex.: "Hoje", "14 jul").
  final String label;

  /// Se desenha filetes dos dois lados da pílula. Default `false`.
  final bool withRules;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;

    final Widget pill = AppSurface(
      variant: AppSurfaceVariant.raised,
      radius: BorderRadius.circular(999),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.s12,
        vertical: AppSpacings.s4,
      ),
      child: AppText(
        label,
        style: theme.textTheme.labelSmall.withColor(
          colors.onSurface.customOpacity(0.6),
        ),
      ),
    );

    if (!withRules) return Center(child: pill);

    return Row(
      children: <Widget>[
        const Expanded(child: AppDivider(thickness: AppStrokes.m)),
        const SizedBox(width: AppSpacings.s12),
        pill,
        const SizedBox(width: AppSpacings.s12),
        const Expanded(child: AppDivider(thickness: AppStrokes.m)),
      ],
    );
  }
}
