import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_strokes.dart';
import '../../tokens/app_style.dart';
import 'app_api_flow_step_tile.dart';
import 'app_api_models.dart';

/// Diâmetro da bolha numerada de um passo.
const double kAppApiFlowBulletSize = 24.0;

/// Fluxo de negócio como timeline vertical numerada.
///
/// Responde à pergunta que a lista de endpoints não responde: **em que ordem**.
/// Cada passo mostra o número, o que a etapa faz e — quando é uma chamada — a
/// linha `[verbo] path`, clicável via [onStepTap] para o painel levar o leitor
/// ao cartão do endpoint.
///
/// ```dart
/// AppApiFlow(
///   flow: doc.flows.first,
///   onStepTap: (AppApiFlowStep step) => panel.revealEndpoint(step.endpointId!),
/// )
/// ```
final class AppApiFlow extends StatelessWidget {
  /// Cria um [AppApiFlow].
  const AppApiFlow({
    required this.flow,
    this.onStepTap,
    this.style,
    this.radiusMode,
    super.key,
  });

  /// Fluxo exibido.
  final AppApiFlowData flow;

  /// Toque num passo que aponta para um endpoint. `null` = passos não são
  /// clicáveis.
  final ValueChanged<AppApiFlowStep>? onStepTap;

  /// Tratamento de container ([AppStyle]) do cartão. `null` segue o global.
  final AppStyle? style;

  /// Override do modo de forma. `null` segue o global.
  final AppRadiusMode? radiusMode;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final AppStyle s = style ?? theme.styleTheme.style;
    final StyleDecoration deco = resolveStyleDecoration(
      style: s,
      isDark: theme.brightness == AppBrightness.dark,
      outline: colors.outline,
      surfaceContainer: colors.surfaceContainer,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: deco.color,
        border: deco.border,
        boxShadow: deco.boxShadow,
        borderRadius: theme.radiusTheme.tileRadius(radiusMode),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacings.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppText(
              flow.title,
              style: theme.textTheme.titleSmall.copyWith(
                color: colors.onSurface,
              ),
            ),
            if (flow.description != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacings.s4),
                child: AppText(
                  flow.description!,
                  style: theme.textTheme.bodySmall.copyWith(
                    color: colors.neutralPrimary.s600,
                  ),
                ),
              ),
            const SizedBox(height: AppSpacings.s16),
            for (int i = 0; i < flow.steps.length; i++)
              _Step(
                step: flow.steps[i],
                index: i,
                isLast: i == flow.steps.length - 1,
                onTap: onStepTap,
              ),
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.step,
    required this.index,
    required this.isLast,
    required this.onTap,
  });

  final AppApiFlowStep step;
  final int index;
  final bool isLast;
  final ValueChanged<AppApiFlowStep>? onTap;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final bool isDark = theme.brightness == AppBrightness.dark;
    final Color accent = colors.primaryAccent(isDark: isDark);

    final Widget content = Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacings.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppText(
            step.title,
            style: theme.textTheme.bodyMedium.copyWith(color: colors.onSurface),
          ),
          if (step.description != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacings.s2),
              child: AppText(
                step.description!,
                style: theme.textTheme.bodySmall.copyWith(
                  color: colors.neutralPrimary.s600,
                ),
              ),
            ),
          if (step.hasCall)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacings.s8),
              child: AppApiFlowStepTile(
                step: step,
                onTap: onTap == null ? null : () => onTap!(step),
              ),
            ),
          if (step.note != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacings.s4),
              child: AppText(
                step.note!,
                style: theme.textTheme.labelSmall.copyWith(
                  color: colors.neutralPrimary.s600,
                ),
              ),
            ),
        ],
      ),
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Trilho: bolha numerada + conector até o próximo passo. O conector
          // cresce com a altura real do conteúdo (por isso o IntrinsicHeight),
          // senão passos de alturas diferentes deixariam buracos na linha.
          //
          // O conector é um `Positioned` com top+bottom e left+width: são as
          // duas constraints por eixo que o Stack precisa para dar tamanho
          // TIGHT ao filho. Um `ColoredBox` dentro de constraints frouxas
          // (Center/SizedBox só com largura) encolhe para altura zero — a linha
          // existe na árvore e não aparece na tela.
          SizedBox(
            width: kAppApiFlowBulletSize,
            child: Stack(
              children: <Widget>[
                if (!isLast)
                  Positioned(
                    top: kAppApiFlowBulletSize,
                    bottom: 0,
                    left: (kAppApiFlowBulletSize - AppStrokes.s) / 2,
                    width: AppStrokes.s,
                    child: ColoredBox(color: colors.divider),
                  ),
                Container(
                  width: kAppApiFlowBulletSize,
                  height: kAppApiFlowBulletSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent.withValues(alpha: 0.12),
                    border: Border.all(color: accent, width: AppStrokes.s),
                  ),
                  child: AppText(
                    '${index + 1}',
                    style: theme.textTheme.labelSmall.copyWith(color: accent),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacings.s12),
          Expanded(child: content),
        ],
      ),
    );
  }
}
