import 'package:flutter/widgets.dart';

import '../../atoms/divider/app_divider.dart';
import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../molecules/interactive/app_interaction.dart';
import '../../theme/theme.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_spacings.dart';
import '../resizable_split/app_resizable_split.dart';
import 'app_api_docs_panel.dart';
import 'app_api_models.dart';
import 'app_entity_doc_panel.dart';
import 'app_entity_models.dart';

/// Abaixo desta largura as duas colunas viram uma pilha.
///
/// Duas colunas de documentação exigem espaço de leitura em CADA uma; espremer
/// as duas abaixo disto produz linhas de 5 palavras e código com scroll
/// horizontal em tudo.
const double kAppDocsWorkspaceStackBelow = 900.0;

/// Fração inicial da coluna de conceito.
///
/// Ligeiramente menor que a metade: a coluna de API carrega tabelas, árvores de
/// schema e blocos de código, que precisam de mais largura que prosa.
const double kAppDocsWorkspaceFirstFraction = 0.45;

/// Documentação de um contexto em **duas colunas**: o conceito à esquerda, a
/// API à direita.
///
/// As duas metades respondem perguntas diferentes e o leitor alterna entre elas
/// o tempo todo — "o que é um dispositivo?" e "como eu crio um?". Lado a lado,
/// a alternância é o movimento dos olhos; empilhadas, seria scroll.
///
/// A divisória é arrastável ([AppResizableSplit]) e cada coluna **rola sozinha**,
/// para que ler o schema de um endpoint não faça a explicação sumir.
///
/// Abaixo de [kAppDocsWorkspaceStackBelow] as colunas empilham num scroll único.
///
/// Precisa de **altura limitada** — é o que o corpo de um `AppSideSheet` dá
/// (`Expanded`). Dentro de um scroll vertical, não funciona.
final class AppDocsWorkspace extends StatelessWidget {
  /// Cria um [AppDocsWorkspace].
  const AppDocsWorkspace({
    required this.entity,
    required this.api,
    this.entityTitle = 'Documentação',
    this.apiTitle = 'API',
    this.onOpenEntityDocs,
    this.onOpenApiDocs,
    this.entityLinkLabel = 'Documentação completa',
    this.apiLinkLabel = 'Referência da API',
    this.initialFirstFraction = kAppDocsWorkspaceFirstFraction,
    this.onTapLink,
    super.key,
  });

  /// Documentação conceitual (coluna esquerda). `null` esconde a coluna e a API
  /// ocupa a largura toda.
  final AppEntityDoc? entity;

  /// Endpoints do contexto (coluna direita).
  final AppApiDoc api;

  /// Cabeçalho da coluna esquerda.
  final String entityTitle;

  /// Cabeçalho da coluna direita.
  final String apiTitle;

  /// Abre a documentação completa (fora do app). `null` esconde o link.
  final VoidCallback? onOpenEntityDocs;

  /// Abre a referência completa da API (fora do app). `null` esconde o link.
  final VoidCallback? onOpenApiDocs;

  /// Rótulo do link da coluna esquerda.
  final String entityLinkLabel;

  /// Rótulo do link da coluna direita.
  final String apiLinkLabel;

  /// Fração inicial da coluna esquerda.
  final double initialFirstFraction;

  /// Toque num link do Markdown da coluna de conceito.
  final void Function(String href)? onTapLink;

  @override
  Widget build(BuildContext context) {
    final AppEntityDoc? entityDoc = entity;

    final Widget apiColumn = _DocsColumn(
      title: apiTitle,
      linkLabel: apiLinkLabel,
      onOpenExternal: onOpenApiDocs,
      child: AppApiDocsPanel(doc: api, showHeader: false),
    );

    if (entityDoc == null) return apiColumn;

    final Widget entityColumn = _DocsColumn(
      title: entityTitle,
      linkLabel: entityLinkLabel,
      onOpenExternal: onOpenEntityDocs,
      child: AppEntityDocPanel(
        doc: entityDoc,
        showHeader: false,
        onTapLink: onTapLink,
      ),
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < kAppDocsWorkspaceStackBelow) {
          // Empilhado: um scroll só para as duas, senão haveria dois
          // scrollables aninhados no mesmo eixo.
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _StackedSection(
                  title: entityTitle,
                  linkLabel: entityLinkLabel,
                  onOpenExternal: onOpenEntityDocs,
                  child: AppEntityDocPanel(
                    doc: entityDoc,
                    showHeader: false,
                    onTapLink: onTapLink,
                  ),
                ),
                const AppDivider(),
                _StackedSection(
                  title: apiTitle,
                  linkLabel: apiLinkLabel,
                  onOpenExternal: onOpenApiDocs,
                  child: AppApiDocsPanel(doc: api, showHeader: false),
                ),
              ],
            ),
          );
        }

        return AppResizableSplit(
          first: entityColumn,
          second: apiColumn,
          initialFirstFraction: initialFirstFraction,
          minFirstFraction: 0.25,
          maxFirstFraction: 0.7,
          minFirstSize: 320,
          minSecondSize: 360,
          tooltip: 'Redimensionar as colunas',
        );
      },
    );
  }
}

/// Uma coluna: cabeçalho fixo (título + link externo) e corpo rolável.
class _DocsColumn extends StatelessWidget {
  const _DocsColumn({
    required this.title,
    required this.child,
    required this.linkLabel,
    this.onOpenExternal,
  });

  final String title;
  final Widget child;
  final String linkLabel;
  final VoidCallback? onOpenExternal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // Cabeçalho fica FORA do scroll: com a coluna rolada, o leitor precisa
        // continuar sabendo em qual metade está e como sair para a completa.
        _ColumnHeader(
          title: title,
          linkLabel: linkLabel,
          onOpenExternal: onOpenExternal,
        ),
        const AppDivider(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacings.s16,
              AppSpacings.s16,
              AppSpacings.s16,
              AppSpacings.s32,
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}

/// Seção no modo empilhado — mesmo cabeçalho, sem scroll próprio.
class _StackedSection extends StatelessWidget {
  const _StackedSection({
    required this.title,
    required this.child,
    required this.linkLabel,
    this.onOpenExternal,
  });

  final String title;
  final Widget child;
  final String linkLabel;
  final VoidCallback? onOpenExternal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _ColumnHeader(
          title: title,
          linkLabel: linkLabel,
          onOpenExternal: onOpenExternal,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacings.s16,
            AppSpacings.s8,
            AppSpacings.s16,
            AppSpacings.s24,
          ),
          child: child,
        ),
      ],
    );
  }
}

class _ColumnHeader extends StatelessWidget {
  const _ColumnHeader({
    required this.title,
    required this.linkLabel,
    this.onOpenExternal,
  });

  final String title;
  final String linkLabel;
  final VoidCallback? onOpenExternal;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final bool isDark = theme.brightness == AppBrightness.dark;
    final Color accent = colors.primaryAccent(isDark: isDark);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacings.s16,
        AppSpacings.s12,
        AppSpacings.s8,
        AppSpacings.s12,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: AppText(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall.copyWith(
                color: colors.onSurface,
              ),
            ),
          ),
          if (onOpenExternal != null)
            AppInteraction(
              onTap: onOpenExternal,
              tooltip: linkLabel,
              semanticLabel: linkLabel,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacings.s8,
                vertical: AppSpacings.s4,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AppText(
                    linkLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall.copyWith(color: accent),
                  ),
                  const SizedBox(width: AppSpacings.s4),
                  AppIcon(
                    AppIconToken.externalLink,
                    size: AppIconSize.s,
                    color: accent,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
