import 'package:flutter/widgets.dart';

import '../../atoms/badge/app_badge.dart';
import '../../atoms/divider/app_divider.dart';
import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../foundation/flocks_interaction.dart';
import '../../molecules/copy/app_copy_button.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_strokes.dart';
import '../../tokens/app_style.dart';
import '../content/app_code_block.dart';
import 'app_api_method_badge.dart';
import 'app_api_models.dart';
import 'app_api_param_table.dart';
import 'app_api_path.dart';
import 'app_api_schema_tree.dart';

/// Cartão colapsável de **um** endpoint: verbo, path e resumo no cabeçalho;
/// parâmetros, corpo, respostas e `curl` no corpo.
///
/// Construído sobre as mesmas primitivas do [AppExpansionTile]
/// ([FlocksInteraction] + [AppExpand] + [AppAnimatedRotation]) em vez de
/// envolvê-lo: aquele componente só aceita `title` `String`, e aqui o cabeçalho
/// é composto (pílula do verbo + path em mono + resumo + ações).
///
/// Somente leitura — o `curl` é um exemplo com **placeholder** de credencial,
/// nunca o token da sessão. O componente não executa nada.
final class AppApiEndpointTile extends StatefulWidget {
  /// Cria um [AppApiEndpointTile].
  const AppApiEndpointTile({
    required this.endpoint,
    this.baseUrl,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.showCopyPath = true,
    this.showAllResponseExamples = false,
    this.style,
    this.radiusMode,
    super.key,
  });

  /// Endpoint documentado.
  final AppApiEndpoint endpoint;

  /// Base da API, mostrada esmaecida antes do path e usada no copiar.
  final String? baseUrl;

  /// Se o cartão nasce aberto.
  final bool initiallyExpanded;

  /// Notificado a cada abre/fecha.
  final ValueChanged<bool>? onExpansionChanged;

  /// Mostra o botão de copiar o path completo no cabeçalho.
  final bool showCopyPath;

  /// Mostra o corpo de exemplo de **todas** as respostas.
  ///
  /// Default `false`: só o primeiro sucesso e o primeiro erro ganham exemplo. As
  /// respostas de erro de uma API real compartilham o mesmo envelope, então
  /// repetir seis blocos quase idênticos empurra o resto da página para baixo
  /// sem ensinar nada — o que o leitor precisa é de *um* exemplo de cada lado.
  final bool showAllResponseExamples;

  /// Tratamento de container ([AppStyle]). `null` segue o global.
  final AppStyle? style;

  /// Override do modo de forma. `null` segue o global.
  final AppRadiusMode? radiusMode;

  @override
  State<AppApiEndpointTile> createState() => AppApiEndpointTileState();
}

