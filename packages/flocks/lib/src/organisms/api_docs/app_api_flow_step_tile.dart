import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../molecules/interactive/app_interaction.dart';
import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_api_method_badge.dart';
import 'app_api_models.dart';
import 'app_api_path.dart';

/// Linha compacta `[verbo] path` de um passo de fluxo.
///
/// Com [onTap] vira um alvo clicável (hover/foco/tooltip) que o painel usa para
/// levar o leitor ao cartão do endpoint correspondente; sem ele é só a
/// referência escrita.
@internal
final class AppApiFlowStepTile extends StatelessWidget {
  /// Cria um [AppApiFlowStepTile].
  const AppApiFlowStepTile({required this.step, this.onTap, super.key});

  /// Passo — precisa ter verbo e path ([AppApiFlowStep.hasCall]).
  final AppApiFlowStep step;

  /// Toque. `null` = somente leitura.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (!step.hasCall) return const SizedBox.shrink();

    final AppThemeData theme = AppTheme.of(context);
    final Widget row = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppApiMethodBadge(step.method!, width: null),
        const SizedBox(width: AppSpacings.s8),
        Flexible(child: AppApiPath(step.path!)),
      ],
    );

    if (onTap == null) return row;

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: AppInteraction(
        onTap: onTap,
        tooltip: 'Ver o endpoint',
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacings.s4,
          vertical: AppSpacings.s2,
        ),
        radius: theme.radiusTheme.tileRadius(),
        semanticLabel: 'Ver o endpoint ${step.endpointId}',
        child: row,
      ),
    );
  }
}
