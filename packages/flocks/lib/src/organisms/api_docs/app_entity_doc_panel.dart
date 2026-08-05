import 'package:flutter/widgets.dart';

import '../../atoms/badge/app_badge.dart';
import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_style.dart';
import '../content/app_markdown.dart';
import 'app_api_path.dart';
import 'app_entity_models.dart';

/// Documentação **conceitual** de uma entidade: o que ela é, como se relaciona
/// com as outras e quem troca dados com ela.
///
/// É a coluna esquerda do [AppDocsWorkspace]. Complementa o
/// [AppApiDocsPanel]: um responde "o que isso significa", o outro "como eu
/// chamo".
///
/// **Não rola sozinho** — quem hospeda dá o scroll (o contrato dos sheets).
///
/// Prosa livre entra como **Markdown** ([overview] e [AppEntityDocSection]),
/// porque ciclo de vida e regra de negócio não cabem numa estrutura fixa. Já
/// relações e integrações são **estruturadas**: são o que o leitor varre com o
/// olho, e uma lista de cartões varre melhor que um parágrafo.
final class AppEntityDocPanel extends StatelessWidget {
  /// Cria um [AppEntityDocPanel].
  const AppEntityDocPanel({
    required this.doc,
    this.showHeader = true,
    this.relationsTitle = 'Relações',
    this.integrationsTitle = 'Integrações',
    this.onTapLink,
    super.key,
  });

  /// Documentação exibida.
  final AppEntityDoc doc;

  /// Mostra título e subtítulo próprios. Desligue quando quem hospeda já dá o
  /// cabeçalho da coluna (é o caso do [AppDocsWorkspace]).
  final bool showHeader;

  /// Título da seção de relações.
  final String relationsTitle;

  /// Título da seção de integrações.
  final String integrationsTitle;

  /// Toque num link do Markdown. `null` abre no navegador externo.
  final void Function(String href)? onTapLink;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (showHeader) ...<Widget>[
          AppText(
            doc.title,
            style: theme.textTheme.titleMedium.copyWith(
              color: colors.onSurface,
            ),
          ),
          if (doc.subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacings.s4),
              child: AppText(
                doc.subtitle!,
                style: theme.textTheme.bodySmall.copyWith(
                  color: colors.neutralPrimary.s600,
                ),
              ),
            ),
          const SizedBox(height: AppSpacings.s16),
        ],
        if (doc.overview != null)
          AppMarkdown(
            data: doc.overview!,
            style: theme.textTheme.bodyMedium,
            onTapLink: onTapLink,
          ),
        if (doc.relations.isNotEmpty) ...<Widget>[
          _sectionTitle(theme, colors, relationsTitle),
          for (final AppEntityRelation r in doc.relations)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacings.s8),
              child: _RelationCard(relation: r),
            ),
        ],
        if (doc.integrations.isNotEmpty) ...<Widget>[
          _sectionTitle(theme, colors, integrationsTitle),
          for (final AppEntityIntegration i in doc.integrations)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacings.s8),
              child: _IntegrationCard(integration: i),
            ),
        ],
        for (final AppEntityDocSection s in doc.sections) ...<Widget>[
          _sectionTitle(theme, colors, s.title),
          AppMarkdown(
            data: s.body,
            style: theme.textTheme.bodyMedium,
            onTapLink: onTapLink,
          ),
        ],
      ],
    );
  }

  Widget _sectionTitle(
    AppThemeData theme,
    AppColorTheme colors,
    String label,
  ) => Padding(
    padding: const EdgeInsets.only(
      top: AppSpacings.s24,
      bottom: AppSpacings.s8,
    ),
    child: AppText(
      label,
      style: theme.textTheme.titleSmall.copyWith(color: colors.onSurface),
    ),
  );
}

/// Cartão de uma relação: cardinalidade + entidade alvo + o que significa.
class _RelationCard extends StatelessWidget {
  const _RelationCard({required this.relation});

  final AppEntityRelation relation;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              // A cardinalidade vem antes do nome: é ela que muda a leitura da
              // frase inteira ("1 chip" vs "N chips").
              AppBadge(
                relation.kind.label,
                color: AppBadgeColor.primary,
                size: AppBadgeSize.s,
              ),
              const SizedBox(width: AppSpacings.s8),
              Expanded(
                child: AppText(
                  relation.target,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium.copyWith(
                    color: colors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          if (relation.description != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacings.s4),
              child: AppText(
                relation.description!,
                style: theme.textTheme.bodySmall.copyWith(
                  color: colors.neutralPrimary.s600,
                ),
              ),
            ),
          if (relation.via != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacings.s8),
              child: Row(
                children: <Widget>[
                  AppIcon(
                    AppIconToken.hyperlink,
                    size: AppIconSize.s,
                    color: colors.neutralPrimary.s600,
                  ),
                  const SizedBox(width: AppSpacings.s4),
                  Flexible(child: AppApiPath(relation.via!)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Cartão de uma integração: nome + sentido da troca + o que ela faz.
class _IntegrationCard extends StatelessWidget {
  const _IntegrationCard({required this.integration});

  final AppEntityIntegration integration;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: AppText(
                  integration.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium.copyWith(
                    color: colors.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacings.s8),
              AppBadge(
                integration.direction.label,
                color: integration.direction.badgeColor,
                size: AppBadgeSize.s,
              ),
            ],
          ),
          if (integration.description != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacings.s4),
              child: AppText(
                integration.description!,
                style: theme.textTheme.bodySmall.copyWith(
                  color: colors.neutralPrimary.s600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Moldura comum dos cartões — segue os eixos globais de estilo e forma.
class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final AppStyle style = theme.styleTheme.style;
    final StyleDecoration deco = resolveStyleDecoration(
      style: style,
      isDark: theme.brightness == AppBrightness.dark,
      outline: colors.outline,
      surfaceContainer: colors.surfaceContainer,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: deco.color,
        border: deco.border,
        boxShadow: deco.boxShadow,
        borderRadius: theme.radiusTheme.tileRadius(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacings.s12),
        child: child,
      ),
    );
  }
}
