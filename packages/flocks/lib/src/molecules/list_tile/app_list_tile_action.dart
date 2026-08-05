import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_strokes.dart';

/// Item de lista com título, valor e um `trailing` de ação (ex.: swapArrow).
///
/// Ênfase de DADO: título discreto (titleSmall) sobre valor forte (titleMedium),
/// com borda inferior. A linha inteira é clicável quando [onPressed] != null.
///
/// ```dart
/// AppListTileAction(
///   title: 'Veículos',
///   text: 'TTS4G47',
///   trailing: const AppIcon(AppIconToken.swapArrow),
///   onPressed: _pickVehicle,
/// )
/// ```
final class AppListTileAction extends StatelessWidget {
  /// Cria um [AppListTileAction].
  const AppListTileAction({
    required this.onPressed,
    required this.text,
    required this.title,
    required this.trailing,
    super.key,
  });

  /// Callback ao tocar no item. Quando `null`, a linha não é clicável.
  final VoidCallback? onPressed;

  /// Valor atual exibido (ex.: "TTS4G47", "21/01/2026").
  final String text;

  /// Título em destaque (ex.: "Veículos", "Data").
  final String title;

  /// Widget à direita (ex.: `AppIcon(AppIconToken.swapArrow)`).
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;

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
            horizontal: AppSpacings.s16,
            vertical: AppSpacings.s32,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AppText(
                      title,
                      semanticLabel: title,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: theme.textTheme.titleSmall.copyWith(
                        color: colors.neutralPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacings.s8),
                    AppText(
                      text,
                      semanticLabel: text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium.copyWith(
                        color: colors.neutralPrimary.s900,
                      ),
                    ),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );

    if (onPressed != null) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: content,
        ),
      );
    }

    return MouseRegion(cursor: SystemMouseCursors.basic, child: content);
  }
}
