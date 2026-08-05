import 'package:flutter/widgets.dart';

import '../../atoms/checkbox/checkbox.dart';
import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_strokes.dart';

/// Item de lista com checkbox à direita para seleção.
///
/// - `title`: nome do item (titleSmall, neutralPrimary) — opcional.
/// - `text`: identificador (titleMedium, neutralPrimary.s900; `secondary` quando
///   marcado).
/// - A linha inteira alterna o estado quando habilitada.
///
/// ```dart
/// AppListTileCheckbox(
///   title: 'Polo Track 01',
///   text: 'TTS4G47',
///   checked: _selected.contains(id),
///   onChanged: (v) => _toggle(id, v),
/// )
/// ```
final class AppListTileCheckbox extends StatelessWidget {
  /// Cria um [AppListTileCheckbox].
  const AppListTileCheckbox({
    required this.checked,
    required this.text,
    this.title,
    this.enabled = true,
    this.onChanged,
    super.key,
  });

  /// Se o checkbox está marcado.
  final bool checked;

  /// Se o tile está habilitado.
  final bool enabled;

  /// Callback quando o estado muda.
  final ValueChanged<bool>? onChanged;

  /// Identificador do item (ex.: "TTS4G47").
  final String text;

  /// Nome do item (ex.: "Polo Track 01"). Opcional.
  final String? title;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;

    final Color textColor = checked
        ? colors.secondary
        : colors.neutralPrimary.s900;

    final Widget content = SelectionContainer.disabled(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colors.tertiary.s100,
              width: AppStrokes.m,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacings.s16 + AppSpacings.s8,
            vertical: AppSpacings.s16,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (title != null && title!.isNotEmpty) ...<Widget>[
                      AppText(
                        title!,
                        semanticLabel: title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall.copyWith(
                          color: colors.neutralPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacings.s4),
                    ],
                    AppText(
                      text,
                      semanticLabel: text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium.copyWith(
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacings.s16),
              AppCheckbox(
                checked: checked,
                enabled: enabled,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );

    if (enabled && onChanged != null) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged!(!checked),
          child: content,
        ),
      );
    }

    return content;
  }
}
