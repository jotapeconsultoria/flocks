import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../molecules/input/app_input.dart';
import '../../molecules/interactive/app_interaction.dart';
import '../../molecules/list_empty/app_list_empty.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_durations.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_illustrations.dart';
import '../../tokens/app_spacings.dart';
import '../content/app_content_style.dart';
import 'app_api_endpoint_tile.dart';
import 'app_api_flow.dart';
import 'app_api_models.dart';

/// Painel de documentação da API no contexto de uma tela.
///
/// Monta, num único fluxo de leitura: cabeçalho (título, contexto, base URL
/// copiável), busca, os fluxos de negócio e os grupos de endpoints. Tocar um
/// passo de fluxo **abre e rola até** o cartão do endpoint correspondente — é o
/// que costura a narrativa ("em que ordem") à referência ("o que cada um faz").
///
/// **Não rola sozinho**: o contrato do [AppBottomSheet]/[AppSideSheet] é que a
/// superfície cuida da rolagem. Fora de um sheet, embrulhe num scroll.
///
/// **Puro de apresentação**: recebe um [AppApiDoc] já resolvido. Carregamento e
/// erro são do host — o painel não faz rede.
final class AppApiDocsPanel extends StatefulWidget {
  /// Cria um [AppApiDocsPanel].
  const AppApiDocsPanel({
    required this.doc,
    this.onOpenExternal,
    this.showHeader = true,
    this.showSearch = true,
    this.searchHint = 'Filtrar por verbo, path ou descrição',
    this.emptyText = 'Nenhum endpoint casa com o filtro.',
    super.key,
  });

  /// Documentação exibida.
  final AppApiDoc doc;

  /// Ação de "abrir a referência completa" (Swagger UI). `null` esconde o link.
  final VoidCallback? onOpenExternal;

  /// Mostra título, subtítulo, base URL e link próprios. Desligue quando quem
  /// hospeda já dá o cabeçalho da coluna (é o caso do [AppDocsWorkspace]) —
  /// senão o título aparece duas vezes.
  final bool showHeader;

  /// Mostra o campo de busca. Default `true`.
  final bool showSearch;

  /// Placeholder do campo de busca.
  final String searchHint;

  /// Mensagem quando a busca não casa nada.
  final String emptyText;

  @override
  State<AppApiDocsPanel> createState() => _AppApiDocsPanelState();
}

class _AppApiDocsPanelState extends State<AppApiDocsPanel> {
  final TextEditingController _search = TextEditingController();
  final Map<String, GlobalKey<AppApiEndpointTileState>> _tileKeys =
      <String, GlobalKey<AppApiEndpointTileState>>{};
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  GlobalKey<AppApiEndpointTileState> _keyFor(String id) =>
      _tileKeys.putIfAbsent(id, GlobalKey<AppApiEndpointTileState>.new);

  bool _matches(AppApiEndpoint e) {
    if (_query.isEmpty) return true;
    final String q = _query.toLowerCase();
    return e.method.label.toLowerCase().contains(q) ||
        e.path.toLowerCase().contains(q) ||
        (e.summary?.toLowerCase().contains(q) ?? false) ||
        e.tags.any((String t) => t.toLowerCase().contains(q));
  }

  List<AppApiGroup> get _visibleGroups {
    if (_query.isEmpty) return widget.doc.groups;
    final List<AppApiGroup> out = <AppApiGroup>[];
    for (final AppApiGroup g in widget.doc.groups) {
      final List<AppApiEndpoint> kept = g.endpoints.where(_matches).toList();
      if (kept.isEmpty) continue;
      out.add(
        AppApiGroup(
          title: g.title,
          endpoints: kept,
          description: g.description,
        ),
      );
    }
    return out;
  }

  void _clearSearch() {
    _search.clear();
    setState(() => _query = '');
  }