/// Estado do [AppApiEndpointTile] — público para que o painel possa abrir um
/// cartão específico ao navegar de um passo de fluxo para o endpoint.
class AppApiEndpointTileState extends State<AppApiEndpointTile> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  void didUpdateWidget(covariant AppApiEndpointTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initiallyExpanded != widget.initiallyExpanded) {
      _expanded = widget.initiallyExpanded;
    }
  }

  /// Abre o cartão (idempotente).
  void expand() {
    if (_expanded) return;
    setState(() => _expanded = true);
    widget.onExpansionChanged?.call(true);
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    widget.onExpansionChanged?.call(_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final AppStyle style = widget.style ?? theme.styleTheme.style;
    final BorderRadius radius = theme.radiusTheme.tileRadius(widget.radiusMode);
    final StyleDecoration deco = resolveStyleDecoration(
      style: style,
      isDark: theme.brightness == AppBrightness.dark,
      outline: colors.outline,
      surfaceContainer: colors.surfaceContainer,
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: deco.color,
        border: deco.border,
        boxShadow: deco.boxShadow,
        borderRadius: radius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _header(theme, colors, radius),
          AppExpand(
            child: _expanded
                ? _body(theme, colors)
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  Widget _header(
    AppThemeData theme,
    AppColorTheme colors,
    BorderRadius radius,
  ) {
    final AppApiEndpoint e = widget.endpoint;
    return AppSemantics.button(
      label: '${e.id}${e.summary == null ? '' : ' — ${e.summary}'}',
      enabled: true,
      onTap: _toggle,
      child: FlocksInteraction(
        onPressed: _toggle,
        selected: _expanded,
        builder: (BuildContext context, Set<WidgetState> states) {
          final bool hovered = states.contains(WidgetState.hovered);
          final bool pressed = states.contains(WidgetState.pressed);
          final bool focused = states.contains(WidgetState.focused);
          final Color overlay = pressed
              ? colors.onSurface.withValues(alpha: 0.12)
              : hovered
              ? colors.onSurface.withValues(alpha: 0.08)
              : colors.transparent;

          return AnimatedContainer(
            duration: AppMotion.resolve(context, AppDurations.fast),
            curve: AppCurves.standard,
            decoration: BoxDecoration(
              color: overlay,
              borderRadius: radius,
              border: Border.all(
                color: focused ? colors.focusRing : colors.transparent,
                width: AppStrokes.m,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacings.s12,
                vertical: AppSpacings.s12,
              ),
              child: SelectionContainer.disabled(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    AppApiMethodBadge(e.method),
                    const SizedBox(width: AppSpacings.s8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          AppApiPath(e.path, prefix: widget.baseUrl),
                          if (e.summary != null)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: AppSpacings.s2,
                              ),
                              child: AppText(
                                e.summary!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall.copyWith(
                                  color: colors.neutralPrimary.s600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (widget.showCopyPath) ...<Widget>[
                      const SizedBox(width: AppSpacings.s8),
                      AppCopyButton(
                        copyTooltip: 'Copiar path',
                        value: '${widget.baseUrl ?? ''}${widget.endpoint.path}',
                      ),
                    ],
                    const SizedBox(width: AppSpacings.s8),
                    AppAnimatedRotation(
                      turns: _expanded ? 0.5 : 0.0,
                      child: AppIcon(
                        AppIconToken.chevronDown,
                        size: AppIconSize.s,
                        color: colors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _body(AppThemeData theme, AppColorTheme colors) {
    final AppApiEndpoint e = widget.endpoint;
    final TextStyle body = theme.textTheme.bodySmall.copyWith(
      color: colors.onSurface,
    );
    final TextStyle muted = body.copyWith(color: colors.neutralPrimary.s600);
    final List<AppApiParam> nonBodyParams = e.params
        .where((AppApiParam p) => p.location != AppApiParamLocation.body)
        .toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacings.s12,
        AppSpacings.s0,
        AppSpacings.s12,
        AppSpacings.s12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const AppDivider(),
          const SizedBox(height: AppSpacings.s12),
          Wrap(
            spacing: AppSpacings.s8,
            runSpacing: AppSpacings.s4,
            children: <Widget>[
              AppBadge(
                e.requiresAuth ? 'Bearer token' : 'Público',
                color: e.requiresAuth
                    ? AppBadgeColor.warning
                    : AppBadgeColor.success,
                size: AppBadgeSize.s,
              ),
              for (final String tag in e.tags)
                AppBadge(tag, size: AppBadgeSize.s),
            ],
          ),
          if (e.description != null) ...<Widget>[
            const SizedBox(height: AppSpacings.s8),
            AppText(e.description!, style: body),
          ],
          if (e.notes != null) ...<Widget>[
            const SizedBox(height: AppSpacings.s8),
            AppText(e.notes!, style: muted),
          ],
          if (nonBodyParams.isNotEmpty) ...<Widget>[
            _sectionTitle(theme, colors, 'Parâmetros'),
            AppApiParamTable(nonBodyParams),
          ],
          if (e.requestFields.isNotEmpty) ...<Widget>[
            _sectionTitle(theme, colors, 'Corpo da requisição'),
            AppApiSchemaTree(e.requestFields),
          ],
          if (e.requestExampleJson != null) ...<Widget>[
            const SizedBox(height: AppSpacings.s8),
            AppCodeBlock(code: e.requestExampleJson!, language: 'json'),
          ],
          if (e.responses.isNotEmpty) ...<Widget>[
            _sectionTitle(theme, colors, 'Respostas'),
            for (final AppApiResponse r in e.responses)
              _response(
                theme,
                colors,
                r,
                body: body,
                showExample: _showsExample(r),
              ),
          ],
          if (e.curl != null) ...<Widget>[
            _sectionTitle(theme, colors, 'Exemplo'),
            AppCodeBlock(code: e.curl!, language: 'bash', wrap: true),
          ],
        ],
      ),
    );
  }

  /// Quais respostas exibem o corpo de exemplo.
  ///
  /// Com [AppApiEndpointTile.showAllResponseExamples] desligado, apenas a
  /// primeira de sucesso e a primeira de erro — as demais ficam como chip +
  /// descrição.
  bool _showsExample(AppApiResponse r) {
    if (widget.showAllResponseExamples) return true;
    final List<AppApiResponse> same = widget.endpoint.responses
        .where((AppApiResponse o) => o.isSuccess == r.isSuccess)
        .toList();
    return same.isNotEmpty && same.first == r;
  }

  Widget _sectionTitle(AppThemeData theme, AppColorTheme colors, String label) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacings.s16,
        bottom: AppSpacings.s8,
      ),
      child: AppText(
        label,
        style: theme.textTheme.labelMedium.copyWith(color: colors.onSurface),
      ),
    );
  }

  Widget _response(
    AppThemeData theme,
    AppColorTheme colors,
    AppApiResponse r, {
    required TextStyle body,
    required bool showExample,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacings.s8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppBadge(
                '${r.status}',
                color: r.badgeColor,
                size: AppBadgeSize.s,
              ),
              const SizedBox(width: AppSpacings.s8),
              Expanded(child: AppText(r.description ?? '—', style: body)),
            ],
          ),
          if (showExample && r.fields.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacings.s4),
              child: AppApiSchemaTree(r.fields, initiallyExpandedDepth: 0),
            ),
          if (showExample && r.exampleJson != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacings.s8),
              child: AppCodeBlock(code: r.exampleJson!, language: 'json'),
            ),
        ],
      ),
    );
  }
}
