import 'package:flutter/widgets.dart';

import '../../atoms/divider/divider.dart';
import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_spacings.dart';

/// Estilo de container de um list-tile / grupo de list-tiles.
enum AppListTileStyle {
  /// Genérico com **borda** (`outline`), sem fundo — foco informativo.
  bordered,

  /// **Agrupável** com fundo `surfaceContainer` — foco acionável (cliques).
  grouped,
}

/// Escopo que informa aos [AppListTile] filhos que estão dentro de um
/// [AppListTileGroup] — o grupo desenha o container e as divisórias, então os
/// tiles renderizam só a linha. Não é API pública.
class ListTileGroupScope extends InheritedWidget {
  /// Cria um [ListTileGroupScope].
  const ListTileGroupScope({
    required this.style,
    required super.child,
    super.key,
  });

  /// Estilo herdado pelo grupo.
  final AppListTileStyle style;

  /// O estilo do grupo ancestral, ou `null` se o tile é avulso.
  static AppListTileStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ListTileGroupScope>()?.style;

  @override
  bool updateShouldNotify(ListTileGroupScope oldWidget) =>
      oldWidget.style != style;
}

/// Agrupa [children] ([AppListTile]/[AppListTileRadio]) num único card:
/// fundo/borda conforme [style], cantos arredondados (radius global) e
/// **divisórias** (`outline`) entre as linhas — com um rótulo de seção
/// opcional ([title]) ACIMA do card.
///
/// ```dart
/// AppListTileGroup(
///   title: 'Respostas rápidas',
///   children: <Widget>[
///     AppListTile.navigation(title: 'Suporte', onTap: openSupport),
///     AppListTile.navigation(title: 'Sair', onTap: logout),
///   ],
/// )
/// ```
final class AppListTileGroup extends StatelessWidget {
  /// Cria um [AppListTileGroup].
  const AppListTileGroup({
    required this.children,
    this.style = AppListTileStyle.grouped,
    this.title,
    super.key,
  });

  /// Tiles do grupo.
  final List<Widget> children;

  /// Estilo do container. Default [AppListTileStyle.grouped].
  final AppListTileStyle style;

  /// Rótulo de seção ACIMA do card — o MESMO desenho do título de seção do
  /// `AppMenu` (`labelSmall`, neutro `s600`, 1 linha com ellipsis, padding
  /// 12/8/12/4). Fica FORA do container de propósito: o card é o conteúdo, o
  /// rótulo separa grupos numa lista seccionada. `null` = sem rótulo.
  final String? title;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final BorderRadius radius = theme.radiusTheme.tileRadius();

    // Divisória INTERNA sutil (não chama atenção): o token `divider` do tema —
    // o mesmo padrão do `AppDivider`, mais neutro que o `outline` da borda.
    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      if (i > 0) rows.add(const AppDivider());
      rows.add(children[i]);
    }

    final BoxDecoration decoration = style == AppListTileStyle.grouped
        ? BoxDecoration(color: colors.surfaceContainer, borderRadius: radius)
        : BoxDecoration(
            border: Border.all(color: colors.outline),
            borderRadius: radius,
          );

    final Widget card = ListTileGroupScope(
      style: style,
      child: DecoratedBox(
        decoration: decoration,
        child: ClipRRect(
          borderRadius: radius,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: rows,
          ),
        ),
      ),
    );
    if (title == null) return card;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // O desenho do _SectionTitle do AppMenu, duplicado (a classe é privada
        // ao menu): labelSmall + neutralPrimary.s600, 1 linha, LTRB 12/8/12/4.
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacings.s12,
            AppSpacings.s8,
            AppSpacings.s12,
            AppSpacings.s4,
          ),
          child: AppText(
            title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall.copyWith(
              color: colors.neutralPrimary.s600,
            ),
          ),
        ),
        card,
      ],
    );
  }
}
