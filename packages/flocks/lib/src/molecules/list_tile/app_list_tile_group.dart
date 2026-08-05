import 'package:flutter/widgets.dart';

import '../../atoms/divider/divider.dart';
import '../../theme/theme.dart';

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
/// **divisórias** (`outline`) entre as linhas.
///
/// ```dart
/// AppListTileGroup(children: <Widget>[
///   AppListTile.navigation(title: 'Suporte', onTap: openSupport),
///   AppListTile.navigation(title: 'Sair', onTap: logout),
/// ])
/// ```
final class AppListTileGroup extends StatelessWidget {
  /// Cria um [AppListTileGroup].
  const AppListTileGroup({
    required this.children,
    this.style = AppListTileStyle.grouped,
    super.key,
  });

  /// Tiles do grupo.
  final List<Widget> children;

  /// Estilo do container. Default [AppListTileStyle.grouped].
  final AppListTileStyle style;

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

    return ListTileGroupScope(
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
  }
}
