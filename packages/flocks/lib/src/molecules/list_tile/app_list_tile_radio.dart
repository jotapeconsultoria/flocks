import 'package:flutter/widgets.dart';

import '../../atoms/radio/radio.dart';
import 'app_list_tile_group.dart';
import 'list_tile_shell.dart';

/// Linha de lista com um **radio** (seleção única em grupo). Tocar a linha
/// seleciona o [value]. Genérico `AppListTileRadio<T>` — classe própria porque
/// um construtor nomeado não pode introduzir `<T>` (como `RadioListTile<T>`).
///
/// Mesmos estilos/variações do [AppListTile] (leading/subtitle/draggable);
/// agrupe com [AppListTileGroup].
///
/// ```dart
/// AppListTileRadio<String>(
///   title: 'Polo Track 01',
///   value: 'a', groupValue: selected, onChanged: choose,
/// )
/// ```
final class AppListTileRadio<T> extends StatelessWidget {
  /// Cria um [AppListTileRadio].
  const AppListTileRadio({
    required this.title,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.subtitle,
    this.leading,
    this.style = AppListTileStyle.grouped,
    this.enabled = true,
    this.reorderIndex,
    this.reorderEnabled = true,
    this.semanticLabel,
    super.key,
  });

  /// Título (forte).
  final String title;

  /// Valor deste item.
  final T value;

  /// Valor selecionado no grupo.
  final T? groupValue;

  /// Callback de seleção.
  final ValueChanged<T?>? onChanged;

  /// Subtítulo (muted, opcional).
  final String? subtitle;

  /// Leading (ícone/avatar), opcional.
  final Widget? leading;

  /// Estilo do container quando avulso.
  final AppListTileStyle style;

  /// Se está habilitado.
  final bool enabled;

  /// Draggable: índice de reordenamento.
  final int? reorderIndex;

  /// Se o reordenamento está ativo.
  final bool reorderEnabled;

  /// Rótulo de acessibilidade (default: [title]).
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return TileScaffold(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: AppRadio<T>(
        value: value,
        groupValue: groupValue,
        enabled: enabled,
        onChanged: onChanged,
      ),
      onTap: enabled && onChanged != null ? () => onChanged!(value) : null,
      enabled: enabled,
      style: style,
      reorderIndex: reorderIndex,
      reorderEnabled: reorderEnabled,
      semantics: TileSemantics.merge,
      semanticLabel: semanticLabel,
    );
  }
}