  /// Abre e rola até o cartão do endpoint apontado pelo passo.
  ///
  /// Limpa a busca antes: com um filtro ativo o cartão-alvo pode estar fora da
  /// árvore, e aí não haveria o que revelar.
  void _revealStep(AppApiFlowStep step) {
    final String? id = step.endpointId;
    if (id == null) return;
    if (_query.isNotEmpty) _clearSearch();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final BuildContext? target = _tileKeys[id]?.currentContext;
      if (target == null) return;
      _tileKeys[id]?.currentState?.expand();
      Scrollable.ensureVisible(
        target,
        // Rolagem programada também é movimento: com reduce-motion o alvo
        // aparece de uma vez, em vez de deslizar até ele.
        duration: AppMotion.resolve(context, AppDurations.medium),
        alignment: 0.1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final List<AppApiGroup> groups = _visibleGroups;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.showHeader) _header(theme, colors),
        if (widget.showSearch) ...<Widget>[
          if (widget.showHeader) const SizedBox(height: AppSpacings.s16),
          AppInput(
            controller: _search,
            hintText: widget.searchHint,
            prefixIcon: AppIconToken.search,
            onChanged: (String v) => setState(() => _query = v.trim()),
            onClear: _clearSearch,
          ),
        ],
        for (final AppApiFlowData flow in widget.doc.flows) ...<Widget>[
          const SizedBox(height: AppSpacings.s16),
          AppApiFlow(flow: flow, onStepTap: _revealStep),
        ],
        if (groups.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacings.s32),
            child: AppListEmpty(
              illustration: AppIllustrations.empty,
              text: widget.emptyText,
              onClearFilter: _query.isEmpty ? null : _clearSearch,
            ),
          )
        else
          for (final AppApiGroup g in groups) ...<Widget>[
            const SizedBox(height: AppSpacings.s24),
            _groupTitle(theme, colors, g),
            for (final AppApiEndpoint e in g.endpoints)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacings.s8),
                child: AppApiEndpointTile(
                  key: _keyFor(e.id),
                  endpoint: e,
                  baseUrl: widget.doc.baseUrl,
                ),
              ),
          ],
      ],
    );
  }

  Widget _header(AppThemeData theme, AppColorTheme colors) {
    final AppApiDoc doc = widget.doc;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppText(
          doc.title,
          style: theme.textTheme.titleMedium.copyWith(color: colors.onSurface),
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
        if (doc.baseUrl != null || widget.onOpenExternal != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacings.s8),
            child: Wrap(
              spacing: AppSpacings.s8,
              runSpacing: AppSpacings.s4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                if (doc.baseUrl != null)
                  _baseUrlChip(theme, colors, doc.baseUrl!),
                if (widget.onOpenExternal != null)
                  AppInteraction(
                    onTap: widget.onOpenExternal,
                    tooltip: 'Abrir a referência completa',
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacings.s4,
                      vertical: AppSpacings.s2,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        AppIcon(
                          AppIconToken.apiCloud,
                          size: AppIconSize.s,
                          color: colors.primaryAccent(
                            isDark: theme.brightness == AppBrightness.dark,
                          ),
                        ),
                        const SizedBox(width: AppSpacings.s4),
                        AppText(
                          'Referência completa',
                          style: theme.textTheme.labelSmall.copyWith(
                            color: colors.primaryAccent(
                              isDark: theme.brightness == AppBrightness.dark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _baseUrlChip(
    AppThemeData theme,
    AppColorTheme colors,
    String baseUrl,
  ) {
    return AppInteraction(
      onTap: () => Clipboard.setData(ClipboardData(text: baseUrl)),
      tooltip: 'Copiar a base URL',
      semanticLabel: 'Copiar a base URL $baseUrl',
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.s4,
        vertical: AppSpacings.s2,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppText(
            baseUrl,
            style: AppContentStyle.resolve(
              context,
            ).code.copyWith(color: colors.neutralPrimary.s600),
          ),
          const SizedBox(width: AppSpacings.s4),
          AppIcon(
            AppIconToken.copy,
            size: AppIconSize.s,
            color: colors.neutralPrimary.s600,
          ),
        ],
      ),
    );
  }

  Widget _groupTitle(AppThemeData theme, AppColorTheme colors, AppApiGroup g) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppText(
          g.title,
          style: theme.textTheme.titleSmall.copyWith(color: colors.onSurface),
        ),
        if (g.description != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacings.s2),
            child: AppText(
              g.description!,
              style: theme.textTheme.bodySmall.copyWith(
                color: colors.neutralPrimary.s600,
              ),
            ),
          ),
      ],
    );
  }
}
