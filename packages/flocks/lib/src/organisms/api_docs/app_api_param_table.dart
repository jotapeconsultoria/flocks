import 'package:flutter/widgets.dart';

import '../../atoms/badge/app_badge.dart';
import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_spacings.dart';
import '../content/app_content_style.dart';
import '../data_table/app_simple_data_table.dart';
import 'app_api_models.dart';

/// Tabela de parâmetros de uma requisição.
///
/// Sobre o [AppSimpleDataTable] — sem ordenação nem paginação, que é o caso:
/// a lista é curta e a ordem vem da especificação. Nome e tipo saem em mono (a
/// mesma família da folha de conteúdo), o resto no corpo de texto do tema.
///
/// Renderiza vazio (`SizedBox.shrink`) quando não há parâmetros, para o call
/// site poder incluir sem condicional.
final class AppApiParamTable extends StatelessWidget {
  /// Cria um [AppApiParamTable].
  const AppApiParamTable(this.params, {this.showLocation = true, super.key});

  /// Parâmetros exibidos, na ordem da especificação.
  final List<AppApiParam> params;

  /// Mostra a coluna "Em" (path/query/header/body). Desligue quando a tabela já
  /// está sob um título que diz de onde eles vêm.
  final bool showLocation;

  @override
  Widget build(BuildContext context) {
    if (params.isEmpty) return const SizedBox.shrink();

    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final TextStyle mono = AppContentStyle.resolve(context).code;
    final TextStyle body = theme.textTheme.bodySmall.copyWith(
      color: colors.onSurface,
    );
    final TextStyle muted = body.copyWith(color: colors.neutralPrimary.s600);

    return AppSimpleDataTable(
      columnLabels: <String>[
        'Parâmetro',
        if (showLocation) 'Em',
        'Tipo',
        'Descrição',
      ],
      rows: <List<Widget>>[
        for (final AppApiParam p in params)
          <Widget>[
            _name(p, mono: mono, muted: muted),
            if (showLocation) AppBadge(p.location.label, size: AppBadgeSize.s),
            AppText(p.type, style: mono),
            _description(p, body: body, muted: muted),
          ],
      ],
    );
  }

  Widget _name(
    AppApiParam p, {
    required TextStyle mono,
    required TextStyle muted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppText(p.name, style: mono),
        if (p.isRequired)
          const Padding(
            padding: EdgeInsets.only(top: AppSpacings.s4),
            child: AppBadge(
              'obrigatório',
              color: AppBadgeColor.danger,
              size: AppBadgeSize.s,
            ),
          ),
      ],
    );
  }

  Widget _description(
    AppApiParam p, {
    required TextStyle body,
    required TextStyle muted,
  }) {
    final List<Widget> extras = <Widget>[
      if (p.enumValues.isNotEmpty)
        AppText('Valores: ${p.enumValues.join(' · ')}', style: muted),
      if (p.defaultValue != null)
        AppText('Default: ${p.defaultValue}', style: muted),
    ];

    if (p.description == null && extras.isEmpty) {
      return AppText('—', style: muted);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (p.description != null) AppText(p.description!, style: body),
        for (final Widget e in extras)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacings.s2),
            child: e,
          ),
      ],
    );
  }
}
