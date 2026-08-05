import 'package:flutter/widgets.dart';

import '../../atoms/illustrations/illustrations.dart';
import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_sizes.dart';
import '../../tokens/app_spacings.dart';
import '../buttons/button_state_colors.dart';
import '../interactive/app_interaction.dart';

/// Estado vazio de uma lista: ilustração centralizada, mensagem e uma ação
/// opcional de limpar filtro.
///
/// Cores 100% do tema (texto em `onSurface`); a ilustração adapta-se a
/// claro/escuro. A ação é um texto clicável ([AppInteraction]) secundário.
///
/// ```dart
/// AppListEmpty(
///   illustration: AppIllustrations.empty,
///   text: 'Nenhum resultado encontrado.',
///   onClearFilter: clearFilters,
/// )
/// ```
final class AppListEmpty extends StatelessWidget {
  /// Cria um [AppListEmpty].
  const AppListEmpty({
    required this.illustration,
    required this.text,
    this.onClearFilter,
    super.key,
  });

  /// URL da ilustração (ex.: `AppIllustrations.empty`).
  final String illustration;

  /// Mensagem exibida abaixo da ilustração.
  final String text;

  /// Ação de limpar filtro. Quando não `null`, mostra um botão "Limpar".
  final VoidCallback? onClearFilter;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacings.s16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppIllustration(
              illustration,
              // Mesmo acento do botão "Limpar" logo abaixo.
              accentColor: appRoleAccent(
                theme.colorTheme,
                theme.colorTheme.secondary,
              ),
              size: AppIllustrationSize.m,
            ),
            const SizedBox(height: AppSpacings.s16),
            AppText(
              text,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge.copyWith(
                color: theme.colorTheme.onSurface,
              ),
            ),
            if (onClearFilter != null) ...<Widget>[
              const SizedBox(height: AppSpacings.s32),
              SizedBox(
                width: AppSizes.s128,
                child: AppInteraction(
                  semanticLabel: 'Limpar',
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacings.s12,
                  ),
                  onTap: onClearFilter,
                  child: Center(
                    child: AppText(
                      'Limpar',
                      style: theme.textTheme.titleMedium.copyWith(
                        color: appRoleAccent(
                          theme.colorTheme,
                          theme.colorTheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
