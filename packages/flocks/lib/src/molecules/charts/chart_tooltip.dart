import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_sizes.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_strokes.dart';
import 'chart_models.dart';

/// Tooltip de chart (título + itens cor/label/valor). Elevação por tom
/// (`surfaceContainer`) + borda `outline`, sem sombra. Não é API pública.
class ChartTooltip extends StatelessWidget {
  /// Cria um [ChartTooltip].
  const ChartTooltip({required this.data, super.key});

  /// Dados do tooltip.
  final AppChartTooltipData data;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colors.outline, width: AppStrokes.m),
        borderRadius: theme.radiusTheme.resolve(),
        color: colors.surfaceContainer,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacings.s8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (data.label != null) ...<Widget>[
              AppText(
                data.label!,
                style: theme.textTheme.labelLarge.copyWith(
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacings.s4),
            ],
            for (final AppChartTooltipItem item in data.items)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacings.s4),
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: theme.radiusTheme.resolve(
                          size: const Size.square(AppSizes.s8),
                        ),
                        color: item.color,
                      ),
                      height: AppSizes.s8,
                      width: AppSizes.s8,
                    ),
                    const SizedBox(width: AppSpacings.s8),
                    Flexible(
                      child: AppText(
                        '${item.label}: ${item.value}',
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
