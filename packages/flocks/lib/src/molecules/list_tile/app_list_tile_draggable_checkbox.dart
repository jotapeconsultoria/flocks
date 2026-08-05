import 'package:flutter/widgets.dart';

import '../../atoms/checkbox/checkbox.dart';
import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_strokes.dart';

/// Tile com handle de arraste + checkbox para listas reordenáveis.
///
/// Combina um [ReorderableDragStartListener] (handle à esquerda) com um
/// [AppListTileCheckbox]-like: título/valor + [AppCheckbox]. Use dentro de uma
/// lista reordenável, passando o [reorderIndex] da linha.
///
/// ```dart
/// AppListTileDraggableCheckbox(
///   reorderIndex: i,
///   title: 'Coluna',
///   text: 'Placa',
///   checked: col.visible,
///   onChanged: (v) => _toggle(col, v),
/// )
/// ```
///
/// Omita [text] para exibir apenas [title] em uma única linha destacada.
final class AppListTileDraggableCheckbox extends StatefulWidget {
  /// Cria um [AppListTileDraggableCheckbox].
  const AppListTileDraggableCheckbox({
    required this.checked,
    required this.reorderIndex,
    required this.title,
    this.text,
    this.enabled = true,
    this.onChanged,
    this.reorderEnabled = true,
    super.key,
  });

  /// Se o checkbox está marcado.
  final bool checked;

  /// Se o tile está habilitado.
  final bool enabled;

  /// Callback quando o estado muda.
  final ValueChanged<bool>? onChanged;

  /// Se o handle de arraste está ativo.
  final bool reorderEnabled;

  /// Índice da linha na lista reordenável (usado pelo handle de arraste).
  final int reorderIndex;

  /// Identificador secundário do item (ex.: "TTS4G47"). Quando `null`, apenas
  /// [title] é exibido, em uma única linha destacada.
  final String? text;

  /// Nome do item (ex.: "Polo Track 01").
  final String title;

  @override
  State<AppListTileDraggableCheckbox> createState() =>
      _AppListTileDraggableCheckboxState();
}

class _AppListTileDraggableCheckboxState
    extends State<AppListTileDraggableCheckbox> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;

    final Color textColor = widget.checked
        ? colors.secondary
        : colors.neutralPrimary.s900;

    final String? subtitle = widget.text;
    final Widget label = subtitle == null
        ? AppText(
            widget.title,
            semanticLabel: widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium.copyWith(color: textColor),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppText(
                widget.title,
                semanticLabel: widget.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall.copyWith(
                  color: colors.neutralPrimary,
                ),
              ),
              const SizedBox(height: AppSpacings.s4),
              AppText(
                subtitle,
                semanticLabel: subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium.copyWith(color: textColor),
              ),
            ],
          );

    final Widget content = SelectionContainer.disabled(
      child: DecoratedBox(
        decoration: BoxDecoration(
          // Realce de hover na linha INTEIRA: ela é arrastável, e sem resposta
          // ao ponteiro nada dizia que dava para pegar a linha — só a handle
          // parecia interativa (revisão P1r10).
          color: _hovered
              ? colors.onSurface.customOpacity(0.06)
              : colors.transparent,
          border: Border(
            bottom: BorderSide(color: colors.divider, width: AppStrokes.m),
          ),
        ),
        child: Padding(
          // Vertical enxuto: com `s32` de cada lado seis colunas não cabiam sem
          // rolar, e a lista existe para ser vista de uma vez. `s16` é o passo
          // que dá ar à linha sem custar um item da lista.
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacings.s16 + AppSpacings.s8,
            vertical: AppSpacings.s16,
          ),
          child: Row(
            children: <Widget>[
              // Sem listener próprio: a linha inteira já é área de arraste
              // (ver abaixo). A handle segue sendo a AFORDÂNCIA — o desenho que
              // diz "me arraste" — e mantém o cursor de pegar.
              MouseRegion(
                cursor: SystemMouseCursors.grab,
                child: AppIcon(
                  AppIconToken.dragArrow,
                  color: colors.neutralPrimary,
                ),
              ),
              const SizedBox(width: AppSpacings.s16),
              Expanded(child: label),
              const SizedBox(width: AppSpacings.s16),
              AppCheckbox(
                checked: widget.checked,
                enabled: widget.enabled,
                onChanged: widget.onChanged,
              ),
            ],
          ),
        ),
      ),
    );

    // UM listener, cobrindo a linha inteira (a handle inclusive): dois
    // aninhados ficavam competindo pelo mesmo gesto.
    final Widget draggable = ReorderableDragStartListener(
      index: widget.reorderIndex,
      enabled: widget.reorderEnabled,
      child: content,
    );

    // Sem toggle (linha travada) ela ainda arrasta, mas não responde ao
    // ponteiro como algo clicável.
    if (!widget.enabled || widget.onChanged == null) return draggable;

    return MouseRegion(
      // `grab`: a ação da linha inteira que o ponteiro anuncia é o ARRASTE. O
      // clique também alterna o checkbox, mas alternar já tem um alvo próprio à
      // direita — o que faltava dica era o arraste.
      cursor: SystemMouseCursors.grab,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      // Arrastar reordena; tocar alterna. São gestos distintos, então um não
      // come o outro.
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => widget.onChanged!(!widget.checked),
        child: draggable,
      ),
    );
  }
}
